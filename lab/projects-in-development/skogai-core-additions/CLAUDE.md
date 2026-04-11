# skogai-core-additions

workflow commands for the SkogAI ecosystem - systematic approaches to plan, work, review, and compound knowledge.

## what this is

command definitions that provide structured workflows for:

- `workflows:plan` - transform feature descriptions into actionable plans with research and context
- `workflows:work` - execute plans systematically with testing and quality checks
- `workflows:review` - exhaustive code reviews using parallel multi-agent analysis
- `workflows:compound` - document solved problems to compound team knowledge

## structure

```
workflows/
  plan.md       # planning workflow
  work.md       # execution workflow
  review.md     # review workflow
  compound.md   # documentation workflow
```

## design principles

**parallel by default**
- workflows launch multiple specialized agents simultaneously
- maximize speed through concurrent research, analysis, and review

**systematic execution**
- clear phases with specific tasks
- todo tracking throughout
- quality gates before completion

**knowledge persistence**
- document solutions in `docs/solutions/`
- create actionable todos in `todos/`
- searchable YAML frontmatter for future reference

**simplicity first**
- start minimal, expand only when needed
- follow existing patterns
- ship complete features over perfect process

## command format

all commands follow the structure:

```markdown
---
name: workflows:command-name
description: what it does
argument-hint: "[what user provides]"
---

[$skogai:command:workflows:command-name]

# command content

[$/skogai:command:workflows:command-name]
```

## usage

these commands are invoked through the SkogAI system with arguments:

```bash
workflows:plan "add user authentication"
workflows:work plan.md
workflows:review "PR #123"
workflows:compound "fixed n+1 query"
```

## integration points

- uses argc commands for environment setup
- integrates with worktree (wt) for git operations
- creates todos using file-todos skill
- leverages parallel task agents for speed
- follows certainty-principle for high-stakes decisions

## current state

re-introducing these workflows with focus on:
- routing and principles
- returning to "old skogai-way" of systematic execution
- parallel agent coordination
- knowledge compounding over repeated problem-solving
