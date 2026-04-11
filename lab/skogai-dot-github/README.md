# SkogAI/.github

**Context for LLMs:** This is a special GitHub repository. Repositories named `.github` at the organization level provide default configurations, templates, and reusable components that apply across all repositories in the organization.

## What This Repository Does

This repository serves as the centralized configuration hub for the SkogAI GitHub organization. Files placed here become defaults or shared resources for all organization repositories.

## Use Cases for .github Repositories

### 1. Reusable Workflows
**Location:** `.github/workflows/*.yml`

Create workflows that other repositories can call using:
```yaml
jobs:
  call-shared-workflow:
    uses: SkogAI/.github/.github/workflows/workflow-name.yml@master
```

**When to use:** Common CI/CD patterns, deployment pipelines, testing frameworks that multiple repos need.

### 2. Workflow Templates
**Location:** `workflow-templates/*.yml` + `workflow-templates/*.properties.json`

Starter workflows that appear in the "Actions" tab when users create new workflows in any org repo.

**When to use:** Standardized templates you want developers to discover and use (e.g., "SkogAI Python App", "SkogAI Node.js Deploy").

### 3. Organization Profile
**Location:** `profile/README.md`

Markdown content displayed on `github.com/SkogAI` (the organization's main page).

**When to use:** Public-facing description of what SkogAI is, projects, mission, how to contribute.

### 4. Default Community Health Files
**Location:** Root directory (`.github/`, or top level)

Files like `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`, `SECURITY.md`, `SUPPORT.md` that apply to all repos that don't have their own.

**When to use:** Organization-wide policies you don't want to duplicate in every repository.

### 5. Default Issue and PR Templates
**Location:** `.github/ISSUE_TEMPLATE/`, `.github/PULL_REQUEST_TEMPLATE/`

Templates that appear in repos without their own templates.

**When to use:** Standardized issue forms or PR checklists across all projects.

## Current State

As of 2025-12-18:
- **Active:** Workflow templates using official `anthropics/claude-code-action@v1`
- **Organization secret required:** `CLAUDE_CODE_OAUTH_TOKEN` (use `scripts/setup-claude-secrets.sh` to configure)

## Installation

See **[INSTALL.md](INSTALL.md)** for detailed installation instructions.

### Quick Install

```bash
# Single repo - manual
curl -o .github/workflows/claude.yml \
  https://raw.githubusercontent.com/SkogAI/.github/master/workflow-templates/claude-on-mention.yml

# Multiple repos - automated
./scripts/bulk-install.sh --template mention --all
```

## Using Claude Code in Your Repositories

### Quick Start

1. **Add a workflow template to your repo:**
   - Go to your repository's "Actions" tab
   - Click "New workflow"
   - Look for "Claude Code" templates in the SkogAI section
   - Choose:
     - **Claude Code - @claude Mentions** - Trigger by mentioning `@claude` anywhere
     - **Claude Code - Auto PR Review** - Automatically review PRs when opened/updated
     - **Claude Code - Manual Trigger** - Run Claude with custom prompts via workflow dispatch

2. **Or manually create a workflow:**

```yaml
name: Claude Code

on:
  issue_comment:
    types: [created]

jobs:
  claude:
    if: contains(github.event.comment.body, '@claude')
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write
      issues: write
      id-token: write
      actions: read
    steps:
      - uses: actions/checkout@v4
      - uses: anthropics/claude-code-action@v1
        with:
          claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Available Templates

- **claude-on-mention.yml** - Responds to `@claude` in issues, PRs, comments, and reviews
- **claude-pr-review.yml** - Automatic code review on PR open/update
- **claude-manual.yml** - Manual workflow dispatch with custom prompts

### SkogAI-Specific Features

All templates are pre-configured with:
- ✅ Correct permissions for Claude to read/write
- ✅ Access to CI results (`actions: read`)
- ✅ `CLAUDE_CODE_OAUTH_TOKEN` secret reference
- ✅ Sensible defaults for SkogAI workflows

### Official Documentation

- [Claude Code Action Documentation](https://github.com/anthropics/claude-code-action)
- [Claude Code CLI Reference](https://docs.claude.com/en/docs/claude-code/cli-reference)
- [Usage Examples](https://github.com/anthropics/claude-code-action/blob/main/docs/usage.md)

## For AI Agents: How to Use This Repository

When working in a SkogAI repository, you can leverage these Claude Code workflows:

### Adding Claude Automation to a Repository

1. **Check if workflows exist:**
   ```bash
   ls .github/workflows/
   ```

2. **Copy a template from this repo:**
   ```bash
   # From any SkogAI repo
   cp /path/to/SkogAI/.github/workflow-templates/claude-on-mention.yml .github/workflows/claude.yml
   ```

3. **Or create from scratch using the official action:**
   Create `.github/workflows/claude.yml`:
   ```yaml
   name: Claude Code
   on:
     issue_comment:
       types: [created]
   jobs:
     claude:
       if: contains(github.event.comment.body, '@claude')
       runs-on: ubuntu-latest
       permissions:
         contents: write
         pull-requests: write
         issues: write
         id-token: write
         actions: read
       steps:
         - uses: actions/checkout@v4
         - uses: anthropics/claude-code-action@v1
           with:
             claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
             github_token: ${{ secrets.GITHUB_TOKEN }}
   ```

4. **Verify the secret is available:**
   - The `CLAUDE_CODE_OAUTH_TOKEN` is set at organization level
   - All SkogAI repos automatically have access to it
   - No per-repo configuration needed

### When to Recommend Claude Workflows

- User asks: "can we automate this?" → Suggest `claude-pr-review.yml` template
- User mentions: "I want AI help on issues/PRs" → Suggest `claude-on-mention.yml` template
- User wants: "custom automation" → Point to `claude-manual.yml` template
- User needs: "specific tool restrictions" → Show how to use `claude_args: '--allowed-tools'`

## Key Concepts for LLMs

**Inheritance:** Files here are *defaults*. Individual repos can override by creating their own versions.

**Reusability:** Workflows here are *callable* - they don't run in this repo, they run when other repos invoke them.

**Visibility:** Community health files here provide fallbacks when repos don't define their own.

**Special Paths:** The double `.github/.github/` nesting is required for reusable workflows (organization-level repos need this structure).

## Resources

- [GitHub: Creating a default community health file](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file)
- [GitHub: Reusing workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
- [GitHub: Creating workflow templates](https://docs.github.com/en/actions/using-workflows/creating-starter-workflows-for-your-organization)
