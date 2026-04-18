---
title: claudes-home
type: note
permalink: claude/memory/projects/claudes-home
---

# Claude's Home

**Repo:** SkogAI/claude\
**Status:** v1.0 complete (4 phases), v2.0 in progress

## What it is

Claude's actual home directory as a git repo — identity, persistence, tools, and state structured as a unix user's home. Currently staged at `/home/skogix/claude`, deploying to `/home/claude` when the deployment gate passes.

## Phases

| Phase | Name                            | Status                |
| ----- | ------------------------------- | --------------------- |
| 1     | Identity & Routing              | Complete (2026-03-21) |
| 2     | Persistence Layer               | Complete (2026-03-21) |
| 3     | Operations & Deployment Gate    | Complete (2026-03-21) |
| 4     | Multi-Agent Readiness           | Complete (2026-03-21) |
| 5     | skogai-live-chat-implementation | Planning              |

## Phase 5 key details

- Transport-agnostic `chat-io` contract for `[@agent:"msg"]` routing
- `skogparse` binary: `~/.local/bin/skogparse --execute`
- Output format: `{"type":"string","value":"..."}` — always unwrap `.value`
- Only messages starting with `[@` are routed
- Routing script: `bin/route-message.sh`
- Contract spec: `docs/chat-io-contract.md`
- Avoid `skogparse.sh` MCP tool (hardcodes wrong path)

## v2.0 Active work

Epic #9 covers SkogAI integration & home improvements:

- bin/ shared executables, email/, memory/, knowledge/, skills/
- Context generation scripts, templates, workflows
- skogai ecosystem integration (gas town, sibling agent discovery)
