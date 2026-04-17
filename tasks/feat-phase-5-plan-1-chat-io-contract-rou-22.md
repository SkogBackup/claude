---
state: new
created: 2026-04-18
tracking: ["https://github.com/SkogAI/claude/issues/22"]
---

# feat: phase 5 plan 1 — chat-io contract, routing script, bats tests

**Source**: [Github #22](https://github.com/SkogAI/claude/issues/22)

## Description

Implements ROADMAP Phase 5, Plan 1.

## Requirements

* CHAT-01: Routing script detects `[@agent:"msg"]` and dispatches via skogparse
* CHAT-02: Unknown agents produce human-readable error, not raw JSON
* CHAT-03: Plain text without notation bypasses routing
* CHAT-04: JSON envelope is unwrapped — only the value field reaches the caller
* CHAT-05: Chat-io contract spec documents deliver/reply semantics

## Deliverables

* `docs/chat-io-contract.md` — transport-agnostic contract spec
* `bin/route

## Notes

*Imported from external tracker. See source link for full context.*
