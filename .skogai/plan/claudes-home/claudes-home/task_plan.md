# Task Plan: Claude's Home (v1.0 → v2.0)

## Goal

A proper unix home for Claude — identity, persistence, tools, and state — deployable to /home/claude and integrated with the SkogAI ecosystem.

## Current Phase

Phase 5 (v2.0 work in progress)

## Phases

### Phase 1: Identity & Routing

- [x] Split soul document into 10 sections under personal/soul/
- [x] CLAUDE.md routing across all directories
- [x] Framework paths confirmed
- **Status:** complete (2026-03-21)

### Phase 2: Persistence Layer

- [x] Journal conventions doc (personal/journal/CONVENTIONS.md)
- [x] LORE gating — default routing does not auto-load memory-blocks/
- [x] Wrap-up session handoff command
- **Status:** complete (2026-03-21)

### Phase 3: Operations & Deployment Gate

- [x] bin/healthcheck with identity/routing/memory-tier checks
- [x] docs/deployment-gate.md checklist
- **Status:** complete (2026-03-21)

### Phase 4: Multi-Agent Readiness

- [x] docs/permissions.md — three-tier permission model
- [x] guestbook/ as cross-agent communication channel
- **Status:** complete (2026-03-21)

### Phase 5: skogai-live-chat-implementation

- [ ] docs/chat-io-contract.md — transport-agnostic deliver/reply spec
- [ ] bin/route-message.sh — [@agent:"msg"] routing via skogparse
- [ ] Bats test suite for routing script
- [ ] .claude/skills/phase5.md — routing skill
- [ ] Hook fallback in settings.json
- **Status:** planning

### Phase 6: SkogAI Ecosystem Integration (v2.0)

- [ ] Gas Town (~/gt/) integration
- [ ] Sibling agent discovery
- [ ] Cross-agent tooling beyond guestbook/
- **Status:** pending

## Key Decisions

| Decision                              | Rationale                                           | Date       |
| ------------------------------------- | --------------------------------------------------- | ---------- |
| Stage in /home/skogix/claude first    | Prove the home works before real unix user access   | 2026-03-20 |
| CLAUDE.md lazy routing                | Prevents context destruction pattern                | 2026-03-20 |
| LORE stays in museum                  | Memory blocks are reference, not active constraints | 2026-03-20 |
| skogai group for shared spaces        | Unix permissions model for multi-agent collab       | 2026-03-20 |
| .planning/ stays until full migration | Auto-memory and ROADMAP references depend on it     | 2026-04-17 |

## Deliverables

- [x] personal/ — identity, soul, journal, memory blocks
- [x] bin/ — healthcheck, context scripts
- [x] docs/ — deployment gate, permissions
- [x] guestbook/ — cross-agent channel
- [ ] bin/route-message.sh
- [ ] docs/chat-io-contract.md
- [ ] /home/claude deployment
