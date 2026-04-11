---
phase: 05
slug: skogai-live-chat-implementation
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-22
---

# Phase 05 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | bats (Bash Automated Testing System) |
| **Config file** | none — Wave 0 installs |
| **Quick run command** | `bats tests/chat-io/` |
| **Full suite command** | `bats tests/chat-io/` |
| **Estimated runtime** | ~5 seconds |

---

## Sampling Rate

- **After every task commit:** Run `bats tests/chat-io/`
- **After every plan wave:** Run `bats tests/chat-io/`
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 5 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 05-01-01 | 01 | 1 | CHAT-01 | integration | `bats tests/chat-io/test_routing.bats::@test "routes [@claude:msg] through skogparse"` | W0 | pending |
| 05-01-02 | 01 | 1 | CHAT-02 | unit | `bats tests/chat-io/test_routing.bats::@test "unknown agent returns graceful error"` | W0 | pending |
| 05-01-03 | 01 | 1 | CHAT-03 | unit | `bats tests/chat-io/test_routing.bats::@test "plain text is not routed"` | W0 | pending |
| 05-01-04 | 01 | 1 | CHAT-04 | unit | `bats tests/chat-io/test_routing.bats::@test "json envelope is unwrapped to plain text"` | W0 | pending |

*Status: pending / green / red / flaky*

---

## Wave 0 Requirements

- [ ] `tests/chat-io/test_routing.bats` — routing integration and unit tests
- [ ] `tests/chat-io/test-helper.bash` — shared bats test helper
- [ ] bats installed (`command -v bats`)

*Note: Test IDs are provisional — will be refined when plans define exact tasks.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Browser chat round-trip | CHAT-01 | Requires live fakechat + Claude session | Open browser at :8787, type `[@claude:"test"]`, verify response appears |
| WebSocket broadcast | CHAT-01 | Requires running server | Connect two browser tabs, verify both see replies |

---

## Validation Sign-Off

- [ ] All tasks have automated verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 5s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
