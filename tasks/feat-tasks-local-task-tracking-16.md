---
state: new
created: 2026-04-17
tracking:
  - https://github.com/SkogAI/dot-skogai/issues/16
permalink: claude/tasks/feat-tasks-local-task-tracking-16
---

# feat: tasks/ — local task tracking

**Source**: [Github #16](https://github.com/SkogAI/dot-skogai/issues/16)

## Description

## Summary

File-based task tracking for work that doesn't need a GitHub issue — scratchpad tasks, WIP items, or offline-first capture.

## What

```
tasks/
├── .gitkeep
└── <slug>.md   # one file per task
```

Each task file: short description, status, notes. No enforced schema — keep it lightweight.

## Notes

- Complements GitHub issues, not a replacement — quick capture without needing network
- Filename convention: `<slug>.md` (kebab-case description)
- Status in filename prefix optional: \`pen

## Notes

*Imported from external tracker. See source link for full context.*
