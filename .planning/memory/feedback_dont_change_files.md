---
name: feedback_dont_change_files
description: When user says "don't change files", stop and present the plan first — do NOT write anything
type: feedback
---

When the user says "don't change any files" — that means ZERO file writes. Not even in a worktree. Present the plan/analysis first, get approval, THEN write.

**Why:** User wants to review the approach before any implementation. Worktree isolation doesn't override an explicit "don't change files" instruction.

**How to apply:** If told to create a worktree but not change files, enter the worktree and then present the plan verbally. Wait for approval before any Write/Edit calls.
