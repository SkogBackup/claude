# .skogai/tools/ -- executable tooling inventory

Canonical location for executable tools that used to live in home-folder `bin/` paths.

## local executables

### `healthcheck`
- **purpose:** run workspace sanity checks (routing files, identity paths, core tool availability).
- **usage:** `./.skogai/tools/healthcheck`
- **arguments:** none.

### `claude-md-linecheck`
- **purpose:** hook helper that warns when edited `CLAUDE.md` files exceed 80 lines.
- **usage:** `./.skogai/tools/claude-md-linecheck` (expects hook JSON on stdin).
- **arguments:** none (reads tool payload from stdin).

### `context.sh`
- **purpose:** orchestrate context generation for agents.
- **usage:** `./.skogai/tools/context.sh [AGENT_DIR]`
- **arguments:**
  - `AGENT_DIR` (optional): workspace root to inspect. Defaults to detected agent root.

### `context-git.sh`
- **purpose:** render git status + recent commits context block.
- **usage:** `./.skogai/tools/context-git.sh [AGENT_DIR]`
- **arguments:**
  - `AGENT_DIR` (optional): repo root. Defaults to detected git toplevel.

### `context-journal.sh`
- **purpose:** render recent journal context from flat and date-subdir formats.
- **usage:** `./.skogai/tools/context-journal.sh [AGENT_DIR]`
- **arguments:**
  - `AGENT_DIR` (optional): workspace root containing `journal/`.

### `context-workspace.sh`
- **purpose:** render tree view of key workspace directories.
- **usage:** `./.skogai/tools/context-workspace.sh [AGENT_DIR]`
- **arguments:**
  - `AGENT_DIR` (optional): workspace root to scan.

### `fetch-docs.sh`
- **purpose:** download Claude Code docs markdown snapshots from `code.claude.com`.
- **usage:** `./.skogai/tools/fetch-docs.sh`
- **arguments:** none.

### `find-agent-root.sh`
- **purpose:** locate the nearest agent root (`gptme.toml` with `[agent]`, fallback to git root).
- **usage:**
  - command mode: `./.skogai/tools/find-agent-root.sh [START_DIR]`
  - source mode: `. ./.skogai/tools/find-agent-root.sh && find_agent_root [START_DIR]`
- **arguments:**
  - `START_DIR` (optional): directory to start upward search from.

## environment binaries (discoverability)

These are expected platform tools and should be considered "big tools". Availability depends on the host image.

- `gptodo` — task/issue management CLI (`gptodo --help`)
- `wt` — worktrunk worktree manager (`wt --help`)
- `gita` — multi-repo git operations (`gita --help`)
- `skogai` — SkogAI CLI (`skogai --help`)
- `skogcli` — SkogAI client CLI (`skogcli --help`)
- `argc` — argument/command parser (`argc --help`)
