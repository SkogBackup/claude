---
title: claude-container-environment
type: note
permalink: claude/lab/projects-in-development/web-setup-for-claude/claude-container-environment
---

# Claude Container Environment Overview

**Generated**: 2026-01-11 **Session ID**: session_011iwfyHqnjkTAUdvYTjPrp2 **Container ID**: container_019vvRENrjWDJ3Q7Uo66yxPs--claude_code_remote--shy-mixed-juicy-radian

______________________________________________________________________

## Executive Summary

This document describes the runtime environment for Claude Code when accessed via the **Claude mobile app** (or web interface). This differs significantly from a local installation where skogai is designed to run.

### Key Differences from Local Setup

| Aspect                 | Cloud Container (Current) | Local Setup (Intended)             |
| ---------------------- | ------------------------- | ---------------------------------- |
| **Working Directory**  | `/home/user/skogai`       | `/skogai`                          |
| **User**               | `root` (uid=0)            | User-specific (likely `skogix`)    |
| **Persistence**        | Ephemeral (session-based) | Persistent filesystem              |
| **Environment**        | Sandboxed container       | Host machine                       |
| **Network**            | Proxied through Anthropic | Direct internet access             |
| **Config Location**    | `/root/.claude`           | `/skogai/.claude` (per bin/claude) |
| **Bootstrap Required** | No (pre-configured)       | Yes (via bin/bootstrap)            |

______________________________________________________________________

## Container Specifications

### System Information

```
OS: Ubuntu 24.04.3 LTS (Noble Numbat)
Kernel: Linux 4.4.0
Architecture: linux/amd64
Filesystem: 30GB ephemeral (1% used)
Sandbox: Yes (IS_SANDBOX=yes)
```

### Runtime Details

```
Claude Code Version: 2.1.1
Entrypoint: remote
Environment Type: cloud_default
Remote: true
Debug Mode: true
```

### User & Permissions

```
Current User: root
UID/GID: 0/0
Groups: root
Home Directory: /root
Working Directory: /home/user/skogai
```

______________________________________________________________________

## Directory Structure

### Home Directories

```
/home/
├── claude/          # Claude user home (uid: claude, gid: ubuntu)
├── ubuntu/          # Ubuntu user home
└── user/            # Working directory for repos
    └── skogai/      # Current repository (this project)

/root/               # Root home directory
├── .claude/         # Claude Code configuration (active)
├── .claude.json     # Session-specific config
├── .bun/            # Bun runtime
├── .cargo/          # Rust toolchain
├── .config/         # User configurations
├── .gradle/         # Gradle home
├── .npm/            # NPM cache
├── .rustup/         # Rustup home
└── .ssh/            # SSH keys (commit signing)
```

______________________________________________________________________

## Development Tools

### Programming Languages

```bash
Python:  3.11.14          (/usr/local/bin/python3)
Node:    v22.21.1         (/opt/node22/bin/node)
NPM:     10.9.4           (/opt/node22/bin/npm)
Go:      go1.24.7         (/usr/local/go/bin/go)
Rust:    1.92.0           (/root/.cargo/bin/rustc)
Java:    OpenJDK 21.0.9   (/usr/bin/java)
```

### Build Tools & Package Managers

```bash
Gradle:  /opt/gradle
Maven:   /opt/maven
NVM:     /opt/nvm
Rbenv:   /opt/rbenv
Bun:     /root/.bun
Rustup:  /root/.rustup
```

______________________________________________________________________

## Git Configuration

### Identity

```
user.name = Claude
user.email = noreply@anthropic.com
user.signingkey = /home/claude/.ssh/commit_signing_key.pub
```

### Repository Settings

```
core.repositoryformatversion = 0
core.filemode = true
core.bare = false
core.logallrefupdates = true
```

### Editor & Behavior

```
GIT_EDITOR = true
GIT_FETCH_ARGS = --deepen 50
```

______________________________________________________________________

## Network Configuration

### Proxy Setup

All HTTP/HTTPS traffic is routed through Anthropic's egress proxy:

```bash
HTTP_PROXY=http://container_<id>:<jwt>@21.0.0.125:15004
HTTPS_PROXY=http://container_<id>:<jwt>@21.0.0.125:15004
```

### No Proxy Exceptions

```
localhost
127.0.0.1
169.254.169.254
metadata.google.internal
*.svc.cluster.local
*.local
*.googleapis.com
*.google.com
```

### Certificate Configuration

```
SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt
REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
```

______________________________________________________________________

## Claude Code Environment Variables

### Core Variables

```bash
CLAUDECODE=1
CLAUDE_CODE_VERSION=2.1.1
CLAUDE_CODE_ENTRYPOINT=remote
CLAUDE_CODE_REMOTE=true
CLAUDE_CODE_REMOTE_ENVIRONMENT_TYPE=cloud_default
CLAUDE_CODE_DEBUG=true
CLAUDE_CODE_PROXY_RESOLVES_HOSTS=true
```

### Session & Container IDs

```bash
CLAUDE_CODE_SESSION_ID=167b49c5-ccd7-4f81-842b-cad68fb1ae7d
CLAUDE_CODE_REMOTE_SESSION_ID=session_011iwfyHqnjkTAUdvYTjPrp2
CLAUDE_CODE_CONTAINER_ID=container_019vvRENrjWDJ3Q7Uo66yxPs--claude_code_remote--shy-mixed-juicy-radian
```

### File Descriptors & Authentication

```bash
CLAUDE_CODE_OAUTH_TOKEN_FILE_DESCRIPTOR=4
CLAUDE_CODE_WEBSOCKET_AUTH_FILE_DESCRIPTOR=3
```

### MCP & Tooling

```bash
CODESIGN_MCP_PORT=36837
CODESIGN_MCP_TOKEN=hwv3o2bdfNK391WxdVLBqc7ceuzNYWvBTbnoX0kKBkQ=
MCP_TOOL_TIMEOUT=60000
```

______________________________________________________________________

## Runtime Configuration

### Resource Limits

```bash
NODE_OPTIONS=--max-old-space-size=8192
MAX_THINKING_TOKENS=31999
```

### Build & Package Configuration

```bash
COREPACK_ENABLE_AUTO_PIN=0
ELECTRON_GET_USE_PROXY=1
DEBIAN_FRONTEND=noninteractive
```

### Debugging & Telemetry

```bash
RUST_BACKTRACE=1
PYTHONUNBUFFERED=1
OTEL_EXPORTER_OTLP_METRICS_TEMPORALITY_PREFERENCE=delta
```

______________________________________________________________________

## PATH Configuration

Complete PATH (in order):

```
/root/.local/bin
/root/.cargo/bin
/usr/local/go/bin
/opt/node22/bin
/opt/maven/bin
/opt/gradle/bin
/opt/rbenv/bin
/root/.bun/bin
/usr/local/sbin
/usr/local/bin
/usr/sbin
/usr/bin
/sbin
/bin
```

______________________________________________________________________

## Authentication & Secrets

### GitHub Token

```bash
GH_TOKEN=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
```

*Note: This is a session-specific token managed by Claude Code*

### Anthropic API

```bash
ANTHROPIC_BASE_URL=https://api.anthropic.com
```

______________________________________________________________________

## Implications for skogai

### What Works Out-of-the-Box

- ✅ Git operations (with session-specific identity)
- ✅ All major programming languages and build tools
- ✅ File operations within `/home/user/skogai`
- ✅ Network requests (proxied)
- ✅ Development workflows

### What Needs Adaptation

- ⚠️ **Path assumptions**: Scripts reference `/skogai` but we're in `/home/user/skogai`
- ⚠️ **Persistence**: Changes only last for the session duration
- ⚠️ **User permissions**: Running as root, not the intended user setup
- ⚠️ **Config location**: `.claude` in `/root` not `/skogai/.claude`
- ⚠️ **Bootstrap process**: Container is pre-bootstrapped differently

### Environment Detection Pattern

```bash
#!/usr/bin/env bash

if [ -n "$CLAUDE_CODE_REMOTE" ]; then
  # Running in cloud container via mobile/web app
  SKOGAI_ROOT="${PWD}"  # Use current working directory
  SKOGAI_CONFIG="/root/.claude"
  SKOGAI_MODE="cloud"
else
  # Running locally with custom launcher
  SKOGAI_ROOT="/skogai"
  SKOGAI_CONFIG="/skogai/.claude"
  SKOGAI_MODE="local"
fi

export SKOGAI_ROOT SKOGAI_CONFIG SKOGAI_MODE
```

______________________________________________________________________

## Recommendations

### For skogai Development

1. **Add environment detection** to all scripts in `bin/`
1. **Create cloud-specific config** paths that respect `$CLAUDE_CODE_REMOTE`
1. **Document both modes** in README with usage examples
1. **Use relative paths** where possible instead of hardcoded `/skogai`
1. **Test in both environments** to ensure compatibility

### For Context System

1. **Enhance tmp/context** to include environment metadata
1. **Auto-detect mode** and adjust git-diff communication accordingly
1. **Store session info** to understand which environment generated context
1. **Version control cloud vs local** context separately if needed

### For Documentation

1. Create `docs/environments/cloud.md` (this environment)
1. Create `docs/environments/local.md` (intended setup)
1. Create `docs/environments/detection.md` (how to detect and adapt)
1. Update CLAUDE.md with environment-aware instructions

______________________________________________________________________

## Session Lifecycle

### On Session Start

1. Container spins up with pre-configured Ubuntu image
1. Repository cloned/synced to `/home/user/skogai`
1. Environment variables set (session-specific tokens, IDs)
1. Claude Code agent starts with remote entrypoint
1. User connects via mobile app or web interface

### During Session

- All changes persist within the container
- Git commits use "Claude" identity
- Network traffic proxied through Anthropic
- Session remains active until user disconnects or timeout

### On Session End

- Container may be destroyed (ephemeral)
- Changes pushed to git remain (if pushed)
- Local modifications lost unless committed
- New session = new container with fresh checkout

______________________________________________________________________

## Testing This Environment

To verify environment details at any time:

```bash
# Quick environment check
env | grep CLAUDE_CODE

# Verify paths
echo "Working Dir: $(pwd)"
echo "Home Dir: $HOME"
echo "User: $(whoami)"

# Check tools
which python3 node go rustc java

# Confirm git identity
git config user.name
git config user.email
```

______________________________________________________________________

## Version History

- **2026-01-11**: Initial documentation generated during session_011iwfyHqnjkTAUdvYTjPrp2
