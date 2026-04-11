# Installing Claude Code Workflows

Quick guide for adding Claude Code automation to SkogAI repositories.

## Prerequisites

1. **Organization secret configured:**
   ```bash
   gh secret list --org SkogAI | grep CLAUDE_CODE_OAUTH_TOKEN
   ```
   If not set, run `./scripts/setup-claude-secrets.sh`

2. **GitHub CLI authenticated:**
   ```bash
   gh auth status
   ```

## Option 1: Manual Install (Single Repo)

### Quick Start - @claude Mentions

```bash
# Navigate to your repo
cd /path/to/your/repo

# Create workflows directory if needed
mkdir -p .github/workflows

# Copy the template
curl -o .github/workflows/claude.yml \
  https://raw.githubusercontent.com/SkogAI/.github/master/workflow-templates/claude-on-mention.yml

# Commit and push
git add .github/workflows/claude.yml
git commit -m "feat: Add Claude Code workflow for @claude mentions"
git push
```

### Full Install - All Templates

```bash
# Navigate to your repo
cd /path/to/your/repo

# Create workflows directory
mkdir -p .github/workflows

# Copy all templates
curl -o .github/workflows/claude.yml \
  https://raw.githubusercontent.com/SkogAI/.github/master/workflow-templates/claude-on-mention.yml

curl -o .github/workflows/claude-pr-review.yml \
  https://raw.githubusercontent.com/SkogAI/.github/master/workflow-templates/claude-pr-review.yml

curl -o .github/workflows/claude-manual.yml \
  https://raw.githubusercontent.com/SkogAI/.github/master/workflow-templates/claude-manual.yml

# Commit and push
git add .github/workflows/claude*.yml
git commit -m "feat: Add Claude Code workflows"
git push
```

## Option 2: Automated Install (Multiple Repos)

Use the bulk installer script:

```bash
# Clone this repo if you haven't
git clone git@github.com:SkogAI/.github.git
cd .github

# See all SkogAI repos and their Claude workflow status
./scripts/bulk-install.sh --list

# Install @claude mention workflow to all repos
./scripts/bulk-install.sh --template mention --all

# Install to specific repos
./scripts/bulk-install.sh --template mention --repos "skogix,dotfiles,ansible"

# Install all templates to specific repos
./scripts/bulk-install.sh --template all --repos "skogix"

# Dry run (preview changes without committing)
./scripts/bulk-install.sh --template mention --all --dry-run
```

## Option 3: Via GitHub UI

1. Go to your repository on GitHub
2. Click **Actions** tab
3. Click **New workflow**
4. Look for **SkogAI** section (may take a few minutes after templates are pushed)
5. Choose a Claude Code template
6. Commit the workflow file

**Note:** GitHub's UI discovery of org templates can be delayed. Manual/automated install is faster.

## Verifying Installation

After installing, verify the workflow is active:

```bash
# In your repo
gh workflow list | grep -i claude
```

You should see workflows like:
- `Claude Code` (from claude-on-mention.yml)
- `Claude Code Review` (from claude-pr-review.yml)
- `Claude Code - Manual Trigger` (from claude-manual.yml)

## Testing

Create a test issue and mention `@claude`:

```bash
gh issue create --title "Test Claude" --body "@claude Please confirm you're working"
```

Check workflow runs:

```bash
gh run list --limit 5
```

## Customizing Workflows

### Restrict to Specific File Types

Edit `.github/workflows/claude-pr-review.yml`:

```yaml
on:
  pull_request:
    types: [opened, synchronize]
    paths:
      - "src/**/*.ts"
      - "src/**/*.py"
```

### Restrict Tools

Edit any workflow to add `claude_args`:

```yaml
- uses: anthropics/claude-code-action@v1
  with:
    claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
    github_token: ${{ secrets.GITHUB_TOKEN }}
    claude_args: '--allowed-tools "Bash(gh pr:*),Read,Grep"'
```

See [Claude Code CLI Reference](https://docs.claude.com/en/docs/claude-code/cli-reference) for all options.

## Troubleshooting

### Workflow doesn't trigger

1. Check workflow syntax: `gh workflow list`
2. Verify secret exists: `gh secret list --org SkogAI | grep CLAUDE`
3. Check workflow file has correct permissions (see templates)

### Claude doesn't respond

1. Check workflow run logs: `gh run list`, then `gh run view <run-id>`
2. Verify `CLAUDE_CODE_OAUTH_TOKEN` is valid
3. Check if `@claude` mention is in comment body

### Permission errors

Ensure workflow has required permissions:

```yaml
permissions:
  contents: write
  pull-requests: write
  issues: write
  id-token: write
  actions: read
```

## Updating Workflows

When SkogAI/.github templates are updated, re-run the install:

```bash
# Manual update
curl -o .github/workflows/claude.yml \
  https://raw.githubusercontent.com/SkogAI/.github/master/workflow-templates/claude-on-mention.yml

# Or use bulk installer
./scripts/bulk-install.sh --template mention --repos "your-repo" --force
```
