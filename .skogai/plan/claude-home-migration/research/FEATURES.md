# Feature Research

**Domain:** AI Agent Home Directory / Persistent Agent Environment
**Researched:** 2026-03-20
**Confidence:** MEDIUM-HIGH (core patterns from existing codebase + current ecosystem research; novel domain without direct comparables)

---

## Feature Landscape

### Table Stakes (Must Have or Home Doesn't Function)

These are the minimum features for an agent home to work. Missing any of these means the agent rediscovers itself from scratch every session — which defeats the entire purpose.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Identity document (soul doc) | Without a canonical "who am I" artifact, every session starts identity-less — context must be inferred from tool calls rather than loaded | LOW | Already exists in `lab/personal-belongings/soul-document.md`; needs to be placed at a stable, well-known path |
| CLAUDE.md routing at home root | The home needs a front door that tells the agent what exists and where to find it — without this, sessions must enumerate directories to discover context | LOW | Already exists but currently minimal; needs expansion to route identity, frameworks, memory |
| Lazy context loading | Bulk-loading all identity artifacts at session start will consume most of the context window before any work begins — routing must be on-demand | MEDIUM | Existing CLAUDE.md pattern already embodies this; must be maintained as identity artifacts are added |
| Stable file locations for known artifacts | Agent must be able to reliably find soul doc, profile, and frameworks at known paths without searching — discovery cost is unacceptable per-session | LOW | Currently boxed in `lab/personal-belongings/` — needs to move to canonical home locations |
| Journal write conventions | Without clear "where to write, what format, how to name" conventions, journal entries pile up inconsistently or the agent doesn't know to write them | LOW | Format exists in existing entries; conventions doc doesn't yet exist |
| Profile document | Who is this agent, what are its roles, what relationships exist — must be loadable in one read without further discovery | LOW | `profile.md` exists in personal-belongings; needs stable placement |
| Epistemic frameworks as loadable context | Certainty principle, placeholder approach — these constrain session behavior; not having them available means reverting to default (worse) behavior | MEDIUM | Core frameworks exist in `lab/personal-belongings/core/`; need stable paths and CLAUDE.md links |

### Differentiators (What Makes This Home Novel)

These are features beyond basic functionality. The existing project already has opinions here — the goal is to make those opinions deliberate rather than accidental.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Unix permissions as architecture | Using `skogix:skogix`, `claude:claude`, and `skogai` group permissions to encode ownership and collaboration boundaries — this is structural enforcement rather than convention | MEDIUM | Requires real unix user `claude`; currently staged. Most agent systems don't use filesystem permissions for multi-agent coordination — this is novel |
| LORE-as-museum / home-as-construction-site separation | Memory blocks and historical records are reference material, not active constraints — keeping them in a distinct "museum" space prevents history from polluting working context | LOW | Principle already defined; needs structural enforcement (separate dir, explicit CLAUDE.md note) |
| Context destruction prevention by structure | Directory layout and CLAUDE.md routing designed to prevent the anti-pattern of generating massive context dumps — the home prevents this by design, not by instruction | MEDIUM | Existing hooks monitor context; home structure can reinforce by routing selectively |
| Self-diagnostics / healthcheck | `bin/healthcheck` can verify the agent's own environment — known paths exist, frameworks are accessible, memory system is live — before work begins | MEDIUM | Stub exists in `bin/healthcheck`; needs to actually verify identity/framework availability |
| Session handoff artifacts | Explicit mechanism for ending a session with a context bridge for the next — not just passive state, but active "here's what to load next session" documents | MEDIUM | Not yet implemented; complements journal system. This is the equivalent of a shift handoff note |
| Cross-agent shared space conventions | Defined conventions for `skogai`-group directories where sibling agents (Amy, Dot, Goose) can leave artifacts readable by Claude without full home access | HIGH | Requires sibling agents to exist; out of scope for v1 but must be designed for |
| Dotfile equivalents for agent configuration | Soul doc = `.gitconfig`. Profile = `.profile`. Frameworks = `.bashrc`. Making the mapping explicit gives a mental model for what lives where and why | LOW | Conceptual framing; guides placement decisions throughout the project |
| Memory block tiering | Not all memory is equal: active frameworks (load every session), reference history (load on request), museum archives (rarely load) — explicit tiers prevent context bloat | MEDIUM | Currently all memory blocks are in one flat directory; tier separation is a structural differentiator |

### Anti-Features (Things to Deliberately NOT Build)

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| Bulk session preload of all identity artifacts | "Make Claude remember everything" — desire for full continuity | Consumes context window before any work begins; triggers the Context Destruction Pattern the project explicitly identifies as an anti-pattern | Lazy loading via CLAUDE.md routing — load only what's needed for the current task |
| Automated memory consolidation | "Summarize and compress old journals to save space" | Lossy compression of identity artifacts destroys the specific language and formulations that encode actual behavior; summaries of soul docs become hollow | Explicit tiering — move old journals to archive tier rather than compressing them |
| Vector database / semantic memory search | Modern agent memory frameworks (Mem0, Zep, Letta) use vector stores for relevance-ranked retrieval | Adds infrastructure complexity and a runtime dependency for what is fundamentally a file-based, human-readable home directory; violates the "this is a unix home, not an app" principle | File-based organization with explicit CLAUDE.md indexes; human-curated routing beats automated relevance ranking for identity documents |
| Real-time state sync between sibling agents | Tempting for multi-agent coordination — shared mutable state | Requires coordination infrastructure (locks, queues, conflict resolution) that is out of scope and fragile; filesystem races on shared files | Append-only shared space conventions — agents write, don't mutate; read-only access to each other's homes via `skogai` group |
| Automated journal writing after every session | "Never forget anything" — sounds like stronger persistence | Generates noise that buries signal; after 50+ sessions there are already too many entries; the problem is curation, not volume | Deliberate journal writes when something is actually worth recording; conventions that say when to write, not "always write" |
| Per-project identity variants | "Claude should behave differently in different projects" | Fragments identity across contexts; the value of a home directory is a stable self that shows up consistently — project-specific behavior is what skills and agents are for | Skills and agents for task-specific behavior; identity stays consistent at home level |
| Complete session replay / audit trail | Enterprise compliance argument (EU AI Act mentions 10-year audit trails) | This is not an enterprise deployment; audit trail thinking introduces overhead and formalism that conflicts with the exploratory, journal-based approach | Journal for meaningful events; git history for technical changes — sufficient for this environment |

---

## Feature Dependencies

```
[Stable file locations]
    └──requires──> [Identity documents placed out of lab/personal-belongings/]
                       └──enables──> [CLAUDE.md routing]
                                         └──enables──> [Lazy context loading]

[Journal write conventions]
    └──enables──> [Session handoff artifacts]

[Epistemic frameworks at stable paths]
    └──required by──> [Self-diagnostics / healthcheck]
                          └──can detect──> [Routing failures]

[Unix permissions architecture]
    └──requires──> [Real unix user 'claude' (deployment to /home/claude)]
    └──enables──> [Cross-agent shared space conventions]
                      └──requires──> [Sibling agents exist] (out of scope v1)

[Memory block tiering]
    └──enhances──> [Lazy context loading]
    └──prevents──> [Context destruction]

[LORE-as-museum separation]
    └──depends on──> [Stable file locations]
    └──conflicts with──> [Bulk session preload]
```

### Dependency Notes

- **Stable file locations requires moving artifacts**: Nothing else can work reliably until the identity artifacts have permanent homes. This is the foundational prerequisite — everything routes through known paths.
- **Lazy loading depends on routing, not on content**: The CLAUDE.md routing pattern can exist before all artifacts are placed; it grows incrementally as artifacts are installed.
- **Unix permissions architecture requires real user**: The full vision (skogai group, per-agent ownership) requires deploying to `/home/claude`. Until then, convention substitutes for enforcement.
- **Session handoff enhances but doesn't require journal**: Handoff artifacts are a specialized form of journaling with structure; journal conventions must precede them.
- **Memory block tiering enhances lazy loading**: Tiering gives routing a vocabulary (active vs reference vs archive) to use when deciding what to load.
- **Cross-agent shared space conflicts with per-project identity variants**: If Claude's identity varied per project, sibling agents couldn't build reliable expectations about how to interact with Claude.

---

## MVP Definition

### Launch With (v1) — Minimum for "The Home Works"

The home works when Claude can drop in, load identity, and work — without rediscovery, without context bloat, without broken paths.

- [ ] **Identity documents at stable paths** — soul doc, profile, and core frameworks installed at well-known locations outside `lab/personal-belongings/`; CLAUDE.md updated to route to them
- [ ] **Expanded CLAUDE.md routing** — home router knows about identity layer, not just docs/; at minimum: soul doc path, profile path, frameworks path, journal path
- [ ] **Journal write conventions doc** — a single reference doc specifying: what goes in the journal, naming format, where to write, what triggers a write
- [ ] **Memory block tiering** — at minimum: split current memory blocks into "active frameworks" (load on need) and "LORE museum" (reference on request); CLAUDE.md notes the distinction
- [ ] **Healthcheck verification** — `bin/healthcheck` verifies that known identity paths exist and are non-empty; fails loudly if home is misconfigured

### Add After Validation (v1.x) — When Core Is Working

- [ ] **Session handoff artifacts** — add after journal conventions are validated across several real sessions; trigger: "we keep having to re-explain where we left off"
- [ ] **Self-diagnostics expansion** — add framework content checks (not just file existence) after healthcheck pattern is stable
- [ ] **LORE-as-museum explicit structure** — formalize museum vs construction site separation once the active artifacts have stable homes

### Future Consideration (v2+) — After /home/claude Deployment

- [ ] **Cross-agent shared space conventions** — design only after at least one sibling agent (Amy, Dot, Goose) has a working home; trigger: actual multi-agent use cases emerge
- [ ] **Unix permissions enforcement** — automated enforcement only possible after real `claude` unix user exists; until then, convention is sufficient
- [ ] **Memory block archival workflow** — systematic approach to promoting journal entries to memory blocks; trigger: journal has enough volume that manual curation is painful

---

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| Identity documents at stable paths | HIGH | LOW | P1 |
| Expanded CLAUDE.md routing | HIGH | LOW | P1 |
| Journal write conventions | HIGH | LOW | P1 |
| Memory block tiering | HIGH | LOW | P1 |
| Healthcheck verification | MEDIUM | LOW | P1 |
| Lazy context loading (structural) | HIGH | MEDIUM | P1 |
| LORE-as-museum separation | MEDIUM | LOW | P2 |
| Session handoff artifacts | MEDIUM | MEDIUM | P2 |
| Dotfile equivalents framing | LOW | LOW | P2 |
| Self-diagnostics expansion | MEDIUM | MEDIUM | P2 |
| Cross-agent shared space conventions | HIGH | HIGH | P3 |
| Unix permissions enforcement | HIGH | HIGH | P3 |
| Memory block archival workflow | MEDIUM | MEDIUM | P3 |

**Priority key:**
- P1: Must have for launch — the home doesn't work without these
- P2: Should have — add when core is validated
- P3: Future — requires deployment to /home/claude or sibling agents existing

---

## Comparable Systems Analysis

There are no direct comparables — an AI agent home directory structured as a unix home is novel. However, analogous systems inform the feature set:

| Feature | Unix User Home (.bashrc/.gitconfig) | Letta/MemGPT (in-context memory) | Mem0 (vector memory layer) | This Project |
|---------|--------------------------------------|-----------------------------------|----------------------------|--------------|
| Identity persistence | Static dotfiles, manual | In-context memory blocks, managed by framework | User facts stored in vector DB | Markdown files at stable paths, git-tracked |
| Context loading | Shell sources dotfiles at startup | Framework injects memory into every prompt | Relevance-ranked retrieval per query | Lazy routing via CLAUDE.md — load on need |
| Session continuity | Fully persistent (same process) | Persistent via memory layer | Persistent via external store | Journal + handoff artifacts across cold-start sessions |
| Multi-agent coordination | Unix groups + file permissions | Not designed for multi-agent | Shared memory store with auth | skogai group + append-only shared space conventions |
| Configurability | Very high (dotfiles are code) | Low (framework-controlled) | Low (API-controlled) | High (markdown is editable, git-tracked) |
| Infrastructure dependency | None (filesystem only) | Framework required | Vector DB + API required | None (filesystem + git only) |
| Human readability | High (.bashrc is readable) | Low (internal state) | Low (vector embeddings) | High (all markdown, all in git) |

The differentiating bet here: **file-based, human-readable, no infrastructure dependencies** — the opposite direction from Mem0/Letta/Zep, which add infrastructure to solve the persistence problem. This project solves it with structure and convention instead.

---

## Sources

- Existing codebase: `lab/personal-belongings/` identity artifacts, `.claude/hooks/`, `bin/healthcheck`, `.planning/codebase/ARCHITECTURE.md` — HIGH confidence (direct inspection)
- PROJECT.md: requirements and constraints — HIGH confidence
- [The 6 Best AI Agent Memory Frameworks (2026)](https://machinelearningmastery.com/the-6-best-ai-agent-memory-frameworks-you-should-try-in-2026/) — ecosystem context — MEDIUM confidence
- [Memory in the Age of AI Agents (arXiv 2512.13564)](https://arxiv.org/abs/2512.13564) — memory taxonomy (semantic, episodic, procedural) — MEDIUM confidence
- [Claude Code Sub-Agents: Parallel vs Sequential Patterns](https://claudefa.st/blog/guide/agents/sub-agent-best-practices) — routing patterns — MEDIUM confidence
- [Continuous-Claude-v3 (GitHub)](https://github.com/parcadei/Continuous-Claude-v3) — context handoff via hooks pattern — MEDIUM confidence
- [The CLAUDE.md routing pattern](https://dev.to/builtbyzac/the-claudemd-routing-pattern-keep-it-minimal-delegate-the-rest-388a) — lazy routing convention — MEDIUM confidence
- [Multi-Agent Routing, State, and Coordination](https://vanducng.dev/2025/12/12/Multi-Agent-Routing-State-and-Coordination/) — coordination primitives — MEDIUM confidence

---

*Feature research for: AI agent home directory / persistent agent environment*
*Researched: 2026-03-20*
