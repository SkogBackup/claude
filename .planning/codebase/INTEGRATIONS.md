# External Integrations

**Analysis Date:** 2026-03-20

## APIs & External Services

**Package Registry:**
- npm registry - Version checking and package updates
  - SDK/Client: npm CLI (built-in)
  - Check command: `npm view get-shit-done-cc version`
  - Used by: `gsd-check-update.js` hook for GSD update detection

**Web Search:**
- Brave Search API - Optional web search capability via GSD tools
  - SDK/Client: HTTP API via gsd-tools.cjs
  - Auth: `BRAVE_API_KEY` environment variable
  - Usage: `gsd-tools.cjs websearch <query>` command
  - Optional: Feature only works when key is configured

## Data Storage

**Configuration Storage:**
- Local filesystem only - All config stored in `.planning/` and `.claude/` directories
- Config files:
  - `.planning/config.json` - Project configuration with hooks settings
  - `.planning/STATE.md` - Project state and workflow tracking
  - `.planning/ROADMAP.md` - Phase definitions and progress
  - `.planning/REQUIREMENTS.md` - Feature requirements and completion status
  - `.planning/codebase/` - Generated analysis documents (STACK.md, ARCHITECTURE.md, etc.)

**Caching:**
- Local filesystem - Temporary files and caches stored in OS temp directory
  - Session metrics: `/tmp/claude-ctx-{session_id}.json` (context window metrics)
  - Update cache: `~/.claude/cache/gsd-update-check.json` (GSD version check results)
  - Todo state: `~/.claude/todos/{session_id}-agent-*.json` (in-progress task tracking)

**File Storage:**
- Local filesystem only - No external file storage services

## Authentication & Identity

**Auth Provider:**
- Custom/None - This is a developer workspace with local authentication only
- User identity: Configured via git user name/email
- Permission system: File-based (settings.json and .planning/config.json)

**Workspace Identity:**
- Claude Code session ID - Used for task tracking and context metrics
- Git configuration - User name and email for commit operations

## Monitoring & Observability

**Error Tracking:**
- None - Hooks have silent error handling (no error reporting services)
- Local logging: Hook errors don't propagate (see gsd-context-monitor.js line 153)

**Logs:**
- Structured JSON files in filesystem:
  - Session context metrics: `/tmp/claude-ctx-{session_id}.json`
  - GSD update check cache: `~/.claude/cache/gsd-update-check.json`
  - Todo tracking: `~/.claude/todos/` (JSON-based)
  - Optional runtime logs: `.runtime/` directory (if enabled)

**Context Monitoring:**
- In-band monitoring - Statusline hook writes context metrics to bridge file
- Thresholds: WARNING at 35% remaining context, CRITICAL at 25% remaining

## CI/CD & Deployment

**Hosting:**
- Claude Code editor environment (local or remote)
- Optional: Gas Town worktrunk rigs for multi-project management
- Optional: Dolt database for shared data

**CI Pipeline:**
- None native - GSD provides workflow orchestration for manual multi-phase projects
- Deployment: Direct to Claude Code via git checkout and hook installation
- Version management: GSD update checks via npm registry

**Installation:**
- Automatic hook installation by Claude Code on session start
- Manual GSD updates via `npm install get-shit-done-cc@latest`

## Environment Configuration

**Required env vars:**
- None strictly required
- Optional:
  - `BRAVE_API_KEY` - Enable web search capability
  - `CLAUDE_CONFIG_DIR` - Override default config location (multi-account support)
  - `ENABLE_CLAUDEAI_MCP_SERVERS` - Control MCP server availability (default: false)
  - `GEMINI_API_KEY` - Detect and adapt for Gemini environment

**Secrets location:**
- Avoided by design - Configuration files use environment variable references
- Sensitive keys: Environment-injected, not committed to git
- Local security: Relies on OS filesystem permissions on ~/.claude/ and ~/.config/

## Webhooks & Callbacks

**Incoming:**
- None - This is a single-user development environment

**Outgoing:**
- None - No external notifications or webhook deliveries
- Internal: Context monitor hook provides additionalContext to Claude agent (in-process message injection)

## Git Integration

**Repository:**
- Location: `/home/skogix/claude`
- Gitignore excludes: `.claude/` subdirectories (get-shit-done, cache, todos, worktrees, commands, handoff, review)
- Tracked files: Agent definitions, skill configs, command templates, reference docs, public hooks

**Operations:**
- Commit automation: `gsd-tools.cjs commit <message> --files [...]` for planning docs
- Hook triggering: git operations trigger Claude Code SessionStart hook for update checks
- Version control: Project state tracked in `.planning/STATE.md`, `.planning/ROADMAP.md`

## Plugin & Marketplace Integration

**Claude Code Plugins:**
- All disabled by default (enabledPlugins section has all false)
- Available plugins (not activated):
  - claude-md-management
  - claude-code-setup
  - github
  - feature-dev
  - code-simplifier
  - typescript-lsp
  - plugin-dev
  - skill-creator
  - frontend-design
  - playwright
  - pyright-lsp
  - linear
  - pr-review-toolkit

**MCP (Model Context Protocol):**
- Disabled by default (`ENABLE_CLAUDEAI_MCP_SERVERS`: false)
- Optional worktrunk marketplace integration (`.extraKnownMarketplaces`)

---

*Integration audit: 2026-03-20*
