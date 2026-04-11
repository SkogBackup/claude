#!/usr/bin/env bash
# @describe SkogAI/.github workflow manager
# @version 1.0.0
#
# Manage Claude Code workflow templates across SkogAI repositories

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ORG="SkogAI"

# @cmd List all repositories and their workflow status
list() {
    "$SCRIPT_DIR/scripts/bulk-install.sh" --list
}

# @cmd Install Claude Code workflows to repositories
# @option --template[=mention|pr-review|manual|all] <TEMPLATE> Template to install
# @option --repos <REPOS> Comma-separated list of repository names
# @flag --all Install to all SkogAI repositories
# @flag --dry-run Preview changes without committing
# @flag --force Overwrite existing workflow files
install() {
    local args=()

    if [ -n "$argc_template" ]; then
        args+=("--template" "$argc_template")
    else
        echo "Error: --template is required"
        exit 1
    fi

    if [ "$argc_all" = "1" ]; then
        args+=("--all")
    elif [ -n "$argc_repos" ]; then
        args+=("--repos" "$argc_repos")
    else
        echo "Error: Either --all or --repos must be specified"
        exit 1
    fi

    if [ "$argc_dry_run" = "1" ]; then
        args+=("--dry-run")
    fi

    if [ "$argc_force" = "1" ]; then
        args+=("--force")
    fi

    "$SCRIPT_DIR/scripts/bulk-install.sh" "${args[@]}"
}

# @cmd Check workflow status for specific repositories
# @arg repos+ Repository names to check
status() {
    local repos=("$@")

    echo "Checking workflow status for: ${repos[*]}"
    echo ""

    for repo in "${repos[@]}"; do
        echo "Repository: $repo"
        echo "─────────────────────────────"

        # Check for claude.yml (mention workflow)
        if gh api "repos/$ORG/$repo/contents/.github/workflows/claude.yml" &>/dev/null || \
           gh api "repos/$ORG/$repo/contents/.github/workflows/claude-on-mention.yml" &>/dev/null; then
            echo "✅ Mention workflow: Installed"
        else
            echo "❌ Mention workflow: Not installed"
        fi

        # Check for PR review workflow
        if gh api "repos/$ORG/$repo/contents/.github/workflows/claude-pr-review.yml" &>/dev/null || \
           gh api "repos/$ORG/$repo/contents/.github/workflows/claude-code-review.yml" &>/dev/null; then
            echo "✅ PR Review workflow: Installed"
        else
            echo "❌ PR Review workflow: Not installed"
        fi

        # Check for manual workflow
        if gh api "repos/$ORG/$repo/contents/.github/workflows/claude-manual.yml" &>/dev/null; then
            echo "✅ Manual workflow: Installed"
        else
            echo "❌ Manual workflow: Not installed"
        fi

        echo ""
    done
}

# @cmd Show template information
# @arg template[`_choice_template`] Template name to show
templates() {
    local template="${1:-}"

    if [ -z "$template" ]; then
        echo "Available templates:"
        echo ""
        echo "  mention    - Trigger Claude on @claude mentions"
        echo "  pr-review  - Auto-review PRs when opened/updated"
        echo "  manual     - Manual workflow dispatch with custom prompts"
        echo "  all        - All templates"
        echo ""
        echo "Use: argc templates <name> to see template details"
        return
    fi

    local template_file=""
    case "$template" in
        mention)
            template_file="workflow-templates/claude-on-mention.yml"
            ;;
        pr-review)
            template_file="workflow-templates/claude-pr-review.yml"
            ;;
        manual)
            template_file="workflow-templates/claude-manual.yml"
            ;;
        *)
            echo "Unknown template: $template"
            exit 1
            ;;
    esac

    if [ -f "$SCRIPT_DIR/$template_file" ]; then
        echo "Template: $template"
        echo "File: $template_file"
        echo ""
        cat "$SCRIPT_DIR/$template_file"
    else
        echo "Template file not found: $template_file"
        exit 1
    fi
}

# @cmd Quick install mention workflow to specific repos
# @arg repos+ Repository names
# @flag --dry-run Preview changes
# @flag --force Overwrite existing files
quick() {
    local repos="${*}"
    local args=("--template" "mention" "--repos" "${repos// /,}")

    if [ "$argc_dry_run" = "1" ]; then
        args+=("--dry-run")
    fi

    if [ "$argc_force" = "1" ]; then
        args+=("--force")
    fi

    "$SCRIPT_DIR/scripts/bulk-install.sh" "${args[@]}"
}

# @cmd Validate prerequisites and configuration
check() {
    echo "Checking prerequisites..."
    echo ""

    # Check gh CLI
    if command -v gh &>/dev/null; then
        echo "✅ GitHub CLI (gh) installed: $(gh --version | head -n1)"
    else
        echo "❌ GitHub CLI (gh) not found"
        echo "   Install: https://cli.github.com/"
        exit 1
    fi

    # Check gh auth
    if gh auth status &>/dev/null; then
        echo "✅ GitHub CLI authenticated"
    else
        echo "❌ GitHub CLI not authenticated"
        echo "   Run: gh auth login"
        exit 1
    fi

    # Check org secret
    if gh secret list --org "$ORG" 2>/dev/null | grep -q CLAUDE_CODE_OAUTH_TOKEN; then
        echo "✅ CLAUDE_CODE_OAUTH_TOKEN configured"
    else
        echo "⚠️  CLAUDE_CODE_OAUTH_TOKEN not found in org secrets"
        echo "   Run: ./scripts/setup-claude-secrets.sh"
    fi

    # Check templates exist
    echo ""
    echo "Templates:"
    for template in workflow-templates/*.yml; do
        if [ -f "$template" ]; then
            echo "  ✅ $(basename "$template")"
        fi
    done

    echo ""
    echo "✅ All checks passed"
}

# Choice function for templates
_choice_template() {
    echo "mention"
    echo "pr-review"
    echo "manual"
}

# Run argc
eval "$(argc --argc-eval "$0" "$@")"
