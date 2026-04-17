---
state: new
created: 2026-04-17
tracking:
  - https://github.com/SkogAI/dot-skogai/issues/20
permalink: claude/tasks/feat-workflows-automation-definitions-an-20
---

# feat: workflows/ — automation definitions and action lists

**Source**: [Github #20](https://github.com/SkogAI/dot-skogai/issues/20)

## Description

## Summary

Workflow definitions for automation — sequences of actions agents can execute, scheduled or triggered.

## What

```
workflows/
├── CLAUDE.md       # router: what workflows exist, how to trigger
├── .claude/
│   └── CLAUDE.md   # claude-specific workflow context
└── dagu/           # dagu DAG definitions (or other workflow engine)
    └── dags/
```

## Notes

- Workflows are "lists of actions to do" — scripted multi-step operations
- Engine-agnostic at the directory level (dagu, make, a

## Notes

*Imported from external tracker. See source link for full context.*
