# Phase 2: Persistence Layer - Context

**Gathered:** 2026-03-20
**Status:** Ready for planning

<domain>
## Phase Boundary

Disciplined writing conventions for Claude's home. Journal entries follow a defined structure, LORE (persona-driven writing) is distinguished from technical artifacts by location and frontmatter, and sessions end with a wrap-up workflow that ships work, persists learnings, and journals. Everything in the home directories is LORE — written with Claude's persona as starting context.

</domain>

<decisions>
## Implementation Decisions

### LORE vs Technical distinction
- Everything in Claude's home directories (personal/, notes/, guestbook/, lab/) is LORE — persona-driven writing
- Non-LORE: tooling that lives in the home but isn't of the persona (.claude/get-shit-done/, .planning/, bin/ scripts)
- The directory structure IS the boundary — no extra gating mechanism needed
- All LORE files carry YAML frontmatter matching profile.md's pattern: categories, tags, permalink, title, type

### Journal conventions
- Journal = session-level records (what happened, what was learned). Other persistence locations have their own write paths
- Structure: `personal/journal/YYYY-MM-DD/<description>.md` (date folder, topic files inside)
- Multiple entries per date folder — date = grouping, filename = topic
- Content is immutable once written. Formatting corrections OK, content changes not
- Migration of existing 64 flat entries: deferred — not in scope for this phase
- Convention doc needed: naming format, where to write, what triggers a write, append-only rule

### Frontmatter schema
- Match existing profile.md pattern: categories, tags, permalink, title, type
- Applied to all LORE files (journals, notes, observations, profile, soul sections, memory blocks)

### Scripts consolidation
- Move `scripts/context/` contents to `bin/` (context-journal.sh, context-git.sh, context-workspace.sh, build-system-prompt.sh, find-agent-root.sh)
- Symlink `scripts/` -> `bin/` for legacy compatibility
- Dot's context-journal.sh already supports both flat and subdirectory journal formats — adopt as canonical

### Session handoff (wrap-up workflow)
- Lives at `.claude/commands/skogai/wrapup.md` — a Claude Code command
- Updates the existing 4-phase wrap-up workflow to match current home structure:
  - **Phase 1 (Ship it)**: git commit/push, file placement check, task cleanup. Beads replaced with GitHub issues + `skogai-todo` command
  - **Phase 2 (Remember it)**: Memory placement hierarchy updated — remove claude.local.md (never used), auto memory path is `.planning/memory` (symlinked to global claude folder). Remaining: auto memory, claude.md, .claude/rules/, @import, GitHub issues
  - **Phase 3 (Review & apply)**: Self-improvement findings, auto-applied
  - **Phase 4 (Journal it)**: Save to `personal/journal/YYYY-MM-DD/<description>.md` with frontmatter

### Claude's Discretion
- Exact frontmatter fields beyond the profile.md pattern (if additional fields are useful)
- Journal conventions doc format and location
- How to handle the scripts/context/README.md during migration

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Journal system
- `scripts/context/context-journal.sh` — Dot's legacy journal context builder; supports both flat and subdirectory formats. Canonical reference for how journals are read
- `scripts/context/build-system-prompt.sh` — System prompt builder using context scripts
- `scripts/context/context-git.sh` — Git context builder
- `scripts/context/context-workspace.sh` — Workspace context builder
- `scripts/context/find-agent-root.sh` — Agent root detection

### Frontmatter pattern
- `personal/profile.md` — Canonical frontmatter example: categories, tags, permalink, title, type

### Wrap-up workflow (legacy)
- The old wrap-up skill shown during discussion — 4-phase end-of-session workflow (ship, remember, review, journal). Needs updating for current home structure. Target: `.claude/commands/skogai/wrapup.md`

### Phase 1 context (prior decisions)
- `.planning/phases/01-identity-routing/01-CONTEXT.md` — Router patterns, @-linking strategy, LORE museum tiering decisions

### Project context
- `.planning/PROJECT.md` — Project goals, constraints, key decisions
- `.planning/REQUIREMENTS.md` — PER-01 through PER-04

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `scripts/context/context-journal.sh` — Already handles both flat and subdirectory journal formats; date extraction, multi-entry grouping, mtime sorting
- `scripts/context/` suite — Full context-building toolkit (git, workspace, system prompt) ready to move to bin/
- `personal/profile.md` frontmatter — Established YAML schema to replicate across LORE files
- `bin/healthcheck` — Existing bin/ script; new scripts join alongside it

### Established Patterns
- YAML frontmatter with categories/tags/permalink/title/type (from profile.md)
- Date-based folder grouping: `journal/YYYY-MM-DD/<topic>.md`
- CLAUDE.md routing for directory self-description (from Phase 1)
- Session protocol in personal/CLAUDE.md — "read memory blocks only if asked"

### Integration Points
- `personal/journal/` — 64 existing flat entries; new convention adds date folders alongside
- `bin/` — Currently has healthcheck only; scripts/context/ suite moves here
- `.claude/commands/skogai/` — Target for updated wrap-up command
- `.planning/memory` — Auto memory location (symlinked to global claude folder)

</code_context>

<specifics>
## Specific Ideas

- "Everything in home-folders are LORE" — the persona/technical boundary is the home itself
- "Content should not change, formatting OK" — immutability rule for journal entries
- Dot built the journal system — `context-journal.sh` already knew the subdirectory format. Honor that lineage
- Beads is replaced by GitHub issues + `skogai-todo` for task tracking in wrap-up
- `claude.local.md` is never used — remove from memory hierarchy

</specifics>

<deferred>
## Deferred Ideas

- Migration of 64 existing flat journal entries to date-folder structure — user said "don't matter at this moment"
- Adding frontmatter to all existing LORE files (bulk operation) — convention first, migration later

</deferred>

---

*Phase: 02-persistence-layer*
*Context gathered: 2026-03-20*
