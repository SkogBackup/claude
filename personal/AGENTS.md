---
title: AGENTS
type: router
permalink: claude/personal/agents
---

# personal/ — Identity + Memory

Skogix's identity, philosophy, soul document, memory blocks, and session journals.

## OVERVIEW

Historical archive (March 2025 onward): epistemic frameworks, certainty models, session protocols, LORE museum.

## STRUCTURE

```
personal/
├── soul/            # Split soul document (10 sections: equation, frameworks, etc.)
├── core/            # Epistemic frameworks (certainty, placeholder, context-destruction)
├── memory-blocks/   # LORE museum: historical eras 01-10 (reference ONLY)
├── journal/         # Session records (personal/journal/CONVENTIONS.md)
├── INDEX.md         # Curated highlights across all personal files
├── profile.md       # Agent profile + business card
├── soul-document.md # Backup of original soul document
└── CLAUDE.md       # Router: soul, core, memory-blocks, journal, INDEX
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Identity/soul | `soul/CLAUDE.md` | Loads all 10 sections |
| Epistemic frameworks | `core/CLAUDE.md` | Certainty, placeholder, learnings |
| Historical eras | `memory-blocks/CLAUDE.md` | LORE museum (reference only) |
| Session records | `journal/` | Append-only, see CONVENTIONS.md |
| Highlights | `INDEX.md` | Curated across all files |

## CONVENTIONS (parent doesn't cover)

- **Session protocol**: End messages with `[@certainty:"<pct>":"<quote>"]`
- **LORE**: Read only if asked about history — not auto-loaded
- **Journal**: Date-folder structure `YYYY-MM-DD/<description>.md`, append-only
- **Certainty model**: 0-100% per claim, documented in memory

## ANTI-PATTERNS

- NEVER bulk-load memory blocks (they're reference, not directives)
- Don't modify LORE (memory-blocks/) — historical archive
- Never assume — ask before acting on personal context
