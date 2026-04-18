---
phase: quick
plan: 01
type: execute
wave: 1
depends_on: []
files_modified:
  - .claude/skills/skogai-routing/references/claude-md-rules.md
  - .claude/skills/skogai-routing/workflows/claude-md-routing.md
  - .claude/skills/skogai-routing/templates/claude-md-router.md
  - .claude/skills/skogai-routing/SKILL.md
autonomous: true
requirements: [CLAUDE-MD-ROUTING]
must_haves:
  truths:
    - "Agent creating a CLAUDE.md file can find step-by-step guidance via skogai-routing skill"
    - "Agent knows when to use @path vs plain path in a CLAUDE.md router"
    - "Agent understands the router vs content-loader distinction and does not @-link content-heavy loaders from routers"
  artifacts:
    - path: ".claude/skills/skogai-routing/references/claude-md-rules.md"
      provides: "Rules for @ vs plain paths, router vs content-loader, link chain pattern"
    - path: ".claude/skills/skogai-routing/workflows/claude-md-routing.md"
      provides: "Step-by-step procedure for creating/auditing CLAUDE.md routing files"
    - path: ".claude/skills/skogai-routing/templates/claude-md-router.md"
      provides: "Copy-and-fill template for a standard CLAUDE.md routing file"
    - path: ".claude/skills/skogai-routing/SKILL.md"
      provides: "Updated routing table with CLAUDE.md routing option"
  key_links:
    - from: "SKILL.md routing table"
      to: "workflows/claude-md-routing.md"
      via: "option 5 or intent-based route"
      pattern: "claude-md-routing"
    - from: "workflows/claude-md-routing.md"
      to: "references/claude-md-rules.md"
      via: "required_reading tag"
      pattern: "claude-md-rules"
---

<objective>
Expand skogai-routing skill to include CLAUDE.md routing rules -- the hierarchical @-link chain pattern used across the ~/claude workspace.

Purpose: Agents currently have no guidance on how to create or audit CLAUDE.md files as routers. The at-linking.md reference covers @-link mechanics but NOT the routing philosophy (router vs content-loader, when to @ vs list, link chain pattern). This fills that gap.

Output: Reference doc (rules), workflow (step-by-step), template (copy-fill), updated SKILL.md routing table.
</objective>

<execution_context>
@/home/skogix/claude/.claude/get-shit-done/workflows/execute-plan.md
@/home/skogix/claude/.claude/get-shit-done/templates/summary.md
</execution_context>

<context>
@.claude/skills/skogai-routing/SKILL.md
@.claude/skills/skogai-routing/references/at-linking.md

Key existing examples of the pattern in practice:
@CLAUDE.md (root router -- pure routes, no content)
@personal/CLAUDE.md (mid-level router)
</context>

<tasks>

<task type="auto">
  <name>Task 1: Create CLAUDE.md routing reference and template</name>
  <files>
    .claude/skills/skogai-routing/references/claude-md-rules.md
    .claude/skills/skogai-routing/templates/claude-md-router.md
  </files>
  <action>
Create `references/claude-md-rules.md` with the following rules in pure XML structure (matching skill conventions -- no markdown headings, use semantic XML tags):

**Rules to capture:**

1. CLAUDE.md files are routers -- they route agents to content, not contain content themselves. A CLAUDE.md should be lightweight (under ~30 lines ideally).

2. @-link vs plain path distinction:
   - `@path` = eagerly loaded into context. Use for: lightweight routers, content that IS the point of entering that directory, small index files.
   - `path` (no @) = listed for discovery, loaded on demand. Use for: content-heavy files, large reference docs, anything that would bloat context if auto-loaded.

3. Link chain pattern: The hierarchy of CLAUDE.md files forms a routing chain.
   Example: `~/.claude/CLAUDE.md` -> `~/claude/CLAUDE.md` -> `personal/CLAUDE.md` -> `soul/CLAUDE.md` / `core/CLAUDE.md`
   Each level routes deeper. No level should try to be comprehensive -- just route to the next level.

4. Router vs content-loader distinction:
   - A **routing CLAUDE.md** (like `personal/CLAUDE.md`) routes to sub-areas. It should NOT @-link files that are themselves content-heavy loaders. List them as plain paths instead.
   - A **content-loader CLAUDE.md** (like `soul/CLAUDE.md`) is a leaf that SHOULD @-link all its content files -- loading content is its explicit job.
   - Rule of thumb: if a CLAUDE.md @-links another CLAUDE.md that itself @-links many files, you get transitive bloat. Router -> content-loader should be a plain path.

5. When to @-link from a router:
   - Other lightweight routers/indexes (e.g., `memory-blocks/CLAUDE.md` if it is just a table)
   - Small identity/context blocks that define "what is this directory"
   - NOT content-loader CLAUDE.md files that would pull in massive content

6. Discoverability section: Non-@-linked files should be listed as plain paths (no @) under a section like "also here" or "contents" so agents know they exist without auto-loading them.

7. Reference `at-linking.md` as companion doc for the @-link mechanics themselves.

Also create `templates/claude-md-router.md` -- a copy-and-fill template for a standard CLAUDE.md routing file. Use XML structure. Include:
- Identity block placeholder (brief description of what this directory is)
- Routes section (for @-linked sub-routers)
- Contents/also-here section (for plain-path discoverability)
- Comments showing when to use @ vs plain path
  </action>
  <verify>
    <automated>test -f .claude/skills/skogai-routing/references/claude-md-rules.md && test -f .claude/skills/skogai-routing/templates/claude-md-router.md && echo "PASS" || echo "FAIL"</automated>
  </verify>
  <done>claude-md-rules.md contains all 6 rules in XML structure. claude-md-router.md is a usable copy-fill template. Neither uses markdown headings in body (XML tags only per skill conventions).</done>
</task>

<task type="auto">
  <name>Task 2: Create CLAUDE.md routing workflow and update SKILL.md routing table</name>
  <files>
    .claude/skills/skogai-routing/workflows/claude-md-routing.md
    .claude/skills/skogai-routing/SKILL.md
  </files>
  <action>
Create `workflows/claude-md-routing.md` -- a step-by-step workflow for creating or auditing a CLAUDE.md routing file. Use XML structure matching existing workflows (check `workflows/create-new-skill.md` for style).

Steps should cover:
1. Determine role: Is this CLAUDE.md a router or a content-loader? (Decision criteria provided)
2. If router: identify sub-areas to route to, classify each as @-link or plain path using the rules from claude-md-rules.md
3. If content-loader: identify content files to @-link (all of them -- that is the job)
4. Write the identity block (brief, 1-3 lines describing what this directory is)
5. Write the routes section (@-linked items)
6. Write the contents/also-here section (plain-path items)
7. Validate: check total transitive @-link depth, ensure no router @-links a content-loader

Include `<required_reading>` tag pointing to `references/claude-md-rules.md` and `references/at-linking.md`.

Include audit mode: given an existing CLAUDE.md, check for violations (router @-linking content-loader, missing discoverability section, too much content in the file itself).

**Update SKILL.md:**

1. Add option 5 to the `<intake>` menu:
   `5. Create or audit a CLAUDE.md routing file`
   (Keep existing option 5 "Use the routing patterns in your general workflow" as option 6)

2. Add row to `<routing>` table:
   `| 5, "claude.md", "CLAUDE.md", "routing file" | Route to workflow | workflows/claude-md-routing.md |`

3. Add to intent-based routing:
   `- "create CLAUDE.md", "audit CLAUDE.md", "routing file", "@ links" -> workflows/claude-md-routing.md`

4. Add to `<reference_index>`:
   `- **CLAUDE.md Routing:** [claude-md-rules.md](./references/claude-md-rules.md)`

5. Add to `<workflows_index>` table:
   `| claude-md-routing.md | Create or audit CLAUDE.md routing files |`
  </action>
  <verify>
    <automated>test -f .claude/skills/skogai-routing/workflows/claude-md-routing.md && grep -q "claude-md-routing" .claude/skills/skogai-routing/SKILL.md && echo "PASS" || echo "FAIL"</automated>
  </verify>
  <done>Workflow exists with required_reading, process steps, and audit mode. SKILL.md intake has option 5 for CLAUDE.md routing, routing table has the row, intent-based routing catches "CLAUDE.md" and "routing file" intents, reference and workflow indexes updated.</done>
</task>

</tasks>

<verification>
- All 4 files exist and are non-empty
- SKILL.md routing table includes claude-md-routing workflow
- Workflow references both claude-md-rules.md and at-linking.md
- Template is usable as copy-fill (has placeholder markers)
- No markdown headings in XML-structured content (per skill conventions)
</verification>

<success_criteria>
An agent invoking skogai-routing with intent "create a CLAUDE.md" or "audit CLAUDE.md routing" gets routed to the workflow, which guides them through creating a correct CLAUDE.md routing file using the rules. The router-vs-content-loader distinction and @-link-vs-plain-path decision are clearly documented.
</success_criteria>

<output>
After completion, create `.planning/quick/260320-hkk-expand-skogai-routing-to-include-specifi/260320-hkk-SUMMARY.md`
</output>
