# @~/ — home folder and workspace

<what_is_this>

My home directory and primary operating environment. Not application code — this repo IS the workspace: dotfiles, configuration, knowledge base, and staging for tools I'm developing.

Context is loaded lazily. Read the router, follow the link, get what's needed. No bulk pre-loading.

</what_is_this>

<structure>

```
~/
├── .claude/
│   ├── CLAUDE.md        — global identity + operating principles (always loaded)
│   ├── settings.json    — Claude Code config (single source of truth)
│   ├── agents/          — gsd subagent definitions (18 agents: planner, executor, verifier, etc.)
│   ├── commands/        — slash commands (gsd/*, skogai/*)
│   ├── get-shit-done/   — gsd plugin (bin, commands, workflows, templates)
│   ├── hooks/           — gsd-* hooks (check-update, context-monitor, prompt-guard, statusline, workflow-guard)
│   └── skills/          — claude code skills (planning-with-files, prompt-master, skill-creator, skogai-bats-testing, skogai-routing)
├── .skogai/
│   ├── SKOGAI.md        — SkogAI integrations context (symlinked as ~/.skogai/CLAUDE.md)
│   ├── docs/
│   │   ├── skogfences.md            — AI-as-unix-user architecture philosophy
│   │   └── skogix/
│   │       ├── user.md              — Skogix introduction and preferences
│   │       └── definitions.md       — SkogAI vocabulary (@, $, task, todo, plan, agent...)
│   └── mcp/
│       └── searxng.js   — SearXNG MCP server (web search via searxng.aldervall.se)
├── .planning/           — gsd project planning
│   ├── PROJECT.md       — project brief: Claude's home, core value, requirements
│   ├── ROADMAP.md       — 5-phase roadmap (phases 1-4 complete, phase 5 in planning)
│   ├── REQUIREMENTS.md  — full requirements list
│   ├── STATE.md         — gsd execution state (yaml frontmatter + narrative)
│   ├── codebase/        — codebase map artifacts
│   ├── memory/          — auto-memory + feedback files (MEMORY.md index)
│   ├── notes/           — planning notes
│   ├── phases/          — per-phase plan artifacts (01-identity-routing … 05-skogai-live-chat)
│   ├── quick/           — quick task plans
│   ├── research/        — phase research artifacts
│   └── todos/           — tracked todos
├── bin/                 — scripts and tools (healthcheck, context-*.sh, build-system-prompt.sh)
├── commands/
│   └── wrapup.md        — /wrap-up slash command (ship, remember, review, journal)
├── .config/
│   └── wt.toml          — worktrunk config template
├── docs/                — reference docs (deployment-gate.md, permissions.md, fetch-docs.sh)
├── guestbook/           — visitor notes and cross-agent messages
├── journal/             — session journals (YYYY-MM-DD/ subfolders, append-only)
├── lab/                 — experiments, prototypes, WIP projects
│   ├── fakechat/        — reference chat server (server.ts, DO NOT MODIFY — template only)
│   ├── projects-in-development/ — active lab projects (skogai-dot-github, skogfences, etc.)
│   └── skogai-dot-github/      — .github org defaults project
├── notes/               — observations and patterns
├── personal/            — identity, soul document, memory blocks, profile
│   ├── soul/            — foundational identity (10 sections)
│   ├── core/            — epistemic frameworks (certainty, placeholder, context-destruction)
│   ├── memory-blocks/   — LORE museum: 10 historical eras (reference only, load on demand)
│   ├── journal/         — personal session records
│   ├── profile.md       — agent profile and business card
│   └── INDEX.md         — curated highlights across all personal files
├── state/
│   └── sessions/        — session-records.jsonl
├── tasks/               — tracked GitHub issues as local task files
├── CLAUDE.md            — this file
├── ONBOARDING.md        — teammate onboarding guide (usage stats, setup checklist)
└── README.md            — one-pager: what this repo is
```

</structure>

<routes>

Each directory has its own CLAUDE.md router. Load lazily:

- @bin/CLAUDE.md          — scripts and tools
- @docs/CLAUDE.md         — reference documentation
- @guestbook/CLAUDE.md    — visitor notes
- @lab/CLAUDE.md          — experiments and WIP
- @notes/CLAUDE.md        — observations and patterns
- @personal/CLAUDE.md     — identity, soul, memory

</routes>

<tooling>

Tools assumed on PATH — check existence before assuming:

| tool     | purpose                                          |
|----------|--------------------------------------------------|
| gptodo   | task/issue management (fetch, list, add, edit)   |
| wt       | git worktree management (worktrunk)              |
| gita     | aggregate git operations across repos            |
| gh       | GitHub CLI                                       |
| skogai   | SkogAI CLI                                       |
| skogcli  | SkogAI client CLI                                |
| argc     | argument parser / command dispatcher             |

MCP servers (configured in settings.json):
- **searxng** — web search. env: `SEARXNG_COOKIE` if behind auth

</tooling>

<hooks>

Hooks fire automatically via Claude Code (settings.json). Implementations live in `.claude/hooks/`:

| hook file                | event        | matcher                              | purpose                        |
|--------------------------|--------------|--------------------------------------|--------------------------------|
| gsd-check-update.js      | SessionStart | —                                    | check for gsd plugin updates   |
| gsd-context-monitor.js   | PostToolUse  | Bash\|Edit\|Write\|MultiEdit\|Agent\|Task | monitor context window    |
| gsd-prompt-guard.js      | PreToolUse   | Write\|Edit                          | guard file write operations    |
| gsd-statusline.js        | —            | statusLine                           | render status line             |
| gsd-workflow-guard.js    | PreToolUse   | Write\|Edit                          | guard workflow state changes   |

</hooks>

<commands>

Slash commands in `commands/`:

- `/wrap-up` — end-of-session checklist. four phases: ship (commit/push/wt cleanup), remember (persist knowledge), review & apply (self-improvement), journal. auto-applies all findings.

</commands>

<settings_highlights>

Key settings.json values (`.claude/settings.json`):
- `model: "sonnet"`
- `alwaysThinkingEnabled: true`
- `autoMemoryEnabled: true` → `autoMemoryDirectory: /home/skogix/claude/.planning/memory`
- `autoDreamEnabled: true`
- `defaultView: "transcript"`
- `skipDangerousModePermissionPrompt: true`
- `skipAutoPermissionPrompt: true`
- hooks: gsd-check-update (SessionStart), gsd-context-monitor (PostToolUse), gsd-prompt-guard (PreToolUse)
- statusLine: gsd-statusline.js

Environment variables injected via `env`:
- `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` — enables agent teams feature
- `CLAUDE_CODE_TMPDIR=/home/skogix/claude/tmp` — temp dir for Claude Code
- `CLAUDE_CODE_SHELL=/usr/bin/zsh` — explicit zsh
- `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1` — load CLAUDE.md from additional dirs
- `DISABLE_AUTOUPDATER=0` — keep autoupdater on

Enabled plugins (active):
- `code-simplifier`, `typescript-lsp`, `frontend-design`, `playwright`
- `pyright-lsp`, `pr-review-toolkit`, `worktrunk`, `chrome-devtools-mcp`
- `discord`, `mcp-server-dev`, `remember`, `claude-md-management`

Extra marketplaces:
- `worktrunk` — local: `/home/skogix/.local/src/worktrunk`
- `skogai-marketplace` — local: `/home/skogix/.local/src/marketplace` (auto-update)
- `claude-plugins-official` — github: `anthropics/claude-plugins-official`

Permissions: `gptodo`, `gh`, `skogai`, `argc`, `skogcli`, `wt`, `gita` are pre-allowed. `additionalDirectories: ["/home/skogix/claude/"]`.

</settings_highlights>

<current_state>

Active project: **Claude's Home** (SkogAI/claude)
Milestone: v1.0 — four phases complete, one in planning

| Phase | Name | Status |
|-------|------|--------|
| 1 | Identity & Routing | Complete (2026-03-21) |
| 2 | Persistence Layer | Complete (2026-03-21) |
| 3 | Operations & Deployment Gate | Complete (2026-03-21) |
| 4 | Multi-Agent Readiness | Complete (2026-03-21) |
| 5 | skogai-live-chat-implementation | Planning |

Phase 5 goal: transport-agnostic `chat-io` contract, routing script for `[@agent:"msg"]` notation via skogparse, Claude skill + hook fallback. Reference: `.planning/ROADMAP.md`, `.planning/phases/05-skogai-live-chat-implementation/`.

Memory/feedback files in `.planning/memory/` shape behavior — check `MEMORY.md` for the index before modifying conventions.

</current_state>

<git_conventions>

Remote: `origin → SkogAI/claude`

Branch naming: `<agent>/<description>-<id>`
  example: `claude/add-claude-documentation-KmFlh`

Commit style: conventional, lowercase, imperative
  - `chore:` — maintenance/config
  - `docs:` — documentation
  - `feat:` — new features
  - `fix:` — bug fixes

</git_conventions>

<see_also>

- @~/.claude/CLAUDE.md                    — global identity and operating principles
- @~/.skogai/SKOGAI.md                    — SkogAI integrations and shared infrastructure
- @~/.skogai/docs/skogix/user.md          — Skogix personal introduction
- @~/.skogai/docs/skogix/definitions.md   — SkogAI vocabulary
- @~/.skogai/docs/skogfences.md           — skogfences architecture philosophy
- @.planning/memory/MEMORY.md             — auto-memory index + behavior feedback files

</see_also>
