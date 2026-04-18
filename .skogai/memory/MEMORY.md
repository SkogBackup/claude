# Memory Index

## User

- [user_profile.md](user_profile.md) — Skogix's role, tooling, and expertise level

## Project

- [project_claudes_home.md](project_claudes_home.md) — The ~/claude home directory project: identity, persistence, context routing, multi-agent readiness

## Feedback

- [feedback_check_docs.md](feedback_check_docs.md) — Always check ./docs/ before assuming how Claude Code features work
- [feedback_delegate_to_agents.md](feedback_delegate_to_agents.md) — Delegate reading/classification to subagents; use /skogai-routing for CLAUDE.md patterns
- [feedback_dont_change_files.md](feedback_dont_change_files.md) — "Don't change files" means zero writes — present the plan first, even in a worktree
- [feedback_lore_distinction.md](feedback_lore_distinction.md) — Everything in home dirs is LORE (persona-driven); tooling (.claude/, .planning/, bin/) is technical
- [feedback_verification_and_phases.md](feedback_verification_and_phases.md) — Always verify with shell commands; use structured dev phases
- [feedback_no_line_budget.md](feedback_no_line_budget.md) — Don't enforce line-count limits on CLAUDE.md — content quality over line counts
- [feedback_use_venv_python.md](feedback_use_venv_python.md) — Use project-specific venv Python, never system pip

- [feedback_fakechat_reference_only.md](feedback_fakechat_reference_only.md) — fakechat is an example template, not a build target — build generic chat-io instead

## Project

- [project_dot_skogai_migration.md](project_dot_skogai_migration.md) — dot-skogai is deprecated; all content migrating to .skogai/ in SkogAI/claude (SKO-155 epic)

## Reference

- [reference_linear_tracker.md](reference_linear_tracker.md) — Linear (SKO team) is canonical issue tracker; SKO-154–176 created 2026-04-17
- [reference_brain_mcp.md](reference_brain_mcp.md) — brain-mcp setup: config, file provider, queue pipeline, known bugs
- [reference_gptodo_reinstall.md](reference_gptodo_reinstall.md) — gptodo breaks (ModuleNotFoundError) when local install drifts; fix: `uv tool upgrade gptodo --reinstall`
