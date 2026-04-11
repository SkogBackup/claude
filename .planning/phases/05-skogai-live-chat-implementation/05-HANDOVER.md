# Phase 05: Channel Integration — Handover

## What We're Building

A simple, generic way to send and receive messages to/from Claude Code via the MCP channel contract.

NOT tied to fakechat. NOT tied to skogparse. NOT tied to any specific UI.

## The Contract (learned from fakechat example)

fakechat/server.ts is a **two-faced bridge**:

```
Outside world ←[any transport]→ Bridge server ←[stdio/MCP]→ Claude Code
```

### Inbound (external → Claude Code)

The `deliver()` function fires an MCP notification:

```ts
mcp.notification({
  method: 'notifications/claude/channel',
  params: {
    content: "the message text",
    meta: {
      chat_id: 'web',
      message_id: 'u1234',
      user: 'someone',
      ts: new Date().toISOString(),
      // optional: file_path for attachments
    },
  },
})
```

Claude Code sees this as a `<channel>` tag in its conversation.

### Outbound (Claude Code → external)

Claude calls the `reply` tool (defined via `ListToolsRequestSchema`). The tool handler broadcasts the response to connected clients.

### Plugin setup

- Must declare `experimental: { 'claude/channel': {} }` in MCP capabilities
- Must be launched with `claude --channels plugin:name@registry`
- MCP server connects via `StdioServerTransport` (stdio)

## Design Principles

- Multiple transports, one contract: WebSocket, HTTP, file-watcher, CLI args — all just trigger `deliver()` and listen for `reply`
- Keep it as simple as port.sh and claude.sh — argc comment tags, minimal code
- The skogparse/notation layer is SEPARATE. It wraps around this. We don't touch it.
- Text in → channel → text out. That's the scope.

## Research

Full research at: `.planning/phases/05-skogai-live-chat-implementation/05-RESEARCH.md`

## Open Questions for Planning

1. Single server with multiple transport endpoints (WS + HTTP + file) or separate scripts per transport?
2. Plugin registry vs local-only plugin?
3. Message history/persistence — needed at this layer or handled externally?
4. Auth/identity — how does a message declare who sent it? (meta.user field)

## Next Step

`/gsd:plan-phase 5`

## Branch

`feature/channel-integration` — worktree at `.worktrees/channel-integration/`
