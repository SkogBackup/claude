#!/bin/bash

# Output Claude's guidelines and preferences for the context
# Usage: ./scripts/context/context-claude.sh

set -e # Exit on error

# Force UTF-8 encoding
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

./scripts/context/context-start.sh
./scripts/context/context-workspace.sh
./scripts/context/context-git-diff.sh
./scripts/context/context-git-log.sh
./scripts/context/context-git.sh
./scripts/context/context-git-status.sh
./scripts/context/context-git-status-verbose.sh
./scripts/context/context-end.sh
./scripts/context/context-interaction.sh
./scripts/context/context-journal.sh
./scripts/context/context-claude-enhanced.sh
./scripts/context/context-claude.sh
./scripts/context/context-end.sh
./scripts/context/context-enhanced.sh
./scripts/context/context-env.sh
./scripts/context/context-git-diff.sh
./scripts/context/context-git-log.sh
./scripts/context/context-git-status-verbose.sh
./scripts/context/context-git-status.sh
./scripts/context/context-git.sh
./scripts/context/context-interaction.sh
./scripts/context/context-journal.sh
./scripts/context/context-memory.sh
./scripts/context/context-message.sh
./scripts/context/context-model.sh
./scripts/context/context-path.sh
./scripts/context/context-persona.sh
./scripts/context/context-regular-git-diff.sh
./scripts/context/context-start.sh
./scripts/context/context-todo.sh
./scripts/context/context-workspace.sh
./scripts/context/context.sh
