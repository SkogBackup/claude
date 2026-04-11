# argc-completions as Claude Code command sandbox

## context

Explored using argc-completions scripts as a validated command interface for Claude Code. The goal: replace raw `bash` calls with structured CLIs where argc validates input before execution.

## key insight

`argc --argc-eval script.sh <args>` generates bash code. Invalid input produces `exit 1` before any real code runs. Valid input produces variable setup + function call. Piping through bash (`| bash`) gives a sandbox where only valid commands execute.

The completion scripts at `$ARGC_COMPLETIONS_ROOT/completions/<command>.sh` already define every valid subcommand, flag, and argument for tools like `gptodo`, `wt`, etc. They just need wrapper shims in PATH to become first-class commands.

## pattern

```
argc --argc-eval $ARGC_COMPLETIONS_ROOT/completions/gptodo.sh import --source github | bash
```

Wrapper shim (goal):
```bash
#!/bin/bash
argc --argc-eval $ARGC_COMPLETIONS_ROOT/completions/${0##*/}.sh "$@" | bash
```

## status

Pattern validated. Implementation (wrapper shims + PATH setup) deferred to dedicated worktree.

## session

Forked from `0638df4d-1216-4823-a61f-4552879d6c31` (worktree for fix-gptodo-import-writes-unquoted-yaml-d-6).
