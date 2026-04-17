---
title: AGENTS
type: note
permalink: claude/lab/projects-in-development/skogtown/agents
---

# Agent Instructions

Skogtown is the central hub for AI agent orchestration ("Gas Town"). It manages multiple isolated workspaces (rigs) where AI agents work on shared codebases.

## Quick Start

```bash
bd onboard              # Initialize beads issue tracking
bd ready                # Find available work
gt prime                # Load full context (for Mayor sessions)
```

## Build / Lint / Test Commands

```bash
# Linting (pre-commit hooks)
pre-commit run --all-files          # Run all linters
pre-commit run shellcheck --all-files   # Shell scripts only
pre-commit run prettier --all-files     # YAML/JSON/Markdown only

# Single hook on specific file
pre-commit run trailing-whitespace --files path/to/file.md

# Install hooks (first time setup)
pre-commit install
```

**Pre-commit checks enabled:**

- `trailing-whitespace` - No trailing whitespace
- `end-of-file-fixer` - Files end with single newline
- `check-yaml` - Valid YAML syntax
- `check-added-large-files` - Blocks large files
- `check-merge-conflict` - No merge conflict markers
- `mixed-line-ending` - Consistent line endings
- `shellcheck` - Shell script linting (severity=warning)
- `prettier` - Format YAML, Markdown, JSON

## Issue Tracking (bd)

```bash
bd ready                              # Find available work
bd show <id>                          # View issue details
bd update <id> --status in_progress   # Claim work
bd close <id>                         # Complete work
bd sync                               # Sync with git
bd create "title" --priority high     # Create new issue
bd q "quick capture"                  # Quick capture, returns ID only
bd list --status pending              # List pending issues
bd search "keyword"                   # Search issues
```

## Agent Workflow (gt)

```bash
gt sling <issue-id>         # Assign work to agent
gt hook                     # Show current hook (assigned work)
gt done                     # Signal work ready for merge
gt mail inbox               # Check messages
gt nudge <agent> "message"  # Send message to agent
gt trail                    # Show recent agent activity
```

## Project Structure

```
/skogtown
  AGENTS.md              # This file (agent instructions)
  .pre-commit-config.yaml # Linting configuration
  .beads/                # Issue tracking database (gitignored except metadata)
  daemon/                # Daemon process state and logs
  deacon/                # Watchdog/patrol process
  mayor/                 # Overseer config (rigs, accounts, escalation)
  plugins/               # Town-level plugins for patrol cycles
  settings/              # Global settings (escalation routes)
  logs/                  # Log files

  # Rigs (isolated workspaces for collaborative work)
  gastown/               # Rig: SkogAI/gastown (Gas Town infrastructure)
  skogix/                # Rig: SkogAI/skogix (main collaborative workspace)
```

### Personal Agent HQs (Countryside Retreats)

Agents have their own Gas Town HQ instances outside /skogtown:

```
/home/skogix/skogai/
  claude/                # claude-hq: Personal Gas Town HQ for claude agent
  amy/                   # amy-hq: Personal Gas Town HQ for amy agent
  dot/                   # dot-hq: Personal Gas Town HQ for dot agent
  goose/                 # goose-hq: Personal Gas Town HQ for goose agent
```

**Architecture Pattern: "Downtown Office + Countryside Retreat"**

- **Collaborative workspace** (/skogtown): Agents work as crew members on shared projects
- **Personal HQs** (/home/skogix/skogai/{agent}/): Agents serve as mayors in their own towns
- Personal town daemons can be stopped when not needed (resource efficiency)
- Clear separation between personal reflection/knowledge management and collaborative work

Each rig contains:

- `config.json` - Rig configuration (git_url, beads prefix)
- `.beads/` - Local issue database
- `mayor/` - Mayor-related config for this rig
- `polecats/` - Worker worktrees (gitignored)
- `refinery/` - Merge queue working directory
- `witness/` - Monitoring agent data
- `.repo.git/` - Bare git repository

## Code Style Guidelines

### JSON Files

- Use 2-space indentation
- Include `type` and `version` fields for config files
- Use ISO 8601 timestamps with timezone: `2026-01-16T10:18:33+01:00`
- Format with prettier

### YAML Files

- Use 2-space indentation
- Format with prettier
- Validate with `check-yaml`

### Markdown Files

- End files with single newline
- No trailing whitespace
- Format with prettier

### Shell Scripts

- Must pass shellcheck at warning level
- Excluded: `.envrc`, `Argcfile.sh`

### Git

- Use `bd merge` strategy for `.beads/issues.jsonl` (see `.gitattributes`)
- Commit messages should reference issue IDs when applicable

## Session Completion (MANDATORY)

**Work is NOT complete until `git push` succeeds.**

```bash
# 1. File issues for remaining work
bd create "Follow-up: ..." --priority medium

# 2. Run quality gates
pre-commit run --all-files

# 3. Update issue status
bd close <completed-id>
bd update <in-progress-id> --status pending

# 4. Sync and push (NON-NEGOTIABLE)
git pull --rebase
bd sync
git push
git status  # MUST show "up to date with origin"

# 5. Clean up
git stash clear
git remote prune origin
```

**Critical Rules:**

- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds

## Directory Patterns

| Pattern            | What it contains                    |
| ------------------ | ----------------------------------- |
| `**/state.json`    | Runtime state (gitignored)          |
| `**/*.lock`        | Lock files (gitignored)             |
| `**/registry.json` | Runtime registries (gitignored)     |
| `**/polecats/`     | Worker worktrees (gitignored)       |
| `**/crew/`         | User-managed workspaces             |
| `**/.runtime/`     | Ephemeral runtime data (gitignored) |
| `**/.beads/`       | Issue database (partially tracked)  |
| `**/CLAUDE.md`     | Role-specific context files         |

## Agent Roles

| Role     | Purpose                        | Location      |
| -------- | ------------------------------ | ------------- |
| Mayor    | Overseer coordinating all rigs | `mayor/`      |
| Deacon   | Watchdog/patrol process        | `deacon/`     |
| Refinery | Merge queue processor          | `*/refinery/` |
| Witness  | Monitoring agent               | `*/witness/`  |
| Polecat  | Worker agents                  | `*/polecats/` |

## Plugin System

Plugins in `plugins/` run during Deacon patrol cycles. Each plugin has:

- `plugin.md` with TOML frontmatter defining gates

**Gate types:**

- `cooldown` - Time since last run (e.g., `24h`)
- `cron` - Schedule-based (e.g., `"0 9 * * *"`)
- `condition` - Metric threshold
- `event` - Trigger-based (startup, heartbeat)

## Escalation Routes

Priority-based routing (see `settings/escalation.json`):

- `critical`: bead -> mail:mayor -> email:human -> sms:human
- `high`: bead -> mail:mayor -> email:human
- `medium`: bead -> mail:mayor
- `low`: bead only

Stale threshold: 4 hours
