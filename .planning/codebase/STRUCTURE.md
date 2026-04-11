# Codebase Structure

**Analysis Date:** 2026-03-20

## Directory Layout

```
/home/skogix/claude/
├── .claude/                         # Claude Code config, skills, hooks, agents
│   ├── agents/                      # Specialized agent role definitions
│   ├── commands/                    # Command skill definitions (currently empty)
│   ├── skills/                      # Skill implementations (prompt-master, skill-creator, etc.)
│   ├── hooks/                       # Runtime event handlers (SessionStart, PostToolUse)
│   ├── get-shit-done/               # GSD CLI tooling and templates
│   │   ├── bin/                     # Executable entry point and lib modules
│   │   ├── templates/               # Document templates (PLAN.md, SUMMARY.md, etc.)
│   │   ├── references/              # Documentation and patterns
│   │   └── VERSION                  # Current GSD version
│   ├── worktrees/                   # Git worktree management (empty)
│   ├── settings.json                # Claude Code configuration
│   ├── settings.schema.example.json  # Settings schema reference
│   ├── package.json                 # CommonJS module declaration
│   ├── gsd-file-manifest.json       # File integrity tracking with SHAs
│   └── cache/                       # Runtime cache (hooks, version checks)
├── .planning/                       # Project planning and state (git-ignored)
│   ├── codebase/                    # Codebase analysis documents (written here)
│   ├── config.json                  # Project-specific GSD configuration
│   ├── PROJECT.md                   # Project metadata and description
│   ├── STATE.md                     # Current project state and progress
│   ├── REQUIREMENTS.md              # Structured requirements with IDs
│   ├── ROADMAP.md                   # Phase decomposition with status
│   ├── phases/                      # Phase directories (N/ for phase number)
│   ├── todos/                       # TODO tracking (pending/, completed/)
│   └── research/                    # Research artifacts and findings
├── docs/                            # Claude Code reference documentation
│   ├── claude-code/                 # Fetched reference docs from code.claude.com
│   └── CLAUDE.md                    # Documentation index and routing
├── lab/                             # Experiments and prototypes
│   └── README.md
├── notes/                           # Personal observations and patterns
├── guestbook/                       # Visitor notes
├── bin/                             # Custom scripts
│   └── healthcheck                  # Runtime health check script
├── CLAUDE.md                        # Home directory router and instructions
├── README.md                        # Repository description
└── .gitignore                       # Git exclusions (ignores .claude/, .planning/, etc.)
```

## Directory Purposes

**.claude/ — Runtime Configuration & Tooling**
- Purpose: Complete Claude Code environment (config, skills, agents, hooks, GSD tools)
- Contains: Settings, agent specifications, skill implementations, hook scripts, CLI tools
- Key files: `settings.json` (main config), `get-shit-done/bin/gsd-tools.cjs` (CLI entry)

**.claude/agents/ — Agent Role Specifications**
- Purpose: Define specialized agent types with role, responsibilities, and tool permissions
- Contains: ~16 agent definitions (gsd-codebase-mapper, gsd-planner, gsd-executor, etc.)
- Pattern: Each agent is a markdown file with frontmatter (name, description, tools, color) and detailed role documentation

**.claude/skills/ — Skill Implementations**
- Purpose: User-facing skill definitions that can be invoked via slash commands
- Contains: prompt-master, skill-creator, skogai-routing, skogai-bats-testing, planning-with-files
- Pattern: Each skill has SKILL.md with trigger definition and implementation

**.claude/hooks/ — Runtime Event Handlers**
- Purpose: Inject custom behavior at Claude Code lifecycle events
- Contains: JavaScript files executed at SessionStart and PostToolUse
- Key hooks:
  - `gsd-check-update.js`: Verify GSD version and check for stale hooks
  - `gsd-context-monitor.js`: Monitor context usage and write bridge file for warnings
  - `gsd-statusline.js`: Render custom statusline showing model, context usage, task

**.claude/get-shit-done/ — GSD CLI System**
- Purpose: Centralized command handling for all project planning operations
- Location: `.claude/get-shit-done/`
- Core: `bin/gsd-tools.cjs` (main CLI entry point)
- Libraries:
  - `lib/core.cjs`: Shared utilities (path, file I/O, config, git)
  - `lib/commands.cjs`: Utility commands (slug, timestamp, todos)
  - `lib/config.cjs`: Config loading with legacy migration
  - `lib/state.cjs`: STATE.md parsing and mutations
  - `lib/phase.cjs`: Phase numbering and ordering
  - `lib/roadmap.cjs`: Roadmap analysis and updates
  - `lib/frontmatter.cjs`: YAML extraction and validation
  - `lib/verify.cjs`: Plan/summary validation
  - `lib/milestone.cjs`: Milestone archival workflows
  - `lib/template.cjs`: Document template filling
  - `lib/model-profiles.cjs`: Model profile definitions and resolution
  - `lib/profile-pipeline.cjs`: Agent-to-model routing logic
  - `lib/profile-output.cjs`: Model decision formatting
- Templates: Markdown document templates (PLAN.md, SUMMARY.md, DEBUG.md, etc.)
- References: Documentation on phase calculation, git integration, TDD patterns, user profiling

**.planning/ — Project State (Git-Ignored)**
- Purpose: Session-persistent project planning state, progress tracking, requirements
- Location: `.planning/` (listed in .gitignore)
- Contains:
  - `config.json`: Project configuration (model profile, workflow options, branching strategy)
  - `PROJECT.md`: Project description, metadata, links
  - `STATE.md`: Current state (phase, status, timestamps, links to roadmap/requirements)
  - `REQUIREMENTS.md`: Structured requirements with IDs (REQ-XX format)
  - `ROADMAP.md`: Phase breakdown with descriptions, status, plan counts
  - `codebase/`: Analysis documents (ARCHITECTURE.md, STRUCTURE.md, CONVENTIONS.md, TESTING.md, STACK.md, INTEGRATIONS.md, CONCERNS.md)
  - `phases/N/`: Phase execution directories containing PLAN.md, SUMMARY.md, CONTEXT.md, artifacts
  - `todos/pending/`: Outstanding action items
  - `todos/completed/`: Closed todos
  - `research/`: Research outputs and findings

**docs/ — Reference Documentation**
- Purpose: Fetched and curated Claude Code reference material
- Location: `docs/`
- Contains: Official Claude Code documentation organized by category
- Main file: `docs/CLAUDE.md` (lazy-load index routing to specific docs)
- Subdirs: `claude-code/` (individual .md files for each topic)

**lab/ — Experiments & Prototypes**
- Purpose: Development space for new patterns and skills
- Contains: WIP code, experimental approaches, proof-of-concept implementations
- Pattern: Nothing here is production; everything might become something

**notes/ — Personal Knowledge Base**
- Purpose: Observations, patterns, and thinking recorded for reference
- Contains: Unstructured markdown notes on architecture patterns, learnings

**bin/ — Custom Scripts**
- Purpose: Utility scripts and tools
- Contains: `healthcheck` (runtime environment validation)

## Key File Locations

**Entry Points:**
- `node ./.claude/get-shit-done/bin/gsd-tools.cjs`: CLI entry point for all state/planning operations
- `.claude/settings.json`: Claude Code configuration (hooks, permissions, plugins)
- `.claude/hooks/*.js`: Runtime event handlers

**Configuration:**
- `.planning/config.json`: Project-specific settings (model profile, workflow toggles)
- `.claude/settings.json`: Global Claude Code settings
- `.claude/settings.schema.example.json`: Settings schema reference

**Core Logic:**
- `.claude/get-shit-done/bin/lib/core.cjs`: Shared utilities (file I/O, git, config loading)
- `.claude/get-shit-done/bin/lib/state.cjs`: STATE.md mutations and parsing
- `.claude/get-shit-done/bin/lib/phase.cjs`: Phase numbering and ordering
- `.claude/get-shit-done/bin/lib/model-profiles.cjs`: Model resolution profiles
- `.claude/get-shit-done/bin/lib/frontmatter.cjs`: YAML frontmatter handling

**Project State:**
- `.planning/PROJECT.md`: Project overview
- `.planning/STATE.md`: Current progress (which phase, status, key links)
- `.planning/REQUIREMENTS.md`: Feature requirements with IDs
- `.planning/ROADMAP.md`: Phase breakdown and planning

**Testing & Validation:**
- `.claude/get-shit-done/bin/lib/verify.cjs`: Validation for plans and summaries
- `.claude/get-shit-done/references/tdd.md`: TDD patterns documentation

## Naming Conventions

**Files:**
- Markdown files: UPPERCASE.md (PROJECT.md, ARCHITECTURE.md, REQUIREMENTS.md)
- CLI tools: lowercase-kebab.cjs (gsd-tools.cjs, frontmatter.cjs)
- Hooks: gsd-{function}.js (gsd-check-update.js, gsd-context-monitor.js)
- Agents: gsd-{type}.md (gsd-planner.md, gsd-executor.md)
- Skills: SKILL.md (inside skill directory)
- Phase directories: numeric only (1, 1.1, 1.2.1) under `.planning/phases/`
- Phase documents: PLAN.md, SUMMARY.md (inside phase directories)

**Directories:**
- Internal: lowercase (agents, skills, hooks, commands, worktrees)
- Kebab-case for complex names: get-shit-done, planning-with-files
- Dot-prefix for hidden: .claude, .planning, .git

**Code Symbols:**
- Functions: camelCase (safeReadFile, loadConfig, toPosixPath)
- Constants: UPPERCASE (MODEL_PROFILES, AUTO_COMPACT_BUFFER_PCT)
- Internal helpers: prefixed with underscore (not used in this codebase)

## Where to Add New Code

**New Agent:**
- Primary code: `.claude/agents/gsd-{type}.md`
- Pattern: Follow existing agent frontmatter structure (name, description, tools, color)
- Include: Complete role documentation, tool permissions, workflow steps

**New Skill:**
- Implementation: `.claude/skills/{skill-name}/SKILL.md`
- Pattern: Frontmatter with trigger definition, then implementation content
- Include: Examples, permissions, configuration options

**New GSD CLI Command:**
- Implementation: Add function to `.claude/get-shit-done/bin/lib/commands.cjs` or new lib module
- Entry point: Register command in `gsd-tools.cjs` dispatcher
- Pattern: Follow existing command pattern (safeReadFile, loadConfig, output with raw mode support)

**New Reference Documentation:**
- Location: `.claude/get-shit-done/references/{topic}.md`
- Purpose: Document patterns, algorithms, or specifications

**New Document Template:**
- Location: `.claude/get-shit-done/templates/{name}.md`
- Pattern: Include frontmatter placeholders marked with `{{field}}` for template filling

**Codebase Analysis:**
- Location: `.planning/codebase/{TYPE}.md`
- Files: ARCHITECTURE.md, STRUCTURE.md, CONVENTIONS.md, TESTING.md, STACK.md, INTEGRATIONS.md, CONCERNS.md
- Pattern: Written by gsd-codebase-mapper agent based on focus area

**Project Planning:**
- Location: `.planning/phases/{number}/`
- Files: PLAN.md (execution plan), SUMMARY.md (completion summary), CONTEXT.md (research), artifacts
- Pattern: Created and managed via GSD CLI commands

**Utilities:**
- Location: `bin/{script-name}` (non-npm scripts) or as npm scripts in package.json

## Special Directories

**.planning/ (Git-Ignored)**
- Purpose: Transient project state that persists within a session but is git-ignored
- Generated: Yes (by agents and GSD tools)
- Committed: No (listed in .gitignore)
- Note: Essential for session state; deleting clears all progress

**.claude/cache/**
- Purpose: Runtime cache for hooks and version checks
- Generated: Yes (by hook processes)
- Committed: No (not in repo)
- Contents: JSON files tracking update checks and context metrics

**.claude/worktrees/**
- Purpose: Git worktree management (currently empty, available for future use)
- Generated: Conditionally (if branching strategy enabled)
- Committed: No (.gitignore)

**docs/claude-code/**
- Purpose: Fetched reference documentation from code.claude.com
- Generated: Yes (by docs/fetch-docs.sh)
- Committed: Yes (checked in for offline access)
- Note: Can be refreshed but should be committed after updates

**.claude/get-shit-done/**
- Purpose: GSD system itself (tools, templates, references)
- Generated: No (part of codebase)
- Committed: Yes
- Note: Version tracked in get-shit-done/VERSION file

---

*Structure analysis: 2026-03-20*
