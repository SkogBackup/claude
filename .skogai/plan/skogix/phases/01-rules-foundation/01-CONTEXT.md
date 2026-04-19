---
title: 01-CONTEXT
type: note
permalink: claude/projects/dot-skogai/plan/phases/01-rules-foundation/01-context
---

# Phase 1: Rules Foundation - Context

**Gathered:** 2026-01-09 **Status:** Ready for planning

<vision>
## How This Should Work

A validation layer that catches bloat after generation. The rules framework acts as a post-generation review system that enforces simplicity through pruning and straight-up rules that prevent unnecessary file creation.

Think of it as quality gates for AI output — checking whether new files should exist at all, measuring percentage of filler documentation and removing it, and blocking the creation of bloat before it lands in the codebase.

</vision>

<essential>
## What Must Be Nailed

- **Rules that prevent file creation bloat** - The core focus is blocking unnecessary documentation and redundant files from being created in the first place. This is THE most important part.

</essential>

<boundaries>
## What's Out of Scope

- Code implementation quality rules - Not checking code patterns, just file/documentation bloat
- Enforcement mechanisms - Just define the rules, enforcement comes later
- Automated pruning tools - Detection only, not automated removal/refactoring

All three of these are explicitly deferred to future work.

</boundaries>

<specifics>
## Specific Ideas

No specific requirements - open to standard approaches for defining and structuring the rules.

</specifics>

<notes>
## Additional Context

The validation layer concept suggests a review-based approach where rules are applied after Claude generates output but before it's finalized. The emphasis on "straight up rules" and quantifiable metrics (like "percentage of filler-documentation") indicates a preference for clear, enforceable criteria over subjective judgments.

The scope exclusions clarify this is phase 1 of a larger system — define the rules first, build enforcement and tooling later.

</notes>

______________________________________________________________________

*Phase: 01-rules-foundation* *Context gathered: 2026-01-09*
