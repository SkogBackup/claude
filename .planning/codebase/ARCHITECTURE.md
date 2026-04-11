# Architecture

**Analysis Date:** 2026-03-20

## Pattern Overview

**Overall:** Layered agent-based system with lazy-loaded modular workflows

**Key Characteristics:**
- Event-driven hook system for runtime instrumentation
- Modular skill/agent architecture with isolated concerns
- Tool-mediated execution (Bash, Read, Write, Grep, Glob)
- State-managed project planning coordination
- Git-integrated commit and version tracking
- Configuration-first with sensible defaults

## Layers

**Configuration & Setup:**
- Purpose: Parse and validate runtime environment, project config, permissions
- Location: `.claude/settings.json`, `.planning/config.json`
- Contains: JSON configuration, environment variables, permission policies
- Depends on: Filesystem (fs), path resolution
- Used by: All agents, hooks, and CLI tools

**State & Persistence:**
- Purpose: Manage project state across sessions, track phase progress, maintain project metadata
- Location: `.planning/PROJECT.md`, `.planning/STATE.md`, `.planning/REQUIREMENTS.md`, `.planning/ROADMAP.md`
- Contains: Frontmatter-driven documents with structured metadata, markdown content
- Depends on: Filesystem, git operations
- Used by: Planners, executors, roadmap management

**Core Tooling Layer (GSD Tools):**
- Purpose: Centralized command handling for state mutation, git operations, phase management
- Location: `.claude/get-shit-done/bin/gsd-tools.cjs` and `lib/` subdirectories
- Contains: CLI command parser, library modules for specific operations
- Depends on: fs, child_process, git CLI
- Used by: All agents, hooks, CLI entry points

**Library Modules (lib/):**
- `core.cjs`: Shared utilities (path handling, file I/O, config loading, git integration, markdown normalization)
- `commands.cjs`: Standalone utility commands (slug generation, timestamps, todos)
- `config.cjs`: Configuration loading and validation with migration support
- `state.cjs`: STATE.md parsing and mutation operations
- `phase.cjs`: Phase numbering, ordering, decimal calculation, phase directory operations
- `roadmap.cjs`: Roadmap parsing, phase extraction, progress tracking
- `frontmatter.cjs`: YAML frontmatter extraction, validation, mutation
- `verify.cjs`: Plan/summary structure validation, reference checking
- `milestone.cjs`: Milestone completion and archival workflows
- `template.cjs`: Document template filling with frontmatter injection
- `model-profiles.cjs`: Model resolution profiles (budget-aware, capacity-aware model selection)
- `profile-pipeline.cjs`: Routing pipeline for agent-type-to-model mapping
- `profile-output.cjs`: Formatting of model selection decisions

**Agent & Skill System:**
- Purpose: Modular task execution with specialized responsibilities
- Location: `.claude/agents/*.md` (agent specifications), `.claude/skills/*/SKILL.md` (skill definitions)
- Contains: Agent role definitions (role/why_this_matters/process), skill triggers and handlers
- Depends on: Agents spawned by skills, tool permissions, configuration
- Used by: Claude Code runtime for orchestration

**Hook System:**
- Purpose: Inject custom behavior at runtime events (SessionStart, PostToolUse)
- Location: `.claude/hooks/*.js` (hook implementations)
- Contains: Event-triggered Node.js scripts
- Depends on: fs, path, environment detection, cache directories
- Used by: Claude Code runtime via settings.json hook configuration

**Execution & Tool Bridge:**
- Purpose: Execute commands and provide feedback to agents
- Location: Implemented via Claude Code's internal tool system (Bash, Read, Write, Grep, Glob)
- Contains: Permission policies defined in settings.json
- Depends on: Shell environment, filesystem access, git repository
- Used by: All agents to perform work

## Data Flow

**Phase Execution Workflow:**

1. Agent (planner/executor) is spawned with phase context
2. Agent reads `.planning/config.json` to load settings and model profile
3. Agent reads `.planning/STATE.md` to understand current project state
4. Agent loads codebase docs from `.planning/codebase/` (ARCHITECTURE.md, CONVENTIONS.md, etc.)
5. Agent uses GSD tools (via Bash) to query/update state
6. Agent writes PLAN.md or SUMMARY.md to phase directory
7. GSD tools validate structure via frontmatter schema checking
8. Tools commit changes to git with templated messages
9. Hooks (PostToolUse) monitor context usage and signal warnings

**State Mutation Flow:**

1. Tools (via CLI) parse command arguments
2. Load configuration and defaults from `core.cjs`
3. Read target document (STATE.md, ROADMAP.md, REQUIREMENTS.md)
4. Extract/parse relevant section (frontmatter, markdown)
5. Apply mutations (update field, mark complete, increment phase)
6. Normalize markdown (MD linting rules)
7. Write back to filesystem
8. Execute git commit if configured

**Git Integration:**

- Commits are parameterized with template messages
- FILE lists are passed via Bash calls
- Commit signing and safety checks enforced via git config
- Gitignore respects `.planning/` staging without tracking

## Key Abstractions

**Phase (Decimal Numbering):**
- Purpose: Tracks decomposed project work with flexible granularity
- Examples: `1`, `1.1`, `1.2.1`, `2` — each phase has directory in `.planning/phases/N/`
- Pattern: Phase directories contain PLAN.md, SUMMARY.md, artifacts. Parent roadmap tracks phase descriptions and status.

**Model Profiles:**
- Purpose: Provide environment-specific model selection without hardcoding
- Examples: `balanced`, `codebase-heavy`, `quality-focused` profiles in `model-profiles.cjs`
- Pattern: Config specifies profile, agents query via `resolve-model` command, pipeline maps agent-type to model

**Frontmatter Schema:**
- Purpose: Enforce required fields in document headers for structured parsing
- Examples: PLAN.md requires `phase`, `wave`, `type`, `completed_at` (optional)
- Pattern: Extracted via `frontmatter.cjs`, validated against schema before writes

**State Document (STATE.md):**
- Purpose: Single source of truth for project progress, phase tracking, metadata
- Examples: Frontmatter contains `current_phase`, `total_phases`, `status`, `started_at`
- Pattern: Mutations via `state update`, `state patch`, `state begin-phase` commands

**Roadmap (ROADMAP.md):**
- Purpose: High-level phase decomposition with progress tracking
- Examples: Phases with descriptions, status (active/completed/pending), plan counts
- Pattern: Updated when phases added/completed, synced with phase directory disk state

## Entry Points

**CLI Entry (gsd-tools.cjs):**
- Location: `.claude/get-shit-done/bin/gsd-tools.cjs`
- Triggers: Called via `node gsd-tools.cjs <command> [args]` in Bash tool calls
- Responsibilities: Parse arguments, dispatch to lib modules, handle I/O and exit codes

**Agent Entry (Skill/Agent):**
- Location: `.claude/agents/*.md`, `.claude/skills/*/SKILL.md`
- Triggers: Spawned by skill triggers (e.g., `/gsd:plan-phase`, `/gsd:map-codebase`)
- Responsibilities: Execute specialized task, read context from STATE.md/.planning/, write outputs

**Hook Entry (SessionStart, PostToolUse):**
- Location: `.claude/hooks/*.js`
- Triggers: Fired by Claude Code at session start and after every tool use
- Responsibilities: Check version updates, monitor context usage, inject warnings

**Runtime Configuration:**
- Location: `.claude/settings.json`
- Triggers: Loaded at Claude Code startup
- Responsibilities: Define hooks, permissions, environment variables, enabled plugins

## Error Handling

**Strategy:** Fail-safe with informative error messages

**Patterns:**
- Tools exit with code 1 on error, write to stderr
- Large JSON responses (>50KB) written to temp file with `@file:` prefix to avoid buffer overflow
- Hooks catch exceptions silently (prevents Claude Code startup failure)
- Safe file reads return null on ENOENT instead of throwing
- Git operations check return codes and fall back gracefully
- Permission checks in settings.json prevent unauthorized operations

## Cross-Cutting Concerns

**Logging:** JSON output from gsd-tools (when not raw mode), timestamped hook cache files, git commit messages

**Validation:** YAML frontmatter schema checking, phase numbering consistency, markdown linting (normalizeMd), git path safety checks

**Authentication:** Permission policies in `.claude/settings.json` controlled via allow/deny lists, scoped to specific commands and paths

**Model Resolution:** Config profile → pipeline → model ID with fallback chain (model_overrides → profile → defaults)

**Environment Detection:** Multi-account support via `CLAUDE_CONFIG_DIR` env var, automatic detection of `.claude/.opencode/.config/opencode` directories, respects host environment (Claude, OpenCode, Gemini)

---

*Architecture analysis: 2026-03-20*
