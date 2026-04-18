---
title: SKOGAI
type: note
permalink: claude/projects/dot-skogai/skogai
---

# SKOGAI.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# .skogai (dot-skogai)

\<what_is_this>

the projects knowledge base, memory system, project tracking, and quick capture. one place to see everything, remember everything, plan everything.

\</what_is_this>

<structure>

@knowledge/ # documented decisions, learnings, patterns @memory/ # session context, decision log @projects/ # project tracking and overview @inbox/ # quick capture @templates/ # starter templates for new content @scripts/ # argc-powered bash scripts

</structure>

<commands>

```bash
# Run bootstrap (for consumer projects using .skogai as submodule)
./scripts/bootstrap/bootstrap.sh

# Source helper functions in scripts
source "$(dirname "$0")/skogai-helper-functions.sh"
```

</commands>

<architecture>

**Modes of Operation:**

- **Dogfooding**: symlink `.skogai -> /home/skogix/.skogai` with `.git/info/exclude`
- **Consumer**: git submodule on project-specific branch

**Detection:**

```bash
file .skogai  # symbolic link = dogfooding, directory = submodule
file .git     # directory = real repo, ASCII text = submodule
```

**Script Framework:** Uses argc for declarative CLI definition:

```bash
# @describe script description
# @arg name![`_choice_validator`] Argument description
main() { ... }
eval "$(argc --argc-eval "$0" "$@")"
```

</architecture>

\<always_load>

- @CONTEXT.md - dynamically generated current context (workspace, git state, memory)

\</always_load>

<important>

**@ is source of truth.** The `@/path` syntax expands real files at prompt-time. Read tool often returns cached content. Always use `@` for files that must be current.

See @knowledge/lessons/2026-01-20-at-file-reference.md for details.

</important>

\<where_to_look>

| task                          | location                                               |
| ----------------------------- | ------------------------------------------------------ |
| log a decision                | knowledge/decisions/ + index in knowledge/DECISIONS.md |
| document a lesson             | knowledge/lessons/                                     |
| record architectural decision | knowledge/decisions/                                   |
| capture reusable pattern      | knowledge/patterns/                                    |
| track project status          | projects/overview.md                                   |
| quick capture                 | inbox/                                                 |
| create new content            | templates/                                             |

\</where_to_look>

\<content_creation>

to create new content, see @templates/CLAUDE.md for available templates:

- knowledge-entry.md for learnings and patterns
- project-status.md for project tracking files
- decision-record.md for architectural decisions

\</content_creation>
