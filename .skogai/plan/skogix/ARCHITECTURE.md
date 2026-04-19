---
title: ARCHITECTURE
type: note
permalink: claude/projects/dot-skogai/plan/codebase/architecture
---

# System Architecture

## Overall Design Pattern

**Pattern: Meta-Development Platform + Claude Code Plugin Ecosystem**

The skogix repository is a personal AI agent development platform built on Claude Code (Anthropic's CLI). It functions as a unified system for:

- Project planning and execution (GSD: "Get Shit Done")
- Claude Code plugin/skill management
- AI agent prompting and architecture
- Development workflow automation

### Key Characteristics

- Single marketplace-based plugin system (dot-skogai-marketplace)
- Modular skill-based architecture (11 specialized skills)
- Git hook-driven lifecycle management
- MCP (Model Context Protocol) server integration
- Configuration-as-code for reproducible development environments

## Architectural Patterns

### Primary Pattern: Marketplace Architecture

```
Claude Code (Official CLI)
    ↓
dot-skogai-marketplace (Plugin)
    ├── hooks/ (8 lifecycle hooks)
    ├── skills/ (11 domain skills)
    ├── commands/ (slash commands)
    └── servers/ (MCP server configs)
```

### Supporting Patterns

#### Layered Skills Architecture

- Each skill encapsulates domain knowledge (jq, git-worktree, todos, docs)
- Skills contain: SKILL.md + optional scripts/, references/, assets/
- Loaded via marketplace.json based on context

#### Hook-Driven Lifecycle

- Session hooks (SessionStart, SessionEnd)
- Tool hooks (PreToolUse, PostToolUse)
- Event hooks (Notification, Stop, SubagentStop)
- User input hook (UserPromptSubmit, PreCompact)
- Enables stateful behavior and decision tracking

#### MCP Server Integration

- Example MCP hub: `skogai-mcp-hub` at https://mcp.skogai.se/mcp
- Extensibility beyond native skills

#### Submodule-Based Bootstrap

- `.skogai/` is a git submodule pointing to SkogAI/.skogai
- Reusable template for all SkogAI projects
- Contains shared hooks, commands, reference templates

## Data Flow

### Session Lifecycle

```
User launches Claude Code with custom bin/claude script
    ↓
Loads marketplace from /home/skogix/.plugin/plugins/
    ↓
dot-skogai-marketplace plugin initialized
    ↓
SessionStart hook executed
    ├─→ Checks garden-state.json for trial expiration
    └─→ May emit context about expired plugins
    ↓
User submits prompt
    ↓
UserPromptSubmit hook executed
    ├─→ Sets worktrunk.status Git config
    └─→ Custom input preprocessing
    ↓
Claude processes (may invoke skills)
    ↓
Skill execution (e.g., /skogai:plan-phase)
    ├─→ Creates/updates files in .skogai/plan/
    └─→ Commits to git with atomic messages
    ↓
Tool usage hooks
    ├─→ PreToolUse: validate tool invocation
    └─→ PostToolUse: process tool results
    ↓
PreCompact hook: optimize context before compaction
    ↓
SessionEnd hook
    ├─→ Unsets worktrunk.status
    └─→ Session cleanup
```

### GSD Project Workflow

```
/skogai:new-project
    ↓ Creates
.skogai/plan/PROJECT.md (vision + requirements)
.skogai/plan/config.json (workflow mode)
    ↓
/skogai:create-roadmap
    ↓ Creates
.skogai/plan/ROADMAP.md (phase breakdown)
.skogai/plan/STATE.md (project memory)
.skogai/plan/phases/
    ↓
/skogai:plan-phase N
    ↓ Creates
.skogai/plan/phases/NN-name/NN-YY-PLAN.md
    ↓
/skogai:execute-plan <path>
    ↓
Subagent execution with fresh context
    ↓ Creates
.skogai/plan/phases/NN-name/NN-YY-SUMMARY.md
    ↓
Updates .skogai/plan/STATE.md
    ↓
Git commit with atomic task messages
```

### Skill Loading Mechanism

```
Command invoked: /skogai:plan-phase
    ↓
Claude Code checks marketplace.json skills array
    ↓
Matches against available skills by context/name
    ↓
Loads from: .skogai/plugin/skills/skill-name/
    ↓
Reads SKILL.md frontmatter for name/description
    ↓
Loads skill content + optional scripts/references
    ↓
Executes skill context within Claude's system prompt
```

## Module Relationships

```
Claude Code (Host)
    ↑
    ├── dot-skogai-marketplace (plugin)
    │   ├── Depends on: skogai-mcp-hub (remote MCP)
    │   └── Contains:
    │       ├── Hooks (shell scripts)
    │       ├── Skills (11 modules):
    │       │   ├── skogai-jq
    │       │   ├── skogai-todos
    │       │   ├── skogai-git-worktree
    │       │   ├── skogai-docs
    │       │   ├── skogai-agent-prompting
    │       │   ├── skogai-argc
    │       │   ├── skogai-developing-for-claude-code
    │       │   ├── skogai-worktrunk
    │       │   ├── skogai-skill-creator
    │       │   ├── mcp-builder-test
    │       │   └── skogai-skills
    │       └── Commands (30+ slash commands)
    │
    └── .skogai/ (submodule)
        └── Shared bootstrap across all SkogAI projects
```

## Separation of Concerns

### By Visibility

- **Visible**: `.skogai/plugin/` (runtime plugins)
- **Hidden**: `.skogai/.claude-plugin/` (marketplace metadata)
- **Hidden**: `todos/` (experimental)
- **Visible**: `plans/` (documented strategies)

### By Lifecycle

- **Cached**: `templates/` (loaded once)
- **Live**: `hooks/` (executed on events)
- **Live**: `commands/` (executed on invocation)
- **Cached**: `settings.json` (session start)

### By Scope

- **Project-Specific**: `plans/`, `todos/`, root files
- **Reusable**: `.skogai/` submodule

## Key Architectural Decisions

1. **Submodule-Based Bootstrap** - `.skogai/` enables consistent tooling across projects
1. **Hook-Driven Lifecycle** - Adds statefulness when needed
1. **Skill Encapsulation** - Complete modules with templates, scripts, docs
1. **File-Based State** - All project state in `.skogai/plan/` (markdown + json)
1. **MCP Server Integration** - Extensibility without modifying core plugin

## Extension Points

1. **Add Skills**: Create `.skogai/plugin/skills/skill-name/SKILL.md`
1. **Add Commands**: Create `.skogai/plugin/commands/command.md`
1. **Add Hooks**: Create shell script in `.skogai/plugin/hooks/`
1. **Add MCP Servers**: Register in marketplace.json
1. **Share**: Push submodule to SkogAI/.skogai
