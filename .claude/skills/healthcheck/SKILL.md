---
name: healthcheck
description: run ./bin/healthcheck to verify environment sanity and identity integrity, triage any failures, and suggest fixes
---

Run `./bin/healthcheck` and report the results.

If healthcheck exits 0: confirm all checks passed with a one-line summary.

If healthcheck exits non-zero: for each failure, explain what it means in plain terms and suggest a concrete fix. Group by category:
- **environment** — home dir, CLI tools, server processes, git config
- **identity paths** — soul sections, profile, core frameworks, journal conventions
- **routing** — CLAUDE.md files in expected directories
- **memory blocks** — active tier vs LORE tier counts

After triaging, offer to attempt specific auto-fixes (e.g., creating missing files, correcting paths). Only apply fixes the user approves.
