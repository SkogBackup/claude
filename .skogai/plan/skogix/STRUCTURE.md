---
title: STRUCTURE
type: note
permalink: claude/projects/dot-skogai/plan/codebase/structure
---

# Directory Structure

## Top-Level Organization

```
/home/skogix/skogix/
├── .skogai/                    # Git submodule (bootstrap)
│   ├── plugin/                 # Claude Code plugin runtime
│   ├── bin/                    # CLI entry point
│   ├── .claude-plugin/         # Marketplace metadata
│   └── .github/                # GitHub workflows
├── plans/                      # Implementation plans
├── todos/                      # Work-in-progress items
├── README.md                   # Project overview
├── CLAUDE.md                   # Project instructions
└── todo.md                     # Todo list
```

## .skogai Directory (Submodule)

```
.skogai/
├── plugin/
│   ├── hooks/              # 8 lifecycle hooks
│   │   ├── session-start.sh
│   │   ├── session-end.sh
│   │   ├── pre-tool-use.sh
│   │   ├── post-tool-use.sh
│   │   ├── pre-compact.sh
│   │   ├── user-prompt-submit.sh
│   │   ├── notification.sh
│   │   └── stop.sh
│   ├── skills/             # 11 specialized skills
│   │   ├── skogai-jq/
│   │   ├── skogai-todos/
│   │   ├── skogai-git-worktree/
│   │   ├── skogai-docs/
│   │   ├── skogai-agent-prompting/
│   │   ├── skogai-argc/
│   │   ├── skogai-developing-for-claude-code/
│   │   ├── skogai-worktrunk/
│   │   ├── skogai-skill-creator/
│   │   ├── mcp-builder-test/
│   │   └── skogai-skills/
│   ├── commands/           # Slash commands
│   ├── templates/          # Document templates
│   │   ├── codebase/
│   │   ├── milestone/
│   │   └── discovery/
│   ├── references/         # Reference documentation
│   ├── settings.json       # Claude Code settings
│   └── servers/            # MCP server configurations
├── bin/                    # CLI entry point
├── .claude-plugin/         # Marketplace metadata
│   └── marketplace.json
├── docs/                   # Documentation
│   └── skogix/
│       ├── user.md
│       └── definitions.md
├── CLAUDE.md               # .skogai instructions
├── README.md               # .skogai overview
├── todo.md                 # .skogai todo list
└── skogix.md               # Project-specific additions
```

## Key Directories

| Directory                    | Purpose                   | Organization  |
| ---------------------------- | ------------------------- | ------------- |
| `.skogai/plugin/hooks/`      | Lifecycle event handlers  | By event type |
| `.skogai/plugin/skills/`     | Domain-specific skills    | By domain     |
| `.skogai/plugin/commands/`   | Slash commands            | By namespace  |
| `.skogai/plugin/templates/`  | Document templates        | By use case   |
| `.skogai/plugin/references/` | Reference docs            | By topic      |
| `todos/`                     | Exploratory work          | By project    |
| `plans/`                     | Implementation strategies | By feature    |

## Skill Directory Structure

Each skill follows this pattern:

```
skills/skill-name/
├── SKILL.md            # Main skill definition
├── scripts/            # Optional implementation scripts
├── references/         # Optional reference documentation
└── assets/             # Optional data/templates
```

## todos/ Directory

```
todos/
├── docs-fix/               # Documentation improvements
├── mcp-builder/            # MCP server development
│   └── scripts/
│       ├── connections.py
│       └── evaluation.py
├── dspy-ruby/              # DSPy Ruby integration
├── docgen-lookover/        # Documentation generation
│   └── scripts/
│       ├── watcher.py
│       ├── process_queue.py
│       ├── frontmatter_daemon.py
│       ├── llm.py
│       └── init_db.py
├── cloudflare/             # Cloudflare AI integration
├── testing-framework-bash/ # Bash testing framework
│   ├── setup-tests.sh
│   ├── test-helper.bash
│   ├── unit/
│   │   ├── common-functions.bats
│   │   ├── code-relationships.bats
│   │   └── search-tools.bats
│   └── fixtures/
└── [other projects]
```

## Module Organization

### By Feature (Top Level)

- `.skogai/plugin/` groups all Claude Code concerns
- Skills are feature-complete modules
- Commands organized by namespace
- Templates organized by document type

### By Layer (Within Skills)

```
skills/skill-name/
├── SKILL.md          # Presentation/documentation
├── scripts/          # Implementation
├── references/       # Concepts
└── assets/           # Data/templates
```

## Special Directories

| Directory                 | Purpose                   | Notes                                     |
| ------------------------- | ------------------------- | ----------------------------------------- |
| `.skogai/.claude-plugin/` | Marketplace registration  | Controls plugin visibility                |
| `.skogai/plugin/servers/` | MCP server configs        | Example configs only                      |
| `.skogai/plan/`           | GSD project state         | Created per project, gitignored initially |
| `todos/`                  | R&D work                  | Not part of core delivery                 |
| `plans/`                  | Implementation strategies | Research before implementation            |
| `.github/workflows/`      | CI/CD                     | Marketplace updates automation            |

## File Naming Conventions

- **kebab-case** for all files and directories
- **UPPERCASE.md** for important docs (CLAUDE.md, README.md)
- **lowercase.md** for standard docs (todo.md, skogix.md)
- **.sh** for shell scripts
- **.py** for Python scripts
- **.bats** for Bash test files
- **.json** for configuration

## Code Organization Strategy

**Hybrid: Feature + Layered**

- Skills are feature-complete modules (feature-based)
- Each skill follows internal layering (documentation → implementation → references)
- Commands organized by namespace (CLI organization)
- Makes both feature discovery and implementation details accessible
