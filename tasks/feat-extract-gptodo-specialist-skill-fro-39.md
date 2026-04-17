---
state: new
created: 2026-04-18
tracking: ["https://github.com/SkogAI/claude/issues/39"]
---

# feat: extract gptodo specialist skill from gptme

**Source**: [Github #39](https://github.com/SkogAI/claude/issues/39)

## Description

Extract gptodo-specific content from `skills/gptme/SKILL.md` into a standalone `.skogai/skills/gptodo/SKILL.md`.

## Scope

* Task import from GitHub/Linear issues (`gptodo import`)
* Task lifecycle: list, check, fetch, sync
* Worktree-aware task management (`gptodo worktree`)
* Agent spawning (`gptodo spawn --backend claude`)
* `GPTODO_TASKS_DIR` configuration

## Acceptance criteria

- [ ] `skills/gptodo/SKILL.md` created as standalone skill
- [ ] gptme [SKILL.md](<http://SKILL.md>) updated to

## Notes

*Imported from external tracker. See source link for full context.*
