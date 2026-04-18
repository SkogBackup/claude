---
name: capslock-md-router-pattern
description: All CAPSLOCK.md files are routers/indexes — one sentence per entry linking to detail files, never content themselves
type: feedback
originSessionId: a8a2e68f-c670-4486-b192-bb475a3e26bb
---

CAPSLOCK.md files (DECISIONS.md, GLOSSARY.md, PROJECTS.md, MEMORY.md, etc.) are always routers/indexes — one sentence per entry with a link to the detail file. They are overlays, not content.

**Why:** DECISIONS.md with full decision text would grow unbounded and lose scannability. The pattern is: DECISIONS.md = one-liner + link → `knowledge/decisions/yyyy-mm-dd-name.md` for deep context. Same as CLAUDE.md routing to sub-files.

**How to apply:** When creating or writing to a CAPSLOCK.md, write only index entries. Deep content goes in a dated or named file in the appropriate subdirectory.
