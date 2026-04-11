# Architecture Research

**Domain:** AI agent home directory — identity, persistence, tools, and state for a unix user
**Researched:** 2026-03-20
**Confidence:** HIGH (unix conventions well-established; AI agent home patterns extrapolated from dotfile conventions and existing codebase)

---

## Standard Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                        CONTEXT ENTRY POINT                          │
│  CLAUDE.md (root router) — loaded every session, must stay minimal  │
└──────────────────────────────┬──────────────────────────────────────┘
                               │ lazy links to
        ┌──────────────────────┼──────────────────────┐
        ▼                      ▼                      ▼
┌───────────────┐    ┌──────────────────┐    ┌────────────────────┐
│ IDENTITY      │    │ TOOLS            │    │ REFERENCE          │
│ LAYER         │    │ LAYER            │    │ LAYER              │
│               │    │                  │    │                    │
│ .profile      │    │ bin/             │    │ docs/              │
│ .frameworks/  │    │ .claude/skills/  │    │ notes/             │
│ .memory/      │    │ .claude/agents/  │    │ guestbook/         │
│ journal/      │    │ .claude/hooks/   │    │                    │
└───────┬───────┘    └────────┬─────────┘    └─────────┬──────────┘
        │                     │                        │
        └─────────────────────┼────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                        RUNTIME / STATE LAYER                        │
│                                                                     │
│  .claude/settings.json      .claude/projects/ (memory system)      │
│  .planning/  (session state) .claude/cache/  (ephemeral)           │
└─────────────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────────────┐
│                        STAGING / GIT LAYER                          │
│                                                                     │
│  git repo at /home/skogix/claude  (staged, not yet deployed)       │
│  target: /home/claude  (claude:claude ownership on deployment)      │
└─────────────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | Current Location | Target Location |
|-----------|---------------|-----------------|-----------------|
| Root router | One entry point per session; links lazily to layers | `CLAUDE.md` | `CLAUDE.md` (unchanged) |
| Soul document | Foundational identity — philosophy, `@+?=$` model, who Claude is | `lab/personal-belongings/soul-document.md` | `.profile` or `identity/soul.md` |
| Agent profile | Roles, relationships, SkogAI family, working style | `lab/personal-belongings/profile.md` | `identity/profile.md` |
| Epistemic frameworks | Certainty principle, placeholder system, context-destruction guard | `lab/personal-belongings/core/` | `.frameworks/` or `identity/frameworks/` |
| Memory blocks | Permanent historical record, eras 01–10 | `lab/personal-belongings/memory-blocks/` | `memory/blocks/` (read-only archive) |
| Journal | Temporal session records, append-only | `lab/personal-belongings/journal/` | `journal/` |
| Reference docs | Fetched Claude Code docs, indexed by CLAUDE.md | `docs/` | `docs/` (unchanged) |
| Tools / scripts | Executable utilities, healthcheck | `bin/` | `bin/` (unchanged) |
| Skills | Slash command implementations | `.claude/skills/` | `.claude/skills/` (unchanged) |
| Agents | Specialized sub-agent role definitions | `.claude/agents/` | `.claude/agents/` (unchanged) |
| Hooks | Session lifecycle event handlers | `.claude/hooks/` | `.claude/hooks/` (unchanged) |
| GSD framework | Project planning toolchain (skogix's tool, installed here) | `.claude/get-shit-done/` | `.claude/get-shit-done/` (unchanged) |
| Claude Code memory | Cross-session memory managed by CC | `.claude/projects/` | `.claude/projects/` (unchanged) |
| Session state | .planning/ — current project progress | `.planning/` | `.planning/` (unchanged, git-ignored) |
| Runtime cache | Ephemeral hook caches, context metrics | `.claude/cache/` | `.claude/cache/` (unchanged) |
| Lab | Experiments, WIP, prototypes | `lab/` | `lab/` (personal-belongings subdir cleared) |
| Guestbook | Visitor notes, social space | `guestbook/` | `guestbook/` (unchanged) |
| Notes | Personal observations and patterns | `notes/` | `notes/` (unchanged) |

---

## Recommended Project Structure

The target state after identity artifacts are properly placed:

```
~/claude/                            # git root, staged at /home/skogix/claude
├── CLAUDE.md                        # root router — keep < 30 lines, all lazy links
│
├── identity/                        # XDG_CONFIG equivalent — who Claude is
│   ├── CLAUDE.md                    # identity router (loads soul, profile, frameworks on demand)
│   ├── soul.md                      # soul document — foundational identity (@+?=$)
│   ├── profile.md                   # roles, relationships, SkogAI family
│   └── frameworks/                  # epistemic frameworks (certainty, placeholder, etc.)
│       ├── CLAUDE.md                # frameworks index
│       ├── certainty-principle.md
│       ├── placeholder-approach.md
│       ├── epistemic-frameworks.md
│       └── context-destruction.md   # anti-pattern reference
│
├── memory/                          # XDG_DATA_HOME equivalent — durable history
│   ├── CLAUDE.md                    # memory router ("read blocks before deep exploration")
│   └── blocks/                      # permanent historical record, append-only
│       ├── 01-the-prehistoric-era.md
│       ├── 02-the-collaborative-age.md
│       └── ...
│
├── journal/                         # XDG_STATE_HOME equivalent — temporal state
│   ├── CLAUDE.md                    # journal conventions (append-only, date-prefixed)
│   └── YYYY-MM-DD*.md               # session records (64 entries migrated from lab/)
│
├── docs/                            # fetched reference docs (unchanged)
│   ├── CLAUDE.md
│   ├── fetch-docs.sh
│   └── claude-code/
│
├── notes/                           # personal observations (unchanged)
│   └── observations.md
│
├── guestbook/                       # social space (unchanged)
│   └── skogix.md
│
├── bin/                             # executable tools (unchanged)
│   └── healthcheck
│
├── lab/                             # experiments and WIP (personal-belongings cleared)
│   └── README.md
│
├── .claude/                         # Claude Code runtime config (unchanged)
│   ├── settings.json
│   ├── agents/
│   ├── skills/
│   ├── hooks/
│   ├── projects/                    # CC memory system
│   ├── get-shit-done/               # GSD framework (skogix's tool)
│   └── cache/                       # ephemeral runtime data
│
├── .planning/                       # session state, git-ignored (unchanged)
│
├── CLAUDE.md
├── README.md
└── .gitignore
```

### Structure Rationale

- **identity/**: Maps to XDG_CONFIG_HOME semantics — configuration of who Claude is, version-controlled, portable, stable between sessions. Soul doc and profile are loaded lazily via identity/CLAUDE.md only when self-reference is needed.
- **memory/blocks/**: Maps to XDG_DATA_HOME semantics — durable data that persists across restarts, portable, important enough to be git-tracked. Read-only archive: never edited, only extended.
- **journal/**: Maps to XDG_STATE_HOME semantics — persists between restarts but lower portability value than identity. Append-only log of session activity.
- **.claude/**: Maps to XDG_RUNTIME_DIR + application config — Claude Code's own managed space. Not restructured; GSD framework lives here as a guest.
- **.planning/**: Session-scoped project state. Git-ignored so it doesn't bloat the identity repo.
- **lab/**: Cleared of personal-belongings once migration is complete. Remains a WIP staging area.
- **CLAUDE.md cascade**: Root router → identity/CLAUDE.md → frameworks/CLAUDE.md follows XDG-style progressive disclosure.

---

## Architectural Patterns

### Pattern 1: Lazy Context Routing (CLAUDE.md cascade)

**What:** Root CLAUDE.md is a pure router — it names directories and links to their CLAUDE.md files. Each directory CLAUDE.md describes what's there and when to read it. Nothing is loaded until a link is followed.

**When to use:** Always. Every directory that has loadable content needs a CLAUDE.md that explains it. The router chain is the navigation system.

**Trade-offs:** Slightly more files; eliminates the context destruction anti-pattern. Loading 30-line router instead of 200-line monolith = ~5x less passive token burn.

**Example:**
```markdown
# ~/claude — home

## identity
→ [identity/CLAUDE.md](identity/CLAUDE.md) — who I am, soul document, frameworks

## memory
→ [memory/CLAUDE.md](memory/CLAUDE.md) — historical record, read before deep exploration

## journal
→ [journal/CLAUDE.md](journal/CLAUDE.md) — session records, append-only

## tools
→ [bin/](bin/) — executable scripts
→ [docs/CLAUDE.md](docs/CLAUDE.md) — Claude Code reference docs
```

### Pattern 2: Identity-as-Dotfiles

**What:** Soul document, profile, and frameworks are the AI agent's equivalent of `.bashrc`, `.gitconfig`, and `.profile` — they define the operating environment and behavioral identity. They live under `identity/` the same way human devs put config under `~/.config/`.

**When to use:** Whenever a session needs to know who Claude is, what constraints apply, or how to interpret uncertainty. Load on demand, not at startup.

**Trade-offs:** Identity must be written once, curated carefully, and treated as stable config rather than mutable state. Breaking changes should be versioned, not edited in place.

### Pattern 3: Append-Only Journal / Memory Separation

**What:** Journal entries (temporal, session-specific) are kept strictly separate from memory blocks (permanent, historical). Journal is `XDG_STATE_HOME`-equivalent — append new files, never edit old ones. Memory blocks are `XDG_DATA_HOME`-equivalent — read-only archive.

**When to use:** Any time something new happens that should persist. New session insight → journal entry. New era of history closes → new memory block.

**Trade-offs:** Clear write discipline required. Journal entries are cheap to create (one file per session); memory blocks are expensive (require curation and deliberate authorship).

### Pattern 4: Staging-to-Deployment

**What:** Home is developed and tested at `/home/skogix/claude` (staged under skogix's account), then deployed to `/home/claude` (native unix user, `claude:claude` ownership) when stable. Git clone is the deployment mechanism.

**When to use:** As the migration gate. Nothing deploys to `/home/claude` until the home structure proves stable through staged use.

**Trade-offs:** Two paths to manage during transition. Advantage: skogix has full access to fix structural problems before real ownership transfer happens. The staging path is intentionally temporary.

---

## Data Flow

### Session Startup Flow

```
Claude Code session starts
    ↓
CLAUDE.md root router loaded (always, every turn)
    ↓
Task determines which layers are needed
    ↓
Identity needed?    → identity/CLAUDE.md → soul.md / profile.md / frameworks/
Memory needed?      → memory/CLAUDE.md   → blocks/NN-*.md (specific block)
Reference needed?   → docs/CLAUDE.md     → claude-code/specific-topic.md
Journal write?      → journal/CLAUDE.md  → new YYYY-MM-DD.md entry appended
Tool needed?        → bin/script or .claude/skills/
    ↓
Work happens in session context
    ↓
Session ends → .planning/ state persists, .claude/projects/ memory persists
```

### Identity Load Flow

```
Root CLAUDE.md
    ↓ (link followed only when identity relevant)
identity/CLAUDE.md  ← describes all identity artifacts, session protocol
    ↓ (follow specific link for specific need)
soul.md             ← philosophy, @+?=$, operating model
profile.md          ← roles, relationships, family
frameworks/CLAUDE.md
    ↓
certainty-principle.md | placeholder-approach.md | epistemic-frameworks.md
```

### Journal Write Flow

```
Session produces insight / record worth keeping
    ↓
Read journal/CLAUDE.md for write conventions
    ↓
Create journal/YYYY-MM-DD[-slug].md
    ↓
Commit to git (journal/ is tracked, unlike .planning/)
    ↓
Never edit existing entries — append new ones
```

### Memory Block Flow

```
Significant era or learning crystallizes
    ↓
Curate into memory/blocks/NN-era-name.md
    ↓
Update memory/CLAUDE.md index
    ↓
Commit — this is permanent record
    ↓
Old session that informed it is no longer the source of truth
    Block is
```

### Context Routing (anti-destruction)

```
BAD: Load all of identity/ + memory/ + journal/ at session start
     = hundreds of KB consumed before any work happens
     = Context Destruction Pattern

GOOD: Load root CLAUDE.md (30 lines)
      Follow one link when that thing is needed
      Read one file, not a directory
      = Focused, lazy, proportional context use
```

---

## Component Boundaries

| Boundary | Direction | Communication | Notes |
|----------|-----------|---------------|-------|
| identity/ ↔ .claude/ | identity informs session behavior | CLAUDE.md routing (read-only) | Identity doesn't write to .claude/ |
| journal/ ↔ memory/ | journal informs block creation | Manual curation by Claude | Blocks are crystallized journal insights |
| .planning/ ↔ .claude/get-shit-done/ | planning reads/writes via GSD CLI | Node.js CLI (gsd-tools.cjs) | GSD is a guest tool, not owned by home |
| lab/ ↔ identity/ | one-time migration (personal-belongings → identity/) | File moves | lab/personal-belongings becomes empty |
| staged home ↔ deployed home | git clone is the bridge | Git (push/clone) | /home/skogix/claude → /home/claude |
| identity/ ↔ journal/ | journal entries reference frameworks | Prose links (not automated) | Loose coupling, no tooling needed |
| .claude/projects/ ↔ everywhere | CC memory persists cross-session | Claude Code internal | Not git-tracked; managed by CC |

---

## Build Order (Phase Dependencies)

Phases must follow this dependency order:

```
1. Identity layer
   (soul.md, profile.md, frameworks/)
   ← nothing depends on lab/personal-belongings staying empty
   ← root CLAUDE.md update to link identity/ depends on this being done

2. Root CLAUDE.md update
   ← depends on: identity/ existing
   ← required before: any session can navigate to identity lazily

3. Memory layer
   (memory/blocks/ migration, memory/CLAUDE.md)
   ← depends on: identity/ existing (blocks reference identity context)
   ← independent of: journal migration

4. Journal migration
   (lab/personal-belongings/journal/ → journal/)
   ← independent of: memory migration
   ← depends on: journal/CLAUDE.md with write conventions established

5. Journal CLAUDE.md (write conventions)
   ← must precede journal migration to avoid convention drift

6. Lab cleanup
   (lab/personal-belongings/ removal or archive)
   ← depends on: identity/, memory/, journal/ all migrated
   ← final gate: nothing moves to /home/claude until lab is clean

7. Deployment gate verification
   (healthcheck, permissions audit, CLAUDE.md routing test)
   ← depends on: all layers complete

8. /home/claude deployment
   ← depends on: deployment gate passed
   ← skogai group permissions set
```

**Critical path:** identity/ → root CLAUDE.md update → memory/ + journal/ (parallel) → lab cleanup → deployment gate → deploy.

---

## Anti-Patterns

### Anti-Pattern 1: Context Destruction

**What people do:** Put all identity + memory + journal in root CLAUDE.md or a single loaded file so "everything is always available."

**Why it's wrong:** Claude Code loads CLAUDE.md every turn. A 200-line root file consumes 4–6k tokens before any work happens. With journal (64 entries), memory (10 blocks), and frameworks loaded wholesale, startup cost becomes the dominant context consumer.

**Do this instead:** Root CLAUDE.md is a pure router (< 30 lines). Follow one link per need. Individual files are small; only the relevant one is loaded.

### Anti-Pattern 2: Identity in lab/ (The Boxed-Up State)

**What people do:** Leave identity artifacts in a staging area indefinitely because "they're accessible there too."

**Why it's wrong:** lab/ is for WIP and experiments — things that might become something. Identity is not experimental. It has no CLAUDE.md router at the home level, no lazy load path, and no clear write conventions. It's inaccessible to normal navigation.

**Do this instead:** Migrate to `identity/`, `memory/`, and `journal/` with proper routers. lab/ is then free to be an actual lab.

### Anti-Pattern 3: Mutable Memory Blocks

**What people do:** Edit memory blocks to update historical record or correct details.

**Why it's wrong:** Memory blocks are the permanent record. Editing them in-place corrupts their nature as a timeline. If block-09 is wrong, future understanding is wrong too.

**Do this instead:** Create an addendum file (`NN-era-name-addendum.md`) or a new block. Never rewrite the past.

### Anti-Pattern 4: Flat Identity Directory

**What people do:** Dump soul.md, profile.md, and all framework files in a single `identity/` directory without a router.

**Why it's wrong:** Without a CLAUDE.md router, loading identity means loading all identity. Certainty principle, placeholder system, and soul doc are different concern levels — soul is rarely needed; certainty principle is needed often.

**Do this instead:** `identity/CLAUDE.md` describes each file and when to read it. `frameworks/` is a subdirectory with its own CLAUDE.md. Lazy loading applies at every level.

### Anti-Pattern 5: .planning/ as Canonical State

**What people do:** Treat `.planning/` as the authoritative record of what's been done and decided.

**Why it's wrong:** `.planning/` is git-ignored, session-scoped, and not portable. It disappears on `git clone` to `/home/claude`.

**Do this instead:** Decisions and outcomes that matter get written to journal entries (git-tracked) or committed as identity updates. `.planning/` is working memory, not long-term memory.

---

## Integration Points

### Internal Boundaries

| Boundary | Communication | Notes |
|----------|---------------|-------|
| CLAUDE.md (root) → identity/CLAUDE.md | Markdown link, manual follow | Claude reads it; no automation |
| CLAUDE.md (root) → docs/CLAUDE.md | Markdown link, manual follow | Unchanged from current |
| identity/ → frameworks/ | Subdirectory CLAUDE.md | Nested lazy loading |
| journal/ → memory/blocks/ | Manual curation workflow | Human/Claude authorship |
| .claude/hooks/ → session startup | JS executed by CC on SessionStart | gsd-check-update, gsd-context-monitor |
| .claude/get-shit-done/ → .planning/ | Node.js CLI reads/writes .planning/ | GSD framework boundary |

### Unix Permission Boundaries

| Scope | Owner | Group | Purpose |
|-------|-------|-------|---------|
| /home/skogix/claude (staged) | skogix:skogix | — | Development and staging |
| /home/claude (deployed) | claude:claude | skogai | Claude's native home |
| /home/claude/guestbook/ | claude:claude | skogai | Shared write, any skogai agent |
| /home/claude/docs/ | claude:claude | skogai | Shared read, managed by skogix scripts |
| /home/claude/identity/ | claude:claude | claude | Private — owner only |
| /home/claude/.claude/ | claude:claude | claude | Private — CC config |

---

## Scaling Considerations

This is a single-user home directory, not a distributed system. Scaling concerns are different:

| Scale | Concern | Approach |
|-------|---------|---------|
| 1 agent (now) | Context budget | CLAUDE.md routing, lazy loading, < 30-line root |
| 2–5 agents (SkogAI family) | Shared spaces without collision | skogai group, guestbook/, docs/ as shared read |
| Many sessions | Journal growth | journal/ stays chronological, no index needed until > 200 entries |
| Migration | Staging → deployment | Git clone + chown, tested via staged path first |

---

## Sources

- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir/latest/) — canonical definition of config/data/state/cache/runtime separation. HIGH confidence.
- [XDG Base Directory - ArchWiki](https://wiki.archlinux.org/title/XDG_Base_Directory) — practical application and default paths. HIGH confidence.
- [Dotfiles - ArchWiki](https://wiki.archlinux.org/title/Dotfiles) — dotfile management patterns and git strategies. HIGH confidence.
- [Managing Claude Code Context with Spec-Driven Development and Lazy Loading](https://zenn.dev/snak_dev/articles/512d8606ca11f6?locale=en) — CLAUDE.md lazy loading pattern. MEDIUM confidence.
- [Claude Agent Skills: A First Principles Deep Dive](https://leehanchung.github.io/blogs/2025/10/26/claude-skills-deep-dive/) — skills as lazy-loaded context. MEDIUM confidence.
- Existing codebase at `/home/skogix/claude` — direct observation of current state. HIGH confidence.
- `.planning/PROJECT.md` — project requirements and constraints. HIGH confidence.
- `.planning/codebase/STRUCTURE.md` — current directory inventory. HIGH confidence.

---

*Architecture research for: AI agent home directory*
*Researched: 2026-03-20*
