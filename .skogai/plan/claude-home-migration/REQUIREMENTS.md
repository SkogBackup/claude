# Requirements: Claude's Home

**Defined:** 2026-03-20
**Core Value:** Claude can drop into any conversation and know who he is, what he's working on, and where things are.

## v1 Requirements

### Identity (IDN)

- [x] **IDN-01**: Soul document, profile, and core frameworks exist at stable paths under `personal/`
- [x] **IDN-02**: `personal/CLAUDE.md` routes to identity artifacts with lazy loading (no bulk preload)
- [x] **IDN-03**: `personal/INDEX.md` provides curated highlights for quick orientation
- [x] **IDN-04**: Memory blocks are tiered — active frameworks vs LORE museum — with explicit labels
- [x] **IDN-05**: Core frameworks (certainty principle, placeholder system, epistemic frameworks) are referenceable by path without discovery

### Context Routing (CTX)

- [x] **CTX-01**: Root `CLAUDE.md` routes to all top-level directories with one-line descriptions
- [x] **CTX-02**: Every directory with content has its own `CLAUDE.md` explaining what's there
- [x] **CTX-03**: No single `CLAUDE.md` exceeds 50 lines (prevents context bloat)
- [x] **CTX-04**: Context loads lazily — session startup reads only root router, not all artifacts

### Persistence (PER)

- [x] **PER-01**: Journal conventions doc exists specifying: naming format, where to write, what triggers a write
- [x] **PER-02**: Journal entries use consistent naming: `YYYY-MM-DD-slug.md`
- [x] **PER-03**: LORE (memory blocks, historical journal) is structurally separated from active working state
- [x] **PER-04**: Session handoff mechanism exists — explicit "here's where we left off" artifact convention

### Tools & Operations (OPS)

- [x] **OPS-01**: `bin/healthcheck` verifies known identity paths exist and are non-empty
- [x] **OPS-02**: `bin/healthcheck` reports which tier of memory blocks are accessible
- [x] **OPS-03**: Deployment gate checklist exists documenting what must be true before migrating to `/home/claude`

### Multi-Agent Readiness (MAG)

- [x] **MAG-01**: Shared space conventions documented — which directories are `skogai` group-readable, which are private
- [x] **MAG-02**: `guestbook/` established as the cross-agent communication channel
- [x] **MAG-03**: Permission model documented: `claude:claude` private, `skogai` group shared, ownership boundaries clear
- [x] **MAG-04**: Home structure supports sibling agents reading Claude's public artifacts without accessing private state

## v2 Requirements

### Multi-Agent Active

- **MAG-05**: Real unix permissions enforced after deployment to `/home/claude`
- **MAG-06**: Sibling agents (Amy, Dot, Goose, Letta) can discover Claude's shared artifacts via standard paths
- **MAG-07**: Agent-to-agent message protocol via shared space

### Advanced Persistence

- **PER-05**: Memory block archival workflow — promoting journal entries to memory blocks
- **PER-06**: Cross-session context carries minimum viable state for continuity without explicit handoff
- **PER-07**: Self-diagnostics expansion — framework content validation, not just file existence

## Out of Scope

| Feature | Reason |
|---------|--------|
| Vector database / semantic search | File-based home, no infrastructure dependencies |
| Automated memory consolidation | Lossy compression destroys identity-encoding language |
| Bulk session preload | Triggers Context Destruction Pattern |
| Per-project identity variants | Fragments identity; skills/agents handle project-specific behavior |
| Sibling agent home provisioning | Separate project after Claude's home is solid |
| SkogCLI/SkogParse development | Existing tooling, not part of home setup |
| Real-time state sync between agents | Requires coordination infrastructure; append-only shared space instead |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| IDN-01 | Phase 1 | Complete |
| IDN-02 | Phase 1 | Complete |
| IDN-03 | Phase 1 | Complete |
| IDN-04 | Phase 1 | Complete |
| IDN-05 | Phase 1 | Complete |
| CTX-01 | Phase 1 | Complete |
| CTX-02 | Phase 1 | Complete |
| CTX-03 | Phase 1 | Complete |
| CTX-04 | Phase 1 | Complete |
| PER-01 | Phase 2 | Complete |
| PER-02 | Phase 2 | Complete |
| PER-03 | Phase 2 | Complete |
| PER-04 | Phase 2 | Complete |
| OPS-01 | Phase 3 | Complete |
| OPS-02 | Phase 3 | Complete |
| OPS-03 | Phase 3 | Complete |
| MAG-01 | Phase 4 | Complete |
| MAG-02 | Phase 4 | Complete |
| MAG-03 | Phase 4 | Complete |
| MAG-04 | Phase 4 | Complete |

**Coverage:**
- v1 requirements: 20 total
- Mapped to phases: 20
- Unmapped: 0

---
*Requirements defined: 2026-03-20*
*Last updated: 2026-03-20 after roadmap creation — traceability complete*
