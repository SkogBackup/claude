---
state: new
created: 2026-04-18
tracking: ["https://github.com/SkogAI/claude/issues/40"]
---

# feat: create skogai-git orchestrator skill

**Source**: [Github #40](https://github.com/SkogAI/claude/issues/40)

## Description

Create `.skogai/skills/skogai-git/SKILL.md` that orchestrates gita, worktrunk, and gptodo into unified git workflows.

## Scope

* Routing table: intent → sub-skill (status → gita, worktree → worktrunk, tasks → gptodo)
* Composite workflows:
  * Morning check (fetch all, show dirty/behind)
  * Start task (pick issue → create worktree → assign)
  * Ship task (commit → push → PR → merge → clean up)
  * End of day (status across all worktrees + repos)

## Depends on

* worktrunk specialist skill
* 

## Notes

*Imported from external tracker. See source link for full context.*
