# dev/ - Projects in Development

<what_is_this>
Active development projects extending SkogAI functionality - workflow commands, skills, plugins, and tooling.
</what_is_this>

<projects>
- ./claude-plugins/ - plugins extending claude code functionality
- ./skill-reviews/ - skill audit and review workflows
- ./skogai-core-additions/ - workflow commands (plan, work, review, compound)
- ./skogai-todo/ - taskwarrior-based todo management
- ./skogdocs/ - documentation skill for domain/patterns/interfaces
- ./skogfences/ - barrier/fence utilities for workflow control
- ./web-setup-for-claude/ - web deployment and container setup
</projects>

# Argcfile.sh - Repository Management Workflow

<what_is_this>
Argc-based CLI for managing SkogAI repositories with gita and worktree (wt) integration.
Located at /home/skogix/dev/Argcfile.sh
</what_is_this>

<environment>
DEV_BASE_DIR=/home/skogix/dev/repos    # Base directory for cloned repositories
WORKTREE_DIR=.worktrees                # Subdirectory name for worktrees within each repo
GITA_GROUP=repos                       # Gita group name tracking active repos
</environment>

<available_commands>
argc dev list                          # List active repos (directories in DEV_BASE_DIR)
argc dev list --type=all               # List all SkogAI repos from GitHub
argc dev status                        # Show gita status of all tracked repos
argc dev add <repo>                    # Clone repo from SkogAI and add to gita group
</available_commands>

<workflow>
The workflow integrates three tools:
1. gita - Multi-repository management (tracking, batch operations)
2. wt (worktrunk) - Git worktree management with .worktrees/ convention
3. argc - CLI framework for clean command interface

Repositories are:
- Cloned to /home/skogix/dev/repos/<repo-name>/
- Tracked in gita group "repos"
- Worktrees created in <repo>/.worktrees/<branch>/ using wt

Example worktree workflow (manual for now):
cd /home/skogix/dev/repos/<repo>
wt switch --create feature-branch      # Creates .worktrees/feature-branch/
wt remove                              # Removes worktree, switches back to main
</workflow>

<current_state>
Working:
- Repository listing (local and GitHub)
- Repository cloning via argc dev add
- Gita tracking and status display
- Worktree creation using wt (manual)

Active repos in DEV_BASE_DIR:
- dev (example empty repo)
- lore
- docs (shows as repos/docs in gita due to name collision)
- skogix

Known issues:
- Gita name collision: docs shows as "repos/docs" because there's an existing "docs" entry in gita from another location
- Need to investigate gita rename or clean up duplicate entries
</current_state>

<next_steps>
Potential commands to add:
- argc dev start <repo> <branch>     # Clone if needed, create worktree, switch to it
- argc dev finish                    # Remove current worktree, merge if desired
- argc dev remove <repo>             # Remove repo from tracking and filesystem
- argc dev cd <repo>                 # Print path for cd navigation

Note: Claude Code doesn't persist directory changes across Bash calls, so directory switching
commands need special handling (print path for eval, or document manual workflow).
</next_steps>
