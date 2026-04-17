---
state: new
created: 2026-04-17
tracking:
  - https://github.com/SkogAI/dot-skogai/issues/18
permalink: claude/tasks/feat-scripts-bootstrap-init-and-symlink-18
---

# feat: scripts/bootstrap/ — init and symlink setup

**Source**: [Github #18](https://github.com/SkogAI/dot-skogai/issues/18)

## Description

## Summary

Bootstrap scripts for initializing `.skogai` in a new consumer project and for the dogfooding symlink mode.

## What

- `bootstrap.sh` — one-shot init: creates missing dirs, `.gitkeep` files, runs `symlink.sh`
- `consumer-init.sh` — post-submodule-add setup for consumer projects
- `symlink.sh` — wires up any symlinks needed (e.g. `~/.skogai → /path/to/.skogai` for dogfooding)

## Notes

- Must be idempotent (safe to run multiple times)
- No absolute paths — derive from script location
-

## Notes

*Imported from external tracker. See source link for full context.*
