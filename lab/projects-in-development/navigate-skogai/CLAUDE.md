---
title: CLAUDE
type: note
permalink: claude/lab/projects-in-development/navigate-skogai/claude
---

# navigate-skogai skill development

## what we're doing

Creating a routing skill that helps navigate the SkogAI ecosystem - projects, documentation, and configuration.

## approach

- **Placeholders over fabrication**: Use `[@todo]` markers instead of making up content
- **Incremental building**: Add reference files only as we verify what actually exists
- **Ask, don't assume**: Get information from user rather than guessing structure
- **File-safe naming**: `dash-skogai` for `/skogai`, `dot-skogai` for `.skogai`

## structure

- `skill/` - Symlink to actual skill at `../../.claude/skills/navigate-skogai/`
- This directory holds meta-knowledge, development notes, and context about the skill itself

## current state

Two reference files exist:

- `dash-skogai.md` - Navigation for `/skogai` (includes multi-agent architecture explanation)
- `dot-skogai.md` - Navigation for `.skogai` (includes historical context)

Content is being added incrementally through verified exploration.

## adding knowledge to the skill

**if you're here to add knowledge, read this first:**

### the catastrophic failure pattern (DON'T DO THIS)

1. "let me explore the filesystem and show you what I find"
1. create detailed documentation from `ls` and `cat` commands
1. fill skill with directory listings and surface-level descriptions
1. result: zero teaching value, just regurgitated file structure

### the correct pattern (DO THIS)

1. **ask user first**: "what should I know about X?"

   - user has design rationale, historical context, architectural intent
   - this is ALWAYS faster than exploring and guessing

1. **distinguish question types**:

   - design decisions/intent/history → ask user (they made the choices)
   - verifiable technical facts → can discover (permissions, group membership, etc.)

1. **real knowledge vs directory listings**:

   - "tmp is temp folder" = useless
   - "setgid enables multi-agent collaboration" = valuable
   - focus on WHY/HOW/WHEN, not WHAT/WHERE

1. **capture methodology**:

   - document HOW knowledge was discovered
   - include commands run, reasoning applied
   - see ANSWERS.md for examples

1. **use the question/answer workflow**:

   - add questions to QUESTIONS.md
   - when answered, move to ANSWERS.md with full context
   - update skill references with concise distillation

### remember

the skill grows from **verified knowledge through actual work**, not upfront speculation.
