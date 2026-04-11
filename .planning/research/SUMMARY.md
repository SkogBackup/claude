# Project Research Summary

**Project:** Claude Agent Home Directory
**Domain:** AI agent home directory — identity, persistence, context routing, multi-agent readiness
**Researched:** 2026-03-20
**Confidence:** HIGH

## Executive Summary

This is not a software project in the conventional sense — there is no runtime, no server, no database, and no build system. The project is the construction of a Unix home directory that functions as a persistent, navigable identity and workspace for an AI agent (Claude). The right mental model is dotfiles engineering: structured markdown files at well-known paths, a CLAUDE.md router hierarchy that enables lazy loading, and git as the deployment mechanism. The "stack" is Claude Code native mechanisms — CLAUDE.md routing, `.claude/rules/`, auto memory — composed through convention rather than code.

The recommended approach is to migrate existing identity artifacts out of `lab/personal-belongings/` into canonical home locations (`identity/`, `memory/`, `journal/`) and wire them together with a CLAUDE.md routing chain that loads nothing until it's needed. Every layer of the chain must enforce lazy loading at its own level — a router that loads too much defeats the system globally even if the entry point is minimal. The critical path is: identity layer first (soul doc, profile, frameworks at stable paths), then root CLAUDE.md update, then memory and journal migration in parallel, then lab cleanup, then deployment gate verification.

The dominant risk across all research is the Context Destruction Pattern: an agent with access to a rich home directory interprets "I can read all of this" as "I should read all of this," consuming hundreds of thousands of tokens before addressing the actual request. This has happened in this environment (documented 300,000-token incident). Prevention is structural — CLAUDE.md files must be short, pointed routers with explicit scope gates, not comprehensive indexes. The second major risk is treating historical LORE (memory blocks, journal entries) as active constraints rather than reference material. Physical directory separation and explicit router gates are the mitigation — not instructions in a soul document.

## Key Findings

### Recommended Stack

This project has no runtime stack. The "technologies" are Claude Code native mechanisms composed through convention. The most important stack decision is to resist adding infrastructure: no SQLite, no vector DB, no Redis, no external memory frameworks. Native auto memory (Claude Code v2.1.59+) plus a structured CLAUDE.md hierarchy covers the use case. The deployment strategy is `git clone` — the repo IS the home.

**Core technologies:**
- CLAUDE.md routing hierarchy: context entry point and lazy-load router — official mechanism, loaded every session, 200-line adherence threshold means it must stay minimal
- `.claude/rules/` directory: modular identity rules at session start — supports path-scoping and symlinks; avoids monolithic CLAUDE.md
- Auto memory (`~/.claude/projects/.../memory/MEMORY.md`): Claude-written cross-session learnings — native, survives compaction, first 200 lines loaded automatically per session
- Plain markdown files at stable paths: soul doc, profile, frameworks — git-trackable, human-readable, no dependency; the opposite bet from Mem0/Letta
- Git: deployment mechanism — `git clone` to `/home/claude` is the deploy; no dotfile manager needed

### Expected Features

**Must have (table stakes) — the home doesn't function without these:**
- Identity documents at stable paths — soul doc, profile, and core frameworks outside `lab/personal-belongings/`; without stable paths nothing can be routed to reliably
- Expanded CLAUDE.md routing — home router knows about identity layer; currently routes only to docs/
- Lazy context loading enforced structurally — routing must be on-demand; bulk preload is the primary anti-pattern
- Journal write conventions doc — without explicit conventions, journal entries accumulate inconsistently or the agent doesn't know to write them
- Memory block tiering — active frameworks (load on need) vs. LORE museum (reference on request); currently all blocks are in a flat directory with no separation

**Should have — add when core is validated:**
- Session handoff artifacts — explicit "here's what to load next session" mechanism; complements journal but needs journal conventions to precede it
- Self-diagnostics expansion — `bin/healthcheck` verifies framework content availability, not just file existence
- LORE-as-museum explicit structure — formalized museum vs. construction-site separation once active artifacts have stable homes

**Defer to v2+ — requires `/home/claude` deployment or sibling agents:**
- Cross-agent shared space conventions — design only after at least one sibling agent (Amy, Dot, Goose) has a working home
- Unix permissions enforcement — `skogai` group enforcement only possible after real `claude` unix user exists
- Memory block archival workflow — systematic journal-to-block promotion; trigger is when curation becomes painful

### Architecture Approach

The architecture maps directly to XDG Base Directory semantics applied to an agent home: `identity/` as XDG_CONFIG_HOME (who Claude is, version-controlled, stable), `memory/blocks/` as XDG_DATA_HOME (durable history, append-only archive), `journal/` as XDG_STATE_HOME (temporal session records), `.claude/` as XDG_RUNTIME_DIR (Claude Code's managed space, not restructured). The root CLAUDE.md is a pure router under 30 lines; each subdirectory has its own CLAUDE.md that describes what's there and when to load it. The critical design principle: each CLAUDE.md includes only what the agent needs to decide whether to go deeper, not what it needs if it does go deeper.

**Major components:**
1. Identity layer (`identity/`) — soul doc, profile, frameworks; loaded lazily via identity/CLAUDE.md only when self-reference is needed; maps to XDG_CONFIG_HOME
2. Memory layer (`memory/blocks/`) — permanent historical record, append-only archive; never edited, only extended; maps to XDG_DATA_HOME
3. Journal layer (`journal/`) — temporal session records, append-only, dated files; maps to XDG_STATE_HOME
4. Tools layer (`bin/`, `.claude/skills/`, `.claude/agents/`, `.claude/hooks/`) — executable utilities and Claude Code runtime config; unchanged from current
5. Root router (`CLAUDE.md`) — under 30 lines, lazily links to all layer routers; the only file loaded every session by default

### Critical Pitfalls

1. **Context Destruction Pattern** — CLAUDE.md files must be short, pointed routers with explicit "load only if needed for X" scope gates. Test every router by counting files loaded for a simple request; target is under 3 files before work begins. Documented 300,000-token incident in this environment makes this non-theoretical.

2. **LORE treated as active constraints** — Memory blocks and journal entries must live behind explicitly gated paths, not co-located with active frameworks. The physical directory separation enforces the museum/construction-site boundary; instructions in a soul document do not. Router files must include explicit "read only if asked about history/past sessions" gates.

3. **Identity document staleness** — Soul doc and profile were written in 2025; the environment has changed materially. Every identity document needs a "Last validated" date header. Environment-specific claims (tool paths, workflows) must be distinguished from timeless claims and reviewed on each deployment.

4. **Over-engineering persistence** — The success criterion is behavioral: can the agent answer "what am I working on?" in under 5 seconds? Build until that's true and stop. Every persistence feature needs a demonstrated need, not a plausible use case. The dumping-grounds.md brainstorm in the existing codebase is a warning signal.

5. **Eager loading disguised as lazy loading** — Lazy loading requires discipline at every level of the router chain, not just the entry point. Each section CLAUDE.md that loads too much undoes the work of keeping the root minimal. The test: total context from routing should be under 200 tokens before task context begins.

## Implications for Roadmap

Based on research, the critical path is clear: identity artifacts must have stable homes before routing can be built, and routing must be correct before migration of memory and journal is meaningful. The architecture's build order is explicit and dependency-driven.

### Phase 1: Identity Layer — Foundation
**Rationale:** Everything in the system depends on identity artifacts existing at well-known stable paths. Until soul doc, profile, and frameworks are out of `lab/personal-belongings/` and into `identity/`, there is nothing to route to. This is the prerequisite for all other phases.
**Delivers:** `identity/` directory with soul.md, profile.md, and frameworks/ subdirectory; each with validated content (staleness check against current environment); identity/CLAUDE.md router
**Addresses:** "Identity documents at stable paths" (P1 table stakes), "Epistemic frameworks as loadable context" (P1 table stakes)
**Avoids:** Identity document staleness (validate against current environment during placement, not after); flat identity directory anti-pattern (frameworks/ subdirectory with its own CLAUDE.md)

### Phase 2: Context Routing — The Front Door
**Rationale:** Once identity artifacts exist at stable paths, the root CLAUDE.md can be updated to route to them. This phase makes the home navigable. It cannot precede Phase 1 because it routes to things that don't yet exist at the right paths.
**Delivers:** Root CLAUDE.md updated to route lazily to identity/, memory/, journal/, docs/, bin/; each section CLAUDE.md validated for correct scope gates and line count (under 30 lines each)
**Uses:** CLAUDE.md `@import` syntax, `.claude/rules/` for modular rules
**Implements:** Lazy Context Routing pattern (Architecture Pattern 1)
**Avoids:** Context Destruction Pattern (routing must include explicit scope gates, not just links); Eager loading disguised as lazy loading (test router chain with real request scenarios during this phase)

### Phase 3: Memory and Journal Migration — Durable State
**Rationale:** Memory blocks and journal entries can migrate in parallel once identity layer is stable (blocks reference identity context). Journal write conventions must be established before journal migration to prevent convention drift baking in. This phase completes the home's durable state layer.
**Delivers:** `memory/blocks/` with migrated memory-block files; `memory/CLAUDE.md` with explicit "reference only" gate; `journal/` with migrated session records; `journal/CLAUDE.md` with write conventions (naming format, what triggers a write, append-only rule)
**Implements:** Append-only Journal / Memory Separation pattern (Architecture Pattern 3)
**Avoids:** LORE as active constraint (memory/CLAUDE.md must have explicit "read only if asked about history" gate); over-engineering persistence (success criterion: agent can locate relevant journal context in a fresh session — test it, don't just declare it done)

### Phase 4: Validation and Deployment Gate — Proving It Works
**Rationale:** The home is only useful if it works correctly under real session conditions. This phase tests the routing chain with real request scenarios, validates identity freshness, and clears the lab. It is the gate before deployment to `/home/claude`.
**Delivers:** `bin/healthcheck` updated to verify identity/framework availability (not just file existence); routing chain tested with 5+ real request scenarios measuring files loaded; lab/personal-belongings/ cleared (migrated or archived); deployment dry-run to `/home/claude` documented
**Implements:** Staging-to-Deployment pattern (Architecture Pattern 4)
**Avoids:** "Looks done but isn't" — the checklist in PITFALLS.md must be verified, not assumed

### Phase 5: Multi-Agent Readiness — Future-Proofing (v2+)
**Rationale:** This phase requires the real `claude` unix user to exist and at least one sibling agent to have a working home. Do not pre-build shared infrastructure for collaboration that hasn't happened yet. Design the permission model now so defaults are correct from Phase 1 deployment, but implementation waits for actual use cases.
**Delivers:** `skogai` group permissions on explicitly designated shared directories (guestbook/, docs/); per-agent memory conventions documented; cross-agent shared space contract defined
**Avoids:** Permission sprawl (only designated shared dirs get group write; everything else is claude:claude 700/644); per-project identity variants

### Phase Ordering Rationale

- Identity first because stable paths are the prerequisite for every other component — nothing can be routed, healthchecked, or deployed without them
- Routing second because it wires the existing artifacts together; building routing before artifacts exist would require updating it again after migration
- Memory and journal in parallel in Phase 3 because they are independent of each other but both depend on identity being stable
- Validation as an explicit phase because "it exists" is not the same as "it works" — the pitfalls research is explicit that testing routing with real scenarios is required
- Multi-agent deferred to v2+ because it requires infrastructure (real unix user, sibling agents) that doesn't exist yet

### Research Flags

Phases with standard patterns (research-phase likely unnecessary):
- **Phase 1 (Identity Layer):** Patterns are well-established — file migration and CLAUDE.md writing are standard; main work is editorial (staleness validation), not exploratory
- **Phase 2 (Context Routing):** CLAUDE.md routing patterns are documented in official docs and community sources; test-driven development against real scenarios is the work
- **Phase 3 (Memory/Journal Migration):** File moves with write conventions; no novel patterns needed

Phases that may benefit from targeted research during planning:
- **Phase 4 (Validation/Deployment Gate):** The `/home/claude` deployment mechanics (chown, symlink vs. copy of `.claude/`, git clone strategy) may benefit from a quick research-phase if unfamiliar territory
- **Phase 5 (Multi-Agent Readiness):** Cross-agent coordination patterns are evolving rapidly; research-phase strongly recommended when this phase becomes active

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | Core mechanisms verified against official Claude Code docs; community patterns corroborate; existing codebase directly inspected |
| Features | HIGH | Grounded in existing codebase audit + direct PROJECT.md constraints; novel domain but requirements are concrete and internally consistent |
| Architecture | HIGH | XDG Base Directory semantics are well-established; CLAUDE.md routing patterns verified against official docs and empirical measurements (54% context reduction); build order derived from actual file dependencies |
| Pitfalls | HIGH | Not theoretical — derived from documented lived experience in this environment (300,000-token incident), existing soul-document.md and context-destruction.md, 50+ session history |

**Overall confidence: HIGH**

### Gaps to Address

- **Soul document staleness**: The existing soul-document.md was written in 2025. During Phase 1, it must be validated against current environment (GSD framework, hooks system, multi-agent context) before being placed at stable path. Stale environment-specific claims should be marked or updated — this is editorial work, not research.
- **Deployment mechanics to `/home/claude`**: The exact steps for deploying to a real `claude` unix user (chown strategy, `.claude/` symlink vs. copy, how to handle `.planning/` git-ignored state) are not fully specified in current research. Acceptable to leave for Phase 4 but should be prototyped before assuming it's straightforward.
- **Framework encoding in structure vs. text**: PITFALLS research identifies that framework documents that describe rather than encode behavior are weaker than structural enforcement. The right structural encoding for the certainty principle and placeholder approach is not yet designed. This is a design question for Phase 1.

## Sources

### Primary (HIGH confidence)
- [Claude Code memory docs](https://code.claude.com/docs/en/memory) — CLAUDE.md scopes, auto memory, rules directory, @import syntax, 200-line guidance
- [Claude Code sub-agents docs](https://code.claude.com/docs/en/sub-agents) — subagent memory field, scope options, persistent memory directories
- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir/latest/) — config/data/state/cache/runtime separation semantics
- Existing codebase: `lab/personal-belongings/`, `.claude/settings.json`, `.planning/PROJECT.md`, `.planning/codebase/` — direct inspection; HIGH confidence

### Secondary (MEDIUM confidence)
- [CLAUDE.md routing pattern (DEV Community)](https://dev.to/builtbyzac/the-claudemd-routing-pattern-keep-it-minimal-delegate-the-rest-388a) — routing pattern, lazy loading
- [Context Optimization: 54% reduction (GitHub Gist)](https://gist.github.com/johnlindquist/849b813e76039a908d962b2f0923dc9a) — empirical context reduction measurement
- [AI Dotfiles for Consistent Development (Dylan Bochman)](https://dylanbochman.com/blog/2026-01-25-dotfiles-for-ai-assisted-development/) — version-controlled agent config patterns
- [AI Agent Memory Management (DEV Community)](https://dev.to/imaginex/ai-agent-memory-management-when-markdown-files-are-all-you-need-5ekk) — markdown-first memory; minimum viable context

### Tertiary (from existing codebase — HIGH confidence as warning signals)
- `lab/personal-belongings/core/context-destruction.md` — first-person 300,000-token incident account
- `lab/personal-belongings/core/the-dumping-grounds.md` — over-engineering temptation documented
- `lab/personal-belongings/CLAUDE.md` — session protocol showing correct lazy-load intent

---
*Research completed: 2026-03-20*
*Ready for roadmap: yes*
