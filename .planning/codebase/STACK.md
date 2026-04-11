# Technology Stack

**Analysis Date:** 2026-03-20

## Languages

**Primary:**
- JavaScript (Node.js) - All development tooling, hooks, scripts, and GSD framework

**Secondary:**
- Bash - System scripts and utilities (`.claude/healthcheck`)
- Markdown - Configuration, documentation, and workflow definitions

## Runtime

**Environment:**
- Node.js - JavaScript runtime for all hooks and CLI tools
- Bash/Shell - Unix shell for system integration and CLI scripts

**Package Manager:**
- npm - Node.js package manager
- Lockfile: Not present (minimal dependencies - project uses CommonJS)

## Frameworks

**Core:**
- Get Shit Done (GSD) 1.26.0+ - Project planning, workflow orchestration, and AI-assisted task management
- Claude Code - Editor extension providing AI capabilities and hooks system

**Development:**
- Claude Code Settings System - Configuration management and permission system (settings.json)
- Claude Code Hooks - Event-driven architecture for SessionStart and PostToolUse events
- Claude Code Plugins - Optional plugins for integrated features (all disabled by default)

## Key Dependencies

**Critical:**
- Node.js built-in modules only:
  - `fs` - File system operations (cache, config, metrics)
  - `path` - Path utilities
  - `os` - OS-level utilities (home directory, temp files)
  - `child_process` - Process spawning for background tasks and npm operations

**Infrastructure:**
- npm registry access - Required for GSD update checks (`npm view get-shit-done-cc version`)
- Brave Search API - Optional web search capability (if configured via env vars)

## Configuration

**Environment:**
- `CLAUDE_CONFIG_DIR` - Override default config directory (supports multi-account setups)
- `ENABLE_CLAUDEAI_MCP_SERVERS` - Toggle MCP server support (default: false)
- `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` - Enable experimental agent team features (default: 1)
- `GEMINI_API_KEY` - Optional Gemini API key (detects Gemini environment)

**Build:**
- No build system (interpreted JavaScript/Bash)
- Configuration file: `.claude/settings.json`
- Schema reference: `.claude/settings.schema.example.json`

## Platform Requirements

**Development:**
- Unix-like shell (bash/zsh) - Required for system integration
- Git - Version control (configured with git identity)
- Node.js 12.0.0+ - JavaScript runtime
- Unix utilities: `find`, `grep`, `sed`, etc.

**Production:**
- Deployment target: Claude Code editor (via settings.json and hooks)
- Optional services: Dolt (`.dolt` integration), Gas Town rigs (worktrunk)

## Integrations

**CLI Tools:**
- `npm` - GSD update checking and package version resolution
- `git` - Version control and commit operations
- `gt` (Gas Town CLI) - Optional project rig management
- `bd` / `beads` - Optional data management

**Services:**
- npm registry - For GSD version checks
- Brave Search API - Optional web search (requires BRAVE_API_KEY configuration)

---

*Stack analysis: 2026-03-20*
