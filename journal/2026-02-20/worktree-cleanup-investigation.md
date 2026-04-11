# Claude Code Worktree Lifecycle — Full Investigation

Traced the complete lifecycle of claude code worktrees: creation, branch tracking, merging, PR workflow, and cleanup.

## The path mismatch

- `-w` CLI flag creates worktrees at `<repo>/.worktrees/<name>` (worktrunk's location)
- `EnterWorktree` tool claims `.claude/worktrees/<name>` in its output
- Despite the mismatch, `EnterWorktree` correctly finds existing worktrees by name
- This path confusion is the root cause of broken cleanup and possibly failed push setup

## The branch tracking bug

The `-w` flag creates branches with a `worktree-` prefix. The branch gets created from HEAD (master) and inherits `merge = refs/heads/master`. Even with `push.autosetupremote=True`, the push config gets fixed on first push but the **merge config is never overwritten** — it stays pointing at master.

Result: `git push` works fine, `git pull` silently merges master into your feature branch.

Fix: `branch.autoSetupMerge=simple` in gitconfig. Only affects new branches — existing ones need manual `git config branch.<name>.merge` fix.

## The cleanup problem

The exit prompt fires but only offers to delete the worktree — no warning about unmerged/unpushed work, no option to create a PR first. Combined with the tracking bug (branches that never got pushed properly), this means exit could nuke work with no trace.

## Worktrunk integration

`wt merge` does local rebase + fast-forward merge to master without touching origin. `wt step push` syncs to the main worktree's .git dir locally. The `git push` to github is always manual. This means the PR workflow requires explicit `git push` + `gh pr create` between `wt merge` and cleanup.

## Side discoveries

- Skills are path-resolved from cwd — worktrees don't have skills available (e.g. `/wrapup` breaks)
- Beads sqlite DB is per-worktree, starts empty — need `br sync --import-only` (filed as br-2d2)
- `EnterWorktree` tool is available even inside a worktree despite docs saying otherwise

## Verdict

The worktree feature is half-baked but usable with manual intervention. The key missing pieces are: proper branch tracking on creation, cleanup that warns about unmerged work, and a `wt hook` for beads sync.
