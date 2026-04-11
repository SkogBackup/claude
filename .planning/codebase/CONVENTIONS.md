# Coding Conventions

**Analysis Date:** 2026-03-20

## Naming Patterns

**Files:**
- Kebab-case for hook files: `gsd-check-update.js`, `gsd-context-monitor.js`, `gsd-statusline.js`
- Prefix with functional name (e.g., `gsd-` for GSD hooks)
- Use descriptive, action-oriented names

**Functions:**
- camelCase for all function declarations: `detectConfigDir()`, `function createTestUser()`
- Descriptive names that indicate purpose: `detectConfigDir`, `getVersionFile`
- Avoid single-letter variables except in loop contexts (e.g., `for (const f of files)`)

**Variables:**
- camelCase for all variables and constants: `stdinTimeout`, `homeDir`, `cwd`, `remaining`
- Use `const` by default, only use `let` when value changes
- Descriptive names over abbreviations: `configDir` not `cfgDir`, `homeDir` not `hDir`
- Boolean variables start with action/state word: `isCritical`, `firstWarn`, `severityEscalated`, `update_available`
- Environment variables use UPPER_SNAKE_CASE: `CLAUDE_CONFIG_DIR`, `ENABLE_CLAUDEAI_MCP_SERVERS`

**Types/Objects:**
- Use camelCase for object properties: `session_id`, `remaining_percentage`, `used_pct`, `hookVersion`
- JSON keys use snake_case when serialized: `update_available`, `stale_hooks`, `display_name`

## Code Style

**Formatting:**
- No explicit linter config file found in codebase (no .eslintrc, .prettierrc, biome.json)
- Observed style: 2-space indentation throughout
- Use single quotes for strings in JavaScript: `const fs = require('fs')`
- Use template literals for interpolation: ``const message = `Usage at ${used}%`  ``
- Line length: appears to aim for ~80 characters in comments, flexible in code

**Linting:**
- No enforced linting configuration detected
- No format enforcement in package.json
- Code follows consistent patterns through convention rather than tooling

## Import Organization

**Order:**
1. Built-in Node.js modules: `require('fs')`, `require('path')`, `require('os')`, `require('child_process')`
2. Standard library imports grouped together at top of file

**Path Aliases:**
- Not used in this codebase (pure Node.js, no build system)
- Absolute paths preferred: `path.join(baseDir, dir)`
- Relative paths for file system operations

**CommonJS vs ES Modules:**
- Use CommonJS: `const fs = require('fs')` not `import fs from 'fs'`
- Package.json specifies: `"type": "commonjs"`

## Error Handling

**Patterns:**
- Silent failure with empty catch blocks: `catch (e) {}` — common pattern for non-critical failures
- Use try/catch for file system operations that may fail
- Exit silently on parse errors: `process.exit(0)` rather than throwing
- Graceful degradation: if optional file doesn't exist, continue without it
- Guard clauses with early exit: `if (!condition) { process.exit(0); }`

**Pattern Example from codebase:**
```javascript
// From gsd-context-monitor.js - typical error pattern
try {
  const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
  if (config.hooks?.context_warnings === false) {
    process.exit(0);
  }
} catch (e) {
  // Ignore config parse errors
}
```

## Logging

**Framework:** console not used; `process.stdout.write()` and `process.stderr` for output

**Patterns:**
- Use `process.stdout.write()` for intentional output: `process.stdout.write(JSON.stringify(output));`
- No console.log in production hooks
- Output raw JSON when needed by calling process
- Include ANSI color codes for terminal output: `\x1b[32m` for green, `\x1b[33m` for yellow, `\x1b[0m` for reset
- Comments describe why, not what: `// Ignore stale metrics` not `// Check if old`

**When to Log:**
- Only for intentional tool output (statusline, JSON responses to hooks)
- Not for debugging within hook execution
- Silent failures preferred over logged errors in hooks

## Comments

**When to Comment:**
- Multi-line comment blocks at file header with version and purpose: `// gsd-hook-version: 1.26.0`
- Inline comments explain non-obvious logic: `// Debounce: check if we warned recently`
- Section comments group related operations: `// Check project directory first (local install), then global`
- Reference issue numbers in comments: `See #775` for known issues

**JSDoc/TSDoc:**
- Not used in this codebase (no TypeScript, no JSDoc blocks)
- Inline comments preferred for documentation

**Comment Style:**
```javascript
// Single line comment for simple explanations
// Can span multiple lines if needed

// gsd-hook-version: 1.26.0
// Multi-line header explains purpose and version
// Multiple lines of context
```

## Function Design

**Size:**
- Functions stay reasonably small (< 50 lines preferred)
- Avoid deep nesting, use early returns
- `detectConfigDir()` is ~15 lines - a good target size

**Parameters:**
- Minimal parameters (< 4 preferred)
- Use object parameters for configuration: `function createTestUser(overrides?: Partial<User>)`
- Optional parameters with defaults: `const envDir = process.env.CLAUDE_CONFIG_DIR;`

**Return Values:**
- Return early from functions to reduce nesting
- Use consistent return types throughout module
- Null/undefined for missing data is acceptable

**Function Examples:**
```javascript
// Good: simple, clear purpose, early returns
function detectConfigDir(baseDir) {
  const envDir = process.env.CLAUDE_CONFIG_DIR;
  if (envDir && fs.existsSync(path.join(envDir, 'get-shit-done', 'VERSION'))) {
    return envDir;
  }
  for (const dir of ['.config/opencode', '.opencode', '.gemini', '.claude']) {
    if (fs.existsSync(path.join(baseDir, dir, 'get-shit-done', 'VERSION'))) {
      return path.join(baseDir, dir);
    }
  }
  return envDir || path.join(baseDir, '.claude');
}
```

## Module Design

**Exports:**
- Hooks are executable scripts (#!/usr/bin/env node) not exported modules
- No explicit exports in hook files — they operate as CLI tools
- When used as modules (if any), use CommonJS exports: `module.exports = { functionName }`

**Barrel Files:**
- Not used in this codebase

## Constants and Magic Numbers

**Pattern:**
- Define constants at module top level with UPPER_SNAKE_CASE
- Include comment explaining what they control

```javascript
// From gsd-context-monitor.js
const WARNING_THRESHOLD = 35;      // remaining_percentage <= 35%
const CRITICAL_THRESHOLD = 25;     // remaining_percentage <= 25%
const STALE_SECONDS = 60;          // ignore metrics older than 60s
const DEBOUNCE_CALLS = 5;          // min tool uses between warnings
```

## Async/Await

**Pattern:**
- Use `async`/`await` for Promise-based operations
- Chain with `.then()` for spawn/exec operations when needed
- Handle async errors within try/catch blocks

```javascript
// From gsd-check-update.js - spawning subprocess
const child = spawn(process.execPath, ['-e', `...`], {
  stdio: 'ignore',
  windowsHide: true,
  detached: true
});
child.unref();
```

## stdin/stdout Handling

**Timeout Pattern:**
- Always use timeout guards when reading stdin from pipes
- Default timeout: 3-10 seconds depending on context
- Exit silently on timeout to prevent hanging

```javascript
// Timeout guard pattern (from gsd-statusline.js)
const stdinTimeout = setTimeout(() => process.exit(0), 3000);
process.stdin.setEncoding('utf8');
process.stdin.on('data', chunk => input += chunk);
process.stdin.on('end', () => {
  clearTimeout(stdinTimeout);
  // process input
});
```

---

*Convention analysis: 2026-03-20*
