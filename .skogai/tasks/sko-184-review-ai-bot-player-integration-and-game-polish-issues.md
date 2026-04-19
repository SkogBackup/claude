---
created: 2026-04-19
state: active
tags:
- bug
- epic
- linear
- github
- small-hours
tracking:
- https://linear.app/skogai/issue/SKO-184
- https://github.com/small-hours-games/small-hours/issues/96
updated: 2026-04-19
---

# SKO-184: review AI bot player integration and game polish issues

**Source**: [Linear SKO-184](https://linear.app/skogai/issue/SKO-184), mirrored to [GitHub #96](https://github.com/small-hours-games/small-hours/issues/96)

## Overview

This epic tracks work needed to:

1. make Small Hours support a first-class AI bot player integration (Claude), and
2. fix/polish game UX issues found during live playtesting.

Playtest baseline referenced in issue: **2026-04-12** (Claude joined via browser player).

## Scope breakdown

### 🤖 Bot integration

- Add a WebSocket bot client interface with structured game state + action API.
- Expose a `BOT_ACTION` message type so bots can submit moves without UI click emulation.
- Add bot player registration to lobby (`?bot=true` and/or dedicated endpoint).
- Add game state event stream endpoint for bot consumers.
- Document action/state contract in README.

### 🐛 Bug fixes

- Gin Rummy: draw action has no clickable target, causing hard game lock.
- Lobby chat: sender names missing in chat message rendering (`: message`).

### ✨ Game polish

- Gin Rummy: make stock pile and discard pile explicitly clickable for draw flow.
- Quiz: add visible countdown timer on player screen.
- Shithead: show opponent face-up cards for strategy context.

## Suggested implementation slices

1. **Unblock gameplay first (high priority):**
   - Gin Rummy draw interaction fix.
   - Lobby chat sender-name rendering fix.
2. **Player-facing polish second:**
   - Quiz countdown timer.
   - Shithead face-up opponent cards.
3. **Bot interface third (incremental, contract-first):**
   - Define and document message contract.
   - Add `BOT_ACTION` and bot join pathway.
   - Add event stream for current game state and deltas.

## Acceptance checklist

- [ ] Gin Rummy game can always progress through draw phase using clickable targets.
- [ ] Lobby chat shows `player_name: message` consistently.
- [ ] Quiz players see active countdown during answer windows.
- [ ] Shithead displays opponent face-up cards in expected zones.
- [ ] Bot can join lobby without browser UI.
- [ ] Bot can submit legal actions through structured protocol.
- [ ] Bot can consume game state updates through stream/socket.
- [ ] README documents stable bot action/state contract.

## Dependencies / open questions

- Confirm authoritative transport model for bots: reuse game socket vs dedicated bot endpoint.
- Decide whether event stream is WebSocket channel, SSE, or both.
- Confirm contract versioning approach (`protocolVersion` field recommended).
- Add deterministic replay fixtures for bot integration tests (recommended for regressions).

## Notes

This task note captures execution order and acceptance criteria so implementation can proceed in small PRs rather than one large epic branch.
