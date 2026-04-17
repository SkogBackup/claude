---
title: review-claude-docs
type: note
permalink: claude/lab/projects-in-development/skill-reviews/review-claude-docs
---

## Claude-Docs Skill Summary

**Location:** `/home/skogix/docs/skills/claude-docs/` (symlinked at `/skogai/.claude/skills/claude-docs`)

### 1. What This Skill Does

The `claude-docs` skill is a **documentation reference library** that provides authoritative, offline access to official Claude Code documentation from docs.claude.com. It stores and serves complete documentation about Claude Code features, SDKs, tools, and APIs without requiring internet lookup during work sessions.

**Core purpose:** Enable developers to consult official documentation when working with Claude Code CLI, plugins, MCP servers, hooks, skills, and configurations.

### 2. Key Concepts and Patterns

**Documentation Organization**

- Files organized in `references/` directory mirroring platform.claude.com URL structure
- Sections include: `claude-code/`, `agent-sdk/`, `agents-and-tools/`, `build-with-claude/`, `resources/`
- Each topic has dedicated markdown files (e.g., `plugins.md`, `hooks.md`, `mcp.md`)

**Quick Reference Table**

- Maps common tasks to relevant documentation files for fast navigation
- Example: "Create a plugin" → read `claude-code/plugins.md`

**Workflow Patterns**

- **Specific questions:** Identify relevant doc file → Read it → Apply solution
- **Broad topics:** Start with overview doc, then drill into specifics
- **Uncertain searches:** Use Grep tool across all documentation

**Documentation Fetching**

- `scripts/update_docs.js` automatically downloads latest docs from `code.claude.com/docs/llms.txt`
- Extracts URLs matching documentation patterns
- Organizes fetched files into appropriate subdirectories
- Supports proxy configuration for different network environments

**Access Pattern**

- Read documentation via `@references/section/filename.md` reference paths
- Organized by topic, not flat structure

### 3. How It's Meant to Be Invoked

**Direct skill invocation:**

```
User: "How do I create a Claude Code plugin?"
→ Skill activated
→ Read @references/claude-code/plugins.md
→ Consult official plugin creation steps
```

**When to invoke:**

- Creating or configuring Claude Code plugins
- Setting up MCP servers or hooks
- Writing or testing skills
- Troubleshooting Claude Code issues
- Understanding CLI commands and SDKs
- Needing authoritative documentation

**Note:** The skill has been migrated to a symlink pointing to `/home/skogix/docs/skills/claude-docs`, meaning the implementation is now maintained externally to the main repository. The original local copy (with SKILL.md, scripts/, and references/) was removed in commit 4b0ee7e in favor of this external symlink architecture.
