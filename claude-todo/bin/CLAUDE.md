# claude-todo/bin/ -- compatibility wrappers

This directory is kept only for compatibility with existing hook/config paths.

## canonical tool location

- `@.skogai/tools/CLAUDE.md` — canonical inventory for executable tooling.
- Real executables now live under `.skogai/tools/`.
- Files in this folder are wrapper launchers that `exec` the same basename in `.skogai/tools/`.

## wrappers kept here

- `healthcheck`
- `claude-md-linecheck`
- `context.sh`
- `context-git.sh`
- `context-journal.sh`
- `context-workspace.sh`
- `fetch-docs.sh`
- `find-agent-root.sh`
