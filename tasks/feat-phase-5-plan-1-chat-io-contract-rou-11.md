---
state: new
created: 2026-04-17
tracking:
  - https://github.com/SkogAI/claude/issues/11
permalink: claude/tasks/feat-phase-5-plan-1-chat-io-contract-rou-11
---

# feat: phase 5 plan 1 — chat-io contract, routing script, bats tests

**Source**: [Github #11](https://github.com/SkogAI/claude/issues/11)

## Description

Part of #9 (Claude's Home v2.0).

Implements ROADMAP Phase 5, Plan 1.

## Requirements covered

- CHAT-01: Routing script detects `[@agent:"msg"]` and dispatches via skogparse
- CHAT-02: Unknown agents produce human-readable error, not raw JSON
- CHAT-03: Plain text without notation bypasses routing
- CHAT-04: JSON envelope is unwrapped — only the value field reaches the caller
- CHAT-05: Chat-io contract spec documents deliver/reply semantics

## Deliverables

- `docs/chat-io-contract.md` — trans

## Notes

*Imported from external tracker. See source link for full context.*
