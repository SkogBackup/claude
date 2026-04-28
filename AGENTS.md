---
title: AGENTS
type: router
permalink: claude/agents
---

# AGENTS.md

**Generated:** 2026-04-28T00:00:00+02:00
**Commit:** c52cee0e
**Branch:** master

## OVERVIEW

Personal workspace + knowledge base for SkogAI ecosystem. Not an app — router-driven CLAUDE.md files at every level. Staged at `/home/skogix/claude`, deploying to `/home/claude`.

## STRUCTURE

```
~/
├── .skogai/          # SkogAI bootstrap/submodule (symlink → /home/skogix/.skogai)
├── .claude/          # Claude Code config (settings.json, commands/, skills/)
├── .planning/        # GSD project planning (phases/, ROADMAP.md, STATE.md)
├── personal/         # Identity, soul, memory blocks, journal
├── lab/              # Experiments, WIP projects
├── journal/          # Session journals (YYYY-MM-DD/)
├── docs/             # Reference docs (deployment-gate, permissions)
├── commands/         # Slash command definitions
└── CLAUDE.md        # Top-level router (start here)
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| SkogAI bootstrap/conventions | `.skogai/CLAUDE.md` | Argc scripts, kebab-case, UPPERCASE.md |
| Identity/soul/memory | `personal/CLAUDE.md` | 10-section soul, LORE museum |
| Experiments/WIP | `lab/CLAUDE.md` | Unstable, move when done |
| Project planning | `.planning/ROADMAP.md` | v1.0: 4/5 phases complete |
| Plugin/skill dev | `.skogai/skills/` | Each skill: SKILL.md + manifest.json |
| Session context | `.planning/memory/MEMORY.md` | Auto-generated feedback |
| Git worktrees | `.config/wt.toml` | Worktrunk config |

## CONVENTIONS (deviations only)

- **Naming**: kebab-case files, UPPERCASE.md for key docs, lowercase.md for standard
- **Bash scripts**: `#!/usr/bin/env bash`, `set -euo pipefail`, argc framework
- **@ notation**: `@path/to/file` expands at prompt-time (bypass cache)
- **No standard app structure**: no `src/`, `main()`, `package.json` at root
- **Symlinks**: `.skogai` → `/home/skogix/.skogai` (dogfooding mode)
- **Commit style**: lowercase conventional (`docs:`, `feat:`, `fix:`, `chore:`)

## ANTI-PATTERNS (THIS PROJECT)

- Never delete journal/history files (append-only)
- Never use `as any` / `@ts-ignore` in TypeScript
- Never commit without explicit user request
- Never bulk pre-load context — read routers lazily
- `scripts/scripts` symlink loop — known issue, don't follow

## COMMANDS

```bash
rtk git status              # Prefixed with rtk (token savings)
wt new <branch>            # Worktree in .claude/worktrees/
gptodo list                 # Task/issue management
skogai <cmd>               # SkogAI CLI
argc --argc-eval <script>   # Argc CLI dispatch
dagu start-all              # Workflow orchestration (localhost:8080)
```

## NOTES

- Phase 5 active: `skogai-live-chat-implementation` (chat-io contract, `[@agent:"msg"]` routing)
- MCP servers: searxng (web search via searxng.aldervall.se)
- Hook files in `.github/hooks/` + `.claude/` (gsd-*, rtk-rewrite)
- Email dir (19059 files) is noise — exclude from all searches
- LSP unavailable for this workspace (knowledge base, not code)
