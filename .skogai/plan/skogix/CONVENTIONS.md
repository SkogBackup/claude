---
title: CONVENTIONS
type: note
permalink: claude/projects/dot-skogai/plan/codebase/conventions
---

# Code Conventions

## Naming Conventions

### Files and Directories

- **kebab-case** for all filenames and directory names
- Examples: `cloudflare-llm-ask.sh`, `docgen-lookover/`, `test-helper.bash`
- Configuration files follow standard conventions: `pyproject.toml`, `package.json`, `.envrc`
- Markdown documentation: `CLAUDE.md`, `README.md`, `docs/`

### Variables (Bash)

- **UPPERCASE** for environment variables and constants
  - `CLOUDFLARE_ACCOUNT_ID`, `DEFAULT_MODEL`, `PROJECT_ROOT`
- **lowercase** for local variables
  - `script_dir`, `venv_path`, `status`
- **Prefixed** environment variables
  - `DOCGEN_MODEL`, `DOCGEN_WORKERS`, `CLAUDE_GARDEN_STATE`

### Functions (Bash)

- **snake_case** naming
  - `check_python()`, `setup_venv()`, `check_jq()`
- **Descriptive action verbs**
  - `setup_`, `check_`, `detect_`, `ensure_`, `assert_`

### Functions (Python)

- **snake_case** for functions
  - `setup_git_repo()`, `assert_output_contains()`
- **PascalCase** for classes
  - `DebouncedMarkdownHandler`, `MCPConnection`, `MCPConnectionStdio`
- **snake_case** for methods
  - `on_created()`, `on_modified()`, `list_tools()`, `call_tool()`

## Code Style

### Bash Scripts

- Header with shebang: `#!/usr/bin/env bash`
- Strict mode: `set -euo pipefail`
- Minimal comments (only where necessary)
- Color-coded output:
  - RED for errors
  - GREEN for success
  - YELLOW for warnings
  - BLUE for info
- No print/echo unless needed for I/O clarification
- Function documentation via comments when needed

### Python Scripts

- Docstrings for classes and functions
- Type hints: `Dict[str, asyncio.TimerHandle]`, `Optional[list]`, `async def`
- Async/await patterns for concurrent operations
- Logging via `logging.getLogger(__name__)`
- Minimal inline comments (self-documenting code)

### JSON/Configuration

- Standard formatting with proper indentation
- Config files in `.skogai/plugin/servers/` for MCP servers
- Template configuration: `config.json` in server directories

## Common Patterns

### Bash Patterns

1. **Setup/Teardown Functions** - `setup()` and `teardown()` for test environment
1. **Error Handling** - Explicit error checking before execution
   ```bash
   check_command || exit 1
   check_jq || exit 1
   ```
1. **Function Composition** - Helper functions for reusable logic
1. **Conditional Execution** - `&&` chaining for dependent operations
1. **Case Statements** - Option parsing in scripts

### Python Patterns

1. **Context Managers** - `async with` for resource management
1. **Event-Driven Architecture** - `PatternMatchingEventHandler` for file watching
1. **Debouncing** - `Dict[str, asyncio.TimerHandle]` for delayed processing
1. **Abstract Base Classes** - `ABC` for connection protocols
1. **Composition** - `AsyncExitStack` for managing multiple resources

### JSON/Markup Patterns

- Hook output follows standardized structure: `hookSpecificOutput.hookEventName`
- Markdown frontmatter for documentation files
- Configuration inheritance and environment variable binding

## Documentation Practices

### Standard Files

- `CLAUDE.md` - project instructions and context
- `README.md` - project overview and quick start
- `docs/**/*.md` - detailed documentation
- No arbitrary markdown creation without strong reasoning

### Code Documentation

- Inline comments only when absolutely necessary
- Function headers explain purpose and parameters
- Test files include descriptive comments
- Hook files include JSON structure documentation

### Testing Documentation

- README.md in test directories explains structure
- Test helper files document available assertion functions
- Test files use descriptive test names

### Project Structure Documentation

- `.skogai/` folder structure documented
- Recent changes section in main README.md
- Documentation index in README.md

## Code Quality Principles

1. **Minimal abstractions** - pragmatic over perfect
1. **Self-documenting code** - names matter, semantic clarity
1. **Error visibility** - never hide code, errors, or warnings
1. **Functional programming** - prefer immutable data, pure functions
1. **Separation of concerns** - visible vs hidden, cached vs live
1. **Simplicity first** - improve complexity later
1. **No over-engineering** - only what's needed

## User Communication Style

- **lowercase** for both files/directories in descriptions
- **Uppercase** letters significant when used (e.g., `CLAUDE.md` vs `claude`)
- Function signatures and data types for architecture
- Direct and to the point
- Give answer immediately, explain after
- Cite sources at end, not inline
