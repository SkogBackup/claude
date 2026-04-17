---
state: new
created: 2026-04-18
tracking: ["https://github.com/SkogAI/claude/issues/35"]
---

# feat: workflows/ — automation definitions and action lists

**Source**: [Github #35](https://github.com/SkogAI/claude/issues/35)

## Description

Workflow definitions for automation — sequences of actions agents can execute, scheduled or triggered.

## Structure

```
.skogai/workflows/
├── CLAUDE.md       # router: what workflows exist, how to trigger
├── .claude/
│   └── CLAUDE.md   # claude-specific workflow context
└── dagu/           # dagu DAG definitions (or other workflow engine)
    └── dags/
```

## Notes

* Workflows are "lists of actions to do" — scripted multi-step operations
* Engine-agnostic at the directory level (dagu, mak

## Notes

*Imported from external tracker. See source link for full context.*
