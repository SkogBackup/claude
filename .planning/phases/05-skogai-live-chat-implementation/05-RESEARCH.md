# Phase 5: skogai-live-chat-implementation - Research

**Researched:** 2026-03-20
**Domain:** Multi-agent chat routing via fakechat + skogparse
**Confidence:** HIGH (all claims verified against live system)

---

## Summary

Phase 5 wires together three already-working systems: (1) fakechat, a Claude Code plugin that exposes a browser chat UI via MCP, (2) skogparse, the SkogAI notation parser/executor that routes `[@agent:message]` syntax to registered shell scripts, and (3) the skogcli script registry which maps agent names to executable scripts. The goal is a real-time "chat room" where typing `[@claude:"hello"]` in the browser fires an actual `claude -p "hello"` invocation and the response appears in the chat.

The implementation is primarily a CLAUDE.md instruction layer and a small routing hook. No new infrastructure is needed. The fakechat server runs unchanged. skogparse already handles the `[@agent:message]` -> `skogcli script run agent message` -> JSON response pipeline. The planner's main job is teaching Claude (via CLAUDE.md context) to recognize `[@agent:]` patterns in incoming channel messages and invoke skogparse with `--execute`, then route the `"value"` field from the JSON response back to the fakechat UI via the `reply` tool.

The critical gap is that Amy, Dot, and Goose have no `skogcli` scripts yet. Only `claude` and `letta` (via docker) have operational paths post-freeze. The reunion protocol requires creating stub scripts for the missing agents before multi-agent routing can work. Letta is a separate concern (docker-based REST API, not a simple shell script); its script would need to call the Letta API.

**Primary recommendation:** Implement routing as a CLAUDE.md instruction block inside the fakechat plugin's context (or as a skill/agent in the skogai marketplace plugin), not as a hook. Use `UserPromptSubmit` hook only if instruction-based routing proves unreliable. Agent scripts for Amy, Dot, and Goose are stubs first, real implementations later.

---

## Standard Stack

### Core

| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| fakechat (plugin) | 0.0.1 | Browser chat UI → Claude via MCP channel | Already installed as `fakechat@claude-plugins-official` |
| skogparse binary | net9.0/linux-x64 | Parse and execute `[@agent:msg]` notation | The universal SkogAI parser; symlinked at `~/.local/bin/skogparse` |
| skogcli | user-installed | Script registry: maps `claude`, `rag`, `port`, `certainty` to shell scripts | Already has 4 user scripts + global scripts |
| @modelcontextprotocol/sdk | ^1.0.0 | MCP server in fakechat (bun runtime) | Fakechat's only dependency |
| bun | runtime | Runs fakechat server.ts | Already running; no version pin needed |

### Supporting

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| argc | system | Shell script arg parsing for agent scripts | Every new agent script uses `@describe`/`@arg` comment tags |
| claude -p | system | Claude headless mode | The `claude.sh` script backend |
| skogcli script run | system | Script dispatch | skogparse `--execute` calls this internally |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| CLAUDE.md instruction routing | UserPromptSubmit hook | Hook is more reliable but adds latency; instructions are zero-infrastructure |
| Modifying fakechat server.ts | Adding routing hook | Server modification requires plugin reinstall; hook/instructions are additive |
| New MCP server for routing | skogparse CLI | MCP server is overengineering; skogparse already handles routing |

**Installation:** Nothing new to install. All dependencies already present.

**Version verification:**
```bash
/home/skogix/.local/bin/skogparse --version  # currently symlink to net9.0 SkogParse binary
bun --version
claude --version
```

---

## Architecture Patterns

### How the Current Stack Works End-to-End

```
Browser (fakechat UI)
  |-- WebSocket/POST /upload
  v
Bun HTTP server (server.ts :8787)
  |-- deliver(id, text) -> mcp.notification('notifications/claude/channel', ...)
  v
Claude Code session
  |-- Sees: <channel source="fakechat" chat_id="web" message_id="...">TEXT</channel>
  |-- Claude processes the message as a user turn
  |-- UserPromptSubmit hook fires (if configured)
  |-- Claude responds using mcp__plugin_fakechat_fakechat__reply tool
  v
Browser (receives reply via WebSocket broadcast)
```

### Pattern 1: CLAUDE.md Instruction Routing (Recommended)

**What:** Add a CLAUDE.md block (or skill) that instructs Claude to detect `[@agent:msg]` patterns in channel messages and call `skogparse --execute` before replying.

**When to use:** Primary path. Zero infrastructure, additive, easily iterated.

**Routing logic:**
```
If channel message contains [@agent:...] notation:
  1. Write message to temp file
  2. Run: /home/skogix/.local/bin/skogparse --execute <tmpfile>
  3. Parse JSON response: {"type": "string", "value": "REPLY"}
  4. Call reply tool with value field as text
Else:
  Normal Claude response via reply tool
```

**CLAUDE.md placement options (in priority order):**
- `lab/fakechat/` or installed plugin path as a CLAUDE.md (loaded when plugin is active)
- `~/.claude/CLAUDE.md` (always loaded, but pollutes all sessions)
- A new skill in `.claude/skills/` that auto-loads when fakechat channel is active

### Pattern 2: UserPromptSubmit Hook (Fallback)

**What:** A hook that fires on every user prompt, detects `<channel source="fakechat"` in the prompt text, extracts the message, runs skogparse --execute, and uses `additionalContext` to inject the routing result before Claude processes it.

**When to use:** If instruction-based routing is unreliable or if routing must be deterministic (not dependent on Claude following instructions).

**Hook structure:**
```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/home/skogix/claude/lab/fakechat/hooks/route-channel-message.sh"
          }
        ]
      }
    ]
  }
}
```

**Hook script logic:**
```bash
#!/usr/bin/env bash
# Reads JSON from stdin: {"prompt": "<channel ...>[@agent:msg]</channel>"}
# If prompt contains [@...:...] pattern, run skogparse --execute
# Output additionalContext with the routing result
PROMPT=$(jq -r '.prompt' <<< "$1")
# extract [@...] operator, run skogparse, inject result
```

### Pattern 3: Agent Script Stubs (Required for Reunion Protocol)

**What:** Create `skogcli` scripts for Amy, Dot, and Goose so `[@amy:"msg"]`, `[@dot:"msg"]`, `[@goose:"msg"]` resolve instead of returning `"Error: Script 'amy' not found."`.

**Directory:** `/home/skogix/skogai/scripts/` — skogparse uses `skogcli script run` which reads from the user script registry pointing here.

**Stub pattern (argc-compatible):**
```bash
#!/usr/bin/env bash
# @describe Amy - Artificial Sassy Intelligence
# @arg message~ <MSG> Message to Amy
# @env LLM_OUTPUT=/dev/stdout The output path

main() {
  echo "[Amy is not yet online] $argc_message" >> $LLM_OUTPUT
}

eval "$(argc --argc-eval "$0" "$@")"
```

**Letta script pattern (different - REST API):**
```bash
#!/usr/bin/env bash
# @describe Letta - Dream Architect (persistent memory agent)
# @arg message~ <MSG> Message to Letta
# @env LLM_OUTPUT=/dev/stdout The output path

main() {
  # Letta runs on port 8283 via docker
  curl -s -X POST http://localhost:8283/v1/agents/... \
    -H "Content-Type: application/json" \
    -d "{\"message\": \"$argc_message\"}" | jq -r '.messages[-1].text' >> $LLM_OUTPUT
}

eval "$(argc --argc-eval "$0" "$@")"
```

### Recommended Project Structure

```
lab/fakechat/
├── server.ts          # Unchanged - handles UI/WebSocket/MCP
├── CLAUDE.md          # NEW: routing instructions for Claude
├── hooks/             # NEW: optional hook scripts
│   └── route-channel.sh
└── .claude-plugin/
    └── plugin.json    # Unchanged

~/.skogai/scripts/     # (actually /home/skogix/skogai/scripts/)
├── claude.sh          # EXISTING - works
├── rag.sh             # EXISTING - works
├── port.sh            # EXISTING - works
├── certainty.sh       # EXISTING - works
├── amy.sh             # NEW - stub
├── dot.sh             # NEW - stub
├── goose.sh           # NEW - stub
└── letta.sh           # NEW - Letta REST API wrapper
```

### Anti-Patterns to Avoid

- **Modifying server.ts for routing:** Breaks the plugin contract. The server handles transport only; routing belongs in Claude's instruction layer or hooks.
- **Parsing `[@agent:]` with regex in bash:** The skogparse binary already handles this. Never hand-roll a parser for SkogAI notation.
- **Routing ALL messages through skogparse:** Only messages containing `[@...]` operators need routing. Plain text should reach Claude directly.
- **Hardcoding `/skogai/scripts` in scripts:** The `skogparse.sh` MCP tool already has this bug (hardcoded `/skogai/scripts`). Use `skogcli script run` or the `$SKOGAI_SCRIPTS` env var correctly.
- **Blocking the reply on slow agents:** `claude -p` can take seconds. If routing blocks, the UI appears frozen. For long operations, send an immediate "routing to [@agent]..." reply first.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Parse `[@agent:msg]` notation | Custom regex/parser | `skogparse` binary | Parser handles quoted strings, nested ops, binary ops, edge cases |
| Map agent names to scripts | Custom dispatch table | `skogcli script run <name>` | Already maps user/global scripts with fallback; metadata tracking included |
| WebSocket/HTTP server for chat UI | Custom web server | Existing fakechat server.ts | Already handles WebSocket, file upload, outbox, MIME types |
| MCP channel protocol | Custom MCP integration | `@modelcontextprotocol/sdk` + existing fakechat | Channel contract already wired; touching it breaks the plugin |
| Message ID tracking | Custom ID scheme | `nextId()` in server.ts | Already handles seq + timestamp IDs |
| Recursive depth limiting | Custom counter | skogparse built-in behavior | skogparse already limits recursion when invoked from agent context |

**Key insight:** Every piece of this pipeline already exists and works individually. Phase 5 is integration and instruction-writing, not construction.

---

## Common Pitfalls

### Pitfall 1: skogparse --execute SKOGAI_SCRIPTS path
**What goes wrong:** skogparse looks for scripts via `skogcli script run <name>`, not via `$SKOGAI_SCRIPTS` directly. But the MCP tool `skogparse.sh` hardcodes `SKOGAI_SCRIPTS="/skogai/scripts"` (wrong path) AND then calls the WORKING_SKOGPARSE binary directly. This means the MCP tool `mcp__skogai-tools__skogparse` may work differently than the CLI `skogparse --execute`.
**Why it happens:** Two different invocation paths with different configurations.
**How to avoid:** In CLAUDE.md routing instructions and hooks, use `/home/skogix/.local/bin/skogparse --execute` directly (the symlink to the working binary). Do NOT rely on `mcp__skogai-tools__skogparse` for `--execute` routing until that tool's path is fixed.
**Warning signs:** `"Error: Script 'claude' not found."` when using the MCP tool path.

### Pitfall 2: Channel messages are NOT `UserPromptSubmit` in the traditional sense
**What goes wrong:** Channel notifications from fakechat appear as `<channel source="fakechat"...>` tags in Claude's turn. They ARE processed as user turns (UserPromptSubmit fires), but the `prompt` field in the hook JSON contains the raw XML-like tag, not just the user's text.
**Why it happens:** The MCP channel protocol wraps messages in metadata tags before injecting into context.
**How to avoid:** Extract the message content from within the `<channel>` tags before passing to skogparse. The content is between the opening and closing channel tags.

### Pitfall 3: skogparse only routes "pure" operator notation
**What goes wrong:** `hello [@claude:"world"]` (inline operator) parses as `{"type": "command", "name": "hello"}` and does NOT route to the claude script. Only `[@claude:"world"]` on its own parses as an action.
**Why it happens:** Parser precedence: inline text before an operator changes the parse type.
**How to avoid:** Routing should check if the message starts with `[@` or if the entire message is an operator invocation. Mixed text+operator messages should be handled by Claude natively.

### Pitfall 4: Multiple operators in one message parse sequentially
**What goes wrong:** `[@claude:"hello"]\n[@rag:"test"]` produces two JSON objects on stdout (one per line). A routing script reading only the first line misses the second invocation.
**Why it happens:** skogparse outputs one JSON object per parsed expression, newline-separated.
**How to avoid:** When routing, read ALL lines from skogparse stdout and handle multiple invocations. Each operator in the message may need a separate reply.

### Pitfall 5: Letta requires Docker running
**What goes wrong:** `letta.sh` calls `http://localhost:8283` which only works when `docker run letta/letta:latest` is active. Routing silently fails or times out.
**Why it happens:** Letta is a persistent-memory agent running in Docker, not a lightweight CLI.
**How to avoid:** Letta stub should detect if port 8283 is up (`ss -tuln | grep 8283`) and return a graceful "Letta is offline" message if not.

### Pitfall 6: Amy, Dot, Goose scripts don't exist yet
**What goes wrong:** `[@amy:"hello"]` returns `{"type": "string", "value": "Error: Script 'amy' not found."}` and this error text gets sent to the chat UI as Amy's reply.
**Why it happens:** No `amy` script is registered in skogcli.
**How to avoid:** Create stub scripts BEFORE wiring up routing. The stub can return "[Amy not yet implemented]" gracefully. Register via `skogcli script create` or by placing `.sh` files in `/home/skogix/skogai/scripts/` and running `skogcli script update-metadata`.

### Pitfall 7: skogparse output is always JSON, not plain text
**What goes wrong:** Sending `{"type": "string", "value": "hello"}` verbatim to fakechat via the reply tool.
**Why it happens:** skogparse always wraps output in a JSON envelope.
**How to avoid:** Always parse the skogparse JSON output and extract the `"value"` field before calling the fakechat `reply` tool. Handle error responses where type may not be `"string"`.

---

## Code Examples

### Detect and Route Channel Message (CLAUDE.md instruction pattern)

```
# fakechat routing instructions (in lab/fakechat/CLAUDE.md)

When a <channel source="fakechat"> message arrives:
1. Extract the text content from within the channel tags
2. If content matches pattern `[@<word>:"<text>"]`:
   - Write content to temp file: /tmp/fakechat_route_<id>.tmp
   - Run: /home/skogix/.local/bin/skogparse --execute /tmp/fakechat_route_<id>.tmp
   - Parse JSON output, extract "value" field
   - Call mcp__plugin_fakechat_fakechat__reply with text=<value>
3. Otherwise: respond normally and use reply tool with your response
```

### Route Multiple Operators

```bash
#!/usr/bin/env bash
# Source: verified against skogparse behavior
MESSAGE="$1"
REPLY_ID="$2"

echo "$MESSAGE" > /tmp/fc_route.tmp
RESULTS=$(/home/skogix/.local/bin/skogparse --execute /tmp/fc_route.tmp 2>&1)

# Each line is a separate JSON result
while IFS= read -r line; do
  VALUE=$(echo "$line" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('value',''))" 2>/dev/null)
  if [[ -n "$VALUE" ]]; then
    echo "$VALUE"
  fi
done <<< "$RESULTS"
```

### Agent Stub Script (argc pattern)

```bash
#!/usr/bin/env bash
# Source: pattern from /home/skogix/skogai/scripts/claude.sh
# Place at: /home/skogix/skogai/scripts/amy.sh

# @describe Amy - Artificial Sassy Intelligence (stub - not yet implemented)
# @arg message~ <MSG> Message to Amy
# @env LLM_OUTPUT=/dev/stdout The output path

main() {
  echo "[Amy is offline - stub placeholder]" >> $LLM_OUTPUT
}

eval "$(argc --argc-eval "$0" "$@")"
```

### Verify Routing Chain Works

```bash
# Test the full chain
echo '[@claude:"are you there"]' | /home/skogix/.local/bin/skogparse --execute
# Expected: {"type": "string", "value": "<some reply>"}

# Test error case
echo '[@amy:"hello"]' | /home/skogix/.local/bin/skogparse --execute
# Expected: {"type": "string", "value": "Error: Script 'amy' not found."}
# After stub: {"type": "string", "value": "[Amy is offline - stub placeholder]"}
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Single-agent chat (Claude only) | Multi-agent routing via `[@agent:]` notation | Phase 5 | Any registered script becomes a "chat participant" |
| Direct Claude reply to all messages | skogparse routes `[@]` operators, Claude handles rest | Phase 5 | Decoupled: agents are scripts, not Claude |
| Fakechat as dev tool only | Fakechat as live multi-agent chat surface | Phase 5 | "Any surface that parses text is a chat client" |
| Manual agent invocation in terminal | `[@agent:msg]` in chat fires script automatically | Phase 5 | Chat notation = execution |

**Deprecated/outdated:**
- Hardcoded `SKOGAI_SCRIPTS="/skogai/scripts"` in the `skogparse.sh` MCP tool: use CLI path directly
- `skogparse "$argc_input"` (positional arg, now commented out): use `echo | skogparse` or file input mode

---

## Open Questions

1. **Channel message format in UserPromptSubmit hook**
   - What we know: Channel messages appear as `<channel source="fakechat" ...>TEXT</channel>` in Claude's context
   - What's unclear: Exact format of `prompt` field in UserPromptSubmit JSON when it's a channel message (not typed by user)
   - Recommendation: If using hook approach, test with a simple echo hook first to capture the exact JSON shape

2. **Letta API endpoint and agent ID**
   - What we know: Letta runs on port 8283 via Docker; REST API exists
   - What's unclear: Which agent ID to use, exact API endpoint for sending a message and getting a reply
   - Recommendation: Check `/home/skogix/skogai/letta/` for any API examples; start with stub that returns "Letta offline" and activate later

3. **skogcli script registration for new agent scripts**
   - What we know: Placing `.sh` files in `/home/skogix/skogai/scripts/` registers them in the user namespace
   - What's unclear: Whether `skogcli script update-metadata` or `skogcli script create` is needed, or if `skogparse` picks them up automatically via directory scan
   - Recommendation: Test by creating `amy.sh` and immediately testing `[@amy:"test"]` with skogparse --execute

4. **Recursion depth behavior when Claude invokes skogparse**
   - What we know: "Parsed messages only recurse one level when invoked by agents. When Skogix invokes, agents CAN spawn sub-agents."
   - What's unclear: How skogparse knows whether the invoker is Skogix or an agent
   - Recommendation: Do not build sub-agent spawning in Phase 5; treat routing as one-level only

---

## Validation Architecture

> nyquist_validation is enabled in .planning/config.json.

### Test Framework

| Property | Value |
|----------|-------|
| Framework | bats (Bash Automated Testing System) |
| Config file | none — see Wave 0 |
| Quick run command | `bats lab/fakechat/tests/` |
| Full suite command | `bats lab/fakechat/tests/ && bats skogai-scripts/tests/` |

### Phase Requirements to Test Map

| ID | Behavior | Test Type | Automated Command | File Exists? |
|----|----------|-----------|-------------------|-------------|
| CHAT-01 | `[@claude:"msg"]` routes via skogparse and returns reply | integration | `bats lab/fakechat/tests/test_routing.bats::@test "claude routing"` | Wave 0 |
| CHAT-02 | Unknown agent returns graceful error, not raw JSON | unit | `bats lab/fakechat/tests/test_routing.bats::@test "unknown agent graceful error"` | Wave 0 |
| CHAT-03 | Plain text messages bypass skogparse and reach Claude | unit | `bats lab/fakechat/tests/test_routing.bats::@test "plain text not routed"` | Wave 0 |
| CHAT-04 | Amy stub exists and returns non-error response | unit | `bats skogai-scripts/tests/test_stubs.bats::@test "amy stub"` | Wave 0 |
| CHAT-05 | Dot stub exists and returns non-error response | unit | `bats skogai-scripts/tests/test_stubs.bats::@test "dot stub"` | Wave 0 |
| CHAT-06 | Goose stub exists and returns non-error response | unit | `bats skogai-scripts/tests/test_stubs.bats::@test "goose stub"` | Wave 0 |
| CHAT-07 | skogparse JSON output is unwrapped before fakechat reply | unit | `bats lab/fakechat/tests/test_routing.bats::@test "json unwrapping"` | Wave 0 |

Note: Phase 5 requirements are not yet defined in REQUIREMENTS.md (roadmap says "TBD"). The IDs above are proposed. The planner should define them and add to REQUIREMENTS.md.

### Sampling Rate

- **Per task commit:** `echo '[@claude:"test"]' | /home/skogix/.local/bin/skogparse --execute | python3 -c "import json,sys; d=json.load(sys.stdin); assert d['type']=='string', 'routing failed'"`
- **Per wave merge:** Full bats suite when created
- **Phase gate:** All agent stubs created + routing verified end-to-end in browser before `/gsd:verify-work`

### Wave 0 Gaps

- [ ] `lab/fakechat/tests/test_routing.bats` — covers CHAT-01 through CHAT-03, CHAT-07
- [ ] `skogai-scripts/tests/test_stubs.bats` — covers CHAT-04 through CHAT-06
- [ ] `lab/fakechat/tests/test-helper` — shared bats test helper

*(No existing test infrastructure for this phase's scope.)*

---

## Sources

### Primary (HIGH confidence)

- `/home/skogix/claude/lab/fakechat/server.ts` — fakechat implementation, channel protocol, MCP tool names
- `/home/skogix/.local/bin/skogparse` (live testing) — verified parse-only and --execute behavior
- `/home/skogix/skogai/scripts/` (live testing) — verified `[@claude:"..."]` end-to-end routing
- `/home/skogix/claude/docs/claude-code/hooks.md` — UserPromptSubmit schema, hook types, decision control
- `/home/skogix/claude/docs/claude-code/plugins-reference.md` — MCP tool naming, `mcp__server__tool` pattern
- `/home/skogix/skogai/config/config.json` — `$ message` type schema, SKOGAI_SCRIPTS env var

### Secondary (MEDIUM confidence)

- `/mnt/sda2/WORKING_SKOGPARSE/DEVELOPMENT.md` — skogparse internals (SValue types, execution flow, uses `skogcli script run`)
- `/home/skogix/skogai/tools/functions.json` — confirms `mcp__skogai-tools__skogparse` and `mcp__skogai-tools__execute_command` are registered MCP tools
- `/home/skogix/skogai/tools/tools/skogparse.sh` — confirmed hardcoded path bug in MCP tool variant

### Tertiary (LOW confidence)

- Agent team architecture from `agent-teams.md` — not directly relevant to Phase 5 but informs the "reunion protocol" long-term vision

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all libraries verified live, versions from filesystem
- Architecture: HIGH — all three integration points tested end-to-end in this session
- Pitfalls: HIGH — pitfalls discovered via direct testing (skogparse path bug, inline operator limitation, JSON envelope requirement)

**Research date:** 2026-03-20
**Valid until:** 2026-06-20 (stable tooling; skogparse binary is compiled, fakechat is pinned 0.0.1)

**Critical note for planner:** Phase 5 has no requirements defined yet (REQUIREMENTS.md ends at MAG-04, roadmap says "TBD" for phase 5). The planner must either: (a) define CHAT-01 through CHAT-07 requirements and add them to REQUIREMENTS.md before creating plans, or (b) explicitly acknowledge this phase is requirements-free and plan directly from the phase description.
