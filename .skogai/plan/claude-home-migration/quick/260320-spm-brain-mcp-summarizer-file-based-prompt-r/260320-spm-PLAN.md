---
phase: quick
plan: 260320-spm
type: execute
wave: 1
depends_on: []
files_modified:
  - /tmp/brain-mcp/brain_mcp/config.py
  - /tmp/brain-mcp/brain_mcp/summarize/summarize.py
autonomous: true
requirements: [FILE-PROVIDER]
must_haves:
  truths:
    - "When provider=file, no LLM API calls are made"
    - "Prompt files are written to {output_dir}/{conversation_id}-prompt.txt"
    - "If {conversation_id}-summary.txt exists, its content is parsed as JSON and used as the summary"
    - "If summary.txt does not exist, conversation is skipped (returns None)"
    - "run_summarize reports prompts-written vs results-read counts"
  artifacts:
    - path: "/tmp/brain-mcp/brain_mcp/summarize/summarize.py"
      provides: "File-based provider logic"
      contains: "_call_file"
    - path: "/tmp/brain-mcp/brain_mcp/config.py"
      provides: "output_dir field on SummarizerConfig"
      contains: "output_dir"
  key_links:
    - from: "summarize.py PROVIDERS dict"
      to: "_call_file function"
      via: "PROVIDERS['file'] = _call_file"
      pattern: '"file".*_call_file'
    - from: "config.py SummarizerConfig"
      to: "summarize.py _call_file"
      via: "cfg.summarizer.output_dir"
      pattern: "output_dir"
---

<objective>
Add a "file" provider to brain-mcp's summarizer that writes prompts to disk and reads results from disk instead of calling any LLM API. This enables integration with skogai-queue which processes prompts externally via `claude -p`.

Purpose: Decouple summarization prompt generation from LLM execution, allowing batch processing through skogai-queue.
Output: Modified summarize.py with file provider, modified config.py with output_dir field.
</objective>

<execution_context>
@/home/skogix/claude/.claude/get-shit-done/workflows/execute-plan.md
@/home/skogix/claude/.claude/get-shit-done/templates/summary.md
</execution_context>

<context>
@/tmp/brain-mcp/brain_mcp/config.py
@/tmp/brain-mcp/brain_mcp/summarize/summarize.py
</context>

<interfaces>
From /tmp/brain-mcp/brain_mcp/config.py:
```python
@dataclass
class SummarizerConfig:
    enabled: bool = False
    provider: str = "anthropic"
    model: str = "claude-sonnet-4-20250514"
    api_key_env: str = "ANTHROPIC_API_KEY"
    max_concurrent: int = 3

@dataclass
class BrainConfig:
    data_dir: Path = Path("./data")
    # ...
    summarizer: SummarizerConfig = field(default_factory=SummarizerConfig)
```

From summarize.py:
```python
PROVIDERS = {
    "anthropic": _call_anthropic,
    "openai": _call_openai,
    "gemini": _call_gemini,
    "openrouter": _call_openrouter,
    "local": _call_ollama,
    "ollama": _call_ollama,
}

def call_llm(prompt: str) -> str:
    # dispatches to provider via PROVIDERS dict

def summarize_conversation(conv: dict) -> dict | None:
    # builds prompt, calls call_llm(), parses JSON response
```
</interfaces>

<tasks>

<task type="auto">
  <name>Task 1: Add output_dir to SummarizerConfig and parse it from toml</name>
  <files>/tmp/brain-mcp/brain_mcp/config.py</files>
  <action>
1. Add `output_dir: str = ""` field to `SummarizerConfig` dataclass (line 67, after `max_concurrent`). Empty string means "use {data_dir}/prompts/" as default — resolved at runtime, not in the dataclass.

2. In the summarizer config parsing block (around line 313-319), add:
   ```
   output_dir=sum_raw.get("output_dir", ""),
   ```
   to the `SummarizerConfig(...)` constructor call.

No other changes to config.py. The output_dir resolution (empty -> data_dir/prompts/) happens in summarize.py where both cfg.data_dir and cfg.summarizer.output_dir are available.
  </action>
  <verify>
    <automated>cd /tmp/brain-mcp && python -c "from brain_mcp.config import SummarizerConfig; s = SummarizerConfig(); assert hasattr(s, 'output_dir'); assert s.output_dir == ''; print('OK')"</automated>
  </verify>
  <done>SummarizerConfig has output_dir field, defaults to empty string, parsed from toml</done>
</task>

<task type="auto">
  <name>Task 2: Implement file provider and integrate into summarize pipeline</name>
  <files>/tmp/brain-mcp/brain_mcp/summarize/summarize.py</files>
  <action>
1. Add `_call_file` function after the existing provider functions (after line 148, before PROVIDERS dict). This function has a DIFFERENT signature than other providers — it does not go through `call_llm()`. It handles file I/O directly:

```python
def _file_provider_summarize(conv: dict, prompt: str, output_dir: Path) -> dict | None:
    """File-based provider: write prompt, read result if available."""
    conv_id = conv["conversation_id"]
    prompt_path = output_dir / f"{conv_id}-prompt.txt"
    summary_path = output_dir / f"{conv_id}-summary.txt"

    # If summary already exists, read it back
    if summary_path.exists():
        text = summary_path.read_text().strip()
        if text.startswith("```"):
            text = text.split("\n", 1)[1]
            text = text.rsplit("```", 1)[0]
        try:
            data = json.loads(text)
            return {
                "conversation_id": conv["conversation_id"],
                "source": conv["source"],
                "title": conv["title"],
                "msg_count": conv["msg_count"],
                "data": data,
            }
        except json.JSONDecodeError as e:
            print(f"  JSON parse error in {summary_path}: {e}", flush=True)
            return None

    # No summary yet — write prompt for external processing
    prompt_path.write_text(prompt)
    return None  # Signal: prompt written, no result yet
```

2. Add `"file"` to the PROVIDERS dict. Value does not matter (will not be called via call_llm), but add it for validation: `"file": None,`

3. Modify `summarize_conversation()` (line 230-261) to handle file provider. At the top of the function, BEFORE `prompt = SUMMARY_PROMPT.format(...)`:

```python
cfg = get_config()
if cfg.summarizer.provider == "file":
    prompt = SUMMARY_PROMPT.format(conversation=conv["text"])
    output_dir = Path(cfg.summarizer.output_dir) if cfg.summarizer.output_dir else cfg.data_dir / "prompts"
    output_dir.mkdir(parents=True, exist_ok=True)
    return _file_provider_summarize(conv, prompt, output_dir)
```

The rest of the function (call_llm path) stays unchanged for other providers.

4. Modify `run_summarize()` (line 264-303) to track and report file provider stats. After the loop that processes conversations, add reporting for the file provider case. Use two counters:

- `prompts_written = 0` — incremented when record is None AND provider is "file"
- `results_read = 0` — incremented when record is not None AND provider is "file"

Add these counters before the loop. Inside the loop, after `record = summarize_conversation(conv)`:
- If `record is None` and provider is "file": increment `prompts_written`, print `"  Prompt written (awaiting external processing)"`
- If `record is not None` and provider is "file": increment `results_read`

After the loop, if provider is "file", print a summary line:
```
print(f"\nFile provider: {prompts_written} prompts written, {results_read} results read back", flush=True)
```

Also when provider is "file" and results_read == 0, skip the parquet/embed step (no new data to process). Change the condition at line 301 from `if records or full:` to also check this.

5. Update the PROVIDERS validation in `call_llm()` — the "file" key is in PROVIDERS but its value is None, so add a guard: if `provider == "file"`, raise `ValueError("File provider does not use call_llm — should be handled in summarize_conversation()")`. This catches programming errors where someone accidentally routes through call_llm with file provider.
  </action>
  <verify>
    <automated>cd /tmp/brain-mcp && python -c "
from brain_mcp.summarize.summarize import _file_provider_summarize, PROVIDERS
assert 'file' in PROVIDERS, 'file not in PROVIDERS'
print('file provider registered')

# Test prompt writing
import tempfile, json
from pathlib import Path
with tempfile.TemporaryDirectory() as td:
    td = Path(td)
    conv = {'conversation_id': 'test-123', 'source': 'test', 'title': 'Test', 'msg_count': 5, 'text': 'hello'}
    result = _file_provider_summarize(conv, 'test prompt', td)
    assert result is None, 'should return None when no summary exists'
    assert (td / 'test-123-prompt.txt').read_text() == 'test prompt', 'prompt not written'
    print('prompt write OK')

    # Test summary reading
    (td / 'test-123-summary.txt').write_text(json.dumps({'summary': 'test', 'key_insights': [], 'concepts': [], 'decisions': [], 'open_questions': [], 'quotable': [], 'domain_primary': 'test', 'domain_secondary': '', 'thinking_stage': 'exploring', 'importance': 'routine', 'emotional_tone': 'analytical', 'cognitive_pattern': 'systematic', 'problem_solving_approach': 'analytical'}))
    result = _file_provider_summarize(conv, 'test prompt', td)
    assert result is not None, 'should return record when summary exists'
    assert result['data']['summary'] == 'test', 'wrong summary'
    print('summary read OK')
print('ALL TESTS PASSED')
"</automated>
  </verify>
  <done>File provider writes prompt.txt, reads summary.txt, reports stats. No API calls made when provider=file. Pipeline handles missing summaries gracefully by skipping.</done>
</task>

</tasks>

<verification>
- `python -c "from brain_mcp.config import SummarizerConfig; print(SummarizerConfig().output_dir)"` prints empty string
- `python -c "from brain_mcp.summarize.summarize import PROVIDERS; assert 'file' in PROVIDERS"` passes
- File provider inline test (Task 2 verify) passes: writes prompt, reads summary, returns correct data
- Existing providers (anthropic, openai, etc.) are completely untouched — no regression risk
</verification>

<success_criteria>
- SummarizerConfig has output_dir field parsed from config.toml
- "file" provider registered in PROVIDERS dict
- When provider=file: prompts written to {output_dir}/{conv_id}-prompt.txt
- When provider=file and summary.txt exists: JSON parsed and returned as record
- When provider=file and summary.txt missing: returns None, prompt written, no error
- run_summarize prints "X prompts written, Y results read back" for file provider
- Zero changes to existing provider functions or their call paths
</success_criteria>

<output>
After completion, create `.planning/quick/260320-spm-brain-mcp-summarizer-file-based-prompt-r/260320-spm-SUMMARY.md`
</output>
