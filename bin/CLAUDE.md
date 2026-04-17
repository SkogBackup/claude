---
title: CLAUDE
type: note
permalink: claude/bin/claude
---

# bin/ -- Executable scripts

Scripts and tools for home directory operations.

## contents

- `healthcheck` -- verifies environment sanity and identity integrity: env checks (home dir, gt cli, bd/beads, dolt server, git config, claude_home rig), identity path validation (soul sections, profile, core frameworks, journal conventions), CLAUDE.md routing verification, and memory block tier reporting (active vs LORE). Exits non-zero on failures. Run: `./bin/healthcheck`

### Context scripts

Generic context generation scripts (originally by Dot). Produce system prompt context for agents.

- `context.sh` -- main orchestrator, calls all component scripts. Usage: `./bin/context.sh [AGENT_DIR]`
- `context-journal.sh` -- journal entries (supports flat + subdirectory formats). Usage: `./bin/context-journal.sh [AGENT_DIR]`
- `context-git.sh` -- git status + recent commits (with truncation)
- `context-workspace.sh` -- workspace tree structure
- `build-system-prompt.sh` -- reads gptme.toml and builds a full system prompt
- `find-agent-root.sh` -- agent root detection

All context scripts accept an optional `AGENT_DIR` argument. Default: git repo root.
