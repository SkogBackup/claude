---
title: PROJECT
type: note
permalink: claude/projects/dot-skogai/plan/project
---

# SkogAI: Anti-Bloat Development System

## What This Is

A structured workflow system that enables building stable, maintainable software by enforcing simplicity through basic rules and principles. The system combats AI-bloat (overengineering, unnecessary documentation, over-defensive code) and supports discovery of work that can't yet be fully articulated. Built to stand the test of time across projects and context switches.

## Core Value

Rules and principles that prevent AI-generated bloat, keeping implementations direct, minimal, and functional rather than abstract and defensive.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] Rules framework that defines and enforces simplicity principles
- [ ] Planning system that handles fuzzy/unarticulated work gracefully
- [ ] Todo system for tracking work across context switches
- [ ] Discovery workflow for surfacing work that exists but isn't yet describable
- [ ] Principles that reject overengineering (unnecessary abstractions, defensive code, documentation bloat)
- [ ] Foundation for eventual F# + argc ecosystem (98% test coverage)

### Out of Scope

- Code implementation — v1 establishes system, not software
- Citing or building on existing Python/JavaScript codebase — fresh paradigm
- Migration of existing tools (docgen, mcp-builder) — not porting, reimagining
- Immediate test coverage — principle established, achieved through execution
- Complete argc library — start with patterns, build iteratively

## Context

The `.skogai/` folder is a git submodule intended to bootstrap all SkogAI projects with consistent tooling. Current state shows incomplete initialization:

- ✓ Symlink docs (complete)
- [ ] rules (missing)
- [ ] plan (missing)
- [ ] todos (missing)

The user has "a lot of things to do but cannot tell yet - for meta reasons" — this project creates the system to discover and articulate that work. The existing codebase (Python-heavy: docgen, MCP builders, bash scripts) represents exploration but not the target architecture.

Target paradigm: functional-first (F#) with structured IO (argc) and high test coverage, explicitly moving away from Python/JavaScript patterns that enable bloat.

## Constraints

- **Tech Stack**: Must integrate with Claude Code marketplace/skills/hooks infrastructure
- **Structure**: Must work within existing .skogai submodule approach for cross-project reuse
- **Philosophy**: Functional programming mindset, 98% test coverage goal (aspirational, not immediate)
- **Other**: TBD as system evolves

## Key Decisions

| Decision                                  | Rationale                                                               | Outcome   |
| ----------------------------------------- | ----------------------------------------------------------------------- | --------- |
| No code implementation in v1              | Must establish system and principles before building on them            | — Pending |
| Greenfield approach despite existing code | Current codebase is exploratory; new paradigm requires fresh foundation | — Pending |
| F# + argc as target ecosystem             | Functional paradigms enforce discipline that prevents bloat             | — Pending |

______________________________________________________________________

*Last updated: 2026-01-08 after initialization*
