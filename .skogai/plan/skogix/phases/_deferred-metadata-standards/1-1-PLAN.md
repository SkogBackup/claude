---
title: 1-1-PLAN
type: note
permalink: claude/projects/dot-skogai/plan/phases/deferred-metadata-standards/1-1-plan
---

# PLAN: Component Metadata Standards

## Objective

Define consistent metadata schemas for all 5 component types (agents, commands, skills, hooks, MCP servers) to enable discovery, filtering, and validation across the marketplace.

## Execution Context

- Phase: 1 of 4 (Component Metadata Standards)
- Depends on: Nothing (first phase)
- Research Required: Unlikely (internal patterns - extending existing marketplace.json)

## Context

### Current State

The marketplace has 5 component types with inconsistent metadata:

| Component       | Current Metadata                                | Location             | Gaps                                |
| --------------- | ----------------------------------------------- | -------------------- | ----------------------------------- |
| **Agents**      | name, description, tools, model                 | YAML frontmatter     | No version, tags, category          |
| **Commands**    | name, description, argument-hint, allowed-tools | YAML frontmatter     | No version, tags, category          |
| **Skills**      | name, description (some have extended metadata) | SKILL.md frontmatter | Inconsistent across sources         |
| **Hooks**       | matcher, hooks[].type, hooks[].command          | marketplace.json     | No name, description, version       |
| **MCP Servers** | command, args, url                              | marketplace.json     | No name, description, version, tags |

### Target State

All components share a **common metadata core** plus **type-specific fields**:

```yaml
# Common Core (required for all)
name: string          # kebab-case identifier
description: string   # Third-person description ("This X should be used when...")
version: semver       # e.g., "1.0.0"
tags: string[]        # For filtering and discovery
category: string      # Primary classification

# Common Core (optional)
author: string        # Creator name
license: string       # e.g., "MIT"
dependencies: string[] # Other components this depends on
```

### Architectural Decision

**Curation over scale**: Every component must work reliably. Metadata validation ensures quality.

## Tasks

### Task 1: Design Metadata Schemas

**Goal**: Define JSON Schema for each component type

**Steps**:

1. Create `.skogai/schemas/` directory for schema files
1. Create `common.schema.json` with shared fields
1. Create type-specific schemas:
   - `agent.schema.json` - extends common + tools, model
   - `command.schema.json` - extends common + argument-hint, allowed-tools
   - `skill.schema.json` - extends common + references, scripts, assets, frameworks
   - `hook.schema.json` - extends common + events[], matcher
   - `mcp-server.schema.json` - extends common + command, args, url, transport

**Deliverables**:

- [ ] `.skogai/schemas/common.schema.json`
- [ ] `.skogai/schemas/agent.schema.json`
- [ ] `.skogai/schemas/command.schema.json`
- [ ] `.skogai/schemas/skill.schema.json`
- [ ] `.skogai/schemas/hook.schema.json`
- [ ] `.skogai/schemas/mcp-server.schema.json`

**Checkpoint**: All 6 schema files created and valid JSON Schema syntax

### Task 2: Document Metadata Standards

**Goal**: Create comprehensive documentation for component authors

**Steps**:

1. Create `docs/metadata-standards.md` with:
   - Overview of metadata system
   - Common fields reference (table)
   - Type-specific fields for each component
   - Examples for each component type
   - Validation requirements
   - Migration guide for existing components
1. Add links to schemas for programmatic validation

**Deliverables**:

- [ ] `docs/metadata-standards.md` complete
- [ ] Examples for all 5 component types
- [ ] Migration instructions for existing components

**Checkpoint**: Documentation readable and complete with all examples

### Task 3: Update Existing Core Components

**Goal**: Add metadata to skogai-core components as reference implementations

**Steps**:

1. Update `.claude/agents/code-simplicity-reviewer.md`:
   - Add version, tags, category to frontmatter
1. Update `.claude/commands/workflows/*.md` (4 files):
   - Add version, tags, category to each
1. Update `.claude/skills/skogai-*/SKILL.md` (8 skills):
   - Add version, tags, category where missing
1. Document hook metadata in marketplace.json (9 hooks):
   - Add descriptive names and versions to hook entries
1. Document MCP server metadata in marketplace.json (1 server):
   - Add description, version, tags to MCP entry

**Deliverables**:

- [ ] 1 agent updated with new metadata
- [ ] 4 workflow commands updated
- [ ] 8 skills verified/updated with metadata
- [ ] 9 hooks documented in marketplace.json
- [ ] 1 MCP server documented in marketplace.json

**Checkpoint**: All skogai-core components have complete metadata

### Task 4: Create Category Taxonomy

**Goal**: Define standard categories for component discovery

**Steps**:

1. Create `.skogai/schemas/categories.json`:
   - Agent categories: review, research, workflow, meta, docs
   - Command categories: workflows, utility, integration
   - Skill categories: development, architecture, workflow, domain
   - Hook categories: lifecycle, automation, integration
   - MCP categories: database, development, browser, api
1. Document category definitions and usage in `docs/metadata-standards.md`

**Deliverables**:

- [ ] `.skogai/schemas/categories.json` with all category definitions
- [ ] Category documentation added to metadata-standards.md

**Checkpoint**: Categories defined and documented

### Task 5: Create Validation Script

**Goal**: Enable automated metadata validation

**Steps**:

1. Create `scripts/validate-metadata.sh`:
   - Accept component path as argument
   - Detect component type from location
   - Load appropriate schema
   - Validate YAML frontmatter against schema
   - Report errors/warnings
1. Add to Argcfile.sh as `argc validate <path>`
1. Document usage in metadata-standards.md

**Deliverables**:

- [ ] `scripts/validate-metadata.sh` functional
- [ ] Argcfile.sh updated with validate command
- [ ] Validation documented

**Checkpoint**: `argc validate .claude/agents/code-simplicity-reviewer.md` succeeds

## Verification

After completing all tasks, verify:

1. **Schema completeness**: All 6 schemas exist and are valid JSON Schema
1. **Documentation quality**: `docs/metadata-standards.md` has examples for all component types
1. **Reference implementations**: All skogai-core components have complete metadata
1. **Validation works**: `argc validate` correctly validates a sample component
1. **No regressions**: Existing functionality unchanged (run `argc status`)

## Success Criteria

- [ ] JSON Schema files created for all 5 component types + common base
- [ ] Documentation complete with migration guide
- [ ] All skogai-core components updated as reference implementations
- [ ] Category taxonomy defined
- [ ] Validation script functional
- [ ] No breaking changes to existing components

## Output

**Created files**:

```
.skogai/schemas/
├── common.schema.json
├── agent.schema.json
├── command.schema.json
├── skill.schema.json
├── hook.schema.json
├── mcp-server.schema.json
└── categories.json

docs/
└── metadata-standards.md

scripts/
└── validate-metadata.sh
```

**Updated files**:

- `.claude/agents/code-simplicity-reviewer.md`
- `.claude/commands/workflows/*.md` (4 files)
- `.claude/skills/skogai-*/SKILL.md` (8 skills)
- `.claude-plugin/marketplace.json` (hooks and MCP metadata)
- `Argcfile.sh` (validate command)

## Next Phase

Phase 2 (Discovery Interface) depends on this metadata schema to enable:

- `/garden discover` command with filters (type, tags, search)
- Component detail view
- Installation hints/prompts

## Estimated Scope

- **Task 1**: ~6 files (schemas)
- **Task 2**: ~1 file (documentation)
- **Task 3**: ~14 files (component updates)
- **Task 4**: ~1 file (categories)
- **Task 5**: ~2 files (script + Argcfile update)

**Total**: ~24 file changes, 5 discrete tasks
