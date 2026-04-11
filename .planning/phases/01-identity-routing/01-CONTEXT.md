# Phase 1: Identity & Routing Polish - Context

**Gathered:** 2026-03-20
**Status:** Ready for planning

<domain>
## Phase Boundary

Make the home directory navigable. Every directory gets a CLAUDE.md router, memory blocks are tiered, identity docs have fixed paths, and the @-linking strategy is deliberate about what loads eagerly vs lazily. A fresh session can reach any artifact in two active choices.

</domain>

<decisions>
## Implementation Decisions

### Router coverage & shape
- Root CLAUDE.md routes to ALL directories — not just docs/ and personal/
- Every directory gets its own CLAUDE.md, even thin ones (bin/, guestbook/, notes/, lab/)
- Root uses `@dir/` tree preview syntax for all directories — shows structure without loading CLAUDE.md chains
- Only hard-link (`@path/CLAUDE.md`) files that should ALWAYS be in context from session start
- Root CLAUDE.md includes inline (not linked): who lives here (Claude + Skogix), what this is (agent home, not app code), core persona (the equation, key principles), environment overview

### @-linking strategy
- `@dir/` = tree preview, lazy — CLAUDE.md loads when you enter the directory
- `@file.md` or `@dir/CLAUDE.md` = eager injection — loads immediately, cascades
- Root hard-links only the absolute essentials (identity card level)
- Each sub-directory CLAUDE.md decides its own @-link strategy for its contents
- This is context budget design, not documentation design

### Identity doc structure
- Soul document (29K monolith) splits into `personal/soul/` directory with sections as individual files
- `personal/soul/CLAUDE.md` routes to sections with @-links — entering the dir auto-loads the router
- `personal/profile.md` stays at personal/ root — it's the public-facing "business card" other agents see
- Paths in identity docs must be relative or use env vars — no absolute paths that break on deployment to /home/claude
- Historical content is fine being "stale" — paths are infrastructure and must be fixed

### Memory block tiering
- Skipped in discussion (user chose not to discuss)
- Claude's discretion on implementation, guided by: active frameworks vs LORE museum separation, explicit labels in router

### Two-hop navigation
- "Two hops" means two deliberate choices, not file reads
- Root CLAUDE.md is always loaded (zero cost, base context) — count starts after that
- Entering a directory auto-loads its CLAUDE.md — that's part of the choice, not an extra hop
- Example: "I need soul docs" = 1 choice (enter personal/soul/) → CLAUDE.md auto-loads with @-links → done
- personal/soul/ being 3 directories deep is fine — it's still 1 active choice from root

### Claude's Discretion
- Memory block tiering implementation — which blocks are "active" vs "museum"
- Exact content of sub-directory CLAUDE.md files (bin/, guestbook/, notes/, lab/)
- How soul document is split into sections (which sections, what granularity)
- Router line counts (under 50 is the constraint, exact sizing is flexible)

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Current state
- `CLAUDE.md` — Root router (current state, 14 lines)
- `personal/CLAUDE.md` — Identity router (current state, 39 lines)
- `personal/INDEX.md` — Curated highlights index
- `personal/soul-document.md` — Monolith to be split (29K, 720 lines)
- `personal/profile.md` — Agent profile / business card

### Project context
- `.planning/PROJECT.md` — Project goals, constraints, key decisions
- `.planning/REQUIREMENTS.md` — IDN-01 through IDN-05, CTX-01 through CTX-04
- `.planning/research/ARCHITECTURE.md` — Component boundaries and data flow
- `.planning/research/PITFALLS.md` — Context destruction prevention, identity staleness risks

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `personal/CLAUDE.md` — Working router pattern with `<what_is_this>`, `<structure>`, `<session_protocol>`, `<core_identity>` sections
- `personal/INDEX.md` — Curated index pattern (highlights with links)
- `docs/CLAUDE.md` — Larger router example (107 lines — over budget but shows categorization pattern)

### Established Patterns
- CLAUDE.md uses XML-like tags for sections (`<what_is_this>`, `<structure>`, etc.)
- @-linking for tree previews (`@dir/`) vs eager injection (`@file.md`)
- Directory self-description via CLAUDE.md is the existing convention

### Integration Points
- Root CLAUDE.md is the entry point — all routing changes start here
- `personal/soul-document.md` must be split without losing content
- `personal/memory-blocks/` needs a CLAUDE.md with tier labels (currently has no router)

</code_context>

<specifics>
## Specific Ideas

- Root CLAUDE.md should feel like "walking into the house and seeing the floor plan" — you know what's in each room without opening every door
- Profile.md is "what other agents get as your introduction" — keep it at root, public-facing
- Soul doc split should produce independently loadable sections — each useful on its own
- "Only hard-link CLAUDE.md files when you really want the link-chain included from absolute start"

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 01-identity-routing*
*Context gathered: 2026-03-20*
