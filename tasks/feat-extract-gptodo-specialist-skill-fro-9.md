---
state: new
created: 2026-04-17
tracking:
  - https://github.com/SkogAI/dot-skogai/issues/9
permalink: claude/tasks/feat-extract-gptodo-specialist-skill-fro-9
---

# feat: extract gptodo specialist skill from gptme

**Source**: [Github #9](https://github.com/SkogAI/dot-skogai/issues/9)

## Description

Parent epic: #7

## Summary

Extract gptodo-specific content from `skills/gptme/SKILL.md` into a standalone `skills/gptodo/SKILL.md`.

## Scope

- Task import from GitHub issues (`gptodo import`)
- Task lifecycle: list, check, fetch, sync
- Worktree-aware task management (`gptodo worktree`)
- Agent spawning (`gptodo spawn --backend claude`)
- GPTODO_TASKS_DIR configuration

## Acceptance criteria

- [ ] `skills/gptodo/SKILL.md` created as standalone skill
- [ ] gptme SKILL.md updated to referenc

## Notes

*Imported from external tracker. See source link for full context.*
