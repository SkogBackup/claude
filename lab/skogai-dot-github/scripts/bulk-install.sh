#!/bin/bash
#
# Bulk installer for Claude Code workflows across SkogAI repositories
#
# Usage:
#   ./bulk-install.sh --list                                    # List all repos and status
#   ./bulk-install.sh --template mention --all                  # Install to all repos
#   ./bulk-install.sh --template mention --repos "repo1,repo2"  # Install to specific repos
#   ./bulk-install.sh --template all --repos "skogix"           # Install all templates
#   ./bulk-install.sh --template mention --all --dry-run        # Preview changes

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ORG="SkogAI"
TEMPLATE_DIR="workflow-templates"
DRY_RUN=false
FORCE=false

# Resolve script directory at startup (before we change directories)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Template mappings
declare -A TEMPLATES=(
    [mention]="claude-on-mention.yml:claude.yml"
    [pr-review]="claude-pr-review.yml:claude-pr-review.yml"
    [manual]="claude-manual.yml:claude-manual.yml"
)

usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Bulk install Claude Code workflows to SkogAI repositories.

OPTIONS:
    --list                  List all repos and their Claude workflow status
    --template TEMPLATE     Which template to install: mention, pr-review, manual, all
    --all                   Install to all SkogAI repositories
    --repos "repo1,repo2"   Install to specific repositories (comma-separated)
    --dry-run               Preview changes without committing
    --force                 Overwrite existing workflow files
    -h, --help              Show this help message

EXAMPLES:
    # List repos
    $0 --list

    # Install @claude mention workflow to all repos
    $0 --template mention --all

    # Install to specific repos
    $0 --template mention --repos "skogix,dotfiles"

    # Install all templates to one repo
    $0 --template all --repos "skogix"

    # Dry run to preview
    $0 --template mention --all --dry-run

EOF
    exit 0
}

log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

check_prerequisites() {
    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI (gh) is not installed"
        exit 1
    fi

    if ! gh auth status &> /dev/null; then
        log_error "Not authenticated with GitHub CLI. Run: gh auth login"
        exit 1
    fi

    if ! gh secret list --org "$ORG" 2>/dev/null | grep -q CLAUDE_CODE_OAUTH_TOKEN; then
        log_warning "CLAUDE_CODE_OAUTH_TOKEN not found in org secrets"
        log_info "Run: ./scripts/setup-claude-secrets.sh"
    fi
}

list_repos() {
    log_info "Fetching SkogAI repositories..."
    echo ""

    # Get all repos
    REPOS=$(gh repo list "$ORG" --json name,isPrivate,updatedAt --limit 100 -q '.[].name')

    printf "%-30s %-15s %-15s %-15s\n" "REPOSITORY" "MENTION" "PR-REVIEW" "MANUAL"
    printf "%-30s %-15s %-15s %-15s\n" "----------" "-------" "---------" "------"

    for repo in $REPOS; do
        # Check for workflows (using API to avoid cloning)
        HAS_MENTION="❌"
        HAS_PR_REVIEW="❌"
        HAS_MANUAL="❌"

        # Check if workflows exist via API
        if gh api "repos/$ORG/$repo/contents/.github/workflows" 2>/dev/null | grep -q "claude.yml\|claude-on-mention.yml"; then
            HAS_MENTION="✅"
        fi
        if gh api "repos/$ORG/$repo/contents/.github/workflows" 2>/dev/null | grep -q "claude-pr-review.yml\|claude-code-review.yml"; then
            HAS_PR_REVIEW="✅"
        fi
        if gh api "repos/$ORG/$repo/contents/.github/workflows" 2>/dev/null | grep -q "claude-manual.yml"; then
            HAS_MANUAL="✅"
        fi

        printf "%-30s %-15s %-15s %-15s\n" "$repo" "$HAS_MENTION" "$HAS_PR_REVIEW" "$HAS_MANUAL"
    done

    echo ""
    log_info "Total repositories: $(echo "$REPOS" | wc -l)"
}

install_workflow() {
    local repo=$1
    local template_src=$2
    local template_dst=$3

    log_info "Installing $template_dst to $ORG/$repo..."

    # Clone repo to temp directory
    TEMP_DIR=$(mktemp -d)
    trap "rm -rf $TEMP_DIR" EXIT

    if ! gh repo clone "$ORG/$repo" "$TEMP_DIR/$repo" -- --depth 1 2>/dev/null; then
        log_error "Failed to clone $ORG/$repo"
        return 1
    fi

    cd "$TEMP_DIR/$repo"

    # Create workflows directory
    mkdir -p .github/workflows

    # Check if workflow already exists
    if [ -f ".github/workflows/$template_dst" ] && [ "$FORCE" = false ]; then
        log_warning "Workflow already exists in $repo (use --force to overwrite)"
        return 0
    fi

    # Copy template
    if [ ! -f "$SCRIPT_DIR/$TEMPLATE_DIR/$template_src" ]; then
        log_error "Template not found: $SCRIPT_DIR/$TEMPLATE_DIR/$template_src"
        return 1
    fi
    cp "$SCRIPT_DIR/$TEMPLATE_DIR/$template_src" ".github/workflows/$template_dst"

    # Check if changes
    if [ -z "$(git status --porcelain)" ]; then
        log_info "No changes needed in $repo"
        return 0
    fi

    if [ "$DRY_RUN" = true ]; then
        log_warning "[DRY RUN] Would commit $template_dst to $repo"
        git diff --stat
        return 0
    fi

    # Commit and push
    git add ".github/workflows/$template_dst"
    git commit -m "feat: Add Claude Code workflow ($template_dst)

Installed from SkogAI/.github/workflow-templates/$template_src
Uses anthropics/claude-code-action@v1"

    if git push; then
        log_success "Installed $template_dst to $repo"
    else
        log_error "Failed to push to $repo"
        return 1
    fi
}

install_to_repos() {
    local template=$1
    local repos=$2

    if [ "$template" = "all" ]; then
        for tpl in "${!TEMPLATES[@]}"; do
            IFS=':' read -r src dst <<< "${TEMPLATES[$tpl]}"
            for repo in $(echo "$repos" | tr ',' ' '); do
                install_workflow "$repo" "$src" "$dst"
            done
        done
    else
        if [ -z "${TEMPLATES[$template]}" ]; then
            log_error "Unknown template: $template"
            log_info "Available templates: ${!TEMPLATES[@]}"
            exit 1
        fi

        IFS=':' read -r src dst <<< "${TEMPLATES[$template]}"
        for repo in $(echo "$repos" | tr ',' ' '); do
            install_workflow "$repo" "$src" "$dst"
        done
    fi
}

# Parse arguments
TEMPLATE=""
REPOS=""
ALL_REPOS=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --list)
            check_prerequisites
            list_repos
            exit 0
            ;;
        --template)
            TEMPLATE="$2"
            shift 2
            ;;
        --repos)
            REPOS="$2"
            shift 2
            ;;
        --all)
            ALL_REPOS=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            log_error "Unknown option: $1"
            usage
            ;;
    esac
done

# Main logic
if [ -z "$TEMPLATE" ]; then
    usage
fi

check_prerequisites

if [ "$ALL_REPOS" = true ]; then
    log_info "Fetching all SkogAI repositories..."
    REPOS=$(gh repo list "$ORG" --json name --limit 100 -q '.[].name' | tr '\n' ',')
fi

if [ -z "$REPOS" ]; then
    log_error "No repositories specified. Use --all or --repos"
    exit 1
fi

if [ "$DRY_RUN" = true ]; then
    log_warning "DRY RUN MODE - No changes will be committed"
fi

install_to_repos "$TEMPLATE" "$REPOS"

log_success "Bulk install complete!"
