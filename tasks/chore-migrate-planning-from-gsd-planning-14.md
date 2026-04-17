---
state: new
created: 2026-04-17
tracking:
  - https://github.com/SkogAI/claude/issues/14
permalink: claude/tasks/chore-migrate-planning-from-gsd-planning-14
---

# chore: migrate planning from gsd/.planning to skogai-planning-with-files

**Source**: [Github #14](https://github.com/SkogAI/claude/issues/14)

## Description

Part of #9 (Claude's Home v2.0). From TODO.md.

## Problem

The current planning setup uses the GSD framework under `.planning/`. This is skogix's tooling installed in claude's home. The goal is to gradually replace it with the native `skogai-planning-with-files` skill/setup.

## Deliverables

- Audit what GSD/.planning currently provides that active work depends on
- Define the skogai-planning-with-files equivalent structure
- Migrate `.planning/` content to the new structure (or establish coexis

## Notes

*Imported from external tracker. See source link for full context.*
