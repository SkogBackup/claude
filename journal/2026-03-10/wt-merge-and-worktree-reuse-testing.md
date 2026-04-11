# wt merge and worktree reuse testing

## what happened

Tested three open questions about the worktree workflow by creating real worktrees,
making commits, and running `wt merge` from various locations.

## findings

### wt merge from inside worktree
- Works. Auto-detects which worktree you're in.
- Single commit: fast-forwards directly (no squash needed).
- Zero commits: no-op merge, still cleans up worktree.
- After merge: cwd switches to `~/claude` on develop.

### claude --worktree reuse
- `claude --worktree <name>` reuses existing worktree if name matches.
- No error, no duplicate. Just runs claude in the existing directory.
- Help text says "Create a new git worktree" but behavior is smarter.

### wt default-branch config
- `wt config state default-branch` can get cleared between sessions.
- Symptoms: `Configured default branch master does not exist locally`.
- Fix: `wt config state default-branch set develop`.

## corrections to prior knowledge
- Auto memory said `wt merge` "produces no visible output on success" — wrong.
  It shows `Merged to develop (1 commit, 1 file, +1)` or similar.
- Auto memory had a separate `wt remove` step after merge — unnecessary,
  merge auto-removes the worktree and branch.
- Shipping workflow was listed as "merge into local master" — corrected to
  "PR from develop to master".
