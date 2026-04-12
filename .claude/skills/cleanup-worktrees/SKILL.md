---
name: cleanup-worktrees
description: Prune stale entries from .claude/worktrees/. Shows current worktrees, identifies prunable ones, and removes them after user confirmation.
disable-model-invocation: true
---

1. Run `git worktree list` and show the output to the user
2. Identify any entries under `.claude/worktrees/` that are stale (point to missing paths or old commits)
3. Ask the user to confirm before removing anything
4. If confirmed, run `git worktree prune` to remove stale references
5. Run `git worktree list` again to confirm the cleanup
6. Report what was removed
