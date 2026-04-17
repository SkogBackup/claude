---
title: AGENTS
type: note
permalink: claude/agents
---

# AGENTS.md

Codex/agent instructions for this repository.

## Purpose

This repository is a personal workspace (not a single app). Most context is documented in `CLAUDE.md` router files across the tree. As an agent, prefer loading the nearest `CLAUDE.md` for the area you are editing.

## Scope and routing

- Start with `./CLAUDE.md` for top-level orientation.
- Before changing files in a subdirectory, check whether that directory has its own `CLAUDE.md` and follow it.
- If a nested `AGENTS.md` exists, it overrides this file for that subtree.

## Editing guidelines

- Keep changes minimal and focused; avoid broad refactors unless requested.
- Preserve the repository's structure as a workspace + knowledge base.
- Prefer additive documentation updates over rewriting historical notes.
- Do not delete or rewrite journal/history-style files unless explicitly requested.

## Validation

- For documentation-only changes, run lightweight checks (for example, `git diff --check`).
- For code changes, run the smallest relevant test/lint commands documented in the nearest context file.

## Commit conventions

- Use conventional commits in lowercase imperative style:
  - `docs:` for documentation updates
  - `chore:` for maintenance/config
  - `feat:` for new capabilities
  - `fix:` for bug fixes

## Notes

- Existing `CLAUDE.md` files are still canonical context artifacts for this repo.
- This `AGENTS.md` exists to make non-Claude coding agents work smoothly in the same workspace.
