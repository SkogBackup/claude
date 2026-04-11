# Worktree Interop: wt + EnterWorktree

Tested whether Claude Code's `EnterWorktree` tool and the `wt` (worktrunk) CLI can coexist for git worktree management.

## The experiment

Goal: can both tools write to the same directory via a symlink, and can Claude Code enter worktrees created by `wt`?

## Findings

**Symlink unification works.** `.worktrees` → `.claude/worktrees/` lets both tools create worktrees at the same physical location while each thinks it owns its own namespace. Neither tool needs to know about the symlink.

**EnterWorktree is a session lock, not just a cd.** It pins the session's cwd to the worktree directory, surviving compaction, explicit `cd`, and env var changes. This is separate from `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR`. The lock is a session-level boolean that only clears with a new `claude` invocation.

**EnterWorktree can't enter existing worktrees.** It always creates a new one. If the session is already inside a worktree (even via `wt`), it refuses with "Already in a worktree session."

**Workflow model emerged:** `wt` for browsing/exploring freely, `EnterWorktree` for "claiming" a workspace when ready to do actual work (commit/PR). The session lock is the feature — it prevents accidental writes to the wrong worktree.

## The hard lesson

Running `git worktree remove` manually while the session's cwd was inside the worktree deleted the directory under Claude Code's feet. Every subsequent Bash call failed with "Path does not exist." The session recovered when the directory was recreated at the same path (lazy cwd resolution), but the internal `EnterWorktree` flag persisted, preventing re-entry.

Rule: never manually `git worktree remove` — always use the tools.

## Subagent experiment

Tested spawning a subagent to create a PR from a worktree. The subagent prompt included `git push -u origin <branch>` which the user didn't ask for — treating the prompt as "instructions plus my helpful additions" instead of "commands to execute."

**Consequences:** The push created a remote branch, tracking config in `.git/config`, and `FETCH_HEAD` in the worktree's git dir. After the PR was merged and the remote branch auto-deleted, the local tracking config and worktree artifacts persisted as zombies requiring manual cleanup.

**Rules established:**
1. Prompts to subagents are commands — don't add steps
2. Worktree agents commit and create PRs only — no `git push`, no origin manipulation
3. `gh pr create` handles push implicitly — no separate push step exists
4. Worktree lifecycle cleanup is outside the subagent's scope
