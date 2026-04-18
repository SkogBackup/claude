# Roadmap: Claude's Home

## Overview

The identity migration is done — personal artifacts are in personal/ with routing and an index. What remains is three distinct deliveries: refining what was placed (memory block tiering, routing completeness, framework path clarity), building what's missing (journal conventions, LORE separation, session handoff, healthcheck), and proving the home is ready (deployment gate, multi-agent permission model). Four phases, each delivering one verifiable capability.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Identity & Routing** - Tier memory blocks, complete CLAUDE.md routing across all directories, confirm framework paths
- [x] **Phase 2: Persistence Layer** - Journal conventions, LORE structural separation from active state, session handoff mechanism
- [x] **Phase 3: Operations & Deployment Gate** - Healthcheck expansion, deployment gate checklist, pre-migration validation (completed 2026-03-21)
- [x] **Phase 4: Multi-Agent Readiness** - Permission model documented, shared space conventions, guestbook established as cross-agent channel (completed 2026-03-21)

## Phase Details

### Phase 1: Identity & Routing
**Goal**: Every artifact in the home is navigable from root in two hops — memory blocks are tiered, frameworks are referenceable by direct path, and no directory is a routing dead end
**Depends on**: Nothing (identity migration is already complete; this phase refines it)
**Requirements**: IDN-01, IDN-02, IDN-03, IDN-04, IDN-05, CTX-01, CTX-02, CTX-03, CTX-04
**Success Criteria** (what must be TRUE):
  1. Soul document, profile, and core frameworks are at stable paths under personal/ with "last validated" dates confirming they match the current environment
  2. Memory blocks are visibly split into active frameworks and LORE museum tiers — personal/CLAUDE.md or a sub-router labels which tier each block belongs to
  3. Each core framework (certainty-principle, placeholder-approach, epistemic-frameworks) is loadable via a direct path without reading adjacent frameworks
  4. Root CLAUDE.md routes to every top-level directory with content — personal/, docs/, bin/, notes/, guestbook/, lab/ — with one-line descriptions
  5. Every directory with content has a CLAUDE.md under 50 lines; a fresh session following root → one directory router reaches the right artifact without loading irrelevant files
**Plans:** 3/3 plans executed

Plans:
- [x] 01-01-PLAN.md — Split soul document, create sub-routers, rewrite personal/CLAUDE.md for lazy loading
- [x] 01-02-PLAN.md — Rewrite root router, create thin CLAUDE.md files, trim docs/CLAUDE.md
- [x] 01-03-PLAN.md — Automated verification of all requirements + human navigation checkpoint

### Phase 2: Persistence Layer
**Goal**: Writing to the home is disciplined — journal conventions exist and are followed, LORE lives behind an explicit gate so it cannot be accidentally loaded as active context, and sessions can end with a context bridge the next session can pick up
**Depends on**: Phase 1
**Requirements**: PER-01, PER-02, PER-03, PER-04
**Success Criteria** (what must be TRUE):
  1. A journal conventions document exists specifying: naming format (YYYY-MM-DD/<description>.md date-folder structure), where to write, what triggers a write, and the append-only rule — readable in under 30 seconds
  2. All journal entries in personal/journal/ follow the YYYY-MM-DD/<description>.md date-folder convention (verifiable with ls)
  3. Reaching memory blocks from a fresh session requires an explicit navigation step — the default routing path does not auto-load LORE
  4. A session handoff convention exists: there is a known artifact format for "here is what to load next session," and at least one handoff artifact has been written using it
**Plans:** 3/3 plans executed

Plans:
- [x] 02-01-PLAN.md — Create journal conventions doc, establish directory structure, verify LORE gating
- [x] 02-02-PLAN.md — Move context scripts from scripts/context/ to bin/, update bin/ router
- [x] 02-03-PLAN.md — Create wrap-up command, write first handoff artifact (journal entry)

### Phase 3: Operations & Deployment Gate
**Goal**: The home can verify its own health and a deployment gate documents exactly what must be true before migrating to /home/claude — nothing ships on assumption
**Depends on**: Phase 2
**Requirements**: OPS-01, OPS-02, OPS-03
**Success Criteria** (what must be TRUE):
  1. Running bin/healthcheck verifies that known identity paths (soul document, profile, core frameworks) exist and are non-empty — exits non-zero with a clear diagnostic message if any are missing
  2. Running bin/healthcheck reports which memory block tier (active vs LORE) is accessible — not just a file count
  3. A deployment gate checklist exists at a stable path, each item is binary (pass/fail), and the checklist covers: routing test results, identity validation, permission audit, and healthcheck passing
**Plans:** 2/2 plans complete

Plans:
- [x] 03-01-PLAN.md — Extend bin/healthcheck with identity path checks, routing verification, and memory block tier reporting
- [x] 03-02-PLAN.md — Create deployment gate checklist at docs/deployment-gate.md

### Phase 4: Multi-Agent Readiness
**Goal**: Shared space boundaries are documented and defensible before any sibling agent is provisioned — permission defaults are correct from day one so collaboration pressure cannot erode them
**Depends on**: Phase 3
**Requirements**: MAG-01, MAG-02, MAG-03, MAG-04
**Success Criteria** (what must be TRUE):
  1. A permission model document specifies which directories are skogai group-readable, which are claude:claude private, and why — categories are explicit, not implied
  2. guestbook/ has a CLAUDE.md establishing it as the designated cross-agent communication channel with write conventions (format, naming, what goes there)
  3. The permission model distinguishes three tiers: private state (personal/, .claude/), shared-read (docs/), shared-write (guestbook/) — each tier is documented with rationale
  4. Claude's home structure allows a future sibling agent to read guestbook/ and docs/ without requiring access to personal/ or .claude/ — the boundaries are navigable by design, not instruction
**Plans**: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Identity & Routing | 3/3 | Complete | 2026-03-21 |
| 2. Persistence Layer | 3/3 | Complete | 2026-03-21 |
| 3. Operations & Deployment Gate | 2/2 | Complete   | 2026-03-21 |
| 4. Multi-Agent Readiness | 1/1 | Complete   | 2026-03-21 |
| 5. Channel Integration | 0/2 | Planning   | — |

### Phase 5: skogai-live-chat-implementation

**Goal:** A generic chat-io contract exists (transport-agnostic deliver/reply) with a routing script that detects [@agent:"msg"] notation and dispatches via skogparse, plus Claude instructions and a hook fallback that wire routing into the channel message flow
**Requirements**: CHAT-01, CHAT-02, CHAT-03, CHAT-04, CHAT-05, CHAT-06, CHAT-07
**Depends on:** Phase 4

**Requirement Definitions:**
- CHAT-01: Routing script detects `[@agent:"msg"]` and dispatches via skogparse
- CHAT-02: Unknown agents produce human-readable error, not raw JSON
- CHAT-03: Plain text without notation bypasses routing
- CHAT-04: JSON envelope is unwrapped — only the value field reaches the caller
- CHAT-05: Chat-io contract spec documents deliver/reply semantics
- CHAT-06: Skill teaches Claude to detect and route channel messages
- CHAT-07: Hook fallback calls the same routing script as the instruction path (no divergence)

*Deferred from phase 5:* Agent stub scripts (Amy, Dot, Goose, Letta) — routing handles "script not found" gracefully; stubs are a separate concern.

**Success Criteria** (what must be TRUE):
  1. A chat-io contract spec documents deliver/reply semantics, identity model, and routing behavior
  2. A routing script detects [@agent:"msg"] notation, calls skogparse --execute, unwraps JSON, and outputs plain text
  3. Plain text messages (no notation) pass through unrouted
  4. Unknown agents produce human-readable errors, not raw JSON
  5. Claude instructions (skill) teach Claude to detect and route channel messages
  6. A hook fallback calls the same routing script as the instruction path (no divergence)
  7. fakechat server.ts is completely unchanged (reference only)
**Plans:** 2 plans

Plans:
- [ ] 05-01-PLAN.md — Chat-io contract spec, routing script, bats test suite (CHAT-01, CHAT-02, CHAT-03, CHAT-04, CHAT-05)
- [ ] 05-02-PLAN.md — CLAUDE.md routing skill, hook fallback, settings.json wiring, browser verification (CHAT-06, CHAT-07)

---
*Roadmap created: 2026-03-20*
*Requirements coverage: 27/27 requirements mapped (20 v1 + 7 phase 5)*
