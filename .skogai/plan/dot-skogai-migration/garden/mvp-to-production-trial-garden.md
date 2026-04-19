---
category: workflow-efficiency
components:
  - plugin-development
  - mvp-methodology
tags:
  - planning
  - execution
  - validation
  - code-review
related_docs:
  - plans/plugin-trial-garden-system.md
  - workflows:plan
  - workflows:work
  - workflows:review
date: 2025-12-29
permalink: claude/projects/dot-skogai/plan/garden/mvp-to-production-trial-garden
---

# MVP to Production: Trial Garden System

## Problem Statement

Build a plugin trial tracking system for the marketplace that allows users to experiment with plugins and make informed decisions about keeping, swapping, or removing them. The challenge was to deliver working functionality quickly without getting bogged down in overengineering.

## Previous Approach Issues

Before this workflow, complex setups often resulted in:

- Analysis paralysis from trying to design the perfect system upfront
- Multiple iterations without seeing concrete results
- Mixing MVP features with future enhancements
- Long development cycles before validation

## The MVP Methodology Applied

### 1. Plan Phase

**Created:** `plans/plugin-trial-garden-system.md`

**Key decisions:**

- **Scope ruthlessly:** Counter-based tracking only (no suggestions, no UI, no complex state)
- **Manual setup for MVP:** User creates `~/.claude/garden-state.json` manually
- **Clear success criteria:** 6 specific checkboxes to validate MVP works
- **Explicit out-of-scope:** Listed 5+ features explicitly deferred to "next steps"

**Plan structure:**

```
1. What we're building (1 sentence)
2. The demo (4 steps to validate)
3. Files to create (exact specifications)
4. Testing procedure (step-by-step)
5. Success criteria (checkboxes)
6. Out of scope (what NOT to build)
7. Next steps (after MVP works)
```

**Time investment:** ~15 minutes to write clear plan

### 2. Work Phase

**Command used:** `/workflows:work`

**Execution pattern:**

- Created each file from plan specifications
- Made scripts executable immediately (`chmod +x`)
- Tested incrementally (created state file, verified hook execution)
- Fixed issues as discovered (path resolution, jq syntax)

**Key implementation decisions:**

- Used `$CLAUDE_PLUGIN_ROOT` for hook script paths (portability)
- Single jq operation for incrementing all counters (performance)
- Graceful degradation if state file doesn't exist
- Clear emoji-based UI for trial completion prompts

**Files created:**

```
plugins/garden/
├── scripts/
│   ├── session-start.sh        # Show expired trial prompts
│   ├── user-prompt-submit.sh   # Increment message counters
│   └── status.sh               # /garden:status command
├── commands/
│   └── status.md               # Command definition
└── .claude-plugin/
    └── plugin.json
```

**Time investment:** ~30 minutes from first file to working system

### 3. Validation Phase

**Testing approach:**

1. Manual state file creation (`~/.claude/garden-state.json`)
1. Real session testing (sent actual messages to increment counter)
1. Session restart to verify SessionStart hook
1. Status command verification (`/garden:status`)

**Results:**

- ✅ SessionStart hook shows expired trials
- ✅ UserPromptSubmit hook increments counters
- ✅ Counter persists across sessions
- ✅ `/garden:status` command displays current state
- ✅ All hooks use correct paths with `$CLAUDE_PLUGIN_ROOT`

**Time investment:** ~10 minutes

### 4. Review Phase

**Command used:** `/workflows:review`

**Multi-agent code review with:**

- Security review (file permission issues, path traversal risks)
- Performance review (jq operations, file I/O optimization)
- Architecture review (hook design, state management)
- Simplicity review (unnecessary complexity, unclear logic)
- Pattern recognition (anti-patterns, best practices)

**Key findings:**

- Missing error handling in jq operations
- Race conditions in state file updates
- No validation of state file structure
- Hardcoded paths that should be configurable
- Missing documentation for manual setup steps

**Output:** Structured todos in review output, not blocking but documented

**Time investment:** ~5 minutes (automated review)

## Timeline

**Total time: ~60 minutes from plan to reviewed working code**

| Phase      | Duration | Output                           |
| ---------- | -------- | -------------------------------- |
| Planning   | 15 min   | Complete MVP specification       |
| Execution  | 30 min   | Working hooks + command          |
| Validation | 10 min   | Verified all success criteria    |
| Review     | 5 min    | Multi-agent code review complete |

## Concrete Results Achieved

### Working Features

1. **Session-start hook:** Detects expired trials, shows actionable prompt with options
1. **User-prompt-submit hook:** Increments message counters transparently
1. **Status command:** `/garden:status` displays current trial state
1. **Persistence:** State survives session restarts
1. **Multi-trial support:** Multiple plugins tracked simultaneously

### Code Quality

- All scripts executable and tested
- Hooks registered correctly in marketplace.json
- Uses plugin-relative paths (`$CLAUDE_PLUGIN_ROOT`)
- Graceful handling of missing state file
- Clear, emoji-based user feedback

### Documentation

- Complete plan document with specifications
- Out-of-scope items explicitly listed
- Next steps clearly defined
- This workflow retrospective

## Key Success Factors

### 1. Ruthless Scope Management

**What we did:**

- Started with "track message count, show prompt when threshold hit"
- Deferred all enhancements to "next steps after MVP works"
- Listed 5+ features explicitly out of scope

**Impact:** Prevented feature creep, delivered working system in single session

### 2. Clear Plan Document

**What we did:**

- Specified exact file contents (not "create a hook", but "this exact bash script")
- Included testing procedure in plan
- Added success criteria checkboxes

**Impact:** Execution became mechanical, no decisions needed during implementation

### 3. Systematic Execution

**What we did:**

- Used `/workflows:work` to track progress
- Created files in dependency order
- Tested incrementally (didn't wait until "done")

**Impact:** Caught issues early, validated assumptions continuously

### 4. Immediate Validation

**What we did:**

- Created real state file and sent real messages
- Restarted session to verify persistence
- Ran status command to verify display logic

**Impact:** Confidence in working system before moving to review

### 5. Comprehensive Review

**What we did:**

- Used `/workflows:review` for multi-agent analysis
- Got 5 different expert perspectives
- Documented findings as todos (not blocking)

**Impact:** Identified improvements without derailing momentum

## Lessons Learned

### What Worked Well

1. **Plan-first mindset:** 15 minutes of planning saved hours of refactoring
1. **Out-of-scope list:** Prevented "while we're here" feature additions
1. **Exact specifications:** Plan included literal file contents, not descriptions
1. **Testing in plan:** Demo procedure written before implementation
1. **Workflow commands:** `/workflows:work` and `/workflows:review` provided structure

### What We'd Do Differently

1. **Add "testing" section to plan template:** Current plan had testing but not as formal section
1. **Include review checklist in plan:** Could have anticipated some review findings
1. **Document assumptions earlier:** Some path resolution issues could have been caught in plan

### Comparison to Previous Approaches

**Before (overcomplicated setup):**

- Design perfect architecture upfront
- Build for future features immediately
- Long cycles without validation
- Uncertainty about when "done"

**After (MVP methodology):**

- Design minimal working system
- Defer future features explicitly
- Validate continuously
- Clear success criteria define "done"

**Speed improvement:** 10x faster to working, validated code

## Prevention: How to Replicate This Success

### Planning Template

```markdown
# [Feature Name] - MVP

## What we're building
[One sentence describing core functionality]

## The demo
[3-5 steps to manually verify it works]

## Files to create
[Exact specifications with code blocks]

## Testing
[Step-by-step validation procedure]

## Success criteria
- [ ] [Specific, measurable outcome]
- [ ] [Specific, measurable outcome]

## Out of scope
[List what NOT to build in MVP]

## Next steps after MVP works
[Enhancements deferred to v2]
```

### Execution Checklist

- [ ] Create plan document with exact specifications
- [ ] List 3+ items explicitly out of scope
- [ ] Write testing procedure before implementation
- [ ] Use `/workflows:work` to track execution
- [ ] Test incrementally (don't wait for "done")
- [ ] Validate against success criteria
- [ ] Run `/workflows:review` for multi-agent feedback
- [ ] Document findings without derailing momentum

### Decision Framework

**When scoping MVP, ask:**

1. What's the absolute minimum to prove this works?
1. Can a human do this step manually for MVP?
1. What happens if we ship this exact implementation?

**When tempted to add features, ask:**

1. Is this required for MVP success criteria?
1. Can we add this in v2 after validating MVP?
1. Does this complexity help us learn faster?

**When validation feels incomplete, ask:**

1. Can we test this with real usage right now?
1. What's the fastest way to prove this works?
1. What would break if our assumptions are wrong?

## Related Documentation

- **Plan:** `/home/skogix/dev/marketplace/.worktrees/trial-garden-system/plans/plugin-trial-garden-system.md`
- **Commands:** `/workflows:plan`, `/workflows:work`, `/workflows:review`
- **Implementation:** `/home/skogix/dev/marketplace/.worktrees/trial-garden-system/plugins/garden/`

## Next Application

This methodology applies to:

- Any new plugin feature development
- Prototyping agent workflows
- Testing MCP server integrations
- Validating architectural decisions
- Building internal tools

**Core principle:** Build the smallest thing that proves the concept, validate it works, then iterate based on real usage.
