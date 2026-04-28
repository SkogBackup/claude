---
title: AGENTS
type: router
permalink: claude/lab/agents
---

# lab/ — Experiments + WIP

Staging area for work in progress, experiments, and prototypes. Nothing here is stable.

## OVERVIEW

Skogix's sandbox: testing ground for skills, workflows, and SkogAI features before permanent home.

## STRUCTURE

```
lab/
├── projects-in-development/   # Active dev projects (skogtown, navigate-skogai, etc.)
├── old-claude-prompt-example.xml
├── README.md                  # Lab overview + experiment ideas
└── CLAUDE.md                 # This file
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Active dev projects | `projects-in-development/CLAUDE.md` | Argcfile.sh, repo management |
| Experiment ideas | `README.md` | Skill authoring, cross-session context, agent protocols |
| Skill testing | `projects-in-development/skogai-*/` | Various WIP skill packages |

## CONVENTIONS (parent doesn't cover)

- **Unstable**: Move finished work to proper directory when done
- **No versioning**: Everything here is interim — final home gets the git history
- **Argcfile.sh**: Repository management CLI at `projects-in-development/Argcfile.sh`

## ANTI-PATTERNS

- Don't treat lab code as production — it's all experimental
- Don't expect stability — interfaces change without notice
- Don't look for tests — WIP by definition
