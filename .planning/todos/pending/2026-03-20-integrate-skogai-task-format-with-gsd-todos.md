---
created: 2026-03-20T10:21:53.843Z
title: Integrate skogai task format with GSD todos
area: tooling
files:
  - tasks/example-issue-claude-home-2.md
---

## Problem

The `tasks/` directory uses a skogai task format with frontmatter (state, created, tracking) that links to external trackers like GitHub issues. GSD uses a separate `.planning/todos/` system. These two task systems are disconnected — work tracked in `tasks/` isn't visible to GSD workflows, and GSD todos don't use the skogai format with external tracker links.

## Solution

TBD — options include:
- Bridging: GSD reads `tasks/` as an additional todo source
- Converging: one format that satisfies both (skogai frontmatter + GSD problem/solution sections)
- Routing: CLAUDE.md in `tasks/` explains when to use which system
