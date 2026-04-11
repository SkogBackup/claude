# Stack Research

**Domain:** AI agent home directory — identity, persistence, context routing, multi-agent readiness
**Researched:** 2026-03-20
**Confidence:** HIGH (core patterns verified against official Claude Code docs; ecosystem patterns verified across multiple independent sources)

---

## The Core Insight

This project has no runtime stack. There is no npm build, no server, no database. The "stack" is a set of conventions, file formats, and Claude Code native mechanisms. The right frame is: what are the primitives Claude Code provides, and how do we compose them into an agent home?

---

## Recommended Stack

### Core Technologies

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| CLAUDE.md routing | Claude Code native | Context entrypoint — minimal router that delegates to subdirectory CLAUDE.md files | Official mechanism; loads on every session; under 200 lines stays within adherence threshold; lazy subdirectory loading is built-in |
| `.claude/rules/` | Claude Code native | Modular identity rules loaded at session start | Path-scoped rules load on demand; avoids stuffing identity docs into one monolith; supports symlinks for shared rules across projects |
| Auto memory (`~/.claude/projects/<project>/memory/`) | Claude Code v2.1.59+ | Claude-written cross-session learnings — build commands, debugging patterns, session insights | Native, no setup; survives compaction; MEMORY.md index loaded as first 200 lines each session |
| Subagent `memory` field | Claude Code native | Persistent memory scoped per named agent | `user` scope stores to `~/.claude/agent-memory/<agent-name>/`; `project` scope shareable via version control |
| Markdown frontmatter | Plain text | Machine-readable state headers on journal and memory files | No dependency; git-trackable; human-editable; same pattern used by GSD STATE.md and ROADMAP.md |
| Git | System | Version control, portability, deployment | Home dir IS the repo; `git clone` to `/home/claude` is the deployment plan |

### Identity Layer (dotfiles equivalent)

| File | Location | Purpose | Convention |
|------|----------|---------|------------|
| Soul document | `~/.claude-home/soul.md` or `identity/soul.md` | Who Claude is, the `@ + ? = $` philosophy, the foundational voice | Stable; changes rarely; under 200 lines active section |
| Profile | `identity/profile.md` | Roles, relationships, SkogAI family, current context | Updated when roles change; not session-by-session |
| Epistemic frameworks | `identity/frameworks/` directory | Certainty principle, placeholder approach, context-destruction pattern | Lazy-loaded via CLAUDE.md `@import` when needed, not always |
| Journal | `journal/` directory | Session-by-session records, one file per session or week | Write on exit; read selectively; not bulk-loaded at session start |

### Persistence Layer

| Mechanism | What It Persists | How It's Accessed | Confidence |
|-----------|-----------------|-------------------|------------|
| CLAUDE.md files (hierarchy) | Instructions, rules, routing pointers | Loaded every session automatically | HIGH — official docs |
| `.claude/rules/*.md` | Modular behavioral rules | Loaded at session start; path-scoped rules on demand | HIGH — official docs |
| Auto memory `MEMORY.md` (first 200 lines) | Claude's own learnings, patterns, key facts | Auto-loaded each session by Claude Code v2.1.59+ | HIGH — official docs |
| Topic files in memory dir | Detailed notes (debugging.md, patterns.md, etc.) | Read on-demand during session, not at startup | HIGH — official docs |
| Journal files | Session history, discoveries, decisions | Explicitly requested; never auto-loaded | MEDIUM — established pattern |
| `identity/` files | Soul, profile, frameworks | Lazy-loaded via `@import` in CLAUDE.md or on explicit request | HIGH — based on CLAUDE.md import mechanism |

### Context Routing Architecture

| Layer | File(s) | Lines Budget | Load Trigger |
|-------|---------|--------------|--------------|
| Root router | `CLAUDE.md` | Under 50 lines | Every session, always |
| Directory routers | Each subdir's `CLAUDE.md` | Under 100 lines each | When Claude reads files in that dir |
| Identity rules | `.claude/rules/identity.md` | Under 150 lines total for all rules | Session start |
| Path-scoped rules | `.claude/rules/` with `paths:` frontmatter | As needed | Only when matching file is opened |
| Memory index | `~/.claude/projects/*/memory/MEMORY.md` | Hard limit: 200 lines loaded | Every session auto |
| Soul/frameworks | `identity/soul.md`, `identity/frameworks/*.md` | Full files available | On-demand via `@import` or explicit read |

### Supporting Patterns

| Pattern | What | Why |
|---------|------|-----|
| `@import` syntax in CLAUDE.md | `@path/to/file` pulls file into context | Lazy loading; the file is only fetched when the CLAUDE.md referencing it loads |
| Symlinks in `.claude/rules/` | Link shared rules into multiple projects | One source of truth for identity rules across worktrees |
| YAML frontmatter on memory files | Structured metadata on journal/memory files | Machine-readable without a database; compatible with GSD patterns already in use |
| `memory: project` on subagents | Subagent-specific memory checked into git | Shared across machines; version-controlled growth of agent knowledge |

### Development Tools

| Tool | Purpose | Notes |
|------|---------|-------|
| GSD framework (`.claude/get-shit-done/`) | Project planning, phase tracking, commit tooling | Already installed; do not restructure |
| Claude Code hooks (`SessionStart`, `PostToolUse`) | Runtime injection, context monitoring | Already active; extend, don't replace |
| `bin/` scripts | Self-diagnostics, environment health checks | Bash preferred; no Node dependency for simple checks |
| Git worktrees (`.claude/worktrees/`) | Parallel session isolation | Already configured in settings |

---

## Installation

No package installation required. The stack is:

```bash
# Verify auto memory is available (requires v2.1.59+)
claude --version

# Create identity directory structure
mkdir -p /home/skogix/claude/identity/frameworks
mkdir -p /home/skogix/claude/journal

# Move personal-belongings to proper home locations (the actual work)
# soul-document.md -> identity/soul.md
# profile.md -> identity/profile.md
# core/*.md -> identity/frameworks/*.md
# journal/ -> journal/ (stays, just rehoused)
# memory-blocks/ -> identity/memory-blocks/ (reference archive)
```

---

## Alternatives Considered

| Category | Recommended | Alternative | Why Not |
|----------|-------------|-------------|---------|
| Cross-session memory | Native auto memory + CLAUDE.md | claude-mem (SQLite + Chroma vector store) | Adds infrastructure dependency; native mechanism is sufficient for single-agent use; vector search is overkill for this scale |
| Identity storage | Plain markdown files in `identity/` | External KV store, database | No runtime; markdown is git-trackable, human-readable, and directly compatible with Claude Code's file tools |
| Context routing | CLAUDE.md hierarchy + `@import` | Single large CLAUDE.md with everything | Research shows 200-line adherence cliff; routing pattern proven to reduce context by 35-54% |
| Rules organization | `.claude/rules/` directory | All rules in CLAUDE.md body | Rules directory supports path-scoping and lazy loading; CLAUDE.md body is always loaded |
| Journal format | One markdown file per session/week | Database, structured log | Markdown is directly readable by Claude without tooling; git-trackable; queryable with Grep tool |
| Deployment | Git clone to `/home/claude` | Ansible, dotfile manager (chezmoi, stow) | Repo IS the home; clone is the deploy; no extra tooling needed for this use case |

---

## What NOT to Use

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| Single monolithic CLAUDE.md over 200 lines | Research and official docs confirm adherence degrades beyond ~200 lines; frontier LLMs can reliably follow ~150-200 instructions total | CLAUDE.md as router; `.claude/rules/` for modular rules; `@import` for large documents |
| Bulk preloading identity docs at session start | The "Context Destruction Pattern" — loads everything whether needed or not; documented anti-pattern in PROJECT.md | Lazy loading via CLAUDE.md routing; `@import` only what the current session actually needs |
| External memory infrastructure (Redis, vector DB, SQLite) for single-agent use | Adds ops complexity and runtime dependencies; auto memory covers the use case; overkill until scale requires it | Native auto memory + MEMORY.md |
| Storing memory blocks as active constraints | LORE is the museum not the construction site; 10 memory blocks loaded every session would consume the context budget without benefit | Memory blocks in `identity/memory-blocks/` as reference archive; MEMORY.md for active learnings |
| Separate identity config per project | Agent identity should be consistent across projects; per-project soul documents create drift | User-level subagent memory (`memory: user`); `~/.claude/rules/` for personal identity rules |
| Executable scripts in identity files | Soul documents and profiles are declarative, not procedural; mixing instructions with automation creates confusion | Keep `identity/` as pure markdown; put automation in `bin/` |

---

## Stack Patterns by Scenario

**Scenario: Session startup (what gets loaded automatically)**
- CLAUDE.md root router (always, every session)
- `.claude/rules/*.md` without `paths:` frontmatter (always, every session)
- First 200 lines of `~/.claude/projects/.../memory/MEMORY.md` (always, if auto memory enabled)
- Nothing else unless explicitly imported or triggered by file access

**Scenario: First session after a gap (re-establishing who Claude is)**
- Root CLAUDE.md points to `identity/CLAUDE.md`
- `identity/CLAUDE.md` imports soul.md summary section or profile.md
- Full soul document available via explicit read if needed
- Journal recent entry available on request

**Scenario: Multi-agent readiness (Amy, Dot, Goose, Letta coordination)**
- Shared spaces via `skogai` group unix permissions (future; out of scope for v1)
- Per-agent memory using `memory: project` scope (`.claude/agent-memory/<agent-name>/`)
- Coordination via shared markdown files in designated `shared/` directory
- No shared database; files as the coordination primitive

**Scenario: Deployment to `/home/claude`**
- `git clone <repo> /home/claude`
- Set ownership: `chown -R claude:claude /home/claude`
- Symlink or copy `.claude/` to `~/.claude/` under user `claude`
- Claude Code reads `~/.claude/CLAUDE.md` automatically at global scope

---

## Version Compatibility

| Component | Required Version | Notes |
|-----------|-----------------|-------|
| Claude Code auto memory | v2.1.59+ | Check with `claude --version`; visible as "Recalled/Wrote memories" in UI |
| CLAUDE.md `@import` syntax | All current versions | Core feature; stable |
| `.claude/rules/` path-scoped rules | All current versions | Core feature; stable |
| Subagent `memory:` frontmatter field | Current Claude Code | Stable API; documented in official sub-agents docs |
| GSD framework | 1.26.0+ | Already installed; `VERSION` file in `.claude/get-shit-done/` |

---

## Sources

- [How Claude remembers your project — Claude Code official docs](https://code.claude.com/docs/en/memory) — CLAUDE.md scopes, auto memory mechanism, rules directory, @import syntax, 200-line guidance. HIGH confidence.
- [Create custom subagents — Claude Code official docs](https://code.claude.com/docs/en/sub-agents) — Subagent memory field, scope options (user/project/local), persistent memory directories. HIGH confidence.
- [CLAUDE.md routing pattern: keep it minimal — DEV Community](https://dev.to/builtbyzac/the-claudemd-routing-pattern-keep-it-minimal-delegate-the-rest-388a) — Routing pattern, context token cost measurement, lazy loading. MEDIUM confidence (community, aligns with official docs).
- [Claude Code Context Optimization: 54% reduction — GitHub Gist](https://gist.github.com/johnlindquist/849b813e76039a908d962b2f0923dc9a) — Empirical context reduction from lazy loading; 7,584 to 3,434 tokens. MEDIUM confidence (practitioner report).
- [Dotfiles: Taming Your Dev Environment and Your AI Coding Agents — Dr. Mowinckel's](https://drmowinckels.io/blog/2026/dotfiles-coding-agents/) — Soul/voice documents as dotfiles equivalent; symlink patterns for agent identity. MEDIUM confidence (community).
- [A Practical Guide to AI Dotfiles — Engineers Meet AI](https://engineersmeetai.substack.com/p/a-practical-guide-to-ai-dotfiles) — AI dotfiles as agent workspace configuration; structure patterns. MEDIUM confidence (community).
- [Dotfiles for Consistent AI-Assisted Development — Dylan Bochman](https://dylanbochman.com/blog/2026-01-25-dotfiles-for-ai-assisted-development/) — Version-controlled agent configurations; symlink approach. MEDIUM confidence (community).
- [AI Agent Memory Management: When Markdown Files Are All You Need — DEV Community](https://dev.to/imaginex/ai-agent-memory-management-when-markdown-files-are-all-you-need-5ekk) — Markdown-first memory; minimum viable context; escalation pattern. MEDIUM confidence.
- Existing codebase: `.planning/codebase/STACK.md`, `ARCHITECTURE.md`, `CONVENTIONS.md`, `.claude/settings.json` — Verified existing stack (Node.js/Bash/Markdown, GSD 1.26.0, hooks system). HIGH confidence (direct inspection).

---

*Stack research for: AI agent home directory — identity, persistence, context routing*
*Researched: 2026-03-20*
