# Merge Log — projects/ → claude/

Traceability record for content merged from ~/projects/ into ~/claude/.
Created 2026-02-27.

## Completed Merges

### hq/CONVENTIONS.md → claude/CONVENTIONS.md
- **Action:** Created new file
- **Source:** projects/hq/CONVENTIONS.md
- **Content:** File conventions, @-imports, SKOGAI.md/CLAUDE.md purposes
- **Rationale:** Institutional conventions had no home in ~/claude

### hq/DECISIONS.md → claude/DECISIONS.md
- **Action:** Created new file
- **Source:** projects/hq/DECISIONS.md
- **Content:** 120 lines of architectural history — install choices, project structure, conventions
- **Rationale:** Decision log is institutional memory that belongs at HQ

### hq/RULES.md → claude/RULES.md
- **Action:** Selectively absorbed (appended new section)
- **Source:** projects/hq/RULES.md
- **Content:** @-import notation rules, .list file convention, cross-project messaging
- **Rationale:** These rules were not in ~/claude/RULES.md yet

### skogai-core/ → claude/projects/skogai-core/
- **Action:** Copied entire directory
- **Source:** projects/skogai-core/
- **Content:** Claude Code plugin scaffold — commands, agents, skills, hooks, docs
- **Rationale:** Plugin development scaffold belongs with Claude Code project

## Not Merged (Reference Only)

### projects/dotfiles/
- **Reason:** Own domain (user configs via bare repo). Referenced, not merged.

### projects/git/
- **Reason:** Own domain (git identity/auth). Referenced, not merged.

### projects/system/
- **Reason:** Own domain (hardware/networking/services). Referenced, not merged.

## Captured as Future Work

These items from projects/claude-code/TODO.md were open but deferred. Captured here for future pickup:

- [ ] Evaluate adding more MCP servers as needed
- [ ] Learn settings defaults before customizing — only change at real pain points
- [ ] Keybindings (vim-style) — defer until default bindings feel limiting
- [ ] Plugin exploration — learn what's built-in first
- [ ] Hook exploration — learn what's built-in first
- [ ] Continue learning memory system through use

### projects/claude-code/ plans (archived)
- original-plan.md and changed-plan.md were historical plans for slimming ~/CLAUDE.md
- Content is superseded by current ~/claude/CLAUDE.md structure
- Not merged — reference only if architectural archaeology is needed
