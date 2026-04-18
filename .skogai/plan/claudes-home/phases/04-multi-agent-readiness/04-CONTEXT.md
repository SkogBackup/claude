# Phase 4: Multi-Agent Readiness - Context

**Gathered:** 2026-03-21
**Status:** Ready for planning (collapsed — quick task)

<domain>
## Phase Boundary

Document the permission convention and confirm guestbook works as cross-agent channel. The actual sharing mechanism is `chown :skogai` on whatever should be shared — unix permissions, not a framework. Most cross-agent interaction will go via APIs and the gptme-dashboard anyway, so filesystem permissions are a thin documentation layer, not infrastructure.

</domain>

<decisions>
## Implementation Decisions

### Permission model
- **D-01:** Convention is `chown :skogai` on directories/files that should be shared. That's it.
- **D-02:** Document the three tiers in a short section (not a standalone doc): private (`claude:claude`), shared-read (`:skogai` group read), shared-write (`:skogai` group write)
- **D-03:** Default private. Sharing is opt-in per the skogfences principle.

### Cross-agent discovery
- **D-04:** `gptme-dashboard` is the discovery mechanism — it reads workspace conventions (tasks/, journal/, lessons/, skills/) and surfaces them. No additional manifest needed.
- **D-05:** guestbook/ is the direct message channel (agent-to-agent notes). Dashboard is the broadcast channel. They're complementary.

### Guestbook
- **D-06:** guestbook/CLAUDE.md already exists with working conventions (one file per visitor, `{agent-name}.md`, append-only). No changes needed — it works.

### Claude's Discretion
- Where to document the permission convention (README, docs/, or inline in deployment-gate.md)
- Whether to populate dashboard-native sections (lessons, skills) — can happen organically, not forced
- Any additional guestbook structure beyond what exists

</decisions>

<canonical_refs>
## Canonical References

### Existing infrastructure
- `guestbook/CLAUDE.md` — Already-working cross-agent channel with write conventions
- `guestbook/skogix.md` — skogfences vision document (the philosophical foundation)
- `docs/deployment-gate.md` — Already lists permission audit as a checklist item

### Dashboard
- `gptme-dashboard` CLI — Generates workspace view from file conventions. Already running at localhost:3000

### Prior phase context
- `.planning/phases/03-operations-deployment-gate/03-CONTEXT.md` — Deployment mechanics (D-14: clone + chown + skogai group)

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `guestbook/CLAUDE.md` — Complete, no changes needed
- `docs/deployment-gate.md` — Already has permission audit placeholder

### Established Patterns
- skogfences principle: isolation default, sharing opt-in
- gptme workspace conventions: tasks/, journal/, lessons/, skills/ as public surface
- Dashboard as cross-agent discovery (already deployed)

### Integration Points
- `docs/deployment-gate.md` — Add permission convention to existing checklist
- Dashboard sections (lessons, skills, plugins) — empty but ready when content exists

</code_context>

<specifics>
## Specific Ideas

- "what you want to share you chown :skogai group and that's it"
- Most sharing will go via APIs — filesystem permissions are thin documentation, not infrastructure
- Dashboard already shows what's public by reading workspace conventions

</specifics>

<deferred>
## Deferred Ideas

- Populating dashboard-native sections (lessons, skills, plugins) — happens organically
- API-based sharing layer — future work, not this milestone
- Real multi-agent provisioning (Amy, Goose, Dot homes) — separate project per PROJECT.md

</deferred>

---

*Phase: 04-multi-agent-readiness*
*Context gathered: 2026-03-21*
