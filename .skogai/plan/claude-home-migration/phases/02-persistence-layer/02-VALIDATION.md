---
phase: 2
slug: persistence-layer
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-20
---

# Phase 2 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | bash + grep (file-based verification) |
| **Config file** | none — convention checks use shell commands |
| **Quick run command** | `ls personal/journal/ && grep -l "naming" personal/journal/CONVENTIONS.md` |
| **Full suite command** | `bash -c 'test -f personal/journal/CONVENTIONS.md && ls personal/journal/*.md 2>/dev/null && grep -q "LORE" personal/memory-blocks/CLAUDE.md && test -f .claude/commands/skogai/wrapup.md'` |
| **Estimated runtime** | ~1 second |

---

## Sampling Rate

- **After every task commit:** Run quick run command
- **After every plan wave:** Run full suite command
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 1 second

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 02-01-01 | 01 | 1 | PER-01 | file check | `test -f personal/journal/CONVENTIONS.md && wc -l personal/journal/CONVENTIONS.md` | ❌ W0 | ⬜ pending |
| 02-01-02 | 01 | 1 | PER-02 | ls pattern | `ls personal/journal/ \| grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}'` | ❌ W0 | ⬜ pending |
| 02-02-01 | 02 | 1 | PER-03 | grep check | `grep -c "Load only when asked" personal/memory-blocks/CLAUDE.md` | ✅ | ⬜ pending |
| 02-02-02 | 02 | 2 | PER-04 | file check | `test -f .claude/commands/skogai/wrapup.md \|\| test -f personal/journal/CONVENTIONS.md` | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `personal/journal/` — directory must be created
- [ ] `personal/journal/CONVENTIONS.md` — journal conventions document
- [ ] `.claude/commands/skogai/` — directory for wrapup command

*Existing infrastructure covers LORE gate (PER-03) — routing language already in place from Phase 1.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Fresh session LORE gate | PER-03 | Requires actual fresh Claude session | Start new session, navigate to personal/, confirm memory blocks not auto-loaded |
| Handoff artifact usability | PER-04 | Requires session boundary test | End session with wrapup, start new session, verify handoff loads correctly |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 1s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
