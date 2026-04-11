# Session Wrap-Up

Run through these 4 phases to close the session properly. Each phase is a checkpoint -- complete it before moving to the next.

## Phase 1: Ship It

- Check `git status` for any uncommitted work
- Verify file placement -- are new files in the right directories? (personal/ for LORE, bin/ for scripts, notes/ for observations)
- Commit and push if there's work to ship
- Update any relevant GitHub issues or run `skogai-todo` for task tracking

## Phase 2: Remember It

What should persist beyond this session? Use the memory hierarchy (most permanent first):

1. **Auto memory** (`.planning/memory/`) -- facts, preferences, project knowledge
2. **CLAUDE.md** files -- routing, conventions, identity
3. **`.claude/rules/`** -- behavioral rules and constraints
4. **`@import`** -- reusable context blocks
5. **GitHub issues** -- actionable todos and tracked work

If new frameworks, preferences, or patterns were discovered, record them in the appropriate tier.

Do NOT use `claude.local.md` -- it is not part of the memory hierarchy.

## Phase 3: Review & Apply

- Were there any self-improvement findings this session? (better prompting patterns, workflow improvements, tooling discoveries)
- If clear and obvious: apply them now (update rules, memory, or conventions)
- If uncertain: note them in `notes/observations.md` for later consideration

## Phase 4: Journal It

Write a journal entry to `personal/journal/YYYY-MM-DD/<description>.md` where:
- `YYYY-MM-DD` is today's date
- `<description>` is a kebab-case topic slug

Include YAML frontmatter:

```yaml
---
categories:
  - journal
tags:
  - [relevant-topic-tags]
permalink: journal/YYYY-MM-DD/description
title: [Entry Title]
type: journal
---
```

Content is **immutable** after writing -- no content edits, only formatting fixes.

See `personal/journal/CONVENTIONS.md` for full conventions.
