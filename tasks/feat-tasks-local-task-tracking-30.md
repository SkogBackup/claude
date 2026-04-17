---
state: new
created: 2026-04-18
tracking: ["https://github.com/SkogAI/claude/issues/30"]
---

# feat: tasks/ — local task tracking

**Source**: [Github #30](https://github.com/SkogAI/claude/issues/30)

## Description

File-based task tracking for work that doesn't need a Linear/GitHub issue — scratchpad tasks, WIP items, or offline-first capture.

## Structure

```
.skogai/tasks/
├── .gitkeep
└── <slug>.md   # one file per task
```

## Notes

* Complements Linear, not a replacement — quick capture without needing network
* Filename convention: `<slug>.md` (kebab-case)
* Status in filename prefix optional: `pending-`, `done-`

## Notes

*Imported from external tracker. See source link for full context.*
