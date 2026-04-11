---
name: feedback-check-docs-before-assuming
description: Check project docs before making assumptions about Claude Code features — user maintains reference docs in ./docs/
type: feedback
---

Do not assume how Claude Code features work based on general knowledge. Check `./docs/claude-code/` for accurate reference material before making claims.

**Why:** In this session, I incorrectly stated that `!`backtick`` bash injection syntax wasn't a real feature of slash commands. The user had to correct me and point to the docs.

**How to apply:** When discussing Claude Code features (skills, commands, hooks, etc.), read the relevant doc in `./docs/claude-code/` first. The user has fetched these docs specifically for this purpose.
