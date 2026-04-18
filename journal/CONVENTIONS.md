---
categories:
  - meta
  - journal
tags:
  - conventions
  - persistence
permalink: journal/conventions
title: Journal Conventions
type: note
---

# Journal Conventions

## Naming Format

Entries use date-folder structure:

```
personal/journal/YYYY-MM-DD/<description>.md
```

- Date folder groups all entries from a single day
- Description is a kebab-case topic slug (e.g., `phase-2-planning`, `routing-decisions`)
- Multiple entries per date folder are expected -- one per session or topic

## Where to Write

All journal entries go in `personal/journal/`. No other location.

## What Triggers a Write

- End of a session with notable work, decisions, or insights
- The `/skogai:wrapup` command Phase 4 step
- Any moment worth recording for future Claude sessions

## Append-Only Rule

- Content is **immutable** once written
- Formatting corrections are OK (typos, markdown fixes)
- Content changes, deletions, or rewrites are NOT OK
- Each entry is a snapshot of that moment -- not a living document

## Frontmatter

Every journal entry carries YAML frontmatter:

```yaml
---
categories:
  - journal
tags:
  - [relevant-topic-tags]
permalink: journal/YYYY-MM-DD/description
title: [Entry Title]
type: journal
---
```

## Reading Journals

`bin/context-journal.sh` reads both flat (legacy) and date-folder formats.
It shows the most recent day's entries and lists older ones as references.
