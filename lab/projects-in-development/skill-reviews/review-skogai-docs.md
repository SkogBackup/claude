---
title: review-skogai-docs
type: note
permalink: claude/lab/projects-in-development/skill-reviews/review-skogai-docs
---

## Summary: skogai-docs Skill

**Location:** `/home/skogix/docs/skills/skogai-docs/` (symlinked at `/skogai/.claude/skills/skogai-docs`)

______________________________________________________________________

### 1. What This Skill Does

**Primary Purpose:** Automatically capture and document solved problems as searchable, categorized documentation with validated YAML frontmatter.

The skill creates a knowledge base of solutions by:

- Detecting when a problem is solved (via confirmation phrases or manual `/doc-fix` invocation)
- Gathering context from conversation history
- Validating the documentation against a schema
- Creating organized documentation in `docs/solutions/[category]/` with YAML frontmatter
- Offering post-documentation actions (promote to critical patterns, link related issues, create skills, etc.)

**Core Benefit:** Turns ad-hoc problem-solving into institutional knowledge that survives session restarts and is searchable across the team.

______________________________________________________________________

### 2. Key Concepts/Patterns

**7-Step Critical Sequence (Strict Execution Order):**

1. **Detect Confirmation** — Auto-trigger on phrases like "that worked", "it's fixed", or manual `/doc-fix`
1. **Gather Context** — Extract from conversation: module name, symptom, failed attempts, root cause, solution, prevention
1. **Check Existing Docs** — Search for similar issues; offer user choice to create new or update existing
1. **Generate Filename** — Sanitized format: `[symptom]-[module]-[YYYYMMDD].md`
1. **Validate YAML Schema** — BLOCKING gate enforces enum validation (problem_type, component, root_cause, resolution_type, severity)
1. **Create Documentation** — Populate using template from `assets/resolution-template.md` with validated YAML
1. **Cross-Reference & Detect Patterns** — Link related issues; suggest critical pattern promotion if 3+ similar issues exist

**YAML Frontmatter Structure:**

- **Required fields:** module, date, problem_type, component, symptoms (array), root_cause, resolution_type, severity
- **Optional fields:** rails_version, related_components, tags
- **Strict validation:** All enums must match schema.yaml exactly; validation blocks progression to Step 6

**Organized Documentation Format:**

- Single file per problem in category directory: `docs/solutions/[category]/[filename].md`
- YAML frontmatter at top for metadata/search
- Sections: Problem, Environment, Symptoms, What Didn't Work, Solution, Why This Works, Prevention, Related Issues
- Code examples show before/after with technical explanations

**Critical Pattern Detection:**

- When 3+ similar issues cluster (severity: critical, affects multiple modules, or foundational), promote to `docs/solutions/patterns/cora-critical-patterns.md`
- Uses critical-pattern-template.md format: ❌ WRONG vs ✅ CORRECT with technical "Why" and "Placement/Context"
- User decides via decision menu (Option 2)

**Decision Gate After Documentation:** Present 7 options post-completion:

1. Continue workflow (default)
1. Add to Required Reading (promote to critical patterns)
1. Link related issues (cross-reference)
1. Add to existing skill (attach to learning skill)
1. Create new skill (extract as new domain)
1. View documentation (display created doc)
1. Other (user-defined)

______________________________________________________________________

### 3. How It's Meant to Be Invoked

**Invocation Methods:**

- **Auto-trigger:** Detects confirmation phrases in conversation ("that worked", "it's fixed", "problem solved", "that did it")
- **Manual:** `/doc-fix` slash command or explicit skill invocation
- **Entry point:** Typically called via `/compound` command (primary interface)
- **Terminal skill:** Does not delegate to other skills; receives all needed context from conversation history

**Preconditions:**

- Problem must be solved (not in-progress)
- Solution must be verified working
- Critical context should be present in conversation history

**Non-Trivial Filter:**

- Only documents problems requiring multiple investigation attempts
- Skips trivial fixes (typos, syntax errors, obvious corrections)

**Context Requirements:**

- If critical info is missing (module name, exact error, stage, resolution), skill asks user and **blocks until details provided** (Step 2 blocking requirement)

______________________________________________________________________

### Current State in /skogai

**Note from /skogai/dev/skogai-docs/problems-and-ideas.md:** This skill was adapted from CORA (Rails project) but needs **skogai-specific schema customization**. The current schema.yaml uses Rails-focused enums (build_error, rails_model, etc.) that don't match skogai's domains (context_issue, skogcontext, git_integration, etc.). The `/skogai/docs/solutions/` directory doesn't exist yet, and there's discussion about whether the schema should live in the skill or be project-specific.
