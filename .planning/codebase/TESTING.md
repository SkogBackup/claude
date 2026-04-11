# Testing Patterns

**Analysis Date:** 2026-03-20

## Test Framework

**Status:**
- No testing framework currently configured
- No test files found in repository
- No jest.config.js, vitest.config.ts, or test scripts in package.json

**Implications:**
- Hooks are tested manually or through integration
- No unit test infrastructure in place
- Code relies on type checking and code review for quality

## When Adding Tests

**Recommended Approach:**
- Install Vitest (modern, Node.js native, minimal config)
- Use Node.js built-in test runner (no dependencies) if minimalism preferred
- Add to package.json scripts:
  ```json
  {
    "scripts": {
      "test": "vitest",
      "test:watch": "vitest --watch",
      "test:coverage": "vitest --coverage"
    }
  }
  ```

## Test File Organization

**Location to Establish:**
- Place test files alongside source: `gsd-check-update.js` → `gsd-check-update.test.js`
- Keep all tests in `.claude/hooks/` directory with source files
- No separate `tests/` directory needed for hooks

**Naming Pattern to Use:**
- Unit tests: `{module-name}.test.js`
- Example: `gsd-statusline.test.js`

**Directory Structure:**
```
.claude/
  hooks/
    gsd-check-update.js
    gsd-check-update.test.js
    gsd-context-monitor.js
    gsd-context-monitor.test.js
    gsd-statusline.js
    gsd-statusline.test.js
```

## Test Structure

**Pattern to Follow:**

For Node.js scripts reading stdin and outputting JSON, use this pattern:

```javascript
import { describe, it, expect, beforeEach, afterEach, vi } from 'vitest';
import * as fs from 'fs';
import * as os from 'os';

describe('gsd-statusline', () => {
  describe('stdin processing', () => {
    it('should parse valid JSON input', async () => {
      // arrange
      const input = JSON.stringify({
        model: { display_name: 'Claude 3 Opus' },
        workspace: { current_dir: '/home/user' },
        session_id: 'test-session',
        context_window: { remaining_percentage: 50 }
      });

      // act
      const result = await processInput(input);

      // assert
      expect(result).toContain('Claude 3 Opus');
    });

    it('should exit gracefully on invalid JSON', async () => {
      // arrange
      const input = 'invalid json';

      // act & assert
      expect(() => JSON.parse(input)).toThrow();
    });
  });

  describe('file system operations', () => {
    it('should read config when present', async () => {
      // arrange
      const mockPath = '/mock/path';
      vi.spyOn(fs, 'existsSync').mockReturnValue(true);
      vi.spyOn(fs, 'readFileSync').mockReturnValue('{"key": "value"}');

      // act
      const config = readConfigFile(mockPath);

      // assert
      expect(config).toEqual({ key: 'value' });
    });

    it('should skip gracefully when config missing', () => {
      // arrange
      vi.spyOn(fs, 'existsSync').mockReturnValue(false);

      // act & assert
      expect(() => readConfigFile('/missing')).not.toThrow();
    });
  });
});
```

**Patterns to Follow:**
- Use beforeEach/afterEach to reset mocks between tests: `vi.clearAllMocks()`
- Use explicit arrange/act/assert comments for clarity
- One behavioral assertion per test (multiple expects on same value OK)
- Test both happy path and error cases

## Mocking

**Framework:**
- Use Vitest `vi` mocking when framework is added
- Alternative: Node.js built-in test mocking if zero-dependency approach preferred

**Patterns for This Codebase:**

```javascript
// Mock file system
import { vi } from 'vitest';
import * as fs from 'fs';

vi.mock('fs');

it('should handle missing file', () => {
  vi.mocked(fs.existsSync).mockReturnValue(false);
  // test code
});

// Mock child_process
vi.mock('child_process', () => ({
  spawn: vi.fn().mockReturnValue({
    unref: vi.fn()
  })
}));

// Mock environment variables
it('should use env variable', () => {
  const oldEnv = process.env.CLAUDE_CONFIG_DIR;
  process.env.CLAUDE_CONFIG_DIR = '/mock/config';

  // test code

  process.env.CLAUDE_CONFIG_DIR = oldEnv;
});
```

**What to Mock:**
- File system operations: `fs.readFileSync`, `fs.existsSync`, `fs.writeFileSync`
- Child process: `spawn`, `execSync`
- stdin/stdout: capture process.stdout.write calls
- Environment variables: `process.env.*`
- Timeouts: use `vi.useFakeTimers()` for setTimeout guards

**What NOT to Mock:**
- Built-in path operations (path.join works fine)
- JSON parsing (test the actual parsing logic)
- Basic object/array operations
- Math functions

## Fixtures and Factories

**Test Data for Hooks:**

```javascript
// Factory for creating mock hook input
function createMockStdinData(overrides = {}) {
  return {
    model: { display_name: 'Claude 3 Opus' },
    workspace: { current_dir: '/home/user' },
    session_id: 'test-session-123',
    context_window: { remaining_percentage: 50 },
    ...overrides
  };
}

// Factory for mock file paths
function createMockConfig(overrides = {}) {
  return {
    hooks: {
      context_warnings: true
    },
    ...overrides
  };
}

// Use in tests
it('should handle custom threshold', () => {
  const input = createMockStdinData({
    context_window: { remaining_percentage: 25 }
  });
  // test code
});
```

**Location:**
- Define factories in test file itself (small scope)
- If shared across multiple test files, create `.claude/hooks/test-fixtures.js`

## Coverage

**Requirements:**
- No enforced coverage target
- Coverage optional for awareness

**Commands to Add:**
```bash
npm run test:coverage                # Run tests with coverage
# Coverage will be in coverage/index.html
```

**What NOT to Worry About:**
- Don't chase 100% coverage
- Focus on critical paths: stdin parsing, config reading, error handling
- Edge cases around file system and environment variables

## Test Types

**Unit Tests:**
- Test individual functions in isolation
- Mock all external dependencies
- Fast: each test should run in <100ms
- Examples: `detectConfigDir()`, `parseInput()`, JSON parsing logic

**Integration Tests:**
- Test multiple functions working together
- Mock only external boundaries (file system, stdin/stdout, child_process)
- Examples: full hook processing pipeline

**E2E Tests:**
- Not needed for CLI hooks
- Integration tests with mocked I/O sufficient

## Common Patterns

**Async Testing (if needed):**
```javascript
it('should handle async operation', async () => {
  const result = await asyncFunction();
  expect(result).toBeDefined();
});
```

**Timeout Testing:**
```javascript
it('should exit on stdin timeout', async () => {
  vi.useFakeTimers();

  // Start listening (would normally hang)
  const timeoutHandler = vi.fn();
  process.once('exit', timeoutHandler);

  // Advance time past timeout
  vi.advanceTimersByTime(5000);

  expect(timeoutHandler).toHaveBeenCalled();
  vi.useRealTimers();
});
```

**JSON I/O Testing:**
```javascript
it('should output valid JSON', () => {
  const output = generateHookOutput({ message: 'test' });

  // Verify it's valid JSON
  expect(() => JSON.parse(output)).not.toThrow();

  // Verify structure
  const parsed = JSON.parse(output);
  expect(parsed).toHaveProperty('hookSpecificOutput');
});
```

**File System Error Testing:**
```javascript
it('should handle file read errors', () => {
  vi.mocked(fs.readFileSync).mockImplementation(() => {
    throw new Error('ENOENT: no such file');
  });

  // Code should handle gracefully
  expect(() => readConfigFile('/path')).not.toThrow();
});
```

## Running Tests

**Commands (once framework added):**
```bash
npm test                              # Run all tests once
npm run test:watch                    # Watch mode for development
npm run test:coverage                 # Run with coverage report
npm test -- gsd-statusline.test.js   # Single file
npm test -- --reporter=verbose       # Detailed output
```

## Current Testing Reality

**Status: No automated tests**
- All hooks tested through integration (manual execution during GSD operations)
- Quality relies on:
  - Code review
  - Manual testing in Claude Code session
  - Conservative error handling patterns (silent failures)
  - Try/catch guards on all critical operations

**When to Add Tests:**
- When modifying hook logic that affects many users
- When adding new configuration-dependent behavior
- When fixing bugs (add regression test first)
- As scaffolding for new hook development

---

*Testing analysis: 2026-03-20*
*No automated test framework currently in use*
