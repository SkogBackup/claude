---
phase: 1
slug: identity-routing
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-20
---

# Phase 1 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | No automated test framework — this phase produces markdown files |
| **Config file** | N/A |
| **Quick run command** | `wc -l $(find . -name CLAUDE.md -not -path './.claude/*' -not -path './.planning/*')` |
| **Full suite command** | Quick run + manual two-hop navigation test from root |
| **Estimated runtime** | ~30 seconds |

---

## Sampling Rate

- **After every task commit:** Run smoke test for that task's requirements only (~30s)
- **After every plan wave:** Run `wc -l` check on all CLAUDE.md files + manual two-hop navigation
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 30 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 01-01-01 | 01 | 1 | IDN-01 | manual smoke | `ls personal/soul/ personal/core/` | N/A | ⬜ pending |
| 01-01-02 | 01 | 1 | IDN-02 | manual | `grep '@soul-document' personal/CLAUDE.md` → empty | N/A | ⬜ pending |
| 01-01-03 | 01 | 1 | IDN-03 | manual | Follow 5 links from INDEX.md — all resolve | N/A | ⬜ pending |
| 01-01-04 | 01 | 1 | IDN-04 | manual smoke | `grep -i 'LORE\|museum\|reference' personal/memory-blocks/CLAUDE.md` | N/A | ⬜ pending |
| 01-01-05 | 01 | 1 | IDN-05 | manual smoke | `cat personal/core/CLAUDE.md` — all 3 frameworks listed | N/A | ⬜ pending |
| 01-02-01 | 02 | 1 | CTX-01 | manual | `cat CLAUDE.md` — count directory entries (6+ dirs) | N/A | ⬜ pending |
| 01-02-02 | 02 | 1 | CTX-02 | manual smoke | `ls bin/CLAUDE.md guestbook/CLAUDE.md notes/CLAUDE.md lab/CLAUDE.md` | N/A | ⬜ pending |
| 01-02-03 | 02 | 1 | CTX-03 | automated | `wc -l $(find . -name CLAUDE.md -not -path './.claude/*' -not -path './.planning/*')` ≤ 50 | N/A | ⬜ pending |
| 01-02-04 | 02 | 1 | CTX-04 | manual | Read personal/CLAUDE.md — @links use `@dir/` not `@file.md` | N/A | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

*Existing infrastructure covers all phase requirements — this phase produces markdown files, not code. No test framework installation needed.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Two-hop navigation from root | CTX-01, CTX-04 | Requires agent session simulation | Start fresh session, follow root → one directory → verify target artifact reached without loading irrelevant files |
| No eager file injection | IDN-02, CTX-04 | Requires understanding @-link semantics | Read personal/CLAUDE.md, confirm `@dir/` syntax (lazy) vs `@file.md` (eager). Only profile.md allowed as eager. |
| Soul section independence | IDN-05 | Requires reading behavior | Load one framework via direct path, confirm no adjacent frameworks loaded |
| Memory tier labeling | IDN-04 | Requires reading CLAUDE.md content | Check personal/memory-blocks/CLAUDE.md explicitly labels active vs museum tiers |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 30s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
