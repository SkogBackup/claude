---
title: CLAUDE
type: note
permalink: claude/projects/dot-skogai/claude
---

# .skogai - SkogAI Repository Bootstrap

This repository is the shared configuration, knowledge base, and tooling layer for all SkogAI projects. It is distributed as a git submodule at `.skogai/` in consumer projects.

## What is this?

`.skogai` is the central bootstrap and knowledge system for the SkogAI ecosystem. It provides:

- **Knowledge base** — documented decisions, learnings, patterns
- **Memory system** — session context, decision log
- **Project tracking** — project state, roadmaps, planning
- **Script infrastructure** — argc-powered bash automation
- **Skills registry** — domain-specific Claude Code skills
- **Workflow orchestration** — Dagu-based workflow DAGs
- **Worktrunk configuration** — shared `.config/wt.toml` for git worktree workflow

## File Structure

```
.skogai/
├── CLAUDE.md                   # Claude Code instructions (this file)
├── SKOGAI.md                   # Guidance with XML-style structural tags
├── README.md                   # Human-readable overview
├── Argcfile.sh                 # Argc CLI for queue management
├── base.yaml / config.yaml     # Dagu orchestration configuration
├── .envrc                      # Direnv PATH configuration
├── .config/
│   └── wt.toml                 # Worktrunk git worktree hooks
├── bin/
│   ├── skogai-loops            # Wrapper for gptme-runloops
│   └── skogai-ralph            # Wrapper for ralph tool
├── dotfiles/
│   └── install.sh              # Safety-checked dotfiles installer
├── email/                      # Email management (inbox, drafts, sent, archive)
├── knowledge/
│   ├── DECISIONS.md            # Decision index (router → decisions/)
│   ├── decisions/              # Architectural decision records (ADRs)
│   ├── lessons/                # Documented lessons from sessions
│   └── patterns/               # Reusable patterns and style guides
├── memory/
│   ├── GLOSSARY.md             # Shared vocabulary
│   ├── PROJECTS.md             # Active project index (router)
│   ├── feedback/               # Behavioral feedback records
│   └── references/             # External system pointers
├── plan/
│   ├── claudes-home/           # Claude's Home project plan (phases 1-5)
│   ├── codebase/               # Architecture, conventions, stack docs
│   ├── PROJECT.md              # Project definition and requirements
│   ├── ROADMAP.md              # 4-phase roadmap
│   └── STATE.md                # Current phase/plan progress
├── projects/
│   └── overview.md             # Active/paused/archived projects table
├── scripts/
│   ├── bootstrap/              # Submodule init and consumer-init scripts
│   ├── context/                # 26 context-generation scripts
│   └── utils/                  # search, wordcount, state-status, migration
├── skills/
│   ├── skill-registry.json     # Registry of all skills
│   └── */                      # Individual skill directories (SKILL.md + manifest.json)
├── tasks/                      # Task tracking files
├── templates/                  # Starter templates (knowledge-entry, decision-record, project-status)
├── todos/                      # Work items (NNN-status-pN-description.md)
├── tools/                      # Tools placeholder
└── workflows/                  # Dagu DAG files and workflow docs
```

## Always Load

Before starting any work, read:

```
@CONTEXT.md   — dynamically generated current context (workspace, git state, memory)
```

## Architecture Modes

**Dogfooding** (developing .skogai itself):

```bash
.skogai -> /home/skogix/.skogai   # symlink
.git/info/exclude contains .skogai
```

**Consumer** (project using .skogai as submodule):

```bash
git submodule add <repo-url> .skogai
(cd .skogai && ./scripts/bootstrap/bootstrap.sh)
```

**Detection:**

```bash
file .skogai  # symbolic link = dogfooding, directory = submodule
file .git     # directory = real repo, ASCII text file = submodule
```

## User Context (skogix)

- Functional programmer — data transformations over control flow, pure functions, immutable data
- Simplicity first — complexity only when earned
- Direct expert-level communication — give the answer first, explain after
- Lowercase for generic references (`claude`, `readme`), uppercase for exact names (`CLAUDE.md`, `Claude`)
- Uses git worktrees extensively (via Worktrunk)
- Prefers code/data over prose

## Repository Conventions

### Naming

- **kebab-case** — all files and directories
- **UPPERCASE.md** — important docs (`CLAUDE.md`, `README.md`, `PROJECT.md`, `ROADMAP.md`)
- **lowercase.md** — standard docs (`todo.md`, `decisions.md`)
- **.sh** — bash scripts; **.py** — Python; **.bats** — bash test files

### Bash Scripts

- Shebang: `#!/usr/bin/env bash`
- Strict mode: `set -euo pipefail`
- UPPERCASE for env vars/constants, lowercase for local vars, snake_case for functions
- Color output: RED=errors, GREEN=success, YELLOW=warnings, BLUE=info
- Minimal comments — only where logic is non-obvious
- Never hide errors or warnings behind abstractions

### Script Framework (argc)

All scripts in `scripts/` use argc for declarative CLI definition:

```bash
# @describe script description
# @arg name![`_choice_validator`] Argument description
main() { ... }
eval "$(argc --argc-eval "$0" "$@")"
```

### Code Quality

1. Minimal abstractions — pragmatic over perfect
1. Self-documenting code — names matter
1. Error visibility — never hide errors or warnings
1. Functional programming — prefer immutable data, pure functions
1. Simplicity first — no speculative abstractions
1. No over-engineering — only what the task actually requires

## Knowledge Management

### Where to Look

| Task                          | Location                                                   |
| ----------------------------- | ---------------------------------------------------------- |
| Log a decision                | `knowledge/decisions/` + index in `knowledge/DECISIONS.md` |
| Document a lesson             | `knowledge/lessons/`                                       |
| Record architectural decision | `knowledge/decisions/`                                     |
| Capture reusable pattern      | `knowledge/patterns/`                                      |
| Track project status          | `projects/overview.md`                                     |
| Quick capture                 | `inbox/`                                                   |
| Create new content            | `templates/` (see `templates/CLAUDE.md`)                   |

### Templates

- `templates/knowledge-entry.md` — learnings and patterns
- `templates/decision-record.md` — ADRs
- `templates/project-status.md` — project tracking

### @ Notation

`@path/to/file` expands the file at prompt-time, bypassing cache. Use it for files that must be current:

- `@CONTEXT.md` — dynamically generated current context
- `@knowledge/lessons/` — current lessons

## Todo System

Todos in `todos/` follow the naming convention:

```
NNN-status-pN-description.md
```

- Status: `pending`, `ready`, `in-progress`, `done`
- Priority: `p1` (critical/blocking), `p2` (high), `p3` (lower)

**Current critical items (P1 — do not ignore):**

- `001-pending-p1-shell-injection-plugin-names.md` — shell injection in session-start.sh (BLOCKS MERGE)
- `002-pending-p1-race-condition-file-updates.md` — race condition in concurrent file updates
- `017-pending-p1-plugin-trial-garden-system.md` — plugin trial garden system

## Skills Registry

Skills in `skills/` are domain-specific knowledge modules activated by context:

| Skill                       | Activation                                                  |
| --------------------------- | ----------------------------------------------------------- |
| `conductor-methodology`     | Always active                                               |
| `typescript-best-practices` | `*.ts`, `*.tsx` files or typescript/type/interface keywords |
| `api-design`                | api/endpoint/rest keywords or routes/controllers/api paths  |
| `testing-strategies`        | test/unit/integration/mock keywords or test directories     |
| `java-best-practices`       | `*.java`, pom.xml, build.gradle or java/optional keywords   |

Each skill: `skills/<name>/SKILL.md` + `manifest.json`

## Workflow Orchestration (Dagu)

- **Binary**: `/home/skogix/.local/bin/dagu` (v1.30.3)
- **Server**: `http://localhost:8080` (start with `dagu start-all`)
- **Config**: `config.yaml` (server), `base.yaml` (base DAG config)
- **Key commands**: `dagu start`, `dagu dry`, `dagu validate`, `dagu exec`

Rules for Dagu work:

- Write a small YAML DAG, run it, see what happens, adjust
- If it takes more than 2-3 lines of bash, rethink the approach
- Use `jq` for JSON — never sed/awk
- Use native Dagu features (`output:`, `parallel:`, `type: jq`, `call:`, `retryPolicy:`)
- Every DAG should fit in one screen

## SSH MCP Multi-User Architecture

- `skogai-ssh` MCP server — execute commands on remote systems
- `claude-ssh` MCP server — execute as claude user (localhost:22)
- Each agent can have a dedicated MCP server for workspace isolation
- Cross-user coordination via MCP instead of direct filesystem access

## Integration as Git Submodule

### Adding to a project

```bash
git submodule add <repo-url> .skogai
git submodule update --init --recursive
```

### Updating submodule in a project

```bash
cd .skogai
git pull origin master
cd ..
git add .skogai
git commit -m "Update .skogai submodule"
```

## Important Notes

- This is a **bootstrap/submodule project** — changes here affect all SkogAI projects that include it
- Keep configuration **portable** — no absolute paths or user-specific settings
- Keep it **minimal** — only include what is genuinely shared across projects
- Configuration is **optional** — consumer projects can override or ignore as needed
- **@ notation is truth** — use `@file` for content that must be current, not cached
- **No code implementation in v1** — establish system and principles first, build on them after
- **Greenfield approach** — existing Python/JS codebase is exploratory; target paradigm is functional-first (F#) with argc and 98% test coverage
