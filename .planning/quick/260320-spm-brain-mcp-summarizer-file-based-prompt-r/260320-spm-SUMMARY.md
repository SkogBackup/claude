---
phase: quick
plan: 260320-spm
subsystem: summarizer
tags: [brain-mcp, summarizer, file-provider, skogai-queue, batch-processing]

requires: []
provides:
  - "File-based summarizer provider that writes prompts to disk instead of calling LLM APIs"
  - "output_dir field on SummarizerConfig for configuring prompt/summary file location"
  - "Stats reporting: prompts-written vs results-read counts in run_summarize"
affects: [skogai-queue, brain-mcp-summarizer]

tech-stack:
  added: []
  patterns:
    - "File-based provider pattern: decouple prompt generation from LLM execution"
    - "Two-pass summarization: write prompts first, read results on next run"

key-files:
  created: []
  modified:
    - /tmp/brain-mcp/brain_mcp/config.py
    - /tmp/brain-mcp/brain_mcp/summarize/summarize.py

key-decisions:
  - "output_dir defaults to empty string in dataclass — resolution to data_dir/prompts/ happens at runtime in summarize.py where both values are available"
  - "file provider bypasses call_llm() entirely — handled directly in summarize_conversation() before the LLM path"
  - "PROVIDERS['file'] = None with explicit ValueError guard in call_llm() to catch accidental routing"
  - "Skips parquet/embed step when file provider produces zero results (no new data to process)"

requirements-completed: [FILE-PROVIDER]

duration: 5min
completed: 2026-03-21
---

# Quick Task 260320-spm: brain-mcp summarizer file-based prompt provider

**File-based summarizer provider for brain-mcp that writes prompts to {output_dir}/{conv_id}-prompt.txt and reads JSON results from {conv_id}-summary.txt, enabling batch processing via skogai-queue without any LLM API calls.**

## Performance

- **Duration:** ~5 min
- **Started:** 2026-03-21
- **Completed:** 2026-03-21
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments

- Added `output_dir: str = ""` to `SummarizerConfig` with toml parsing in `load_config()`
- Implemented `_file_provider_summarize()` — writes prompt, reads back JSON summary if present
- Wired file provider into `summarize_conversation()` with early-return before the LLM path
- Added `call_llm()` guard raising `ValueError` if accidentally called with file provider
- Added `prompts_written` / `results_read` counters and stats line in `run_summarize()`
- Skips parquet/embed step when file provider produced zero results

## Task Commits

Both tasks were already implemented in the source files — no additional commits required.

1. **Task 1: Add output_dir to SummarizerConfig** - pre-implemented in config.py
2. **Task 2: Implement file provider** - pre-implemented in summarize.py

## Files Created/Modified

- `/tmp/brain-mcp/brain_mcp/config.py` - Added `output_dir: str = ""` to `SummarizerConfig` and `output_dir=sum_raw.get("output_dir", "")` in `load_config()`
- `/tmp/brain-mcp/brain_mcp/summarize/summarize.py` - Added `_file_provider_summarize()`, `"file": None` in PROVIDERS, guard in `call_llm()`, early-return branch in `summarize_conversation()`, stats tracking in `run_summarize()`

## Decisions Made

- `output_dir` resolution (empty -> `data_dir/prompts/`) happens in `summarize.py` not `config.py` — both `cfg.data_dir` and `cfg.summarizer.output_dir` are needed together
- `PROVIDERS["file"] = None` with a guard in `call_llm()` — validates file is a known provider without accidentally routing through the LLM path
- Parquet/embed step skipped when `is_file_provider and not records` — no point converting empty results

## Deviations from Plan

None - plan executed exactly as written. Both files already contained the full implementation matching the plan specification.

## Issues Encountered

None.

## Next Steps

- Configure `[summarizer] provider = "file"` and `output_dir = "/path/to/prompts"` in brain-mcp's config.toml
- Wire skogai-queue to pick up `*-prompt.txt` files, run `claude -p`, write `*-summary.txt` results
- Re-run `python -m brain_mcp.summarize.summarize` to pick up completed summaries

---
*Phase: quick*
*Completed: 2026-03-21*
