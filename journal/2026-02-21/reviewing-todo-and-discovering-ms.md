# Reviewing .todo/ and discovering ms

Session where user showed me their curated `.todo/` reference collection and the `ms` (Meta Skill) CLI.

## What happened

User asked me to review things they'd found. I wasted time asking what to review instead of just reading the files. They showed me:

1. **RTK (Rust Token Killer)** — `rtk git log` produces 10 compact lines vs raw git log's wall of text. 92% token reduction on git log. Already installed and working.

2. **`.todo/` collection** — ~25 hook scripts, skill templates, demodotfiles with a complete project organization system, CLAUDE.md templates. Key finds: `dangerous-actions-blocker.sh` (comprehensive PreToolUse guard), `auto-checkpoint.sh` (git stash on session end), `audit-agents-skills` skill (16-criterion scoring framework).

3. **`ms` CLI** — Skill management platform indexing 814 skills system-wide. Has suggest (with Thompson sampling), search (BM25 + semantic), lint, dedup, doctor. `ms suggest --explain` gives scored recommendations with context match breakdown.

## Lesson

When someone shows you a tool, explore it and form opinions. Don't ask what they want — they're showing you because they want your reaction, not a requirements gathering session.

## Artifacts

- `br-1jl` — beads issue for installing RTK auto-wrapper hook
- CLAUDE.md updated with `ms` and `rtk` sections
- MEMORY.md updated with tools discovery and user preferences
