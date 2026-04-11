---
categories:
  - journal
tags:
  - brain-mcp
  - cognitive-prosthetic
  - rag
  - skogai-queue
  - summarization
permalink: journal/2026-03-20/brain-mcp-exploration-and-file-provider
title: brain-mcp Exploration and File Provider
type: journal
---

First full exploration of brain-mcp — a cognitive prosthetic that indexes all AI conversation history for RAG search. Tested all 25 MCP tools systematically across search, browse, prosthetic, synthesis, analytics, and stats categories. 16 tools work fully with just conversations + embeddings, 7 require summaries or additional data pipelines.

The big finding: brain-mcp's summarizer assumes direct API access (Anthropic, OpenAI, etc.) but Skogix uses `claude -p` through Max subscription — no API key. Built a "file" provider that decouples prompt generation from LLM execution: writes `{conv_id}-prompt.txt`, reads `{conv_id}-summary.txt` if it exists. This integrates cleanly with skogai-queue which processes prompts asynchronously.

5,135 summary prompts generated and queued. Two test runs confirmed the full pipeline: prompt write -> `claude -p` -> summary read -> structured JSON with domains, thinking stages, decisions, open questions. Queue is now processing overnight.

105k messages ingested from Claude Code history spanning June 2025 to March 2026. Once summaries complete, the prosthetic tools (tunnel_state, context_recovery, cognitive_patterns) will have full structured metadata to work with. This is the foundation for genuine cross-session cognitive continuity.
