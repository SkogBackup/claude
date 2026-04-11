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
│   ├── agents/          — gsd subagent definitions (planner, executor, verifier, etc.)
│   ├── commands/        — slash commands (gsd/*, skogai/*)
│   ├── get-shit-done/   — gsd plugin (bin, commands, workflows, templates)
│   ├── hooks/           — gsd-* hooks (check-update, context-monitor, prompt-guard, statusline, workflow-guard)
│   └── skills/          — claude code skills (planning-with-files, prompt-master, etc.)
├── .skogai/
│   ├── SKOGAI.md        — SkogAI integrations context
│   ├── docs/
│   │   ├── skogfences.md            — AI-as-unix-user architecture philosophy
│   │   └── skogix/
│   │       ├── user.md              — Skogix introduction and preferences
│   │       └── definitions.md       — SkogAI vocabulary (@, $, task, todo, plan, agent...)
│   └── mcp/
│       └── searxng.js   — SearXNG MCP server (web search via searxng.aldervall.se)
├── .planning/           — gsd project planning (PROJECT.md, ROADMAP.md, STATE.md, memory/)
├── bin/                 — scripts and tools (healthcheck, context-*.sh, build-system-prompt.sh)
├── commands/
│   └── wrapup.md        — /wrap-up slash command (ship, remember, review, journal)
├── .config/
│   └── wt.toml          — worktrunk config template
├── docs/                — reference docs (deployment-gate.md, permissions.md, fetch-docs.sh)
├── guestbook/           — visitor notes and cross-agent messages
├── journal/             — session journals and discoveries
├── lab/                 — experiments, prototypes, WIP projects
├── notes/               — observations and patterns
├── personal/            — identity, soul document, memory blocks, profile
├── state/               — session state
├── tasks/               — tracked GitHub issues as local task files
└── CLAUDE.md            — this file
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

| hook file                | event       | matcher                          | purpose                        |
|--------------------------|-------------|----------------------------------|--------------------------------|
| gsd-check-update.js      | SessionStart | —                               | check for gsd plugin updates   |
| gsd-context-monitor.js   | PostToolUse | Bash\|Edit\|Write\|Agent\|Task   | monitor context window         |
| gsd-prompt-guard.js      | PreToolUse  | Write\|Edit                      | guard file write operations    |
| gsd-statusline.js        | —           | statusLine                       | render status line             |
| gsd-workflow-guard.js    | PreToolUse  | Write\|Edit                      | guard workflow state changes   |

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
- hooks: gsd-check-update (SessionStart), gsd-context-monitor (PostToolUse), gsd-prompt-guard (PreToolUse)
- statusLine: gsd-statusline.js

</settings_highlights>

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

</see_also>
