---
title: EPIC-3-plugin-suggestions
type: note
permalink: claude/projects/dot-skogai/plan/garden/epic-3-plugin-suggestions
---

# Epic 3: Plugin Suggestions

**Status:** 🔜 Pending **Phase:** 3 of 4 **Depends on:** Epic 2 (Trial Management Commands)

## Overview

Automatically detect project tech stack and suggest relevant plugins for trial. Integrates with compound workflow to recommend plugins based on actual project needs.

## Goals

- Detect tech stack from project files
- Suggest relevant plugins automatically
- Integrate with /compound workflow
- Make plugin discovery effortless

## Deliverables

- [ ] tech stack detection script
- [ ] plugin suggestion system
- [ ] integration with /compound workflow
- [ ] plugin mappings database

## Files to Create

- `plugins/garden/scripts/detect-stack.sh` - detect Rails, Python, TypeScript, etc
- `plugins/garden/data/plugin-mappings.json` - tech stack → plugin mappings

## Files to Modify

- workflows compound command to call suggestion system after documenting learnings

## Implementation Details

### Tech Stack Detection

Detect stack from filesystem markers:

```bash
# Rails
if [[ -f "Gemfile" ]] && grep -q "rails" Gemfile; then
  suggestions+=("rails-reviewer")
  suggestions+=("dhh-rails")
fi

# Python
if [[ -f "requirements.txt" ]] || [[ -f "pyproject.toml" ]]; then
  suggestions+=("python-expert")
fi

# TypeScript
if [[ -f "tsconfig.json" ]]; then
  suggestions+=("typescript-expert")
fi

# Frontend frameworks
if [[ -f "package.json" ]]; then
  if grep -q "react" package.json; then
    suggestions+=("react-reviewer")
  fi
  if grep -q "vue" package.json; then
    suggestions+=("vue-reviewer")
  fi
fi
```

### Plugin Mappings Schema

```json
{
  "stacks": {
    "rails": {
      "markers": ["Gemfile"],
      "patterns": ["rails"],
      "plugins": ["rails-reviewer", "dhh-rails", "data-integrity"]
    },
    "python": {
      "markers": ["requirements.txt", "pyproject.toml", "setup.py"],
      "plugins": ["python-expert"]
    },
    "typescript": {
      "markers": ["tsconfig.json"],
      "plugins": ["typescript-expert"]
    },
    "frontend": {
      "markers": ["package.json"],
      "patterns": ["react", "vue", "angular"],
      "plugins": ["design-reviewer", "design-iterator"]
    }
  }
}
```

### Compound Integration

After `/compound` documents learnings:

```
✅ learning documented

💡 detected rails project
   suggested plugins:
   - /garden:trial rails-reviewer
   - /garden:trial dhh-rails

   try them? [y/n]
```

## Testing Plan

- [ ] create test projects for each stack (rails, python, typescript)
- [ ] verify correct plugins suggested for each stack
- [ ] test multi-stack projects (rails + react frontend)
- [ ] verify suggestions don't duplicate already-trialed plugins
- [ ] test integration with /compound workflow

## Success Criteria

- Stack detection works for major frameworks
- Suggestions are relevant and non-intrusive
- Integration with /compound is seamless
- Users can easily accept/decline suggestions

## Related Issues

- Epic 2: Trial Management Commands (dependency)
- Epic 4: Refinement and UX (enhances suggestions)
