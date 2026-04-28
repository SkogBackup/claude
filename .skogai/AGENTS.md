---
title: AGENTS
type: router
permalink: claude/projects/dot-skogai/agents
---

# .skogai/ — SkogAI Bootstrap

Shared config/knowledge base for all SkogAI projects. Consumed as git submodule at `.skogai/` or symlink (dogfooding).

## OVERVIEW

SkogAI ecosystem bootstrap: conventions, scripts, skills registry, workflow orchestration, memory system.

## STRUCTURE

```
.skogai/
├── scripts/          # 26 argc-powered bash scripts (context/, utils/, bootstrap/)
├── skills/           # Domain-specific Claude Code skills (SKILL.md + manifest.json)
├── knowledge/        # Decisions, lessons, patterns (knowledge/DECISIONS.md router)
├── memory/           # Glossary, projects index, feedback
├── plan/            # Project plans (claudes-home/, ROADMAP.md, STATE.md)
├── templates/        # Starter templates (CLAUDE.md, decision-record, etc.)
├── workflows/        # Dagu DAG definitions
├── bin/             # Wrappers (skogai-loops, skogai-ralph)
├── dotfiles/         # Installer scripts
├── email/            # Inbox/drafts/sent/archive
├── Argcfile.sh       # CLI for queue management
├── base.yaml         # Dagu base config
├── config.yaml       # Dagu server config
└── CLAUDE.md        # This subtree's router
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Add/edit skill | `skills/<name>/SKILL.md` | Manifest in `skill-registry.json` |
| Run script | `scripts/context/` or `scripts/utils/` | All use argc — check `--help` |
| Log decision | `knowledge/decisions/` | Index in `knowledge/DECISIONS.md` |
| Check workflows | `workflows/` | `dagu start-all` → localhost:8080 |
| Active todos | `todos/` | NNN-status-pN-description.md |

## CONVENTIONS (parent doesn't cover)

- **Argc framework**: All `scripts/` use `# @describe` / `# @arg` declarative CLI
- **Functional-first**: Data transformations > control flow, pure functions, immutable data
- **Script colors**: RED=errors, GREEN=success, YELLOW=warnings, BLUE=info
- **Dagu**: Small YAML DAGs, `jq` for JSON (never sed/awk), `output:`/`parallel:`/`retryPolicy:`
- **Skills**: Each in `skills/<name>/` — SKILL.md + manifest.json
- **Detection**: `file .skogai` → symlink=dogfooding, directory=submodule

## ANTI-PATTERNS

- Never hide errors/warnings behind abstractions
- No speculative abstractions — only what the task requires
- No code implementation in v1 (bootstrap first, build after)
- Keep portable — no absolute paths or user-specific settings
- `@ notation is truth` — use `@file` for must-be-current content
