## Skogai-Routing Skill Summary

**Location**: `/home/skogix/docs/skills/skogai-routing/` (symlinked at `/skogai/.claude/skills/skogai-routing`)

### 1. What This Skill Does

The skogai-routing skill is a **meta-skill for creating other skills**. It provides a comprehensive framework and methodology for building effective AI skills using the "progressive disclosure" pattern. The skill teaches how to author domain-specific skills that guide Claude through complex workflows efficiently and intelligently.

Key capability: It routes users (or developers) through the skill creation process based on intent, asking clarifying questions only when necessary and providing templates, workflows, and reference documentation for consistent skill authoring.

### 2. Key Concepts and Patterns

**Core Philosophy - Trust the Agent**
- Skills are prompts, not scripts
- Agents are smarter than you think
- Be clear, direct, use XML
- Only add context agents don't have

**Router Pattern (for complex skills)**
```
SKILL.md → Essential principles + intake question + routing logic
├── workflows/ → Step-by-step procedures (FOLLOW)
├── references/ → Domain knowledge (READ)
├── templates/ → Output structures (COPY + FILL)
└── scripts/ → Reusable code (EXECUTE)
```

**Progressive Disclosure**
- Keep SKILL.md under 500 lines
- Split detailed content into reference files
- Claude loads only what's needed (scales token usage with complexity)
- Exponential coverage: 7 choices per level = 7³ = 343 combinations in ~3500 tokens

**Pure XML Structure** (not markdown headings)
- Semantic tags: `<objective>`, `<quick_start>`, `<success_criteria>`
- Better parsing, token efficiency, and Claude performance
- Consistent structure across all skills

**Degrees of Freedom Principle**
- High freedom for creative tasks (code review, analysis)
- Medium freedom for standard operations (API calls, data transformation)
- Low freedom for fragile operations (database migrations, payments)

### 3. How It's Meant to Be Invoked

Invoked as a **skill within the Skill tool**:

```bash
/skogai-routing
```

**Invocation patterns:**

1. **Direct intent recognition** (user provides clear context)
   - "Create new skill for X" → Routes to `workflows/create-new-skill.md`
   - "Audit this skill" → Routes to `workflows/audit-skill.md`
   - "Add workflow to existing skill" → Routes to `workflows/add-workflow.md`

2. **Menu-based routing** (if intent unclear)
   - Asks: "What would you like to do?"
   - Five main options: Create new, Audit/modify, Add component, Get guidance, Use routing patterns

3. **Progressive disclosure routing** (for complex domains)
   - First question narrows category (e.g., "Task-execution or domain expertise?")
   - Routes to appropriate specialized workflow

**Output**: Returns appropriate workflow files containing step-by-step procedures, required reading lists, and templates for consistent skill creation.

The skill also provides 10 core workflows (create-new-skill, audit-skill, add-workflow, etc.) and extensive reference documentation covering structure, principles, patterns, and best practices.
