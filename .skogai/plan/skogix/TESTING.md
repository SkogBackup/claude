---
title: TESTING
type: note
permalink: claude/projects/dot-skogai/plan/codebase/testing
---

# Testing Practices

## Test Frameworks

### Primary Framework: BATS

**Bash Automated Testing System**

- Used for bash script testing
- Location: `todos/testing-framework-bash/`
- Installation: `bats-core` via Homebrew, npm, or apt-get
- Syntax: `@test "description" { commands }`

### Secondary Framework: pytest

**Python Testing**

- Used for Python testing
- Declared in `pyproject.toml`
- Includes `pytest-asyncio` for async test support

### Test Runners

```bash
bats tests/unit/*.bats              # Run all unit tests
bats -v tests/unit/*.bats           # Verbose output
bats tests/unit/common-functions.bats  # Specific test file
```

## Test Directory Structure

```
testing-framework-bash/
├── setup-tests.sh          # Test environment initialization
├── test-helper.bash        # Common test utilities and assertions
├── unit/                   # Unit tests
│   ├── common-functions.bats
│   ├── code-relationships.bats
│   ├── search-tools.bats
│   └── search-tools-full.bats.skip
├── fixtures/               # Test data and mock files
│   └── sample-project/
│       ├── README.md
│       └── src/
│           └── index.js
└── README.md              # Test documentation
```

## Testing Patterns

### Unit Testing Pattern

```bash
#!/usr/bin/env bats

load ../test-helper

setup() {
    setup_test_dir
    source "$SCRIPTS_DIR/common-functions.sh" 2>/dev/null || true
}

teardown() {
    teardown_test_dir
}

@test "function_name does something" {
    run function_name "argument"
    assert_success
    [[ "$output" == "expected output" ]]
}
```

### Common Test Assertions

- `assert_success` - command succeeded (status = 0)
- `assert_failure` - command failed (status ≠ 0)
- `assert_output_contains "string"` - output includes substring
- `assert_output_not_contains "string"` - output excludes substring
- `[[ "$status" -eq 99 ]]` - specific exit code checking

### Isolation Pattern

- `setup_test_dir` - creates isolated temp directory
- `teardown_test_dir` - cleans up after test
- Tests safely create files without affecting repository

### Conditional Testing

- `skip_if_missing "command"` - skip if dependency not available
- OS-specific tests: `[[ "$OSTYPE" != "darwin"* ]]`
- Platform detection for macOS/Linux tests

## Code Coverage

### Coverage Goals

```
- [✅] common-functions.sh
- [ ] project-info.sh
- [ ] git-ops.sh
- [ ] search-tools.sh
- [ ] interactive-helper.sh
- [ ] test-helper.sh (meta!)
- [ ] Additional scripts...
```

### Coverage Strategy

1. Both success and failure cases tested
1. Edge cases: special characters, spacing, missing files
1. Relationship testing between code modules
1. Integration tests directory created (currently empty)

### Example Test Coverage

- **Function existence**: `check_command "ls"` (success) vs `check_command "nonexistent"` (failure)
- **String transformations**: `slugify` with special characters, spaces, numbers
- **File operations**: `check_file` with existing/non-existent files
- **Platform-specific**: `detect_package_manager` for brew/apt/dnf/yum/pacman
- **Error handling**: `error_exit` with custom messages and exit codes

## Testing Best Practices

1. **One-to-one mapping** - each script has corresponding test file
1. **Descriptive test names** - clearly state what's being tested
1. **Automatic cleanup** - teardown functions remove test artifacts
1. **Skip conditions** - tests gracefully skip on missing dependencies
1. **Minimal mocking** - creates real temporary files/directories
1. **Fast execution** - uses temp directories, no slow I/O
1. **Clear assertions** - explicit checking with helpful error messages
1. **Test data organization** - fixtures/ directory for sample data

## Python Testing Configuration

```toml
[project.optional-dependencies]
dev = [
    "pytest>=7.0.0",
    "pytest-asyncio>=0.21.0",
]

[dependency-groups]
dev = [
    "aiosqlite>=0.19.0",
    "ollama>=0.4.0",
    "pydantic>=2.0.0",
    "pytest>=7.0.0",
    "pytest-asyncio>=0.21.0",
    "pyyaml>=6.0",
    "tenacity>=8.0.0",
    "watchdog>=4.0.0",
]
```

## Testing Philosophy

- **Behavior-driven** - tests describe what code does, not implementation
- **Comprehensive coverage** - both happy paths and edge cases
- **Environment isolation** - tests don't affect system state
- **Graceful degradation** - skip tests when dependencies missing
- **Tests as documentation** - test names explain functionality

## Notable Testing Strengths

### jq-transforms Skill

- 60+ transformations with 715 test fixtures
- Each has schema.json, test.sh, transform.jq
- Comprehensive test coverage
- Self-contained, composable architecture

## Testing Gaps

### Complex Areas Lacking Tests

1. **Docgen Integration System**

   - `watcher.py` (252 lines) - untested
   - `process_queue.py` (315 lines) - untested
   - `frontmatter_daemon.py` (200+ lines) - untested
   - Complex async/threading code without unit tests
   - No integration tests for end-to-end flow

1. **jq-transforms Edge Cases**

   - Loose string comparison in some tests
   - No verification of JSON output validity
   - Some transformations lack edge case tests
