---
title: EPIC-2-trial-management-commands
type: note
permalink: claude/projects/dot-skogai/plan/garden/epic-2-trial-management-commands
---

# Epic 2: Trial Management Commands

**Status:** 🔜 Pending **Phase:** 2 of 4 **Depends on:** Epic 1 (Core Infrastructure)

## Overview

Implement user-facing commands to manage plugin trials: add plugins to trial mode, promote them to permanent stack, swap them out, or reset trial counters.

## Goals

- Enable users to add any plugin to trial mode
- Allow promotion of successful trials to permanent stack
- Support swapping underperforming plugins for alternatives
- Provide reset mechanism for extended trials

## Deliverables

- [ ] /garden:trial command - add plugin to trial mode
- [ ] /garden:keep command - promote trial to permanent
- [ ] /garden:swap command - replace trial with different plugin
- [ ] /garden:reset command - reset trial counter

## Files to Create

- `plugins/garden/commands/trial.md`
- `plugins/garden/commands/keep.md`
- `plugins/garden/commands/swap.md`
- `plugins/garden/commands/reset.md`

## Implementation Details

### /garden:trial <plugin-name> [--threshold N]

```bash
# Add plugin to trial mode
- Check if plugin exists in marketplace
- Install plugin with 'local' scope
- Add entry to garden-state.json trials with:
  - started_at: current timestamp
  - message_count: 0
  - threshold: N (default 50)
  - source: "@marketplace"
  - added_by: "manual"
- Output confirmation
```

### /garden:keep <plugin-name> [--scope user|project]

```bash
# Promote trial to permanent
- Verify plugin in trials
- Move from trials to permanent in garden-state.json
- Optionally change plugin scope
- Output confirmation
```

### /garden:swap <current-plugin> <new-plugin>

```bash
# Swap trial plugins
- Remove current plugin from trials
- Add to removed with reason and message count
- Add new plugin to trials
- Reset threshold to default
- Output confirmation
```

### /garden:reset <plugin-name> [--threshold N]

```bash
# Reset trial counter
- Verify plugin in trials
- Reset message_count to 0
- Optionally update threshold
- Output confirmation
```

## Testing Plan

- [ ] trial new plugin, verify state updates correctly
- [ ] keep plugin, verify moved from trials to permanent
- [ ] swap plugin, verify removed entry and new trial created
- [ ] reset counter, verify message_count reset to 0
- [ ] test error cases (plugin not found, not in trials, etc)
- [ ] verify all commands update garden-state.json atomically

## Success Criteria

- All four commands work end-to-end
- State updates are atomic (no race conditions)
- Clear error messages for invalid operations
- Commands are discoverable via `/garden:` prefix

## Related Issues

- Epic 1: Core Infrastructure (dependency)
- Epic 3: Plugin Suggestions (builds on this)
- Epic 4: Refinement and UX (enhances this)
