# gita integration into claude code workflow

integrated gita (multi-repo git manager) as a first-class tool in the claude code workspace.

## what was done

- registered 27 repos across `~/claude/` and `~/.local/src/`
- created 4 groups: `web`, `claude-home`, `src`, `skogai` (superset)
- built a skill at `skills/gita/SKILL.md` with command reference, group details, and common workflows
- symlinked `~/.config/gita/` into the skill directory for direct config access
- saved gita knowledge to auto memory for cross-session persistence

## gotchas discovered

- gita group names cannot match existing repo names (`claude` was taken, used `claude-home`)
- repos with same basename from different paths get auto-prefixed (e.g. `src/claude-memory` vs `claude-memory`)
- `wt merge` produces zero output on success — led to running it twice unnecessarily and creating issue #39 for wrapper scripts

## spawned work

- SkogAI/claude#39: wrapper scripts for CLI tools with visible output (gptodo import, wt merge, etc.)
