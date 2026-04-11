#!/usr/bin/env bash

# So for minimal settings with only their own plugins:
# [$skogix]
# --setting-sources "" or just omit specific sources to load none
# --tools "" actually works for setting no tools
# --plugin-dir needs to be the actual plugins dir and not the marketplace
# [/$skogix]

# Set config dir BEFORE launching claude (env vars in settings.json are too late)
export CLAUDE_CONFIG_DIR="/skogai/config/claude"

claude -p "$(cat /skogai/dev/claude-routing-via-claude-md-files/test-routing-prompt.md)"
