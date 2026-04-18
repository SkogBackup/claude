# Quick Task 260320-hkk: Expand skogai-routing with CLAUDE.md routing rules

**Completed:** 2026-03-20
**Status:** Done

## What was done

Added CLAUDE.md-specific routing guidance to the skogai-routing skill:

1. **references/claude-md-rules.md** — 6 rules for CLAUDE.md routing:
   - CLAUDE.md files are routers, not content
   - @-link vs plain path decision criteria
   - Link chain pattern (progressive disclosure via filesystem)
   - Router vs content-loader distinction (the critical rule)
   - When to @-link from a router
   - Discoverability section for non-@-linked files

2. **templates/claude-md-router.md** — Copy-fill template with identity block, routes section, contents section

3. **workflows/claude-md-routing.md** — Step-by-step for create and audit modes:
   - Determine router vs content-loader role
   - Classify items as @-link vs plain path
   - Write the CLAUDE.md
   - Validate the chain
   - Audit mode: 6 violation checks

4. **SKILL.md** — Updated with:
   - Option 5 in intake menu
   - Routing table row
   - Intent-based routing for "CLAUDE.md", "routing file"
   - Reference and workflow index entries

## Files changed

- `.claude/skills/skogai-routing/references/claude-md-rules.md` (new)
- `.claude/skills/skogai-routing/templates/claude-md-router.md` (new)
- `.claude/skills/skogai-routing/workflows/claude-md-routing.md` (new)
- `.claude/skills/skogai-routing/SKILL.md` (modified)
