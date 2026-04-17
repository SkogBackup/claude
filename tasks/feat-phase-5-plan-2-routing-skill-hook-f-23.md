---
state: new
created: 2026-04-18
tracking: ["https://github.com/SkogAI/claude/issues/23"]
---

# feat: phase 5 plan 2 — routing skill, hook fallback, settings wiring

**Source**: [Github #23](https://github.com/SkogAI/claude/issues/23)

## Description

Implements ROADMAP Phase 5, Plan 2. Depends on Phase 5 Plan 1.

## Requirements

* CHAT-06: Skill teaches Claude to detect and route channel messages
* CHAT-07: Hook fallback calls the same routing script as the instruction path (no divergence)

## Deliverables

* `.claude/skills/phase5.md` (or equivalent) — routing skill
* Hook entry in `settings.json` wiring `bin/route-message.sh` as fallback
* Verification that skill and hook use the same routing logic

## Notes

*Imported from external tracker. See source link for full context.*
