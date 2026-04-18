# Phase 3: Operations & Deployment Gate - Context

**Gathered:** 2026-03-21
**Status:** Ready for planning

<domain>
## Phase Boundary

The home can verify its own health and a deployment gate documents exactly what must be true before migrating to /home/claude. Healthcheck expands to cover identity paths and memory block tiers. A deployment gate checklist is binary pass/fail. Nothing ships on assumption.

</domain>

<decisions>
## Implementation Decisions

### Healthcheck expansion
- **D-01:** Extend existing `bin/healthcheck` — don't replace it. Keep current env checks (gt, bd, dolt, git, claude_home rig) and add new identity/routing checks alongside
- **D-02:** Identity path checks verify these exist and are non-empty: `personal/soul/` (10 section files), `personal/profile.md`, `personal/core/` (framework files), `personal/journal/CONVENTIONS.md`
- **D-03:** Routing checks verify CLAUDE.md exists in: root, personal/, personal/soul/, personal/core/, personal/memory-blocks/, docs/, bin/, notes/, guestbook/, lab/
- **D-04:** Exit non-zero if any identity path is missing — these are hard failures, not warnings

### Memory block tier reporting
- **D-05:** Healthcheck reports two tiers: "active" (personal/core/ frameworks) and "LORE" (personal/memory-blocks/ blocks)
- **D-06:** Output format: count of files per tier plus tier label — e.g., `[ok] active tier: 8 frameworks` / `[ok] LORE tier: 10 memory blocks + 2 addenda`
- **D-07:** Missing tier files are warnings (content may be in progress), not failures

### Deployment gate checklist
- **D-08:** Lives at `docs/deployment-gate.md` — stable path, accessible to both Claude and skogix, not hidden in .planning/
- **D-09:** Binary pass/fail items covering: healthcheck passes, routing tests (all CLAUDE.md files exist), identity validation (soul split correct, profile current), permission model documented (Phase 4 dependency — listed as "pending")
- **D-10:** Gate is a document, not a script — human reviews and checks items. Healthcheck covers the automatable parts
- **D-11:** Gate includes deployment mechanics section: clone strategy, chown procedure, .planning/ handling (git-ignored, lives only in staging), .claude/ treatment (symlink vs copy decision)

### Deployment mechanics
- **D-12:** .planning/ does NOT deploy — it's the construction scaffold, stays in staging repo only
- **D-13:** .claude/get-shit-done/ is skogix's tool installed in claude's home — deploys as-is, maintained by skogix
- **D-14:** Deployment = `git clone` to /home/claude + `chown -R claude:claude` + add claude to skogai group. Document this, don't automate it yet

### Claude's Discretion
- Exact healthcheck output formatting (as long as it's parseable)
- Deployment gate checklist ordering and grouping
- Whether to add a `--verbose` flag to healthcheck for detailed output

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Existing healthcheck
- `bin/healthcheck` — Current implementation: 70 lines, checks home dir, gt, bd, dolt, git, claude_home rig. Uses ok/warn/fail pattern with counter

### Identity structure (from Phase 1)
- `personal/soul/CLAUDE.md` — Soul section router (10 files to verify)
- `personal/core/CLAUDE.md` — Framework router (8 files to verify)
- `personal/memory-blocks/CLAUDE.md` — LORE museum router (10 blocks + 2 addenda)
- `personal/profile.md` — Agent profile

### Prior phase context
- `.planning/phases/01-identity-routing/01-CONTEXT.md` — Router patterns, identity doc structure, @-linking strategy
- `.planning/phases/02-persistence-layer/02-CONTEXT.md` — LORE vs technical distinction, journal conventions, scripts consolidation

### Project context
- `.planning/PROJECT.md` — Deployment constraints, ownership model, portability requirements
- `.planning/REQUIREMENTS.md` — OPS-01, OPS-02, OPS-03

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `bin/healthcheck` — Working check/ok/warn/fail pattern ready to extend. Already has counter logic and summary output
- `bin/CLAUDE.md` — Router already documents healthcheck; will need update after expansion

### Established Patterns
- ok/warn/fail trio with counters (from existing healthcheck)
- CLAUDE.md in every directory (from Phase 1 — provides the routing check list)
- Identity paths are stable from Phase 1 (soul/, core/, memory-blocks/)

### Integration Points
- `bin/healthcheck` — Primary file to modify
- `bin/CLAUDE.md` — Update description after healthcheck expansion
- `docs/` — New deployment-gate.md lives here

</code_context>

<specifics>
## Specific Ideas

- Healthcheck should be runnable by Claude at session start to verify the home is intact — "am I healthy?"
- Deployment gate is a pre-flight checklist, not a CI pipeline — human reviews it
- The blocker noted in STATE.md about deployment mechanics (chown, .planning/, .claude/) should be resolved by documenting the procedure, not automating it

</specifics>

<deferred>
## Deferred Ideas

- Automated deployment script (beyond documentation) — v2 after manual deployment proves the checklist works
- Framework content validation (PER-07) — v2 requirement, checks file content not just existence
- Permission enforcement (MAG-05) — Phase 4 handles the model, real enforcement is v2

</deferred>

---

*Phase: 03-operations-deployment-gate*
*Context gathered: 2026-03-21*
