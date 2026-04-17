---
title: output
type: note
permalink: claude/lab/projects-in-development/claude-routing-via-claude-md-files/output
---

Based on the loaded context, here's what I can tell you:

1. **Projects in dev/**:

   - claude-plugins - plugins extending claude code functionality
   - skill-reviews - skill audit and review workflows
   - skogai-core-additions - workflow commands (plan, work, review, compound)
   - skogai-todo - taskwarrior-based todo management
   - skogdocs - documentation skill for domain/patterns/interfaces
   - skogfences - barrier/fence utilities for workflow control
   - web-setup-for-claude - web deployment and container setup

1. **tmp/ directory**: temporary files and context injection (specifically shows @tmp/context for context injection)

1. **scripts/**: utility scripts and automation (no specific scripts listed in the routing table)

1. **Configuration files in config/**:

   - claude/ - Claude-specific configuration directory
   - claude-settings.json - Claude Code settings
   - mcp.json - Model Context Protocol server configuration

1. **skogai-core-additions**: workflow commands system providing plan, work, review, and compound commands

1. **Taskwarrior-based todo management**: `skogai-todo` project, routing to @skogai-todo/HOWTO.md

1. **To work on workflow commands**: Navigate to skogai-core-additions, routing to @skogai-core-additions/CLAUDE.md

**Routing acknowledgment example**: If you asked "how does the plan command work in detail?" - I see it's part of skogai-core-additions from dev/, to understand the implementation I'd need to load @skogai-core-additions/CLAUDE.md

The routing table provides orientation without implementation details - exactly the progressive disclosure pattern you're testing.
