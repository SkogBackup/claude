---
state: new
created: 2026-04-18
tracking: ["https://github.com/SkogAI/claude/issues/32"]
---

# feat: scripts/context/ — context generation scripts

**Source**: [Github #32](https://github.com/SkogAI/claude/issues/32)

## Description

Shell scripts that generate system prompt context for AI agents from project state.

## Structure

```
.skogai/scripts/context/
├── context.sh           # orchestrator, calls component scripts
├── context-git.sh       # git status + recent commits
├── context-workspace.sh # workspace tree
├── context-journal.sh   # recent journal/memory entries
└── context-memory.sh    # current.md contents
```

## Notes

* All scripts accept optional `AGENT_DIR` argument (defaults to git root)
* Output is markd

## Notes

*Imported from external tracker. See source link for full context.*
