---
state: new
created: 2026-04-18
tracking: ["https://github.com/SkogAI/claude/issues/36"]
---

# feat: bin/ — shared executables for agent home

**Source**: [Github #36](https://github.com/SkogAI/claude/issues/36)

## Description

Shared binaries/scripts available to all agents in the household — on PATH or invoked directly.

## Structure

```
.skogai/bin/
├── skogai-cli        # main SkogAI CLI entrypoint
├── skogai-parse      # message routing / operator parsing
├── skogai-todo       # todo management
├── skogai-queue      # task queue operations
├── skogai-worktree   # worktree helpers
└── ...               # other shared tools
```

## Notes

* The equivalent of `/usr/local/bin` for the skogai household
* Scripts here 

## Notes

*Imported from external tracker. See source link for full context.*
