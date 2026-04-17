---
title: environment-diff
type: note
permalink: claude/lab/projects-in-development/web-setup-for-claude/environment-diff
---

# Environment Comparison: Cloud vs Local

Quick reference for differences between cloud container and local skogai setup.

______________________________________________________________________

## Critical Path Differences

### Working Directory

```bash
# Cloud Container (current)
/home/user/skogai

# Local Setup (intended)
/skogai
```

### Config Directory

```bash
# Cloud Container
/root/.claude

# Local Setup
/skogai/.claude
```

### User Context

```bash
# Cloud Container
User: root (uid=0, gid=0)
Identity: Claude <noreply@anthropic.com>

# Local Setup
User: skogix (or current user)
Identity: User-configured
```

______________________________________________________________________

## Environment Variables to Check

### Cloud Container Detection

```bash
CLAUDE_CODE_REMOTE=true
CLAUDE_CODE_REMOTE_ENVIRONMENT_TYPE=cloud_default
CLAUDE_CODE_CONTAINER_ID=container_*
IS_SANDBOX=yes
```

### Local Setup Detection

```bash
SKOGAI_ROOT=/skogai  # (expected to be set by bin/claude)
# CLAUDE_CODE_REMOTE not set or false
```

______________________________________________________________________

## Script Adaptation Examples

### Before (hardcoded paths)

```bash
#!/usr/bin/env bash
echo "[\$skogai:context]" > /skogai/tmp/context
git diff --cached >> /skogai/tmp/context
echo "[\$/skogai:context]" >> /skogai/tmp/context
```

### After (environment-aware)

```bash
#!/usr/bin/env bash

# Detect environment
if [ -n "$CLAUDE_CODE_REMOTE" ]; then
  SKOGAI_ROOT="$(git rev-parse --show-toplevel)"
else
  SKOGAI_ROOT="${SKOGAI_ROOT:-/skogai}"
fi

echo "[\$skogai:context]" > "$SKOGAI_ROOT/tmp/context"
git diff --cached >> "$SKOGAI_ROOT/tmp/context"
echo "[\$/skogai:context]" >> "$SKOGAI_ROOT/tmp/context"
```

______________________________________________________________________

## Persistence Differences

| Item                 | Cloud Container        | Local Setup  |
| -------------------- | ---------------------- | ------------ |
| **Git commits**      | Persistent (if pushed) | Persistent   |
| **Unstaged files**   | Lost on session end    | Persistent   |
| **Config changes**   | Lost on session end    | Persistent   |
| **Installed tools**  | Pre-installed, reset   | User-managed |
| **Session duration** | 1-4 hours typical      | Unlimited    |

______________________________________________________________________

## Network Differences

### Cloud Container

- All traffic proxied through Anthropic (21.0.0.125:15004)
- JWT-based authentication for proxy
- Specific NO_PROXY exceptions
- Session-limited GH_TOKEN provided

### Local Setup

- Direct network access
- User's own GitHub credentials
- No proxy by default
- Persistent authentication

______________________________________________________________________

## Quick Reference Commands

### Check Current Environment

```bash
# Are we in cloud?
[ -n "$CLAUDE_CODE_REMOTE" ] && echo "CLOUD" || echo "LOCAL"

# What's the working directory?
git rev-parse --show-toplevel

# Where's Claude config?
[ -n "$CLAUDE_CODE_REMOTE" ] && echo "/root/.claude" || echo "/skogai/.claude"
```

### Get Environment Info

```bash
# In cloud container
env | grep CLAUDE_CODE | sort

# Check user
echo "User: $(whoami) | Home: $HOME | PWD: $PWD"
```

______________________________________________________________________

## Recommended Variables to Export

Add to environment-aware scripts:

```bash
# Detect and export skogai environment
if [ -n "$CLAUDE_CODE_REMOTE" ]; then
  export SKOGAI_MODE="cloud"
  export SKOGAI_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
  export SKOGAI_CONFIG="/root/.claude"
  export SKOGAI_TEMP="$SKOGAI_ROOT/tmp"
  export SKOGAI_DOCS="${SKOGAI_DOCS:-$SKOGAI_ROOT/docs}"
else
  export SKOGAI_MODE="local"
  export SKOGAI_ROOT="${SKOGAI_ROOT:-/skogai}"
  export SKOGAI_CONFIG="$SKOGAI_ROOT/.claude"
  export SKOGAI_TEMP="$SKOGAI_ROOT/tmp"
  export SKOGAI_DOCS="${SKOGAI_DOCS:-$SKOGAI_ROOT/docs}"
fi
```

______________________________________________________________________

## Testing Checklist

When adapting scripts for both environments:

- [ ] Paths use `$SKOGAI_ROOT` instead of hardcoded `/skogai`
- [ ] Config operations use `$SKOGAI_CONFIG`
- [ ] Environment detection happens early in script
- [ ] Works when run from any directory (use absolute paths)
- [ ] Handles missing directories gracefully
- [ ] Respects `$SKOGAI_MODE` for mode-specific behavior
- [ ] Documents which environment it's designed for

______________________________________________________________________

## See Also

- `tmp/claude-container-environment.md` - Full cloud environment documentation
- `bin/bootstrap` - Local setup script (needs cloud adaptation)
- `bin/claude` - Custom launcher (local only)
- `config/claude-settings.json` - Local config (overridden in cloud)
