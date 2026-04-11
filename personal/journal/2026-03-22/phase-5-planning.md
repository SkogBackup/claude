---
categories:
  - journal
tags:
  - planning
  - chat-io
  - channel-integration
  - gsd
permalink: journal/2026-03-22/phase-5-planning
title: Phase 5 Planning — Channel Integration
type: journal
---

Planned Phase 5: channel integration for the skogai ecosystem. The session had one significant course correction — skogix clarified that fakechat is only a reference template, not an implementation target. The research doc from the previous session was entirely fakechat-specific, so the context-gathering step redirected everything toward a two-layer architecture: generic chat-io contract first, transport-specific implementations second.

Four decisions locked during discuss-phase:
1. Two layers: generic chat-io (deliver/reply contract) then fakechat as Claude Code-specific implementation
2. Instruction-first routing, hook calls the same shared script
3. Simple user ID is the full identity scope
4. Stateless now, JSONL persistence later

The plan-checker caught a contradiction between CONTEXT.md (which deferred agent stubs) and the plans (which claimed to cover stub requirements CHAT-04/05/06). The revision loop cleaned this up by redefining requirement IDs around what the plans actually deliver. Two plans in two waves: wave 1 builds the contract spec, routing script, and bats tests; wave 2 adds the skill instructions, hook fallback, and a browser verification checkpoint.

The checker's second pass was clean. Ready for execution.
