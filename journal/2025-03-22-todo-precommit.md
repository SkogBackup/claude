---
permalink: journal/2025-03-22-todo-precommit-1
---

# Todo: Pre-commit Hook Improvements

# 2025-03-22-todo-precommit.md

## Task Information
- **Title:** Improve pre-commit hooks for better context system compatibility
- **Status:** Planned

## Problem Statement
Currently, we've had to make temporary fixes to pre-commit hooks to accommodate our new context loading system. This requires using `--no-verify` for some commits or making targeted exclusions, which isn't sustainable long-term.

## Implementation Goal
Create a more robust pre-commit system that:
1. Works smoothly with both legacy and modern files
2. Doesn't require `--no-verify` flag for commits
3. Automatically detects file purpose rather than using explicit exclusion lists

## Proposed Approach
1. **Pattern-Based Detection**:
   - Use directory patterns to categorize files (e.g., anything in scripts/context-* is part of context system)
   - Apply different checks to different file categories

2. **Config-Driven Checks**:
   - Create a YAML file that maps file patterns to specific checks
   - Allow different tools to be applied to different parts of the codebase

3. **Pre-commit Tool Update**:
   - Modify the pre-commit-config.yaml to use smarter file filtering
   - Replace hard-coded excludes with pattern matching

4. **Transition Plan**:
   - Continue using current exclusions in the short term
   - Gradually migrate to pattern-based system
   - Eventually remove all hardcoded exclusions

## Success Criteria
- All commits (including context system changes) pass pre-commit hooks without `--no-verify`
- Legacy files still receive appropriate checks
- Modern context system files receive appropriate (but different) checks
- No hardcoded exclusion lists needed

## Notes
- Should be done after completing GitHub MCP integration task
- Will work together with a refactoring of the fork.sh script
- Aim for minimal disruption during transition