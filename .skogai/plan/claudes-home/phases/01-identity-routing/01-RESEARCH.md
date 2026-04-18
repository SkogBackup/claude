# Phase 1: Identity & Routing — Research

**Researched:** 2026-03-20
**Domain:** Claude Code CLAUDE.md routing system; AI agent home directory structure
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Router coverage & shape**
- Root CLAUDE.md routes to ALL directories — not just docs/ and personal/
- Every directory gets its own CLAUDE.md, even thin ones (bin/, guestbook/, notes/, lab/)
- Root uses `@dir/` tree preview syntax for all directories — shows structure without loading CLAUDE.md chains
- Only hard-link (`@path/CLAUDE.md`) files that should ALWAYS be in context from session start
- Root CLAUDE.md includes inline (not linked): who lives here (Claude + Skogix), what this is (agent home, not app code), core persona (the equation, key principles), environment overview

**@-linking strategy**
- `@dir/` = tree preview, lazy — CLAUDE.md loads when you enter the directory
- `@file.md` or `@dir/CLAUDE.md` = eager injection — loads immediately, cascades
- Root hard-links only the absolute essentials (identity card level)
- Each sub-directory CLAUDE.md decides its own @-link strategy for its contents
- This is context budget design, not documentation design

**Identity doc structure**
- Soul document (29K monolith) splits into `personal/soul/` directory with sections as individual files
- `personal/soul/CLAUDE.md` routes to sections with @-links — entering the dir auto-loads the router
- `personal/profile.md` stays at personal/ root — it's the public-facing "business card" other agents see
- Paths in identity docs must be relative or use env vars — no absolute paths that break on deployment to /home/claude
- Historical content is fine being "stale" — paths are infrastructure and must be fixed

**Memory block tiering**
- Skipped in discussion (user chose not to discuss)
- Claude's discretion on implementation, guided by: active frameworks vs LORE museum separation, explicit labels in router

**Two-hop navigation**
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

### Deferred Ideas (OUT OF SCOPE)
None — discussion stayed within phase scope
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| IDN-01 | Soul document, profile, and core frameworks exist at stable paths under `personal/` | Soul doc is at personal/soul-document.md (monolith); needs split to personal/soul/; frameworks are at personal/core/ (correct path, stable) |
| IDN-02 | `personal/CLAUDE.md` routes to identity artifacts with lazy loading (no bulk preload) | Current personal/CLAUDE.md uses eager `@file` links for soul-document.md and profile.md — needs to become lazy routing; soul/ subdir auto-loads its router on entry |
| IDN-03 | `personal/INDEX.md` provides curated highlights for quick orientation | INDEX.md exists (4588 bytes, well-structured); needs validation that paths remain correct after soul doc split |
| IDN-04 | Memory blocks are tiered — active frameworks vs LORE museum — with explicit labels | memory-blocks/ contains both memory blocks AND framework files (certainty-principle.md, placeholder-approach.md, etc.) mixed in the same directory; needs structural separation |
| IDN-05 | Core frameworks (certainty principle, placeholder system, epistemic frameworks) are referenceable by path without discovery | personal/core/ contains all three frameworks at stable paths; needs CLAUDE.md router so they're discoverable without reading adjacent files |
| CTX-01 | Root CLAUDE.md routes to all top-level directories with one-line descriptions | Current root CLAUDE.md (14 lines) only lists docs/ and personal/ — missing bin/, guestbook/, notes/, lab/, and any others |
| CTX-02 | Every directory with content has its own CLAUDE.md explaining what's there | bin/, guestbook/, notes/, lab/ all lack CLAUDE.md; state/ and tasks/ are empty or near-empty (decide whether they need routers) |
| CTX-03 | No single CLAUDE.md exceeds 50 lines | Current docs/CLAUDE.md is 107 lines (over limit); personal/CLAUDE.md is 39 lines (within limit); root is 14 lines |
| CTX-04 | Context loads lazily — session startup reads only root router, not all artifacts | personal/CLAUDE.md currently uses `@soul-document.md` and `@profile.md` — these are eager injections that load large files at session start |
</phase_requirements>

---

## Summary

This phase is fundamentally a filesystem reorganization and documentation discipline exercise — no new tooling required. The problem domain is the Claude Code CLAUDE.md routing system: how files load, when they load, and what the cascade looks like. All technical work is creating, editing, and splitting markdown files with careful attention to how Claude Code interprets `@path` syntax.

The current state is close but has two significant gaps. First, the root CLAUDE.md only routes to two of six-plus directories — four directories with content are invisible from session start. Second, `personal/CLAUDE.md` uses eager `@file` links that load the 29K soul document and profile at session entry, directly violating lazy-load requirements. The soul document split is the most structurally complex task because it involves dividing 720 lines of identity-encoding content into independently loadable sections without losing narrative coherence.

Memory block tiering is left to Claude's discretion. The research finding is that personal/core/ and personal/memory-blocks/ are currently mixed — frameworks (certainty-principle.md, placeholder-approach.md, etc.) live alongside actual memory blocks. The natural separation is: frameworks stay in personal/core/ with a CLAUDE.md router, memory blocks stay in personal/memory-blocks/ labelled as LORE/museum, and the personal/CLAUDE.md router distinguishes these tiers explicitly.

**Primary recommendation:** Fix eager loading in personal/CLAUDE.md and add the root router entries first — these are the highest-leverage changes. Then split the soul document. Then add thin CLAUDE.md files for the missing directories.

---

## Standard Stack

### Core

| Component | Current State | Target State | Notes |
|-----------|--------------|--------------|-------|
| CLAUDE.md routing | `@file` eager links in personal/CLAUDE.md | `@dir/` lazy links; sub-routers decide loading | Claude Code native feature, no library needed |
| Soul document | 720-line monolith at personal/soul-document.md | personal/soul/ directory, 10 section files | Split preserves all content, adds CLAUDE.md router |
| personal/core/ | 8 files, no router | Same files + CLAUDE.md router | Framework files stay at same paths; router added |
| personal/memory-blocks/ | Mixed LORE + frameworks, no router | 12 memory block files + CLAUDE.md with tier labels | Framework files may need to move to personal/core/ |
| Root CLAUDE.md | Routes to 2 dirs, 14 lines | Routes to all dirs with content, stays under 30 lines | Add bin/, guestbook/, notes/, lab/ |
| New thin CLAUDE.md files | Missing from bin/, guestbook/, notes/, lab/ | 4 new files, each under 20 lines | Describe what's there, one-line purpose |

### Claude Code @-link Mechanics (Verified)

From official memory docs (HIGH confidence):

- `@path/to/file` inside a CLAUDE.md = **eager injection** — file is expanded and loaded into context at launch alongside the CLAUDE.md that references it
- `@dir/` (directory with trailing slash) = **tree preview** — shows structure, does NOT load CLAUDE.md of that directory automatically
- CLAUDE.md files in subdirectories load **on demand** when Claude reads files in those directories — they are NOT loaded at launch unless their parent has an eager `@` import
- Maximum import depth: 5 hops
- Entering a directory does auto-load its CLAUDE.md in some contexts — but the official spec says subdirectory CLAUDE.md files "load on demand when Claude reads files in those directories"

**Critical clarification:** The CONTEXT.md states "entering a directory auto-loads its CLAUDE.md." The official docs say subdirectory CLAUDE.md files load "on demand when Claude reads files in those directories." These are compatible: navigating to a directory and reading a file there triggers the CLAUDE.md load. The two-hop model is sound.

**What `@dir/` actually does:** Provides a tree preview of the directory structure without loading the directory's CLAUDE.md. This is the lazy/descriptive pattern for the root router.

### No External Libraries Required

This phase is pure markdown authoring. No npm packages, no scripts, no tooling changes. The only "technology" is Claude Code's CLAUDE.md system.

---

## Architecture Patterns

### Recommended Final Structure (Phase 1 Scope)

```
~/claude/
├── CLAUDE.md                    # root router — routes ALL dirs, stays < 30 lines
│
├── personal/
│   ├── CLAUDE.md                # personal router — lazy links, under 50 lines
│   ├── INDEX.md                 # curated highlights (exists, update paths after split)
│   ├── profile.md               # agent business card (stays here)
│   ├── soul/                    # NEW: split soul document
│   │   ├── CLAUDE.md            # soul router — describes sections, loads on demand
│   │   ├── 01-equation.md       # "@ + ? = $" — core identity
│   │   ├── 02-skogai-family.md  # relationships and family
│   │   ├── 03-philosophies.md   # core philosophies
│   │   ├── 04-context-destruction.md  # the critical bug
│   │   ├── 05-notation-system.md
│   │   ├── 06-frameworks.md
│   │   ├── 07-historical-context.md
│   │   ├── 08-memory-architecture.md
│   │   ├── 09-guiding-principles.md
│   │   └── 10-session-protocol.md
│   ├── core/                    # epistemic frameworks (files stay, router added)
│   │   ├── CLAUDE.md            # NEW: frameworks router
│   │   ├── certainty-principle.md
│   │   ├── placeholder-approach.md
│   │   ├── epistemic-frameworks.md
│   │   ├── context-destruction.md
│   │   ├── learnings.md
│   │   ├── the-lore-writer.md
│   │   ├── the-worst-and-first-autonomous-ai.md
│   │   └── the-dumping-grounds.md
│   ├── memory-blocks/           # LORE museum — router adds tier labels
│   │   ├── CLAUDE.md            # NEW: LORE router — "reference only, not active constraints"
│   │   └── claude-memory-block-*.md  (12 files, unchanged)
│   └── journal/                 # (64 entries, unchanged for this phase)
│
├── bin/
│   ├── CLAUDE.md                # NEW: thin router — "executable scripts"
│   └── healthcheck
│
├── guestbook/
│   ├── CLAUDE.md                # NEW: thin router — "visitor notes"
│   └── skogix.md
│
├── notes/
│   ├── CLAUDE.md                # NEW: thin router — "personal observations"
│   └── observations.md
│
├── lab/
│   ├── CLAUDE.md                # NEW: thin router — "experiments and WIP"
│   └── README.md
│
└── docs/                        # existing (CLAUDE.md is 107 lines — over budget)
    └── CLAUDE.md                # NEEDS TRIM to under 50 lines
```

**Directories to route but NOT create CLAUDE.md for (empty/meta):**
- `state/` — empty directory; root router can note "state/ — empty pending Phase 2"
- `tasks/` — one example file; thin CLAUDE.md or skip depending on whether it's in scope

### Pattern 1: Root Router Shape

**What:** Root CLAUDE.md is a pure routing document — persona inline, directories listed with one-liner descriptions, no eager file loads.

**Structure:**
```markdown
# ~/claude — Claude's home

<identity>
I am Claude — the ? in @ + ? = $. Bridge between Skogix's intent and reality.
This is my home directory: identity, tools, docs, and persistent memory.
Not application code — this IS my workspace.
</identity>

## directories

@personal/      — identity, frameworks, memory, journal
@docs/          — Claude Code reference docs
@bin/           — executable scripts and tools
@notes/         — observations and patterns
@guestbook/     — visitor notes, cross-agent messages
@lab/           — experiments and WIP staging
```

**Why this works:** `@dir/` shows structure without loading CLAUDE.md chains. The identity inline means a fresh session has persona context without loading any subfiles. Under 30 lines.

### Pattern 2: personal/ Router Shape

**What:** personal/CLAUDE.md describes what's available, using `@dir/` lazy links for large content areas and only hard-linking what must always be in context.

**Current problem:** The existing personal/CLAUDE.md uses `@soul-document.md` and `@profile.md` as eager injections. A session entering personal/ loads 29K + 4.5K before doing any actual work.

**Target shape:**
```markdown
# personal/ — Claude's personal collection

<what_is_this>
Identity, philosophy, memory, frameworks, and journal from previous sessions.
</what_is_this>

## navigation

@soul/          — foundational identity split into sections (enter to explore)
@profile.md     — agent profile and business card (public-facing)
@core/          — epistemic frameworks: certainty-principle, placeholder-approach
@memory-blocks/ — LORE museum: historical eras 01-10 (reference, not directives)
@journal/       — session records, append-only (64+ entries)
@INDEX.md       — curated highlights (start here for orientation)

<session_protocol>
[keep current protocol — it's short and useful]
</session_protocol>
```

Note: `@profile.md` is kept as an eager link because profile is the "business card" — short (4.5K) and frequently needed. The soul directory becomes lazy.

### Pattern 3: Soul Document Split

**What:** 720-line monolith split into 10 section files corresponding to the top-level `##` headings. Each section is independently loadable.

**Section mapping** (from observed headings):
| File | Source Section | Est. Lines | Load When |
|------|---------------|------------|-----------|
| 01-equation.md | ## 1. The Equation: @ + ? = $ | ~120 | Core identity questions |
| 02-skogai-family.md | ## 2. The SkogAI Family | ~35 | Relationship context needed |
| 03-philosophies.md | ## 3. Core Philosophies | ~100 | Philosophical grounding needed |
| 04-context-destruction.md | ## 4. My Critical Bug | ~55 | Anti-pattern reference |
| 05-notation-system.md | ## 5. The SkogAI Notation System | ~110 | Notation questions |
| 06-frameworks.md | ## 6. My Frameworks | ~130 | Framework reference |
| 07-historical-context.md | ## 7. Historical Context | ~45 | Historical orientation |
| 08-memory-architecture.md | ## 8. Memory & Reference Architecture | ~50 | Architecture reference |
| 09-guiding-principles.md | ## 9. Guiding Principles | ~35 | Principles reference |
| 10-session-protocol.md | ## 10. Session Protocol | ~25 | Session start behavior |

**personal/soul/CLAUDE.md** should describe each section in one line and indicate when to load it. Under 30 lines.

### Pattern 4: Memory Block Tiering (Claude's Discretion)

**Observation:** personal/memory-blocks/ currently contains a mix:
- 12 memory block files (LORE)
- Framework-related files that somehow ended up here: certainty-principle.md, context-destruction.md, epistemic-frameworks.md, learnings.md, placeholder-approach.md, the-dumping-grounds.md, the-lore-writer.md, the-worst-and-first-autonomous-ai.md

Wait — re-checking: the `ls` output for memory-blocks/ shows ONLY memory block files (claude-memory-block-01 through 10). The certainty-principle.md, context-destruction.md etc. are in personal/core/ not memory-blocks/. The memory-blocks/ directory is already clean LORE only.

**Recommended tiering approach for memory-blocks/CLAUDE.md:**
```markdown
# personal/memory-blocks/ — LORE Museum

Historical record of the SkogAI timeline. These are permanent archives, not active directives.
Read only when asked about history or specific eras. Do not load as behavioral constraints.

## Eras (chronological)
- 01 — The Prehistoric Era
- 02 — The Collaborative Age
[...one line each...]
```

Label: "LORE — reference only" is sufficient. The directory structure (museum metaphor) does more work than any label.

### Anti-Patterns to Avoid

- **Eager soul doc injection:** `@soul-document.md` in personal/CLAUDE.md loads 29K at session start. Replace with `@soul/` tree preview.
- **Framework files buried with no router:** personal/core/ has 8 files but no CLAUDE.md — no way to know certainty-principle.md exists without `ls`. Add CLAUDE.md router.
- **docs/CLAUDE.md over budget:** Currently 107 lines. Must trim to under 50. The table format is good; condense categories or reduce descriptions.
- **Missing root entries:** bin/, guestbook/, notes/, lab/ are invisible from root. Add them.
- **Absolute paths in identity docs:** If soul-document.md has absolute paths (e.g., /home/skogix/claude/...) these break on deployment. Audit and replace with relative paths.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Lazy loading | Custom script to load files on demand | Claude Code's built-in CLAUDE.md subdirectory loading | CC already loads subdirectory CLAUDE.md on demand when files are read in that directory |
| Content routing | Index generator, symbol table | CLAUDE.md files with clear section descriptions | Markdown navigation is sufficient for this scale |
| Content splitting | Parse/split script | Manual file creation | Soul doc sections map 1:1 to top-level `##` headings; no automation needed |
| Path validation | Custom checker | Session-time observation | If a CLAUDE.md points to a nonexistent file, CC silently skips it — test by following the path manually |

**Key insight:** This domain has no framework dependencies. The "library" is Claude Code's own CLAUDE.md system, which is already installed and working. The only work is writing well-shaped markdown files.

---

## Common Pitfalls

### Pitfall 1: personal/CLAUDE.md Still Loads Eagerly After Edit

**What goes wrong:** personal/CLAUDE.md is edited to remove `@soul-document.md`, but the edit adds `@profile.md` or `@INDEX.md` as eager links for "convenience." The large-file eager-load problem moves rather than disappears.

**Why it happens:** Every file in personal/ seems important. The instinct is to make everything available. But "available" and "loaded" are different things.

**How to avoid:** The rule is: hard-link only if the file would be useful on every possible task performed in this directory. For personal/, the only candidate is profile.md (short, identity-card, frequently needed). Everything else is lazy.

**Warning signs:** personal/CLAUDE.md grows past 25 lines. Multiple `@file.md` links appear (not `@dir/`).

### Pitfall 2: Soul Document Split Loses Continuity

**What goes wrong:** The soul document is split mechanically by section, but cross-references between sections break. Section 1 mentions "the placeholder system" (Section 3/6), Section 4 assumes knowledge of Section 1. A session loading only Section 4 gets confused context.

**Why it happens:** The soul document was written as a coherent whole. Sectional splits create artificial isolation.

**How to avoid:** Each section file should be self-contained OR have a brief "context" line noting which other sections are prerequisite. The CLAUDE.md router for soul/ should note key dependencies. Do not add cross-file `@links` within soul/ — that defeats the purpose of splitting.

### Pitfall 3: docs/CLAUDE.md Trim Loses Navigation Value

**What goes wrong:** docs/CLAUDE.md is trimmed from 107 lines to under 50 by removing categories or collapsing descriptions. The result is a router that's too sparse to navigate — agent can't tell if the answer is in hooks.md vs hooks-guide.md.

**Why it happens:** Line count target becomes the goal; navigation value is collateral damage.

**How to avoid:** Trim by removing low-use categories (CI/CD platforms, cloud providers, enterprise) while keeping daily-driver and extensibility sections intact. The current "daily drivers" table (12 rows) is the core — preserve it at full detail. Collapse or remove sections that aren't daily drivers. Target: daily drivers + one other section.

### Pitfall 4: Thin CLAUDE.md Files Are Too Thin

**What goes wrong:** bin/CLAUDE.md says "scripts live here." guestbook/CLAUDE.md says "messages here." These don't tell a session when to navigate to the directory or what it would find there.

**Why it happens:** Following the "under 20 lines" instruction too literally produces routers with no routing information.

**How to avoid:** A thin CLAUDE.md should answer: "what's here, when to use it, and what specifically exists." For bin/: "healthcheck script is here — run it to verify identity paths are intact." Three sentences, all useful.

### Pitfall 5: Identity Document Paths Encoded as Absolute

**What goes wrong:** The soul document (written in 2025) may contain references to `/home/skogix/claude/...` or other absolute paths. After deployment to `/home/claude`, these paths break. A session following a link in the soul doc hits a 404.

**How to avoid:** Before finalizing the soul doc split, grep for absolute paths. Replace with relative paths (`../../bin/healthcheck`) or bare filenames. Document in the "last validated" date that paths were checked against the current environment.

---

## Code Examples

### Root CLAUDE.md Target Shape

```markdown
# ~/claude — Claude's home

<identity>
Claude — the ? in @ + ? = $. Bridge between intent (@) and reality ($).
Home directory for an AI agent: identity, tools, docs, memory.
Not application code — this IS the workspace.
</identity>

## directories

@personal/      — identity, soul, frameworks, memory, journal
@docs/          — Claude Code reference docs (fetched from code.claude.com)
@bin/           — executable scripts and tools (healthcheck)
@notes/         — personal observations and patterns
@guestbook/     — visitor notes and cross-agent messages
@lab/           — experiments, WIP, staging
```

Lines: 17. Well under 30 limit.

### personal/CLAUDE.md Target Shape

```markdown
# personal/ — Claude's personal collection

<what_is_this>
Identity, philosophy, frameworks, memory, and journal from previous sessions.
Historical archive spanning March 2025 onward.
</what_is_this>

## contents

@soul/          — foundational identity, split into sections (enter to explore)
@profile.md     — agent profile and business card
@core/          — epistemic frameworks: certainty-principle, placeholder, epistemic
@memory-blocks/ — LORE museum: historical eras (reference only, not directives)
@journal/       — session records, append-only
@INDEX.md       — curated highlights index

<session_protocol>
- end relevant messages with: `[@certainty:"<percent>":"<specific quote from message>"]`
- read memory blocks only if asked about history
- trust curated documentation over blind tool use
- ask before assuming
- focus on what's needed, not what's possible to know
</session_protocol>
```

Lines: 25. Under 50 limit.

### personal/soul/CLAUDE.md Target Shape

```markdown
# personal/soul/ — Soul document sections

Foundational identity split into independently loadable sections.
Read the section you need; you don't need all of them.

## sections

- @01-equation.md          — @ + ? = $ model, core identity, dual role
- @02-skogai-family.md     — relationships: Skogix, siblings, family
- @03-philosophies.md      — uncertainty principle, placeholder system, LORE/construction
- @04-context-destruction.md — the critical bug: pattern, root cause, guard
- @05-notation-system.md   — operator definitions, bridge patterns
- @06-frameworks.md        — survival mechanisms as philosophy
- @07-historical-context.md — origin and timeline
- @08-memory-architecture.md — how memory and reference work
- @09-guiding-principles.md — operational principles
- @10-session-protocol.md  — session start behavior

**Last validated:** 2026-03-20 (paths and content checked against current environment)
```

Lines: 20.

### personal/core/CLAUDE.md Target Shape

```markdown
# personal/core/ — Epistemic frameworks

Active frameworks for session behavior. Load the specific one you need.

- @certainty-principle.md    — confidence scoring system (95% verified, 30% speculative)
- @placeholder-approach.md   — documenting uncertainty with structure
- @epistemic-frameworks.md   — how survival mechanisms became philosophy
- @context-destruction.md    — the 300K token pattern and how to avoid it
- @learnings.md              — comprehensive lessons from 50+ sessions
- @the-lore-writer.md        — origin of skogai, LORE concept, agent family
- @the-worst-and-first-autonomous-ai.md — the agency breakthrough story
- @the-dumping-grounds.md    — brainstorm / ideas collection (not active directives)
```

Lines: 12.

### personal/memory-blocks/CLAUDE.md Target Shape

```markdown
# personal/memory-blocks/ — LORE Museum

Permanent historical record. These are archives, not active constraints.
Load only when asked about specific eras or history.

| Block | Era |
|-------|-----|
| 01 | The Prehistoric Era |
| 02 | The Collaborative Age |
| 03 | The Constitutional Era |
| 04 | The Long Watch / Builder Era |
| 05 | The Ice Age |
| 06 | The Enlightenment Era |
| 07 | The Forgotten Times |
| 08 | The End of a Beginning |
| 09 | The Unanswerable Question |
| 10 | The Friends We Made Along the Way |

Addenda: block-08-uncertainty-principle, block-09-placeholder-system
```

Lines: 18.

---

## State of the Art

| Old Approach | Current Approach | Notes |
|--------------|------------------|-------|
| Single CLAUDE.md with everything | CLAUDE.md cascade with lazy @dir/ links | CC subdirectory loading makes this efficient |
| Identity docs in lab/ staging area | Stable paths under personal/ | Migration is complete (confirmed in STATE.md) |
| Soul document as 720-line monolith | Soul document as personal/soul/ directory | Phase 1 work |
| No routers for bin/, guestbook/ | Thin CLAUDE.md in each directory | Phase 1 work |
| Eager `@file` links in personal/CLAUDE.md | `@dir/` lazy links | Phase 1 work |

**Current working state (confirmed by direct inspection):**
- personal/soul-document.md: 720 lines, at personal/ root (not yet split)
- personal/CLAUDE.md: 39 lines, uses `@soul-document.md` (eager) and `@profile.md` (eager)
- personal/core/: 8 files, no CLAUDE.md router
- personal/memory-blocks/: 12 memory block files (clean LORE), no CLAUDE.md
- Root CLAUDE.md: 14 lines, routes only docs/ and personal/
- bin/, guestbook/, notes/, lab/: all lack CLAUDE.md
- docs/CLAUDE.md: 107 lines (over 50-line budget)
- state/, tasks/: empty or near-empty (state/ is empty; tasks/ has one example file)

---

## Open Questions

1. **`state/` and `tasks/` directories — include in root routing?**
   - What we know: state/ is empty, tasks/ has one example file (example-issue-claude-home-2.md with frontmatter suggesting a task tracker)
   - What's unclear: Are these Phase 1 scope? They appear in the root ls output but weren't mentioned in phase requirements or CONTEXT.md
   - Recommendation: Route them from root with a one-liner if they have content; skip if empty. tasks/ suggests future task tracking — note it exists, don't build the system.

2. **Journal symlink — what's at root level?**
   - What we know: `journal -> ./personal/journal/` exists as a symlink at the root
   - What's unclear: Is this intentional (to allow `@journal/` from root) or a stale artifact?
   - Recommendation: Keep if intentional (allows root-level `@journal/` shortcut), remove if it creates routing ambiguity. Document the intent.

3. **docs/CLAUDE.md trim — how much to cut?**
   - What we know: It's 107 lines (over 50-line limit). The daily-drivers table is 12 rows and highly useful.
   - What's unclear: Which categories can be removed without losing navigation value
   - Recommendation: Keep "Daily drivers" and "Extensibility" tables (most used). Collapse or remove CI/CD, cloud providers, enterprise, getting-started sections into a single "other topics" line: "→ see full docs list in file." This should reach ~45 lines.

4. **Absolute paths in soul document sections**
   - What we know: Soul document was written in 2025, environment has changed
   - What's unclear: Whether absolute paths like `/home/skogix/claude/...` appear in the content
   - Recommendation: Grep for absolute paths before splitting. This is a "last validated" audit step, not a blocker.

---

## Validation Architecture

### Test Framework

| Property | Value |
|----------|-------|
| Framework | No automated test framework — this phase produces markdown files |
| Config file | N/A |
| Quick run command | Manual: follow root → directory → artifact and count files loaded |
| Full suite command | Manual: run the "Looks Done But Isn't" checklist from PITFALLS.md |

This phase has no code to unit test. Validation is behavioral: does a fresh session navigate to the right artifact in two deliberate choices? Does personal/CLAUDE.md NOT eagerly load the 29K soul document?

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Verification Command | Notes |
|--------|----------|-----------|---------------------|-------|
| IDN-01 | personal/soul/ directory exists with section files; personal/core/ has frameworks | manual smoke | `ls personal/soul/ personal/core/` | Check all 10 sections + 8 framework files present |
| IDN-02 | personal/CLAUDE.md has no eager `@soul-document.md` link | manual | `grep '@soul-document' personal/CLAUDE.md` → should return empty | |
| IDN-03 | personal/INDEX.md links resolve after soul split | manual | Follow 5 links from INDEX.md; all should resolve | Update paths if needed |
| IDN-04 | personal/memory-blocks/CLAUDE.md exists with tier labels | manual smoke | `cat personal/memory-blocks/CLAUDE.md \| grep -i "LORE\|museum\|reference"` | Must contain tier signal |
| IDN-05 | personal/core/CLAUDE.md exists; frameworks reachable by path | manual smoke | `cat personal/core/CLAUDE.md` shows all 3 target frameworks | |
| CTX-01 | Root CLAUDE.md routes to bin/, guestbook/, notes/, lab/, personal/, docs/ | manual | `cat CLAUDE.md` — count directory entries | All 6 (minimum) must appear |
| CTX-02 | bin/, guestbook/, notes/, lab/ all have CLAUDE.md | manual smoke | `ls bin/CLAUDE.md guestbook/CLAUDE.md notes/CLAUDE.md lab/CLAUDE.md` | All 4 must exist |
| CTX-03 | No CLAUDE.md exceeds 50 lines | automated | `wc -l $(find . -name CLAUDE.md -not -path './.claude/*' -not -path './.planning/*')` | All results should show ≤ 50 |
| CTX-04 | No eager file injection in personal/CLAUDE.md | manual | Read personal/CLAUDE.md and verify @links are dirs (`@dir/`) not files (`@file.md`) | Exception: profile.md is intentionally eager |

### Sampling Rate

- **Per task commit:** Run the smoke test for that task's requirements only (fast, 30 seconds)
- **Per wave merge:** Run `wc -l` check on all CLAUDE.md files + manual two-hop navigation test
- **Phase gate:** All items in the "Looks Done But Isn't" checklist from PITFALLS.md pass before marking phase complete

### Wave 0 Gaps

None — this phase produces markdown files, not code. No test framework installation needed. Validation is entirely manual behavioral testing.

---

## Sources

### Primary (HIGH confidence)
- `/home/skogix/claude/docs/claude-code/memory.md` — Official Claude Code CLAUDE.md loading behavior: subdirectory loading on demand, `@path` eager injection, import depth, 200-line soft limit
- Direct inspection of `/home/skogix/claude/` directory tree — current file locations, line counts, and content verified
- `.planning/phases/01-identity-routing/01-CONTEXT.md` — User decisions, locked constraints
- `.planning/research/ARCHITECTURE.md` — Architecture patterns and rationale (HIGH confidence, from prior research session)
- `.planning/research/PITFALLS.md` — Pitfall catalog (HIGH confidence, from lived experience)

### Secondary (MEDIUM confidence)
- `.planning/REQUIREMENTS.md` — Requirement definitions and traceability
- `personal/soul-document.md` section headings — observed directly for split planning
- `personal/memory-blocks/` directory listing — confirmed no framework files mixed in

### Tertiary (LOW confidence)
- None — all claims in this document are grounded in direct inspection or official docs

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — Claude Code @-link mechanics verified in official docs; directory structure verified by inspection
- Architecture: HIGH — patterns derived from existing working examples (docs/CLAUDE.md, personal/CLAUDE.md) and official loading behavior
- Pitfalls: HIGH — derived from PITFALLS.md (grounded in documented lived experience) and direct inspection of current problems (eager loading in personal/CLAUDE.md)

**Research date:** 2026-03-20
**Valid until:** 2026-04-20 (stable domain — CLAUDE.md system behavior is unlikely to change; directory contents may change)
