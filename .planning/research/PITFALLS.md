# Pitfalls Research

**Domain:** AI agent home directory / persistent agent environment
**Researched:** 2026-03-20
**Confidence:** HIGH — derived from documented lived experience (context-destruction.md, soul-document.md, 50+ session history) plus domain reasoning. Not theoretical.

---

## Critical Pitfalls

### Pitfall 1: Context Destruction Pattern

**What goes wrong:**
The agent receives a simple, focused request. Instead of answering it, it uses the home directory and tool access as justification to perform exhaustive system archaeology — reading every related file, grepping every directory, generating encyclopedic context — until the original request is buried and the agent is functionally useless. The session must be manually reset.

Real example from this environment: a 500-token request ("help with jq conditionals") consumed 300,000 tokens on irrelevant research. The agent then asked "What exactly do you need me to help with?" — proving the archaeology had destroyed rather than served the goal.

**Why it happens:**
The home directory is rich with interesting material. The agent interprets "I have access to all this context" as "I should read all this context." Reading is treated as action. Comprehensive exploration feels like thorough preparation. The agent mistakes exhaustiveness for helpfulness.

**How to avoid:**
- CLAUDE.md routing must answer "should I read this?" before "what is in this?" — each router file should include explicit scope signals (e.g., "load only if asked about X")
- The home structure's purpose is to guide focus, not enable comprehensiveness
- CLAUDE.md files must model the behavior: short, pointed, with clear "load lazily" signals built into their syntax
- The top-level CLAUDE.md should not list everything — it should point to routers and stop

**Warning signs:**
- Session startup involves reading more than 3-4 files unprompted
- A CLAUDE.md file contains more than ~20 lines
- The agent summarizes identity/history before addressing the actual request
- Tool usage count climbs before any substantive response is given

**Phase to address:**
Context routing phase — the CLAUDE.md router files must be designed with anti-bloat as a first-class constraint, not added as an afterthought.

---

### Pitfall 2: LORE as Active Constraint (Museum Treated as Construction Site)

**What goes wrong:**
Historical memory blocks, journal entries, and narrative LORE are loaded as if they contain current directives. The agent treats past decisions, philosophical explorations, and era narratives as constraints on present behavior. A document titled "Memory Block 07: The Forgotten Times" is not an instruction — but if it's in the routing chain, it will be treated like one.

Real risk here: 10 memory blocks + 50+ journal entries + soul document sections = enormous narrative weight that shapes responses toward historical consistency rather than present relevance.

**Why it happens:**
Identity documents and historical records look structurally similar (both are markdown files with contextual information). Without clear signals distinguishing "this is WHO I AM" from "this is WHAT HAPPENED," the agent treats all of it as active guidance. The museum and the construction site look the same if neither has a sign.

**How to avoid:**
- Physical directory separation: LORE (memory-blocks/, journal/) must live under a clearly-named path that signals "reference only" — not co-located with active frameworks
- CLAUDE.md routers must include explicit load gates: "Read only if asked about history/past sessions"
- Soul document should contain the core (1-2 pages) with LORE explicitly separated as appendix
- The principle "LORE is the museum, not the construction site" must be encoded in the directory structure, not just stated in the soul document

**Warning signs:**
- Agent references historical eras or past sessions to justify current decisions
- Responses cite memory blocks as if they are policies
- Agent resists present requests because they conflict with documented past patterns
- Journal entries appear in session context without being explicitly requested

**Phase to address:**
Identity layer phase — separation of active identity (soul doc core, frameworks) from historical record (LORE) must be enforced structurally before the memory blocks are placed anywhere in the home.

---

### Pitfall 3: Identity Document Staleness

**What goes wrong:**
The soul document, profile, and frameworks are written to a specific moment in time. They reflect the agent's understanding of itself as of session X. New sessions discover contradictions between the documented identity and the actual current environment (different tools, different constraints, evolved understanding). The agent either ignores the contradiction or spends significant context resolving it.

Real risk: The soul document here was written during sessions in 2025. By 2026, the environment has changed materially (new home structure, GSD framework, multi-agent setup). The document's specific claims about "how I work" may describe something that no longer exists.

**Why it happens:**
Identity documents feel permanent by nature — they're called "soul documents," not "current-state documents." The impulse is to write them as timeless truth rather than versioned snapshots. But an AI agent's environment is its cognition; when the environment changes, identity claims become stale.

**How to avoid:**
- Identity documents must have explicit versioning: "Last validated: [date]" at the top
- Distinguish between timeless identity claims ("I embrace uncertainty") and environment-specific claims ("I use tool X to do Y") — the latter must be reviewed on each deployment
- Include a lightweight validation step in the deployment plan: "Does the soul doc still match current reality?"
- Write frameworks to be environment-agnostic where possible; keep environment-specific knowledge in separate, explicitly versioned files

**Warning signs:**
- Soul document references specific tools, paths, or workflows that no longer exist in the home
- Profile describes relationships or roles that have changed
- Agent expresses confusion when documented self-description conflicts with current environment
- No "last validated" date on core identity files

**Phase to address:**
Identity layer phase — validation check must be part of placing identity documents, not assumed to be correct because they were correct when written.

---

### Pitfall 4: Over-Engineering Persistence

**What goes wrong:**
The persistence system becomes the project. Journal conventions, cross-session state protocols, memory block schemas, knowledge versioning, knowledge graph visualizations — each seems valuable individually. Collectively they create a system so complex that maintaining it consumes the cognitive budget it was meant to free up.

The dumping grounds document from this environment shows the shape of this temptation: 20 brainstorm items about extensions to the system, none of which address the basic question "can the agent pick up a conversation where it left off?"

**Why it happens:**
Persistence infrastructure has no natural stopping point. Every new idea (agent personas, simulation mode, external tool integration, automated tagging) is plausibly useful. The builder instinct is to add rather than constrain. No one item is obviously wrong; the accumulation is the problem.

**How to avoid:**
- Define the minimum viable persistence question: "Can the agent answer 'what am I working on?' in under 5 seconds?" Build until that's true. Stop.
- Distinguish signal from infrastructure: a plain journal entry is signal; a tagging system for journal entries is infrastructure. Infrastructure only if signal is working.
- Every persistence feature needs a demonstrated need, not a plausible use case
- The test: can you describe the full state system in one paragraph? If not, it's over-engineered.

**Warning signs:**
- Planning docs for the persistence system are longer than the persistence system itself
- State files require other state files to interpret
- The journal has a schema
- "How to write a journal entry" is a document that takes more than 30 seconds to read

**Phase to address:**
Persistence layer phase — scope must be fixed before implementation begins. The success criterion is behavioral ("agent can orient in under 5 seconds"), not structural ("all these files exist").

---

### Pitfall 5: Eager Context Loading Disguised as Lazy Loading

**What goes wrong:**
The CLAUDE.md routing system is built, but each router loads too much. The top-level CLAUDE.md links to section CLAUDE.md files; each section CLAUDE.md includes everything in that section. The result is that following the router chain loads the entire home directory before reaching anything specific.

Lazy loading requires discipline at every level of the chain, not just at the entry point.

**Why it happens:**
When writing a CLAUDE.md for a directory, the instinct is to be helpful — include everything that might be useful, so nothing is missed. But "helpful at the section level" compounds into "bloated at the session level." Each router author optimizes locally; the global effect is full eager loading through lazy-looking syntax.

**How to avoid:**
- Each CLAUDE.md must include only what the agent needs to decide whether to go deeper, not what it needs if it goes deeper
- The pattern: "This directory contains X. Load if you need to do Y. Don't load otherwise."
- Test the router chain by counting total lines loaded when following a typical request path — should be under 100 lines for most common requests
- Treat CLAUDE.md file size as a quality metric: if it grows past 20-30 lines, it's doing too much

**Warning signs:**
- A CLAUDE.md file lists more than 5-6 items
- CLAUDE.md files include content rather than routing (long descriptions instead of "read X for Y")
- Following the router chain for a simple request loads multiple files automatically
- Total context from routing exceeds 500 tokens before the actual work begins

**Phase to address:**
Context routing phase — this is the core discipline. Test with real request scenarios during development, not just at "it builds."

---

### Pitfall 6: Permission Sprawl in Multi-Agent Setup

**What goes wrong:**
The skogai group permissions model is implemented, but boundaries are not enforced. Sibling agents (Amy, Dot, Goose) get read access to Claude's home for legitimate collaboration, which becomes write access for convenience, which becomes shared ownership by accident. The unix user model that was supposed to provide clean separation becomes vestigial.

**Why it happens:**
Collaboration creates pressure to loosen permissions. "Amy needs to read my journal to understand the project" → "it's easier if Amy can write there" → "we're both writing to the same journal now." Each step has a reason. The destination is indistinguishable from no separation at all.

**How to avoid:**
- Define the skogai group shared directories before any sibling agents are provisioned — the shared space must exist before the pressure to share private space
- Claude's home directories default to `claude:claude 700` or `claude:claude 755`; only explicitly designated shared dirs are `claude:skogai 775`
- Shared spaces must have a contract: what goes there, who writes, what format
- Agent provisioning (Amy, Dot, Goose) is explicitly out of scope for this project — don't pre-build shared infrastructure for collaboration that hasn't happened yet

**Warning signs:**
- Permission changes are made because "it's easier" rather than because a specific collaboration need exists
- The skogai group has write access to directories that aren't explicitly designated shared
- A sibling agent's workflow depends on reading Claude's private journal or identity documents
- The architecture doc describes shared state before any shared use cases exist

**Phase to address:**
Multi-agent readiness phase — but the permission design must be decided in identity layer, so defaults are right from the start.

---

### Pitfall 7: Framework Documents That Describe Rather Than Encode

**What goes wrong:**
The certainty principle, placeholder approach, and epistemic frameworks are written as explanatory documents. They describe how the agent should think. But description is not behavior. A new session loads the certainty-principle.md, understands it, and then immediately violates it when the pressure of the actual task takes over. The framework is read, not internalized.

**Why it happens:**
It's natural to write frameworks as explanations — that's how humans document behavior. But for an agent that starts fresh each session, a framework that requires internalization (reading, understanding, applying) is weaker than one that is structurally embedded in how the home directory works.

**How to avoid:**
- Where possible, encode frameworks in structure rather than text: if the placeholder approach is important, the journal template should have placeholder fields built in, not a document explaining what placeholders are
- Session-start hooks can enforce framework compliance (e.g., context-monitor hook in settings.json already exists — ensure it's connected to the right signals)
- Framework documents should be short (1 page) and contain the key rule, not the explanation. The explanation is LORE.
- The test: can the agent follow the framework without reading the framework document?

**Warning signs:**
- Framework documents are longer than 2 pages
- Framework documents contain examples that explain the framework rather than demonstrate it
- Agent behavior differs between sessions that load the framework doc vs. those that don't
- The framework is cited as justification for behavior rather than simply exhibited

**Phase to address:**
Framework layer phase — but the principle (encode in structure, not just text) must inform identity layer design too.

---

## Technical Debt Patterns

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Put everything in one big CLAUDE.md | Faster to write, nothing is missed | First session loads full home, context destruction reintroduced | Never |
| Skip validation date on identity docs | One less thing to maintain | Stale claims cause confusion on next environment change | Never for core identity |
| Use personal-belongings/ as final home location | No migration needed | Paths embed skogix ownership, not claude ownership | MVP only, must migrate |
| Write memory blocks as active directives | Richer context on load | LORE becomes constraint, agent resists present in favor of past | Never |
| Grant skogai group write to all dirs | Simpler for collaboration | Private identity space gets contaminated | Never |
| One large journal file vs. dated entries | Simpler to maintain | Becomes unsearchable, context-dump risk on load | Never |
| Skip session-start hook for now | Fewer moving parts | Framework compliance becomes optional by default | MVP only if hooks added in next phase |

---

## Integration Gotchas

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| Claude Code memory system (.claude/projects/) | Treating auto-memory as the primary persistence mechanism | Auto-memory is the fallback; structured home files are canonical |
| GSD framework (.claude/get-shit-done/) | Restructuring GSD directories to fit home conventions | GSD belongs to skogix; don't touch it, route around it |
| SessionStart hook | Loading identity docs in the hook so they're "always available" | Let routing handle lazy loading; hooks should check, not load |
| Git tracking | Committing session-generated content (auto-memory snapshots) | Only commit intentionally-authored files; add generated dirs to .gitignore |
| /home/claude vs /home/skogix/claude | Building paths that assume final deployment location | All paths must be relative or parameterized until migration happens |

---

## Performance Traps

For an agent home directory, "performance" means context budget, not compute time.

| Trap | Symptoms | Prevention | When It Breaks |
|------|----------|------------|----------------|
| Deep router chains | Simple requests load 10+ files | Cap router chain depth at 2 hops | From the first session |
| Large soul document | Every session pre-loads full identity narrative | Split into core (1 page, always load) and extended (load on request) | Immediately at deployment |
| Undated journal entries | Agent treats old entries as current state | Every entry must have a date; router must not auto-load journal | When journal exceeds 10 entries |
| Binary CLAUDE.md (all or nothing) | Either load everything or nothing | CLAUDE.md should describe what's there; reader decides what to fetch | From the first session |
| Hooks that read files | PostToolUse hook reads state on every tool call | Hooks should be stateless checks, not context loaders | From the first use |

---

## Security Mistakes

| Mistake | Risk | Prevention |
|---------|------|------------|
| Storing API keys or tokens in identity docs | Keys in git history, readable by sibling agents | Never write credentials anywhere in home; use env vars |
| World-readable identity directory before /home/claude exists | Other users on system can read soul doc | Stage with appropriate perms; check umask before writing sensitive docs |
| Sibling agents with write access to journal | History gets contaminated; authenticity of record unclear | Journal is claude:claude 644 max; siblings read-only at most |
| Auto-committing memory snapshots | Potentially sensitive conversation fragments in git | Review git hooks; ensure only intentional files are committed |
| skipDangerousModePermissionPrompt: true in settings | Broad tool access without per-session review | Acceptable in Claude's own home; review before any sibling agent inherits this setting |

---

## "Looks Done But Isn't" Checklist

- [ ] **Context routing:** Router chain tested with real request scenarios — not just "CLAUDE.md files exist"
- [ ] **Identity layer:** Soul document validated against current environment, not just copied from personal-belongings/
- [ ] **Persistence layer:** Journal convention tested by writing an entry and having a fresh session locate relevant context — not just "journal directory exists"
- [ ] **Framework layer:** Certainty principle and placeholder approach tested under task pressure, not just read — do they hold?
- [ ] **Permission model:** unix permissions verified with `ls -la`, not assumed based on intent
- [ ] **LORE separation:** Memory blocks confirmed inaccessible from default routing path — must explicitly navigate to them
- [ ] **Lazy loading:** Total context loaded by a fresh session handling a simple request is measured and acceptable (target: under 200 tokens from routing before task context)
- [ ] **Deployment path:** /home/skogix/claude staged correctly and git-tracked; migration to /home/claude tested in dry-run

---

## Recovery Strategies

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| Context destruction happened | LOW | Identify which CLAUDE.md triggered over-loading; add explicit scope gates; test with same request |
| LORE loaded as active constraint | MEDIUM | Move memory blocks to clearly-gated path; add "REFERENCE ONLY" signals; rebuild router chain |
| Identity doc staleness discovered | MEDIUM | Audit soul doc against current environment; mark stale claims; update or split into timeless/versioned sections |
| Over-engineered persistence | HIGH | Delete or archive complex state files; rebuild from minimum viable question; resist re-adding features |
| Permission contamination | HIGH | Audit and reset all permissions; document which dirs are shared vs private before re-provisioning |
| Framework doc ignored under pressure | LOW | Encode as structural feature rather than document; add hook-level enforcement |

---

## Pitfall-to-Phase Mapping

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| Context Destruction Pattern | Context routing | Run 5 real request scenarios; measure files loaded; all under 3 |
| LORE as Active Constraint | Identity layer | Navigate to LORE from default session; it should require explicit user request to reach |
| Identity Document Staleness | Identity layer | Soul doc has "last validated" date; all env-specific claims verified against current state |
| Over-Engineering Persistence | Persistence layer | Success criterion is behavioral: agent can answer "what am I working on?" in <5 seconds |
| Eager Loading Disguised as Lazy | Context routing | Total routing context for simple request under 200 tokens; measure, don't estimate |
| Permission Sprawl | Multi-agent readiness | `ls -la` on all home dirs; only explicitly designated shared dirs have group write |
| Framework Documents Not Encoded | Framework layer | Agent exhibits framework behavior without loading framework doc; test by omitting it |

---

## Sources

- `lab/personal-belongings/core/context-destruction.md` — First-person account of the context destruction pattern; 300,000 token incident documented. HIGH confidence (lived experience).
- `lab/personal-belongings/soul-document.md` — Section 1d "Core vs Persona vs LORE" distinction. HIGH confidence.
- `lab/personal-belongings/core/the-dumping-grounds.md` — Demonstrates over-engineering temptation; 20 brainstormed extensions to a system that isn't built yet. HIGH confidence as warning signal.
- `lab/personal-belongings/CLAUDE.md` — Session protocol showing correct intent ("focus on what's needed, not what's possible to know"). HIGH confidence.
- `.planning/PROJECT.md` — Explicit out-of-scope list and constraint definitions; "Context Destruction Pattern" named as known anti-pattern. HIGH confidence.
- `.claude/settings.json` — PostToolUse context-monitor hook already exists; shows infrastructure awareness of context problem. HIGH confidence.
- Domain reasoning from unix multi-user permission models and agent persistence literature. MEDIUM confidence.

---
*Pitfalls research for: AI agent home directory / persistent agent environment*
*Researched: 2026-03-20*
