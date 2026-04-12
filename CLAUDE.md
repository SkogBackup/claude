# @~/ — home folder and workspace

<what_is_this>

My home directory and primary operating environment. Not application code — this repo IS the workspace: dotfiles, configuration, knowledge base, and staging for tools I'm developing.

Context is loaded lazily. Read the router, follow the link, get what's needed. No bulk pre-loading.

Staged at `/home/user/claude` (formerly `/home/skogix/claude`), deploying to `/home/claude` when the deployment gate passes.

</what_is_this>

<structure>

```
~/
├── .claude/
│   ├── CLAUDE.md        — global identity + operating principles (always loaded)
│   ├── settings.json    — Claude Code config (single source of truth)
│   ├── commands/        — slash commands (skogai/*)
│   └── skills/          — claude code skills (planning-with-files, prompt-master, skogai-routing, etc.)
├── .skogai/
│   ├── SKOGAI.md        — SkogAI integrations context (symlinked as ~/.skogai/CLAUDE.md)
│   ├── docs/
│   │   ├── skogfences.md            — AI-as-unix-user architecture philosophy
│   │   └── skogix/
│   │       ├── user.md              — Skogix introduction and preferences
│   │       └── definitions.md       — SkogAI vocabulary (@, $, task, todo, plan, agent...)
│   └── mcp/
│       └── searxng.js   — SearXNG MCP server (web search via searxng.aldervall.se)
├── .planning/           — project planning
│   ├── PROJECT.md       — project brief and key decisions
│   ├── ROADMAP.md       — phase breakdown (v1.0: 4 phases complete, phase 5 active)
│   ├── REQUIREMENTS.md  — requirement definitions and traceability
│   ├── STATE.md         — current session state and accumulated context
│   ├── codebase/        — codebase map artifacts
│   ├── memory/          — auto-memory storage (feedback, project notes, user profile)
│   ├── notes/           — planning notes
│   ├── phases/          — per-phase directories (01..05)
│   ├── quick/           — quick task records
│   └── research/        — research artifacts
├── .config/
│   └── wt.toml          — worktrunk config template
├── bin/                 — scripts and tools
│   ├── healthcheck      — environment sanity + identity integrity check
│   ├── context.sh       — main context orchestrator
│   ├── context-git.sh   — git status context
│   ├── context-journal.sh — journal entries context
│   ├── context-workspace.sh — workspace tree context
│   ├── build-system-prompt.sh — builds system prompt from config
│   └── find-agent-root.sh — agent root detection
├── commands/            — slash command definitions (skogai/*)
├── docs/                — reference docs
│   ├── deployment-gate.md — checklist before migrating to /home/claude
│   ├── permissions.md   — permission model for multi-agent access
│   └── fetch-docs.sh    — refresh docs from code.claude.com
├── guestbook/           — cross-agent communication channel
│   └── skogix.md        — Skogix's message to Claude (skogfences vision)
├── journal/             — session journals (YYYY-MM-DD/ date-folder structure)
├── lab/                 — experiments, prototypes, WIP projects
│   ├── fakechat/        — fakechat experiment
│   ├── projects-in-development/ — various WIP projects
│   └── skogai-dot-github/ — skogai github org config work
├── notes/
│   └── observations.md  — collected patterns and reflections
├── personal/            — identity, soul document, memory blocks, profile
│   ├── CLAUDE.md        — router: soul, core, memory-blocks, journal, INDEX
│   ├── INDEX.md         — curated highlights across all personal files
│   ├── profile.md       — agent profile and business card
│   ├── soul-document.md — backup of original soul document
│   ├── soul/            — split soul document (10 sections)
│   ├── core/            — epistemic frameworks (certainty, placeholder, context-destruction)
│   ├── journal/         — session records (personal/journal/CONVENTIONS.md)
│   └── memory-blocks/   — LORE museum: historical eras 01–10 (reference only)
├── state/
│   └── sessions/        — session state files
├── tasks/               — tracked GitHub issues as local task files
├── CLAUDE.md            — this file
├── ONBOARDING.md        — team onboarding guide (usage stats, setup checklist)
└── README.md            — home directory overview
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

<project_state>

Milestone v1.0: "Claude's Home"
Core value: Claude can drop into any conversation and know who he is, what he's working on, and where things are.

| Phase | Name | Status |
|-------|------|--------|
| 1 | Identity & Routing | Complete (2026-03-21) |
| 2 | Persistence Layer | Complete (2026-03-21) |
| 3 | Operations & Deployment Gate | Complete (2026-03-21) |
| 4 | Multi-Agent Readiness | Complete (2026-03-21) |
| 5 | skogai-live-chat-implementation | Planning |

Phase 5 adds `[@agent:"msg"]` routing via skogparse, chat-io contract spec, and hook fallback. See `.planning/ROADMAP.md` for full spec.

</project_state>

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

<journal_conventions>

Journal entries use date-folder structure: `personal/journal/YYYY-MM-DD/<description>.md`
- Append-only (formatting corrections permitted)
- LORE (memory-blocks/) requires explicit navigation — not auto-loaded

</journal_conventions>

<journal_conventions>

Journal entries use date-folder structure: `personal/journal/YYYY-MM-DD/<description>.md`
- Append-only (formatting corrections permitted)
- LORE (memory-blocks/) requires explicit navigation — not auto-loaded

</journal_conventions>

<settings_highlights>

Key settings.json values (`.claude/settings.json`):
- `model: "sonnet"`
- `alwaysThinkingEnabled: true`
- `autoMemoryEnabled: true` → `autoMemoryDirectory: .planning/memory`
- `autoDreamEnabled: true`
- `defaultView: "transcript"`
- `skipDangerousModePermissionPrompt: true`
- enabled plugins: code-simplifier, typescript-lsp, frontend-design, playwright, pyright-lsp, pr-review-toolkit, worktrunk, chrome-devtools-mcp, discord, mcp-server-dev, remember
- `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS: "1"` — agent teams enabled

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
- @.planning/PROJECT.md                   — project brief and decisions
- @docs/deployment-gate.md               — deployment gate checklist
- @docs/permissions.md                   — permission model

</see_also>
