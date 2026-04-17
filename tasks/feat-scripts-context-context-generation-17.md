---
state: new
created: 2026-04-17
tracking:
  - https://github.com/SkogAI/dot-skogai/issues/17
permalink: claude/tasks/feat-scripts-context-context-generation-17
---

# feat: scripts/context/ — context generation scripts

**Source**: [Github #17](https://github.com/SkogAI/dot-skogai/issues/17)

## Description

## Summary

Shell scripts that generate system prompt context for AI agents from project state.

## What

Core scripts (portable, no hardcoded paths):

- `context.sh` — orchestrator, calls component scripts
- `context-git.sh` — git status + recent commits
- `context-workspace.sh` — workspace tree
- `context-journal.sh` — recent journal/memory entries
- `context-memory.sh` — current.md contents

## Notes

- All scripts accept optional `AGENT_DIR` argument (defaults to git root)
- Output is markdown-f

## Notes

*Imported from external tracker. See source link for full context.*
