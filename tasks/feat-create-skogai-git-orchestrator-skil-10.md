---
state: new
created: 2026-04-17
tracking:
  - https://github.com/SkogAI/dot-skogai/issues/10
permalink: claude/tasks/feat-create-skogai-git-orchestrator-skil-10
---

# feat: create skogai-git orchestrator skill

**Source**: [Github #10](https://github.com/SkogAI/dot-skogai/issues/10)

## Description

Parent epic: #7

## Summary

Create `skills/skogai-git/SKILL.md` that orchestrates gita, worktrunk, and gptodo into unified git workflows.

## Scope

- Routing table: intent → sub-skill (status → gita, worktree → worktrunk, tasks → gptodo)
- Composite workflows:
  - Morning check (fetch all, show dirty/behind)
  - Start task (pick issue → create worktree → assign)
  - Ship task (commit → push → PR → merge → clean up)
  - End of day (status across all worktrees + repos)
- @-references to sub-skil

## Notes

*Imported from external tracker. See source link for full context.*
