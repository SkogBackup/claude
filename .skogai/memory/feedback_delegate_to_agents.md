---
name: feedback-delegate-to-agents
description: Use GSD agents and skills instead of doing everything in the main context — delegate reading/classification work to subagents
type: feedback
---

When facing tasks that could blow the context budget (like reading all memory blocks to classify them), delegate to subagents instead of doing it yourself. The GSD orchestration handles this.

**Why:** The Context Destruction Pattern is real — reading everything into main context to answer questions defeats the purpose. Agents can answer questions in their own context and return summaries.

**How to apply:** Use `/skogai-routing` for CLAUDE.md routing patterns. Use GSD agents (researchers, explorers) for classification and discovery tasks. Keep the orchestrator context lean.
