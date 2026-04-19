---
title: STACK
type: note
permalink: claude/projects/dot-skogai/plan/codebase/stack
---

# Technology Stack

## Languages

- **Python 3.10+** - Primary language for backend tools, automation, and utilities
- **Shell/Bash** - Core scripting language, used extensively for CLI tools and automation
- **TypeScript/JavaScript** - Used for some hooks and Claude Code plugin development
- **JSON** - Configuration and data serialization

## Frameworks

### Python Frameworks

- **MCP (Model Context Protocol) >= 1.1.0** - Framework for building LLM-accessible tools/servers
- **FastMCP** - Python implementation of Model Context Protocol servers
- **Anthropic SDK >= 0.39.0** - Official Anthropic API client for Claude
- **Pydantic >= 2.0.0** - Data validation and serialization with type hints

### Frontend/Automation

- **TypeScript 5.3.3+** - For type-safe automation scripts
- **tsx/tpx** - TypeScript execution tools for running TS scripts

## Key Dependencies

### AI/LLM Integration

- **mcp >= 1.1.0** - Tool protocol framework
- **anthropic >= 0.39.0** - Claude API client
- **ollama >= 0.4.0** - Local LLM client library

### Data Processing

- **pydantic >= 2.0.0** - Data validation
- **aiosqlite >= 0.19.0** - Async DB operations
- **pyyaml >= 6.0** - YAML parsing

### Async & File Operations

- **watchdog >= 4.0.0** - File system monitoring
- **aiofiles >= 23.0.0** - Async file I/O

### Utilities

- **tenacity >= 8.0.0** - Retry with backoff

### Testing

- **pytest >= 7.0.0** - Test framework
- **pytest-asyncio >= 0.21.0** - Async testing
- **bats-core** - Bash Automated Testing System

## Build Tools & Package Managers

- **pip** - Python package manager
- **npm** - Node.js package manager
- **uv** - Python package manager
- **direnv** - Environment management
