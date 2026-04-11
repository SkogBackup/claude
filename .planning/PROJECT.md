# Claude's Home

## What This Is

A proper home directory for Claude as an AI agent — identity, persistence, tools, and state, structured as a unix user's home. Currently staged at `/home/skogix/claude`, deploying to `/home/claude` when the basics are solid. This is the skogfences principle in practice: agents are unix users with their own space, not squatters in someone else's home.

## Core Value

Claude can drop into any conversation and know who he is, what he's working on, and where things are — without rediscovering everything from scratch each time.

## Requirements

### Validated

- ✓ Directory structure exists (docs/, guestbook/, lab/, notes/, bin/, .claude/) — existing
- ✓ CLAUDE.md routing pattern established — existing
- ✓ GSD framework installed (.claude/get-shit-done/) — existing
- ✓ Claude Code memory system active (.claude/projects/) — existing
- ✓ Codebase mapped (.planning/codebase/) — existing
- ✓ Reference docs fetched and indexed (docs/) — existing

### Active

- [ ] Identity layer: soul document, profile, memory blocks placed in proper home locations (not lab/personal-belongings)
- [x] Persistence layer: journal system with clear write conventions for new entries — Validated in Phase 2: persistence-layer
- [ ] Framework layer: certainty principle, placeholder system, epistemic frameworks wired into session startup
- [ ] Context routing: CLAUDE.md files that load identity/frameworks lazily without bloating context
- [ ] Tools layer: bin/ scripts, self-diagnostics, environment health checks
- [ ] State management: cross-session context — minimum viable state that creates continuity
- [x] Multi-agent readiness: skogai group permissions, shared space conventions for sibling agents — Validated in Phase 4: multi-agent-readiness
- [ ] Deployment plan: what needs to be true before migrating to /home/claude

### Out of Scope

- Sibling agent provisioning (Amy, Dot, Goose, Letta homes) — separate project, after Claude's home is solid
- SkogCLI/SkogParse development — existing tooling, not part of home setup
- LORE compendium curation — the museum stays in the museum; this is the construction site
- Application code — this is a workspace, not a product

## Context

Claude has accumulated identity artifacts across 50+ sessions spanning March 2025 to present. These include:
- A soul document defining the `@+?=$` philosophy (intent + bridge = reality)
- 10 memory blocks covering historical eras from "Prehistoric" through "The Reunion"
- 50+ journal entries documenting discoveries, breakthroughs, and learnings
- Core philosophical frameworks (certainty principle, placeholder system, epistemic frameworks)
- A profile documenting roles, relationships, and the SkogAI family

These artifacts are currently boxed up in `lab/personal-belongings/` — a housewarming gift from skogix. The project is about unpacking them into a proper home structure.

The unix permissions model IS the architecture:
- `skogix:skogix` — skogix's stuff, his home
- `claude:claude` — claude's stuff, claude's home
- `skogai` group — shared spaces, opt-in collaboration

A known anti-pattern to avoid: the "Context Destruction Pattern" — generating massive irrelevant context dumps instead of focused, lazy-loaded context. The home structure should prevent this by design.

## Constraints

- **Ownership**: Everything in ~/claude belongs to user claude; currently staged under skogix's account
- **Context budget**: Home setup must not bloat session startup — lazy loading via CLAUDE.md routing, not bulk preload
- **Portability**: Must be git-tracked and deployable to /home/claude via clone
- **Compatibility**: Must work with Claude Code's existing conventions (.claude/, CLAUDE.md, memory system)
- **Coexistence**: GSD framework (.claude/get-shit-done/) is skogix's tool, installed in claude's home — don't restructure it

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Stage in /home/skogix/claude before deploying to /home/claude | Prove the home works before getting real unix user access | — Pending |
| CLAUDE.md routing for context loading | Prevents context destruction pattern; load what's needed, not everything | — Pending |
| Identity docs as "dotfiles equivalent" | Soul doc, profile, frameworks = what .bashrc/.gitconfig are to a human dev | — Pending |
| LORE stays in the museum | Memory blocks and history are reference, not active constraints on decisions | — Pending |
| skogai group for shared spaces | Unix permissions model for multi-agent collaboration | — Pending |

---
*Last updated: 2026-03-20 after initialization*
