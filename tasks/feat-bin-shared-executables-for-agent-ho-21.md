---
state: new
created: 2026-04-17
tracking:
  - https://github.com/SkogAI/dot-skogai/issues/21
permalink: claude/tasks/feat-bin-shared-executables-for-agent-ho-21
---

# feat: bin/ — shared executables for agent home

**Source**: [Github #21](https://github.com/SkogAI/dot-skogai/issues/21)

## Description

## Summary

Shared binaries/scripts available to all agents in the household — on PATH or invoked directly.

## What

```
bin/
├── skogai-cli        # main SkogAI CLI entrypoint
├── skogai-parse      # message routing / operator parsing
├── skogai-todo       # todo management
├── skogai-queue      # task queue operations
├── skogai-worktree   # worktree helpers
└── ...               # other shared tools
```

## Notes

- These are literally shared executables — the equivalent of `/usr/local/bin` for

## Notes

*Imported from external tracker. See source link for full context.*
