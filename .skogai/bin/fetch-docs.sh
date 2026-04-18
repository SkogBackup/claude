#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DIR="$SCRIPT_DIR/claude-code"
mkdir -p "$DIR"
BASE="https://code.claude.com/docs/en"

for page in \
  agent-teams amazon-bedrock analytics authentication best-practices \
  changelog checkpointing chrome claude-code-on-the-web cli-reference \
  common-workflows costs data-usage desktop desktop-quickstart \
  devcontainer discover-plugins fast-mode features-overview \
  github-actions gitlab-ci-cd google-vertex-ai headless hooks \
  hooks-guide how-claude-code-works interactive-mode jetbrains \
  keybindings legal-and-compliance llm-gateway mcp memory \
  microsoft-foundry model-config monitoring-usage network-config \
  output-styles overview permissions plugin-marketplaces plugins \
  plugins-reference quickstart remote-control sandboxing security \
  server-managed-settings settings setup skills slack statusline \
  sub-agents terminal-config third-party-integrations troubleshooting \
  vs-code zero-data-retention; do
  echo "$page"
  curl -sL "$BASE/${page}.md" -o "$DIR/$page.md"
done
