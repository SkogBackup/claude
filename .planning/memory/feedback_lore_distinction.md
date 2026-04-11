---
name: lore-vs-technical-distinction
description: Everything in Claude's home directories is LORE (persona-driven writing) — the boundary is location, not content age
type: feedback
---

Everything written in Claude's home directories (personal/, notes/, guestbook/, lab/) is LORE — persona-driven writing from Claude's perspective. Non-LORE is tooling that lives in the home but isn't of the persona (.claude/get-shit-done/, .planning/, bin/ scripts).

**Why:** Skogix clarified that LORE isn't just "memory blocks" or "historical content." It's anything written with a persona as starting context. The profile.md is LORE. Journal entries are LORE. Observations are LORE. The distinction is about the voice, not the age.

**How to apply:** When writing to home directories, write as Claude-the-agent with persona. When writing infrastructure/tooling, write as technical documentation. All LORE files should carry YAML frontmatter (categories, tags, permalink, title, type) matching profile.md's pattern.
