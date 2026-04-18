---
title: linear-setup-and-dot-skogai-migration
type: note
permalink: claude/personal/journal/2026-04-17/linear-setup-and-dot-skogai-migration
---

# Linear setup and dot-skogai migration plan

**Session:** 2026-04-17

## What happened

Skogix had merged local task files from two repos (`SkogAI/claude` and `SkogAI/dot-skogai`) into `tasks/` and wanted real, organized GitHub issues. Mid-session the goal shifted: instead of GitHub issues, Linear was activated as the single canonical tracker.

Linear was essentially empty (just onboarding stubs, all canceled). Clean slate.

## Decision: dot-skogai → .skogai/

The key architectural decision: `SkogAI/dot-skogai` is being deprecated. All its content (shared agent infrastructure, scripts, skills, templates, etc.) migrates into `SkogAI/claude` under the `.skogai/` directory.

**Why this makes sense:** The skogfences principle — agents are unix users, their shared household infrastructure belongs in the shared home. `.skogai/` in claude's repo _is_ that home. A separate repo was a layering violation.

## What was created

21 Linear issues (SKO-154–176) organized into 3 epics + 1 standalone bug:

- **SKO-154** Epic: Claude's Home v2.0 (Phase 5 chat-io, ecosystem integration, docs)
- **SKO-155** Epic: Migrate dot-skogai → .skogai/ (12 child issues, one per directory/component)
- **SKO-156** Epic: skogai-git orchestrator skill (worktrunk + gptodo + orchestrator)
- **SKO-176** fix(gptodo): unquoted YAML dates bug

The `tasks/` files and GitHub issues in both repos are now deprecated. Linear is source of truth.

## Reflection

The session showed a clean pattern: import chaotic task state → ask one clarifying question → create structured issues in parallel. The Linear MCP made this frictionless — 21 issues in two batches.
