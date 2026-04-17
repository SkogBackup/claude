---
state: new
created: 2026-04-18
tracking: ["https://github.com/SkogAI/claude/issues/38"]
---

# feat: create worktrunk specialist skill

**Source**: [Github #38](https://github.com/SkogAI/claude/issues/38)

## Description

Create `.skogai/skills/worktrunk/SKILL.md` covering the full `wt` CLI for git worktree management.

## Scope

* All `wt` commands: create, open, list, merge, remove, switch, ship
* Project hooks (`.config/wt.toml`)
* User config (`~/.config/worktrunk/config.toml`)
* Branching model: worktree branch → PR to master

## Acceptance criteria

- [ ] `skills/worktrunk/SKILL.md` created
- [ ] Skill description triggers correctly for worktree-related requests
- [ ] Covers both user config and project con

## Notes

*Imported from external tracker. See source link for full context.*
