# RTK Transparent Command Rewriting via Claude Code Hooks

## Discovery

Started by exploring RTK (Rust Token Killer) as a token optimization tool.
The existing docs referenced v0.2.0 which said `ls` was -274% worse and `grep`
was buggy. Testing revealed v0.22.2 was installed — both commands now work
great (73% and 95% savings respectively).

## The Journey: Deny → Discover → Rewrite

### Phase 1: Custom deny-based hook

Built a PreToolUse hook that denied non-RTK commands and told Claude to retry
with `rtk` prefix. Worked but cost an extra API round-trip per rewrite.

### Phase 2: RTK discover

Ran `rtk discover` which analyzed 9 sessions (100 Bash commands) and found
`ls -la` was the #1 missed opportunity at 31 calls. Only 6% of commands
were using RTK.

### Phase 3: RTK's built-in integration

Discovered `rtk init -g --auto-patch` which ships its own production-grade
Claude Code hook (`rtk-rewrite.sh`). The key insight: PreToolUse hooks can
return `updatedInput` in their JSON output to **transparently rewrite**
the command before execution — not just deny it.

```json
{
  "hookSpecificOutput": {
    "permissionDecision": "allow",
    "updatedInput": { "command": "rtk git log --oneline -5" }
  }
}
```

Zero overhead. The command is modified in-place before execution. No deny,
no retry, no extra API call.

### Coverage

RTK's hook covers 30+ command patterns across git, gh, cargo, ls, tree, find,
grep, cat→read, head→read, docker, kubectl, vitest, tsc, eslint, prettier,
playwright, prisma, pnpm, npm, pytest, ruff, pip, go, golangci-lint, curl, wget.

## Key Takeaway

Many CLI tools ship their own Claude Code integration. Before building custom
hooks, check if the tool has `init` or similar setup commands. RTK's hook is
far more robust than what we built manually — it handles env var prefixes,
heredocs, chained commands, and dozens of command patterns.

## Useful Commands

```bash
rtk init --show       # Health check of RTK integration
rtk hook-audit        # See rewrite metrics
rtk gain              # Token savings summary
rtk discover          # Missed optimization opportunities
```
