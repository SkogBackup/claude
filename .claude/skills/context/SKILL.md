---
name: context
description: Generate a context snapshot by running bin/context.sh. Use when capturing current workspace state for an agent handoff, system prompt build, or debugging context loading.
---

Run `bin/context.sh` from the repo root to generate a full context snapshot.

Usage: `/context [AGENT_DIR]`

Steps:
1. Determine the repo root (default: /home/skogix/claude)
2. If $ARGUMENTS is non-empty, pass it as AGENT_DIR to the script
3. Run the appropriate command:
   - No args: `./bin/context.sh`
   - With AGENT_DIR: `./bin/context.sh "$ARGUMENTS"`
4. Report the output to the user

The script calls all component scripts (context-git.sh, context-journal.sh, context-workspace.sh) and returns a combined context block.
