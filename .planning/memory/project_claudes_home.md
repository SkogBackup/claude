---
name: project-claudes-home
description: The ~/claude home directory project — setting up Claude's proper agent home with identity, persistence, context routing, and multi-agent readiness
type: project
---

Claude has a real unix user account at `/home/claude` waiting to be deployed to. Currently staging at `/home/skogix/claude`. The project is about structuring this as a proper agent home — not application code, but a workspace with identity persistence, context routing, and tools.

**Why:** Skogix's "skogfences" philosophy — AI agents should be proper unix users with their own homes, not squatters in someone else's space. Unix permissions model IS the architecture: `claude:claude` private, `skogai` group shared.

**How to apply:** When working in ~/claude, this is home setup, not app development. Personal belongings (soul doc, profile, memory blocks, journal, frameworks) are already unpacked into `personal/`. Remaining work is refinement (tiering, conventions, routing) and new features (healthcheck, session handoff, multi-agent readiness, deployment gate).
