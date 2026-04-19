---
title: EPIC-1-core-infrastructure
type: note
permalink: claude/projects/dot-skogai/plan/garden/epic-1-core-infrastructure
---

# Epic 1: Core Infrastructure

**Status:** ✅ Complete **Phase:** 1 of 4

## Overview

Establish the foundational infrastructure for the plugin trial garden system, including state management, usage tracking hooks, and basic status reporting.

## Goals

- Enable persistent tracking of plugin trials across sessions
- Automatically count user messages for each trial plugin
- Notify users when trials expire
- Provide visibility into current garden state

## Deliverables

- [x] garden-state.json schema and initialization
- [x] session-start.sh trial expiration check
- [x] user-prompt-submit.sh message counter
- [x] basic /garden:status command

## Implementation Summary

### Files Created

- `~/.claude/garden-state.json` - user-level trial state
- `plugins/garden/commands/status.md` - status command
- `plugins/garden/scripts/init-garden.sh` - initialization script
- `plugins/garden/scripts/garden-lib.sh` - shared library functions

### Files Modified

- `.claude/hooks/session-start.sh` - added trial expiration checking
- `.claude/hooks/user-prompt-submit.sh` - added message counting
- `.claude-plugin/marketplace.json` - registered garden plugin

## Testing Completed

- [x] manually created garden-state.json with trial plugin
- [x] verified session-start shows prompt when threshold reached
- [x] verified message counter increments on each prompt
- [ ] verify /garden:status displays correctly (needs plugin refresh)

## Related Issues

- #2 (Phase 2: Trial Management Commands)
- #3 (Phase 3: Plugin Suggestions)
- #4 (Phase 4: Refinement and UX)

## Notes

Phase 1 provides the foundation. Users can now track trials, but need Phase 2 commands to actually manage them (`/garden:trial`, `/garden:keep`, etc).
