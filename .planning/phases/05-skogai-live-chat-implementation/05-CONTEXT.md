# Phase 5: Channel Integration - Context

**Gathered:** 2026-03-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Wire together fakechat, skogparse, and skogcli scripts so `[@agent:"msg"]` in a chat surface routes to the right agent and replies appear in the UI. Two layers: a generic chat-io contract (transport-agnostic message routing), then fakechat as the Claude Code-specific implementation of that contract. No new infrastructure — integration and instruction-writing only.

</domain>

<decisions>
## Implementation Decisions

### Architecture: two-layer design
- **D-01:** Generic chat-io layer first — a `deliver()`/`reply` contract that any transport can implement. This is the reusable piece.
- **D-02:** Fakechat is the first (and currently only) implementation of chat-io, specific to Claude Code's MCP channel protocol.
- **D-03:** The two layers are separate concerns. Chat-io defines the contract; fakechat wires it to MCP stdio + WebSocket UI.

### Routing mechanism
- **D-04:** Instruction-first — CLAUDE.md instructions teach Claude to detect `[@agent:"msg"]` and invoke skogparse.
- **D-05:** Hook (UserPromptSubmit) calls the same routing script that chat-io defines. The hook is a reliability fallback, not a separate implementation.
- **D-06:** One routing script, two entry points (instruction-based call or hook-based call). No divergence between the paths.

### Identity model
- **D-07:** A simple ID is all that connects a message to a user. That's the full scope of identity at this layer.
- **D-08:** No auth, no sessions, no user profiles. The `meta.user` field (or equivalent) carries the ID. Everything else is out of scope.

### Message persistence
- **D-09:** Not needed now. The routing layer is stateless.
- **D-10:** Future persistence will be a JSONL file (one JSON object per message, append-only), git-tracked. Design should not prevent this — messages flow through as plain text, logging is additive later.

### Claude's Discretion
- Exact CLAUDE.md instruction wording and placement
- Routing script implementation details (temp files vs stdin, error formatting)
- Whether chat-io contract is a doc, a script interface, or both
- Test structure and bats organization

</decisions>

<canonical_refs>
## Canonical References

### Channel protocol
- `.planning/phases/05-skogai-live-chat-implementation/05-RESEARCH.md` — Full research: architecture patterns, pitfalls, code examples, stack verification
- `.planning/phases/05-skogai-live-chat-implementation/05-HANDOVER.md` — Contract definition (deliver/reply), open questions, design principles

### Fakechat implementation
- `lab/fakechat/server.ts` — Existing MCP channel server: WebSocket, HTTP, deliver(), reply tool
- `docs/claude-code/hooks.md` — UserPromptSubmit schema, hook types, decision control
- `docs/claude-code/plugins-reference.md` — MCP tool naming (`mcp__server__tool` pattern)

### Routing stack
- `/home/skogix/.local/bin/skogparse` — The notation parser binary (symlink to net9.0 build)
- `/home/skogix/skogai/scripts/` — skogcli script registry (claude.sh, rag.sh, port.sh, certainty.sh exist)
- `/home/skogix/skogai/tools/tools/skogparse.sh` — MCP tool variant (has hardcoded path bug — use CLI binary directly)

### Prior phase context
- `.planning/phases/04-multi-agent-readiness/04-CONTEXT.md` — Permission model, guestbook conventions

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `lab/fakechat/server.ts` — Working MCP channel server with WebSocket UI, deliver(), reply tool
- `/home/skogix/.local/bin/skogparse --execute` — Parses `[@agent:"msg"]` and dispatches to skogcli scripts, returns JSON
- `/home/skogix/skogai/scripts/claude.sh` — Working agent script (argc pattern) for reference

### Established Patterns
- argc comment tags (`@describe`, `@arg`, `@env LLM_OUTPUT`) for all agent scripts
- skogparse JSON envelope: `{"type": "string", "value": "..."}` — must unwrap before replying
- MCP channel notifications: `notifications/claude/channel` with content + meta fields

### Integration Points
- Fakechat's `deliver()` → MCP notification → Claude sees `<channel>` tag
- Claude calls `mcp__plugin_fakechat_fakechat__reply` → WebSocket broadcast → browser
- Routing script sits between: extract from channel tag → skogparse --execute → unwrap JSON → reply

### Known Bugs
- `skogparse.sh` MCP tool hardcodes `SKOGAI_SCRIPTS="/skogai/scripts"` (wrong path) — use CLI binary directly
- Inline operators (`hello [@claude:"world"]`) don't route — only pure operator messages do

</code_context>

<specifics>
## Specific Ideas

- "the implementation is two things, a general chat-io, then fakechat is the claude code specific implementation"
- One routing script serves both instruction path and hook path — no divergence
- Simple user ID is the entire identity model at this layer
- Future JSONL persistence is git-tracked, append-only — but not built now

</specifics>

<deferred>
## Deferred Ideas

- Agent stub scripts (Amy, Dot, Goose, Letta) — separate from routing; routing handles "script not found" gracefully
- JSONL message persistence — design doesn't block it, built later
- Multiple transport implementations beyond fakechat (file-watcher, HTTP, CLI args)
- Sub-agent spawning / recursion depth control
- Auth/sessions/user profiles beyond simple ID

</deferred>

---

*Phase: 05-skogai-live-chat-implementation*
*Context gathered: 2026-03-22*
