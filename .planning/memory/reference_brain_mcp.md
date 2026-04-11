---
name: brain-mcp setup and file provider
description: brain-mcp cognitive prosthetic — config, file provider, queue pipeline, tool inventory, known limitations
type: reference
---

brain-mcp (cognitive prosthetic / conversation RAG) is installed from a local fork at `/tmp/brain-mcp/`.

- **Config:** `~/.config/brain-mcp/config.toml`
- **Data:** `~/.config/brain-mcp/data/` (parquet, prompts, summaries JSONL)
- **Vectors:** `~/.config/brain-mcp/vectors/` (LanceDB, nomic-embed-text-v1.5, 768d)
- **MCP server name:** `skogai-brain-mcp`

**File provider** (custom addition in `summarize.py`): Instead of calling Anthropic API, writes `{conv_id}-prompt.txt` to `output_dir`, reads `{conv_id}-summary.txt` back. Config:
```toml
[summarizer]
enabled = true
provider = "file"
output_dir = "/path/to/prompts"
```

**Pipeline:** `brain-mcp summarize` (write prompts) -> `queue run` (process overnight via `claude -p`) -> `brain-mcp summarize` again (read results, build parquet + vectors)

**Existing summary system:** Separate from brain-mcp — `claude-memory` at `~/.local/src/claude-memory/` generates `-prompt.txt` files, `skogai-queue` processes them into `-summary.txt` files alongside the JSONL history. 36 summaries in `.claude/projects/`, 70 prompts queued in `~/.config/skogai/conversation-archive/`.

**Status as of 2026-03-21:** 105k messages ingested (5,171 conversations), ~6k/30k embeddings indexed. Summaries not yet generated — unlocks: domain analysis, thinking stages, structured decisions/open questions, cognitive patterns, unfinished threads.

**Tool inventory (25 tools, tested 2026-03-21):**
- Working fully: semantic_search, search_conversations, unified_search, conversations_by_date, what_do_i_think, thinking_trajectory, what_was_i_thinking, open_threads, dormant_contexts, tunnel_state, tunnel_history, switching_cost, context_recovery, alignment_check, cognitive_patterns, query_analytics (timeline/summary), brain_stats (overview/conversations/embeddings), trust_dashboard
- Need summaries: search_summaries, unfinished_threads, brain_stats (domains/pulse), cognitive_patterns (full)
- Need additional data: search_docs (markdown corpus), github_search (github import), list_principles/get_principle (principles YAML)
- Need pipelines: query_analytics (stacks/problems/spend)
