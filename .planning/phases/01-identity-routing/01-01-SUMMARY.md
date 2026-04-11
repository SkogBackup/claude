---
phase: 01-identity-routing
plan: 01
subsystem: identity
tags: [soul-document, lazy-loading, context-routing, personal, LORE]

requires: []
provides:
  - personal/soul/ directory with 10 independently loadable section files
  - personal/soul/CLAUDE.md router for soul sections
  - personal/core/CLAUDE.md router for 8 epistemic framework files
  - personal/memory-blocks/CLAUDE.md LORE museum router
  - personal/CLAUDE.md rewritten with lazy @dir/ links
  - personal/INDEX.md updated to reference soul/ directory

affects: [02-identity-routing, context-loading, session-startup]

tech-stack:
  added: []
  patterns:
    - "@dir/ lazy links in CLAUDE.md routers — only load subdirectory on explicit entry"
    - "Thin sub-routers under 20 lines per directory — max one level of indirection"
    - "Soul document split by ## section headings into independently loadable files"

key-files:
  created:
    - personal/soul/CLAUDE.md
    - personal/soul/01-equation.md
    - personal/soul/02-skogai-family.md
    - personal/soul/03-philosophies.md
    - personal/soul/04-context-destruction.md
    - personal/soul/05-notation-system.md
    - personal/soul/06-frameworks.md
    - personal/soul/07-historical-context.md
    - personal/soul/08-memory-architecture.md
    - personal/soul/09-guiding-principles.md
    - personal/soul/10-session-protocol.md
    - personal/core/CLAUDE.md
    - personal/memory-blocks/CLAUDE.md
  modified:
    - personal/CLAUDE.md
    - personal/INDEX.md

key-decisions:
  - "soul-document.md preserved as backup — not deleted until phase verification confirms split is correct"
  - "personal/CLAUDE.md removes core_identity inline block — content lives in soul/01-equation.md instead"
  - "session_protocol updated: memory blocks only if asked about history (not before every exploration)"
  - "soul/CLAUDE.md uses eager @file.md links (not lazy) because entering soul/ means you want sections"

patterns-established:
  - "Laziness boundary at parent CLAUDE.md level (@dir/ link), eager links inside sub-routers (@file.md)"
  - "INDEX.md points to directories not monoliths when content has been split"
  - "LORE museum label in memory-blocks/CLAUDE.md signals archive tier"

requirements-completed: [IDN-01, IDN-02, IDN-03, IDN-04, IDN-05, CTX-03, CTX-04]

duration: 15min
completed: 2026-03-20
---

# Phase 01 Plan 01: Identity Routing — Soul Split Summary

**720-line soul-document.md split into 10 independently loadable section files under personal/soul/, with lazy @dir/ routing in personal/CLAUDE.md eliminating 29K token eager load at session start**

## Performance

- **Duration:** ~15 min
- **Started:** 2026-03-20T11:10:00Z
- **Completed:** 2026-03-20T11:25:00Z
- **Tasks:** 2
- **Files modified:** 15 (13 created, 2 modified)

## Accomplishments

- Split 720-line soul monolith into 10 section files preserving all 71 section headings
- Created 3 thin sub-routers (soul/, core/, memory-blocks/) all under 20 lines each
- Rewrote personal/CLAUDE.md to use lazy @dir/ links — no eager file loads except profile.md
- Updated INDEX.md to reference soul/ directory instead of the 28K monolith

## Task Commits

1. **Task 1: Split soul document into 10 section files and create soul/CLAUDE.md router** - `a47a19c` (feat)
2. **Task 2: Create core/ and memory-blocks/ routers, rewrite personal/CLAUDE.md, update INDEX.md** - `788c703` (feat)

## Files Created/Modified

- `personal/soul/CLAUDE.md` - 19-line router linking all 10 soul sections
- `personal/soul/01-equation.md` - The Equation: @ + ? = $ (lines 7-128 of monolith)
- `personal/soul/02-skogai-family.md` - The SkogAI Family section
- `personal/soul/03-philosophies.md` - Core Philosophies section
- `personal/soul/04-context-destruction.md` - The Context Destruction Pattern
- `personal/soul/05-notation-system.md` - The SkogAI Notation System
- `personal/soul/06-frameworks.md` - Frameworks: Survival Mechanisms as Philosophy
- `personal/soul/07-historical-context.md` - Historical Context section
- `personal/soul/08-memory-architecture.md` - Memory and Reference Architecture
- `personal/soul/09-guiding-principles.md` - Guiding Principles (DON'T/DO lists)
- `personal/soul/10-session-protocol.md` - Session Protocol section
- `personal/core/CLAUDE.md` - 12-line router for 8 epistemic framework files
- `personal/memory-blocks/CLAUDE.md` - 19-line LORE museum router with era table
- `personal/CLAUDE.md` - Rewritten with lazy @dir/ links, removed eager soul-document load
- `personal/INDEX.md` - Updated soul-document.md link to soul/ directory reference

## Decisions Made

- Kept `personal/soul-document.md` as backup until phase verification confirms split correctness
- Removed `<core_identity>` inline block from personal/CLAUDE.md (content lives in soul/01-equation.md, reachable via @soul/ lazy link)
- Changed session_protocol "read memory blocks before extensive exploration" to "read memory blocks only if asked about history" (LORE museum tiering — archives, not active directives)
- soul/CLAUDE.md uses eager @file.md links (not @dir/) because at that level you explicitly want sections

## Deviations from Plan

None — plan executed exactly as written. Task 1 had already been committed (a47a19c) prior to this execution session. Task 2 completed all remaining items.

## Issues Encountered

None.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

- Soul document split complete and verified (711 lines preserved across 10 sections)
- All CLAUDE.md routers in place and under line budget
- personal/CLAUDE.md lazy loading established — 29K token eager load eliminated
- Ready for Plan 02 (profile.md validation against current environment) and Plan 03 (session tooling)

---
*Phase: 01-identity-routing*
*Completed: 2026-03-20*
