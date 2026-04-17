---
state: new
created: 2026-04-18
tracking: ["https://github.com/SkogAI/claude/issues/28"]
---

# feat: memory/ — session context and decision log

**Source**: [Github #28](https://github.com/SkogAI/claude/issues/28)

## Description

Live project memory: what we're working on right now and a running log of decisions made.

## Structure

```
.skogai/memory/
├── context/
│   └── current.md   # always-loaded: current focus, active thread, blockers
└── decisions.md     # append-only log of decisions (quick, informal)
```

* `current.md` — the one file always injected into context. Short: what we're doing, what's next, what's blocked.
* `decisions.md` — lightweight decision log (not full ADRs, just "decided X because Y")

## Notes

*Imported from external tracker. See source link for full context.*
