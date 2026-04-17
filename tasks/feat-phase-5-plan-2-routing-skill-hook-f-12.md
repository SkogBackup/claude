---
state: new
created: 2026-04-17
tracking:
  - https://github.com/SkogAI/claude/issues/12
permalink: claude/tasks/feat-phase-5-plan-2-routing-skill-hook-f-12
---

# feat: phase 5 plan 2 — routing skill, hook fallback, settings wiring

**Source**: [Github #12](https://github.com/SkogAI/claude/issues/12)

## Description

Part of #9 (Claude's Home v2.0). Depends on phase 5 plan 1 issue.

Implements ROADMAP Phase 5, Plan 2.

## Requirements covered

- CHAT-06: Skill teaches Claude to detect and route channel messages
- CHAT-07: Hook fallback calls the same routing script as the instruction path (no divergence)

## Deliverables

- `.claude/skills/phase5.md` (or equivalent) — routing skill CLAUDE.md
- Hook entry in `settings.json` wiring `bin/route-message.sh` as fallback
- Verification that skill and hook use the sam

## Notes

*Imported from external tracker. See source link for full context.*
