---
name: ci
description: Reference guide for the three GitHub Actions CI workflows in this repo — when to trigger each, how they work, and how to customize tool access.
---

## CI Workflows

All three workflows delegate to `SkogAI/.github` reusable workflows and require the `CLAUDE_CODE_OAUTH_TOKEN` secret.

### claude.yml — @claude mention
**Triggers:** `@claude` appears in issue body/title (on open/assign), issue comment, PR review comment, or PR review body.
**Invokes:** `SkogAI/.github/.github/workflows/claude-mention.yml`
**To trigger:** Mention `@claude` anywhere in a GitHub issue or PR.
**Customization:**
- `prompt`: override the prompt Claude receives
- `claude_args`: restrict/expand tool access (e.g. `--allowed-tools Bash(gh pr:*)`)

### claude-pr-review.yml — Auto PR review
**Triggers:** Every PR opened or synchronized.
**Invokes:** `SkogAI/.github/.github/workflows/claude-pr-review.yml`
**Default:** Read-only tool access.
**Customization:** Pass `claude_args` to expand tool access for commenting.

### claude-manual.yml — Manual dispatch
**Triggers:** GitHub → Actions tab → "Claude Code - Manual Trigger" → Run workflow.
**Inputs:**
- `prompt` (required) — the task to run
- `issue_number` (optional) — provides issue/PR context to Claude
**To trigger:** Actions tab → select "Claude Code - Manual Trigger" → "Run workflow" button.

## Required Secret
`CLAUDE_CODE_OAUTH_TOKEN` must be set in the repo's GitHub Secrets (Settings → Secrets and variables → Actions).
