#!/bin/bash

# ============================================================================
# dev: Development and version control utilities
# ============================================================================

# @env DEV_BASE_DIR=/home/skogix/dev/repos    Base directory for repositories
# @env WORKTREE_DIR=.worktrees                Subdirectory name for worktrees
# @env GITA_GROUP=repos                       Gita group name for active repos

# @cmd Development and version control utilities
dev() {
  :
}

# @cmd List repositories
# @option --type[=active|all]    Type of repos to list (active or all)
dev::list() {
  if [[ "$argc_type" == "all" ]]; then
    _choice_repository
  else
    _choice_active_repos
  fi
}

# @cmd Show status of all repositories
dev::status() {
  gita ll
}

# @cmd Clone and add a repository
# @arg repo![`_choice_repository`]    Repository to clone
dev::add() {
  gita clone --directory "$DEV_BASE_DIR" --group "$GITA_GROUP" -- "git@github.com:SkogAI/${argc_repo}.git"
}

# ============================================================================
# Choice functions
# ============================================================================

_choice_repository() {
  gh repo list SkogAI --limit 1000 --json name --jq '.[].name' | command cat
}

_choice_active_repos() {
  ls -1 "$DEV_BASE_DIR"
}

eval "$(argc --argc-eval "$0" "$@")"
