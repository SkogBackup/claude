---
title: README
type: note
permalink: claude/projects/dot-skogai/plan/garden/readme
---

# Garden Plugin - Epic Roadmap

Progressive plugin trial system for the skogai marketplace.

## Overview

Transform the static plugin experience into a living garden that grows based on actual usage patterns. Start minimal, trial plugins temporarily, keep what works.

## Epics

### ✅ Epic 1: Core Infrastructure (COMPLETE)

**Files:** `EPIC-1-core-infrastructure.md` **Status:** Complete **Phase:** Foundation

Build the foundational infrastructure:

- State management (garden-state.json)
- Usage tracking hooks
- Trial expiration detection
- Basic status reporting

**What works:**

- Plugins track message counts automatically
- Session-start notifies when trials expire
- `/garden:status` shows garden state (needs plugin refresh)

### 🔜 Epic 2: Trial Management Commands

**Files:** `EPIC-2-trial-management-commands.md` **Status:** Pending **Phase:** User interaction **Depends on:** Epic 1

User-facing commands to manage trials:

- `/garden:trial` - add plugin to trial mode
- `/garden:keep` - promote trial to permanent
- `/garden:swap` - replace with different plugin
- `/garden:reset` - extend trial period

**Blockers:** None (Epic 1 complete)

### 🔜 Epic 3: Plugin Suggestions

**Files:** `EPIC-3-plugin-suggestions.md` **Status:** Pending **Phase:** Discovery **Depends on:** Epic 2

Automatic plugin discovery:

- Tech stack detection
- Contextual suggestions
- Integration with /compound workflow
- Plugin-to-stack mappings

**Blockers:** Epic 2

### 🔜 Epic 4: Refinement and UX

**Files:** `EPIC-4-refinement-and-ux.md` **Status:** Pending **Phase:** Polish **Depends on:** Epic 3

Advanced features:

- Configurable thresholds
- Usage analytics
- Export/import gardens
- Community recommendations

**Blockers:** Epic 3

## Quick Links

- **Plan:** `plans/plugin-trial-garden-system.md`
- **Code:** `plugins/garden/`
- **State:** `~/.claude/garden-state.json`
- **Hooks:** `.claude/hooks/session-start.sh`, `.claude/hooks/user-prompt-submit.sh`

## Current Status

**Phase 1 Complete:**

- ✅ Infrastructure in place
- ✅ Tracking works
- ⏳ Needs testing with plugin refresh

**Next Steps:**

1. Test `/garden:status` after plugin refresh
1. Begin Epic 2: implement trial management commands
1. Create test plugin for trial workflow validation

## Development Workflow

```bash
# Work in dedicated worktree
wt switch garden-thingies

# Make changes to plugins/garden/

# Test locally
claude plugin refresh

# Try commands
/garden:status

# Commit and merge when ready
wt merge
```

## Architecture

```
garden system
├── state
│   └── ~/.claude/garden-state.json (persistent)
├── hooks
│   ├── session-start.sh (trial expiration)
│   └── user-prompt-submit.sh (message counting)
└── commands
    ├── status.md (✅ implemented)
    ├── trial.md (🔜 pending)
    ├── keep.md (🔜 pending)
    ├── swap.md (🔜 pending)
    └── reset.md (🔜 pending)
```

## Success Metrics

**Adoption:**

- Plugins in trial mode per user
- Trial → permanent conversion rate
- Swap frequency

**Performance:**

- Hook execution time < 100ms
- State file size growth
- Error rate

**Engagement:**

- `/garden:status` usage
- Suggestion acceptance rate
- Community sharing (Phase 4)
