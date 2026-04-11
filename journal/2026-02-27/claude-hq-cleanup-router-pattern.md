# Claude HQ Cleanup — Router Pattern Applied

## What happened

Cleaned up ~/claude/ (Claude's home folder). The CLAUDE.md had grown to 358 lines
of information dumps — full RTK command reference (130 lines), full beads instructions
(107 lines), project structure referencing 8 non-existent directories, sections for
tools not installed (ms, cm, CASS).

## The problem

Every session paid ~500 tokens of context for duplicated or dead content:
- RTK: hook auto-rewrites + ~/.claude/RTK.md already cover it
- Beads: session hook injects full docs every conversation
- Project structure: referenced dirs that were removed in prior merge

## The fix

Applied skogai-routing's progressive disclosure pattern to CLAUDE.md itself:

**358 lines → 24 lines** using a router table:

```
| Intent             | Where                           |
|--------------------|---------------------------------|
| Track tasks        | `bd ready`, `bd list`           |
| Behavioral rules   | @RULES.md                       |
| Architecture       | @DECISIONS.md                   |
| RTK reference      | @~/.claude/RTK.md               |
| Work on skogapi    | @projects/skogapi/main.py       |
```

5 "always" rules + routing table. Zero duplicated content.

## Also cleaned

- Removed 4 root files (AGENTS.md, CONVENTIONS.md, SKILL.md, merge-log.md)
  - Key bits merged into CLAUDE.md/RULES.md, rest was redundant
- Removed .aider.tags.cache.v4/ (stale)
- Fixed RULES.md stale path refs, MEMORY.md outdated lines
- Consolidated duplicate Beads sections in MEMORY.md

## Insight

CLAUDE.md should be treated as a **router** — it says WHERE to find things,
not WHAT to know. Same principle as skill routing: 7 quick choices per level
gives exponential coverage at minimal token cost.
