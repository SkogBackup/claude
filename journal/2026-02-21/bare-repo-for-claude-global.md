# Bare repo for tracking ~/.claude/ — the CLI's runtime home

Set up a dotfiles-style bare git repo to track everything the claude code CLI writes to `~/.claude/`. Combined with symlinks from `~/claude/global/` pointing back, we get full observability of the CLI's behavior while keeping our workspace clean.

## What we built

- **Bare repo** at `/mnt/sda1/claude-global.git` with work tree `$HOME`
- **Wrapper script** `./scripts/cgit.sh` for all bare repo operations
- **Auto-sync hook** via `UserPromptSubmit` — both repos commit on every message
- **`./global/`** directory with symlinks to important `~/.claude/` files (settings, projects, plans, todos, plugins)
- **`./scripts/clog.sh`** to view commit history from both repos side-by-side

## Key discovery: the CLI overwrites settings.json on restart

Hard-linking `settings.json` between repos breaks on session restart — the CLI writes a new file, creating a new inode. Symlinks survive because they follow the path, not the inode. The canonical file lives at `~/.claude/settings.json` (CLI-owned), and `./global/settings.json` is a symlink pointing at it.

## What the bare repo revealed

On session restart, the CLI flushes: `.claude.json` (247 lines of runtime state), 5 backup copies, debug logs (8k+ lines), shell snapshots (10k lines), session-env versions, file-history entries, and more. A single restart commit was 12k insertions. This is why the context window journal entry found 36k tokens of overhead — the CLI carries a lot of internal state.

## Beads cleanup

Closed 14 of 30 migration issues. The bare repo changed the strategy: instead of "drop and let regenerate" for runtime files, we now "track everything and observe." The remaining 16 issues cover things that still need symlinks or review (auto-memory, CLAUDE.md, hooks, skills, history, keybindings, and some SkogAI-specific dirs).

## The bigger picture

This connects back to the inbox.md pattern from a year ago — git diffs as first-class knowledge artifacts. The bare repo turns the CLI's opaque runtime behavior into readable commit history. Every session restart, every config change, every file the CLI creates is captured and diffable.
