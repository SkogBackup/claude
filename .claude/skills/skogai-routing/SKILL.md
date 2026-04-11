---
name: skogai-routing
description: Create routing skills using progressive disclosure. Route agents to knowledge through guided discovery, not information dumps. Use when building skills that show what's needed to find what's needed.
---

<essential_principles>

## How Skills Work

Skills are modular, filesystem-based capabilities that provide domain expertise on demand. This skill teaches how to create effective skills.

### 1. Trust the Agent

Skills are prompts, not scripts. Agents are smarter than you think. Be clear, direct, use XML. Only add context they don't have. Trust that with the right context the end result always follows.

### 2. SKILL.md Is Always Loaded

When a skill is invoked, Claude reads SKILL.md. Use this guarantee:

- The front-matter description is _vital_ and is what decides if the skill will be invoked to begin with.
- Essential principles and teachings go in the beginning third of the skill since that is what gets loaded as a first step. and if the routing is clear then the agent can leave the rest and continue the workflow.
- Workflow-specific content that explain _how_ to do something goes in workflows/
- Reusable knowledge which follows up and strengthens the skill after the routing has been completed.
- Scripts is almost always the best value add since it is a one cost up front for reusable code that can be executed as needed over and over.
- Make sure to create templates freely since they provide consistent output structures that can be copied and filled as needed. This is often the sole reason why agents choose to expand and improve skills themselves - if they have a template to follow then they can produce consistent results.

### 3. Router Pattern for Complex Skills

```
skill-name/
├── SKILL.md              # Router + principles
├── workflows/            # Step-by-step procedures (FOLLOW)
├── references/           # Domain knowledge (READ)
├── templates/            # Output structures (COPY + FILL)
└── scripts/              # Reusable code (EXECUTE)
```

SKILL.md asks "what do you want to do?" → routes to workflow → workflow specifies which references to read.

**When to use each folder:**

- **workflows/** - Multi-step procedures Claude follows
- **references/** - Domain knowledge Claude reads for context
- **templates/** - Consistent output structures Claude copies and fills (plans, specs, configs)
- **scripts/** - Executable code Claude runs as-is (deploy, setup, API calls)

### 4. Pure XML Structure

No markdown headings (#, ##, ###) in skill body. Use semantic XML tags:

```xml
<objective>...</objective>
<process>...</process>
<success_criteria>...</success_criteria>
```

Keep markdown formatting within content (bold, lists, code blocks).

### 5. Progressive Disclosure

SKILL.md under 500 lines. Split detailed content into reference files. Load only what's needed for the current workflow.

**The power of routing:** 7 quick choices per level = exponential coverage. 7¹ = 7, 7² = 49, 7³ = 343. Massive documentation coverage while using say 500 \* 7 = 3500 tokens to cover a "information space" of hundreds or thousand times the size it would take to manually search - as would be the alternative.
</essential_principles>

<intake>
What would you like to do?

1. Create new skill
2. Audit/modify existing skill
3. Add component (workflow/reference/template/script)
4. Get guidance
5. Create or audit a CLAUDE.md routing file
6. Use the routing patterns in your general workflow

If intent is clear from context, route directly. Otherwise, ask.
</intake>

<routing>
| Response | Next Action | Workflow |
|----------|-------------|----------|
| 1, "create", "new", "build" | Ask: "Task-execution skill or domain expertise skill?" | Route to appropriate create workflow |
| 2, "audit", "modify", "existing" | Ask: "Path to skill?" | Route to appropriate workflow |
| 3, "add", "component" | Ask: "Add what? (workflow/reference/template/script)" | workflows/add-{type}.md |
| 4, "guidance", "help" | General guidance | workflows/get-guidance.md |
| 5, "claude.md", "CLAUDE.md", "routing file" | Route to workflow | workflows/claude-md-routing.md |

**Progressive disclosure for option 1 (create):**

- Need to create a "Task-execution skill"? → workflows/create-new-skill.md
- Looking for "Domain expertise skill"? → workflows/create-domain-expertise-skill.md

**Progressive disclosure for option 3 (add component):**

- Workflow → workflows/add-workflow.md
- Reference → workflows/add-reference.md
- Template → workflows/add-template.md
- Script → workflows/add-script.md

**Intent-based routing (if user provides clear intent without selecting menu):**

- "audit this skill", "check skill", "review" → workflows/audit-skill.md
- "verify content", "check if current" → workflows/verify-skill.md
- "create domain expertise", "exhaustive knowledge base" → workflows/create-domain-expertise-skill.md
- "create skill for X", "build new skill" → workflows/create-new-skill.md
- "add workflow", "add reference", etc. → workflows/add-{type}.md
- "upgrade to router" → workflows/upgrade-to-router.md
- "create CLAUDE.md", "audit CLAUDE.md", "routing file", "@ links in CLAUDE.md" → workflows/claude-md-routing.md

**After reading the workflow, follow it exactly.**
</routing>

<quick_reference>

## Skill Structure Quick Reference

**Simple skill (single file):**

```yaml
---
name: skill-name
description: What it does and when to use it.
---
<objective>What this skill does</objective>
<quick_start>Immediate actionable guidance</quick_start>
<process>Step-by-step procedure</process>
<success_criteria>How to know it worked</success_criteria>
```

**Complex skill (router pattern):**

```
SKILL.md:
  <essential_principles> - Always applies
  <intake> - Question to ask
  <routing> - Maps answers to workflows

workflows/:
  <required_reading> - Which refs to load
  <process> - Steps
  <success_criteria> - Done when...

references/:
  Domain knowledge, patterns, examples

templates/:
  Output structures Claude copies and fills
  (plans, specs, configs, documents)

scripts/:
  Executable code Claude runs as-is
  (deploy, setup, API calls, data processing)
```

</quick_reference>

<reference_index>

## Domain Knowledge

All in `references/`:

- **Structure:** [recommended-structure.md](./references/recommended-structure.md), [skill-structure.md](./references/skill-structure.md)
- **Principles:** [core-principles.md](./references/core-principles.md), [be-clear-and-direct.md](./references/be-clear-and-direct.md), [use-xml-tags.md](./references/use-xml-tags.md)
- **Patterns:** [common-patterns.md](./references/common-patterns.md), [workflows-and-validation.md](./references/workflows-and-validation.md)
- **Assets:** [using-templates.md](./references/using-templates.md), [using-scripts.md](./references/using-scripts.md)
- **Advanced:** [executable-code.md](./references/executable-code.md), [api-security.md](./references/api-security.md), [iteration-and-testing.md](./references/iteration-and-testing.md)
- **CLAUDE.md Routing:** [claude-md-rules.md](./references/claude-md-rules.md), [at-linking.md](./references/at-linking.md)
  </reference_index>

<workflows_index>

## Workflows

All in `workflows/`:

| Workflow                         | Purpose                                           |
| -------------------------------- | ------------------------------------------------- |
| create-new-skill.md              | Build a skill from scratch                        |
| create-domain-expertise-skill.md | Build exhaustive domain knowledge base for build/ |
| audit-skill.md                   | Analyze skill against best practices              |
| verify-skill.md                  | Check if content is still accurate                |
| add-workflow.md                  | Add a workflow to existing skill                  |
| add-reference.md                 | Add a reference to existing skill                 |
| add-template.md                  | Add a template to existing skill                  |
| add-script.md                    | Add a script to existing skill                    |
| upgrade-to-router.md             | Convert simple skill to router pattern            |
| get-guidance.md                  | Help decide what kind of skill to build           |
| claude-md-routing.md             | Create or audit CLAUDE.md routing files            |

</workflows_index>

<yaml_requirements>

## YAML Frontmatter

Required fields:

```yaml
---
name: skill-name # lowercase-with-hyphens, matches directory
description: ... # What it does AND when to use it (third person)
---
```

Name conventions: `create-*`, `manage-*`, `setup-*`, `generate-*`, `build-*`
</yaml_requirements>

<success_criteria>
A well-structured routing skill:

- Routes based on intent, not forced menu navigation
- Trusts the agent to understand and detect clear asks
- Keeps SKILL.md under 500 lines (progressive disclosure)
- Uses pure XML structure (semantic, not decorative)
- Provides the right tool for the job, then gets out of the way
- Has been tested with real usage and actually helps
- Grows organically as new patterns emerge
- Improves over time by naturally showing the most used paths
  </success_criteria>
