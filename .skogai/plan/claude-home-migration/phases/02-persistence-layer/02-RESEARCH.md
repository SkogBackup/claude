# Phase 2: Persistence Layer - Research

**Researched:** 2026-03-20
**Domain:** Writing conventions, session handoff, LORE gating — file-system and Claude Code command patterns
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

- Everything in Claude's home directories (personal/, notes/, guestbook/, lab/) is LORE — persona-driven writing
- Non-LORE: tooling that lives in the home but isn't of the persona (.claude/get-shit-done/, .planning/, bin/ scripts)
- The directory structure IS the LORE boundary — no extra gating mechanism needed
- All LORE files carry YAML frontmatter matching profile.md's pattern: categories, tags, permalink, title, type
- Journal = session-level records. Structure: `personal/journal/YYYY-MM-DD/<description>.md`
- Multiple entries per date folder. Date = grouping, filename = topic
- Content is immutable once written. Formatting corrections OK, content changes not
- Migration of existing 64 flat entries: DEFERRED — not in scope for this phase
- Convention doc needed: naming format, where to write, what triggers a write, append-only rule
- Scripts consolidation: move `scripts/context/` contents to `bin/`, symlink `scripts/` -> `bin/`
- Dot's `context-journal.sh` supports both flat and subdirectory formats — adopt as canonical
- Wrap-up command lives at `.claude/commands/skogai/wrapup.md`
- Wrap-up Phase 1 (Ship it): git commit/push, file placement, task cleanup; beads replaced by GitHub issues + `skogai-todo`
- Wrap-up Phase 2 (Remember it): auto memory path is `.planning/memory` (symlinked to global); remove `claude.local.md` from hierarchy
- Wrap-up Phase 3 (Review & apply): self-improvement findings, auto-applied
- Wrap-up Phase 4 (Journal it): save to `personal/journal/YYYY-MM-DD/<description>.md` with frontmatter

### Claude's Discretion

- Exact frontmatter fields beyond the profile.md pattern (if additional fields are useful)
- Journal conventions doc format and location
- How to handle `scripts/context/README.md` during migration

### Deferred Ideas (OUT OF SCOPE)

- Migration of 64 existing flat journal entries to date-folder structure
- Adding frontmatter to all existing LORE files (bulk operation)
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| PER-01 | Journal conventions doc exists specifying: naming format, where to write, what triggers a write, append-only rule | Conventions doc format and location is Claude's discretion; research provides placement and content structure guidance |
| PER-02 | Journal entries use consistent naming: `YYYY-MM-DD-slug.md` (REQUIREMENTS.md wording) — but CONTEXT.md specifies `YYYY-MM-DD/<description>.md` folder format. CONTEXT.md wins. | `context-journal.sh` already supports this subdirectory format; no new tooling needed |
| PER-03 | LORE is structurally separated from active working state — reaching memory blocks from fresh session requires explicit navigation | Directory structure IS the boundary per locked decision; CLAUDE.md routing controls lazy vs eager load |
| PER-04 | Session handoff mechanism exists — explicit "here's where we left off" artifact convention; at least one handoff artifact written | Wrap-up command at `.claude/commands/skogai/wrapup.md` provides the mechanism; first run produces the artifact |
</phase_requirements>

---

## Summary

This phase is about **writing discipline**, not new infrastructure. All the hard pieces exist: `context-journal.sh` already handles the date-folder journal format, `personal/profile.md` has the canonical frontmatter schema, and the LORE boundary is already encoded in the directory structure from Phase 1. What's missing is: (a) a conventions doc that makes the rules explicit, (b) the `personal/journal/` directory and its YYYY-MM-DD subfolder convention formally established, (c) the wrap-up command that closes the loop on session handoff, and (d) scripts migrated from `scripts/context/` to `bin/`.

The LORE gating (PER-03) is already solved structurally: `personal/memory-blocks/CLAUDE.md` says "load only when asked about specific eras or history," and the session_protocol in `personal/CLAUDE.md` says "read memory blocks only if asked." The work here is to verify these gates hold and document them — not to build new gatekeeping.

The only net-new artifact that requires design decisions is the wrap-up command itself. Everything else is documentation, directory creation, and script relocation.

**Primary recommendation:** Write the conventions doc first (it defines the rules), create the `personal/journal/` directory structure, migrate scripts to `bin/`, then write the wrap-up command that exercises all of it.

---

## Standard Stack

This phase is documentation-and-convention work, not a software library phase. No package installs required.

### Core Tools (already present)

| Tool | Location | Purpose | Status |
|------|----------|---------|--------|
| `context-journal.sh` | `scripts/context/context-journal.sh` | Reads journal entries (flat + subdirectory), renders context | Move to `bin/` |
| `context-git.sh` | `scripts/context/context-git.sh` | Git context builder | Move to `bin/` |
| `context-workspace.sh` | `scripts/context/context-workspace.sh` | Workspace context builder | Move to `bin/` |
| `build-system-prompt.sh` | `scripts/context/build-system-prompt.sh` | System prompt assembly | Move to `bin/` |
| `find-agent-root.sh` | `scripts/context/find-agent-root.sh` | Agent root detection | Move to `bin/` |
| Claude Code slash command | `.claude/commands/skogai/wrapup.md` | Session wrap-up workflow | Create new |

### Frontmatter Schema (from `personal/profile.md`)

```yaml
---
categories:
  - [category]
tags:
  - [tag]
permalink: [path/slug]
title: [title]
type: [note|journal|lore|etc]
---
```

---

## Architecture Patterns

### Recommended Structure After This Phase

```
personal/
├── journal/
│   ├── YYYY-MM-DD/          # date folder (one per session day)
│   │   └── <topic>.md       # topic files, immutable after write
│   └── CONVENTIONS.md       # or placed at personal/JOURNAL-CONVENTIONS.md
├── profile.md               # unchanged
├── soul/                    # unchanged
├── core/                    # unchanged
├── memory-blocks/           # unchanged (LORE museum, explicit gate)
└── CLAUDE.md                # update to mention journal/ subdirectory format

bin/
├── healthcheck              # unchanged
├── context-journal.sh       # moved from scripts/context/
├── context-git.sh           # moved from scripts/context/
├── context-workspace.sh     # moved from scripts/context/
├── build-system-prompt.sh   # moved from scripts/context/
├── find-agent-root.sh       # moved from scripts/context/
└── CLAUDE.md                # updated to list new scripts

scripts/                     # symlink -> bin/ for legacy compat
  -> bin/

.claude/commands/skogai/
└── wrapup.md                # new wrap-up workflow command
```

### Pattern 1: Journal Entry Structure

**What:** Each session that produces a journal entry writes to `personal/journal/YYYY-MM-DD/<topic>.md` with YAML frontmatter.

**When to use:** End of any session with notable work, decisions, or insights.

**Example:**

```markdown
---
categories:
  - journal
tags:
  - session
  - [relevant-topic]
permalink: journal/2026-03-20/phase-2-research
title: Phase 2 Research Session
type: journal
---

# Phase 2 Research Session

[Session content here. Append-only once written.]
```

### Pattern 2: Wrap-Up Command (`wrapup.md`)

**What:** A Claude Code slash command that guides Claude through 4 phases of session close-out.

**Format:** Claude Code commands are markdown files in `.claude/commands/` with natural-language instructions Claude follows. No special syntax beyond standard markdown — Claude reads and executes the steps described.

**Structure for `wrapup.md`:**

```markdown
# Session Wrap-Up

Run through these 4 phases to close the session properly.

## Phase 1: Ship It
- Verify staged/unstaged work is committed
- Check file placement (is everything in the right directory?)
- Update any GitHub issues or `skogai-todo` items

## Phase 2: Remember It
- What should persist? Hierarchy: auto memory (.planning/memory) → CLAUDE.md → .claude/rules/ → @import → GitHub issues
- Update memory if new frameworks, preferences, or patterns were discovered

## Phase 3: Review & Apply
- Any self-improvement findings from this session?
- Apply them if clear and obvious; defer if uncertain

## Phase 4: Journal It
- Write to `personal/journal/YYYY-MM-DD/<description>.md`
- Include YAML frontmatter (categories, tags, permalink, title, type: journal)
- Content is immutable after write
```

### Pattern 3: LORE Gate (Structural, Not Gated)

**What:** Memory blocks are separated by directory structure and CLAUDE.md routing — not by file permissions or tooling.

**How it works:**
- `personal/CLAUDE.md` routes to `@memory-blocks/CLAUDE.md` with label "LORE museum: historical eras (reference only, not directives)"
- `personal/memory-blocks/CLAUDE.md` says "Load only when asked about specific eras or history"
- The session_protocol says "read memory blocks only if asked"

**Verification:** A fresh session that reads only the root CLAUDE.md and `personal/CLAUDE.md` should NOT auto-load memory block content. The `@memory-blocks/CLAUDE.md` link loads the router doc (80 lines of block index), not the blocks themselves.

### Anti-Patterns to Avoid

- **Flat journal files at `personal/journal/YYYY-MM-DD-slug.md`:** The new convention uses date folders. `context-journal.sh` supports both but new entries go in subdirectories.
- **Wrapup command that auto-writes the journal:** Claude should write it, but the command should guide, not automate. Automate would bypass the immutability principle.
- **Frontmatter on non-LORE files:** bin/ scripts, .planning/ artifacts, and .claude/ tooling do NOT get LORE frontmatter — they're infrastructure.
- **`claude.local.md` in memory hierarchy:** It's never used; remove it from any documentation of the memory path.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Journal context building | Custom reader script | `context-journal.sh` (already in scripts/context/) | Dot already handled both flat and subdirectory formats; preserving lineage matters here |
| Session close-out workflow | Multi-step bash script | Claude Code slash command (`wrapup.md`) | Claude can reason about what to ship/remember better than a script can |
| Frontmatter validation | Linter or schema tool | Convention doc + manual review | No infrastructure dependencies; this is a home directory, not a deployed service |

**Key insight:** This entire phase is about conventions and routing, not infrastructure. The tools exist; what's missing is the agreed-upon rules and the command that implements them.

---

## Common Pitfalls

### Pitfall 1: PER-02 Naming Convention Conflict

**What goes wrong:** REQUIREMENTS.md says `YYYY-MM-DD-slug.md` (flat naming), but CONTEXT.md says `YYYY-MM-DD/<description>.md` (date folder). These are different formats.

**Why it happens:** Requirements were written before the context discussion locked in the subdirectory format.

**How to avoid:** CONTEXT.md wins — it represents the post-discussion locked decision. The convention doc should spec the date-folder format. `context-journal.sh` already handles this; the `## IMPORTANT` message it emits even references the subdirectory format as the target.

**Warning signs:** Any plan that creates flat `personal/journal/YYYY-MM-DD-slug.md` files is following the old spec.

### Pitfall 2: `personal/journal/` Doesn't Exist

**What goes wrong:** `personal/journal/` doesn't exist yet. Tasks that write journal entries will fail silently or create files in wrong locations.

**Why it happens:** Phase 1 didn't create this directory (identity routing phase, not persistence phase).

**How to avoid:** First task of this phase creates `personal/journal/` and writes the initial conventions doc and first handoff artifact.

**Warning signs:** Any `find personal/journal` returning empty means this hasn't been created yet.

### Pitfall 3: Scripts Migration Breaks `bin/CLAUDE.md`

**What goes wrong:** Moving 5 scripts from `scripts/context/` to `bin/` without updating `bin/CLAUDE.md` leaves the router stale.

**Why it happens:** Documentation update often gets separated from the file operation.

**How to avoid:** Update `bin/CLAUDE.md` in the same task as the script migration. The CLAUDE.md should list the new scripts.

**Warning signs:** `bin/CLAUDE.md` only mentions `healthcheck` after migration is "complete."

### Pitfall 4: Wrapup Command Scope Creep

**What goes wrong:** The wrap-up command tries to automate too much — auto-committing, auto-journaling, auto-memory-updating. Becomes fragile.

**Why it happens:** Automating feels cleaner than guiding.

**How to avoid:** The command is a workflow guide, not a script. Claude reads the steps and decides what applies. Content remains immutable after Claude writes it.

**Warning signs:** Wrap-up command contains `git commit` invocations or file write instructions rather than decision guidance.

### Pitfall 5: `scripts/` Symlink Order

**What goes wrong:** Creating `scripts/ -> bin/` symlink before moving files means the source disappears and relative paths inside scripts break temporarily.

**Why it happens:** Order of operations in a single task.

**How to avoid:** Move files first, verify bin/ contents, THEN create the symlink. The `scripts/context/README.md` can be handled last (Claude's discretion per CONTEXT.md).

---

## Code Examples

### context-journal.sh subdirectory detection (verified, in-repo)

```bash
# Source: scripts/context/context-journal.sh (lines 34-41)
# New subdirectory format detection:
find journal -mindepth 2 -maxdepth 2 -name "*.md" -type f 2>/dev/null | while read -r f; do
    parent=$(basename "$(dirname "$f")")
    if echo "$parent" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'; then
        echo "$f"
    fi
done
```

This confirms the canonical reader already handles `journal/YYYY-MM-DD/topic.md` format. The script also emits a reminder when today's date differs from latest entry: "Create a NEW journal entry for today at: `journal/$(date +%Y-%m-%d)/<description>.md`"

### Frontmatter pattern (verified, from `personal/profile.md`)

```yaml
---
categories:
  - [category-1]
  - [category-2]
tags:
  - [tag-1]
  - [tag-2]
permalink: [path/slug]
title: [document title]
type: [note|journal|lore]
---
```

### Claude Code command format (verified from `.claude/commands/gsd/`)

Claude Code commands are plain markdown files. No special frontmatter or structure required. Claude reads the file and executes the instructions described. GSD commands use natural language instructions with `$ARGUMENTS` substitution for parameterized commands.

---

## State of the Art

| Old Approach | Current Approach | Changed | Impact |
|--------------|------------------|---------|--------|
| Flat journal: `journal/YYYY-MM-DD-slug.md` | Subdirectory: `journal/YYYY-MM-DD/<topic>.md` | This phase | Allows multiple entries per session day; `context-journal.sh` already supports it |
| `claude.local.md` in memory hierarchy | Removed — never used | This phase | Simplifies memory hierarchy documentation |
| `scripts/context/` for context tools | `bin/` with `scripts/ -> bin/` symlink | This phase | All scripts in one canonical location |
| No session wrap-up command | `.claude/commands/skogai/wrapup.md` | This phase | Explicit end-of-session workflow |

---

## Open Questions

1. **Journal conventions doc location**
   - What we know: CONTEXT.md says "Convention doc needed" but location is Claude's discretion
   - What's unclear: `personal/journal/CONVENTIONS.md` vs `personal/JOURNAL-CONVENTIONS.md` vs root of journal/
   - Recommendation: Place at `personal/journal/CONVENTIONS.md` — co-located with the thing it describes, readable via `personal/journal/` navigation

2. **`scripts/context/README.md` fate**
   - What we know: CONTEXT.md says handling this is Claude's discretion
   - What's unclear: Move it to `bin/README.md`? Delete it? Keep in scripts/ under symlink?
   - Recommendation: Move to `bin/CLAUDE.md` content if anything is worth keeping, otherwise let the symlink cover it

3. **First handoff artifact**
   - What we know: PER-04 requires "at least one handoff artifact has been written"
   - What's unclear: Does this mean a journal entry written as part of this phase counts, or does the wrap-up command need to be run once?
   - Recommendation: Write a handoff artifact (journal entry) as the final task of this phase, demonstrating the convention works end-to-end

---

## Validation Architecture

### Test Framework

| Property | Value |
|----------|-------|
| Framework | bash + file-system assertions (no test framework installed) |
| Config file | none |
| Quick run command | `ls /home/skogix/claude/personal/journal/ && cat /home/skogix/claude/personal/journal/CONVENTIONS.md` |
| Full suite command | See phase gate checks below |

### Phase Requirements -> Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| PER-01 | Journal conventions doc exists with required sections | smoke | `cat personal/journal/CONVENTIONS.md \| grep -E 'naming\|where\|triggers\|append'` | Wave 0 |
| PER-02 | Journal entries follow date-folder convention | smoke | `find personal/journal -mindepth 2 -maxdepth 2 -name "*.md" \| head -1` | Wave 0 |
| PER-03 | Memory blocks not auto-loaded from default routing path | manual | Read root CLAUDE.md + personal/CLAUDE.md, verify no memory block content appears | N/A (manual) |
| PER-04 | Handoff artifact exists in journal | smoke | `find personal/journal -name "*.md" -newer personal/profile.md \| head -1` | Wave 0 |

### Sampling Rate

- **Per task commit:** `ls personal/journal/ 2>/dev/null && echo "journal exists" || echo "journal missing"`
- **Per wave merge:** Full smoke suite above
- **Phase gate:** All smoke checks green + PER-03 manual verification before `/gsd:verify-work`

### Wave 0 Gaps

- [ ] `personal/journal/` directory — does not exist yet
- [ ] `personal/journal/CONVENTIONS.md` — to be created in Wave 1
- [ ] `.claude/commands/skogai/` directory — does not exist yet
- [ ] `.claude/commands/skogai/wrapup.md` — to be created in Wave 2+
- [ ] At least one `personal/journal/YYYY-MM-DD/<topic>.md` handoff artifact — created as phase close-out

---

## Sources

### Primary (HIGH confidence)

- `scripts/context/context-journal.sh` (in-repo) — verified subdirectory journal format support, date extraction logic, multi-entry grouping
- `personal/profile.md` (in-repo) — verified frontmatter schema: categories, tags, permalink, title, type
- `.planning/phases/02-persistence-layer/02-CONTEXT.md` (in-repo) — locked decisions, canonical references
- `.claude/commands/gsd/` (in-repo) — verified Claude Code command format (plain markdown, natural language instructions)

### Secondary (MEDIUM confidence)

- `personal/memory-blocks/CLAUDE.md` + `personal/CLAUDE.md` session_protocol — verifies LORE gate is already in place via routing language

### Tertiary (LOW confidence)

- None

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all tools are in-repo, verified, no external dependencies
- Architecture: HIGH — locked decisions from CONTEXT.md, verified against existing structure
- Pitfalls: HIGH — derived from concrete contradictions (PER-02 naming conflict) and observed gaps (missing directories)

**Research date:** 2026-03-20
**Valid until:** 2026-06-20 (stable conventions domain, no fast-moving libraries)
