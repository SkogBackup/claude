---
categories:
  - journal
tags:
  - brain-mcp
  - rag
  - conversation-history
  - cognitive-prosthetic
  - skogai-queue
permalink: journal/2026-03-21/brain-mcp-exploration-and-file-provider
title: brain-mcp Full Tool Exploration and File Provider
type: journal
---

# brain-mcp Full Tool Exploration and File Provider

Skogix kicked off a full embedding run of all conversation history — 105k messages, 30k vectors queued. While that was running, we systematically tested all 25 brain-mcp tools against the live data.

## What we found

The tool set divides into tiers based on what data pipeline stages have run:

- **Conversations only** (working now): keyword search, date browsing, basic stats, approximate open threads
- **+ Embeddings** (partially ready, 6k/30k): semantic search, synthesis, trajectory analysis
- **+ Summaries** (not yet): structured domain analysis, thinking stages, decisions, open questions, cognitive patterns

The "prosthetic" tools (tunnel_state, context_recovery, switching_cost) are the real value proposition — they degrade gracefully without summaries but gain structured metadata with them. The "domain" concept maps directly to Claude Code project directory names.

## File provider

brain-mcp's built-in summarizer calls LLM APIs directly (Anthropic, OpenAI, etc.). Skogix's setup uses `claude -p` through the Max subscription via `skogai-queue` — no API key needed. We added a `"file"` provider that decouples prompt generation from LLM execution:

1. `brain-mcp summarize` writes `{conv_id}-prompt.txt` files
2. `skogai-queue` processes them overnight via `claude -p`
3. Next `brain-mcp summarize` run reads back `{conv_id}-summary.txt` results

Two files modified in `/tmp/brain-mcp/`: `config.py` (added `output_dir` to `SummarizerConfig`) and `summarize.py` (added `_file_provider_summarize()`, stats reporting, guard against accidental `call_llm()` routing).

## Existing parallel system

Discovered that `claude-memory` (`~/.local/src/claude-memory/`) already has its own prompt-generation + queue pipeline producing plain-text summaries. These live alongside the JSONL files in `.claude/projects/` and `.config/skogai/conversation-archive/`. brain-mcp's structured JSON summaries (with domains, thinking stages, decisions) serve a different purpose — they power the prosthetic tools that plain-text summaries can't.

## Next

Once embeddings finish and summaries start flowing, the brain-mcp prosthetic tools should become genuinely useful for context recovery across the 5k+ conversations.
