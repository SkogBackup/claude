# Projects Merge into Claude HQ

Nelson squadron mission to survey ~/projects/ and merge relevant content into ~/claude.

## What happened

Surveyed 6 projects (hq, claude-code, dotfiles, git, system, skogai-core) and classified each as merge, absorb, or reference-only.

**Merged:**
- hq/CONVENTIONS.md → ~/claude/CONVENTIONS.md (file conventions, @-imports)
- hq/DECISIONS.md → ~/claude/DECISIONS.md (120 lines of architectural history)
- hq/RULES.md → absorbed into ~/claude/RULES.md (@ notation, .list convention)
- skogai-core/ → ~/claude/projects/skogai-core/ (plugin scaffold)

**Cleaned up:**
- Removed .todo/demodotfiles/ (4,772 lines of redundant project snapshots)
- Moved findings-nelson-memory-patterns.md to journal/
- Removed duplicate todo/rtk-optimized.md

**Promoted to global ~/.claude/:**
- Commands: learn, catchup
- Agents: doc-writer

**Not merged (reference only):** dotfiles, git, system — domain-specific projects.

## Fleet-memory audit

Applied fleet-memory tier classification to ~/claude post-merge:
- Policy: CLAUDE.md, RULES.md, CONVENTIONS.md, SKILL.md, AGENTS.md
- Knowledge: DECISIONS.md, .todo/skills/
- State: merge-log.md, journal/
- Entity: projects/skogapi, projects/newinstall, projects/skogai-core

## csync.sh incident

Added `--delete` flag to rsync which nuked 4,945 files from global/ mirror. Reverted within minutes. Root cause: rsync `--delete` removes destination files not present in source — exactly wrong for an add-only observability mirror. Fixed to `-a` without `--delete`.

## Traceability

Each merge got its own git commit with structured provenance messages. merge-log.md serves as the master trail. Beads was unavailable (Dolt server down) — git commits substituted.

## Commit trail

```
8d94411 merge: relocate skogai-core plugin scaffold
62c19f2 merge: add merge-log.md traceability trail
330607c merge: DECISIONS.md from projects/hq
3ffe6a9 merge: absorb @ convention and .list rules
7252c55 cleanup: archive demodotfiles mirror, relocate loose findings
a13f0dc cleanup: remove duplicate todo/rtk-optimized.md
5216c9a Revert "auto-sync 18:11:02" (fix --delete damage)
```
