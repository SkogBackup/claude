---
title: CONCERNS
type: note
permalink: claude/projects/dot-skogai/plan/codebase/concerns
---

# Technical Concerns

## Technical Debt

### High-Priority Items

#### Incomplete .skogai Initialization

**Location**: `.skogai/todo.md`

3 of 4 bootstrap tasks incomplete:

- [ ] rules - No rules framework defined
- [ ] plan - No planning structure documented
- [ ] todos - No todo system in place

**Status**: Only "symlink docs" complete

**Impact**: Core bootstrap infrastructure missing for submodule reusability

#### Obsolete Hooks with Dead Code

**Location**: `.skogai/plugin/hooks/`

Multiple lifecycle hooks are stub implementations with commented-out code:

- `pre-tool-use.sh` - completely commented out (lines 32-46)
- `post-tool-use.sh` - completely commented out (lines 30-44)
- `pre-compact.sh` - completely commented out (lines 20-23)
- `session-end.sh` - completely commented out (lines 21-28)

**Issue**: Code appears non-functional; either incomplete or disabled

**Action Needed**: Remove if not used, or re-enable with tests

#### Empty/Stub Implementation

**Location**: `.skogai/plugin/scripts/install.sh`

Only 6 lines, minimal content:

```bash
#!/bin/bash
set -e

echo "Installing skogai-core plugin"
echo "Plugin: $PLUGIN_NAME v$PLUGIN_VERSION"
```

**Issue**: No actual installation logic; references undefined environment variables

#### Unfinished llm.py Module

**Location**: `todos/docgen-lookover/scripts/llm.py:180-212`

- Functions have incomplete implementations
- `pull_model_if_needed()` exception handling generic (catches all `Exception`)
- Missing model availability cross-checking before pull

______________________________________________________________________

## Security Concerns

### Subprocess Execution Without Shell Escaping

**Location**: `todos/docgen-lookover/scripts/generate-frontmatter.py:21-26`

```python
result = subprocess.run(
    ["curl", "-s", "http://localhost:11434/api/generate",
     "-d", json.dumps(payload)],  # Direct JSON injection risk
    capture_output=True, text=True
)
```

**Risk**: If `payload` contains untrusted data, could exploit curl arguments

**Mitigation**: Currently using list form (safe), but fragile with json.dumps()

### Unsafe File Path Handling

**Location**: `todos/docgen-lookover/scripts/watcher.py:150,228-232`

- Uses `Path.rglob("*.md")` without validating returned paths
- Skips hidden dirs with simple string matching
- No use of `resolve()` to canonicalize paths

**Risk**: Symlinks could bypass checks; could process files outside intended directories

### Insufficient Error Handling

**Location**: `todos/docgen-lookover/scripts/process_queue.py:113-129`

Ollama calls with 300-second timeout but:

- No handling of partial responses
- No validation that response contains expected fields
- Generic exception catch masks root causes
- Retry logic doesn't distinguish transient vs. permanent failures

### Missing Environment Variable Validation

**Location**: `todos/docgen-lookover/scripts/frontmatter_daemon.py:16-19,31`

```python
DEFAULT_MODEL = os.environ.get("DOCGEN_MODEL", "qwen3:8b")
```

**Risk**: If Ollama model changes without updating env vars, silent failures

**Action Needed**: Validate model exists before starting daemon

______________________________________________________________________

## Performance Bottlenecks

### Debounce Implementation May Miss Events

**Location**: `todos/docgen-lookover/scripts/watcher.py:103-113`

- Uses `loop.call_later()` for debouncing (naive implementation)
- If daemon crashes between debounce and queue.put, event is lost
- No persistence of pending files

**Impact**: File changes during daemon shutdown may be lost

### Inefficient Queue Processing

**Location**: `todos/docgen-lookover/scripts/process_queue.py:243-286`

- Processes jobs sequentially with hardcoded delay
- No batch processing or parallelization despite `--max-jobs` parameter
- With 300+ files and 2-second delays, processing takes hours

### Ollama Model Loading Not Cached

**Location**: `todos/docgen-lookover/scripts/llm.py:169-181`

- `pull_model_if_needed()` queries Ollama on every daemon restart
- No local cache of available models
- Could be slow if Ollama server has latency issues

______________________________________________________________________

## Maintenance Concerns

### Complex Areas Lacking Tests

#### Docgen Integration System

**Location**: `todos/docgen-lookover/scripts/`

- `watcher.py` (252 lines) - untested
- `process_queue.py` (315 lines) - untested
- `frontmatter_daemon.py` (200+ lines) - untested

**Issue**: Complex async/threading code without unit tests

**Risk**: No integration tests validating end-to-end flow

#### jq-transforms Skill Strengths vs. Issues

**Location**: `.skogai/plugin/skills/skogai-jq/`

**Strengths**:

- 60+ transformations with 715 test fixtures
- Comprehensive test coverage
- Self-contained, composable architecture

**Issues**:

- Several tests use loose string comparison
- Test files don't verify JSON output validity
- Some transformations have incomplete/untested edge cases

### Inconsistent Patterns

#### Hook Architecture Mismatch

**Location**: `.skogai/plugin/hooks/`

- Session hooks structured for JSON I/O but most are disabled
- `session-start.sh` is the only functional hook
- Other hooks are stubs - suggests incomplete migration

#### Mixed Error Handling Styles

**Python**:

- Generic `Exception` catches (`llm.py:209`)
- Custom exception classes (`llm.py:53-68`)
- No consistent logging framework

**Bash**:

- `set -e` for fail-fast
- Stderr for logging
- No structured logging

### Documentation Gaps

#### No Deployment/Operations Docs

**Location**: `todos/docgen-lookover/scripts/frontmatter_daemon.py`

Has usage examples but missing:

- Deployment instructions (systemd service? cron? docker?)
- Health check monitoring
- Recovery procedures if Ollama dies
- Log rotation strategy

#### Missing API Documentation

**Location**: `todos/docgen-lookover/scripts/`

- `watcher.py` and `process_queue.py` have docstrings but:
  - No class-level contracts
  - Database schema not documented
  - Queue format undefined

#### Incomplete Skill Metadata

**Location**: `.skogai/skogix.md`

- Empty file: "# skogix additions" with no content
- Several `.skogai/` todo items incomplete but no issue tracking

______________________________________________________________________

## Incomplete Implementations

### Garden Trial System

**Location**: `.skogai/plugin/hooks/session-start.sh:27-64`

- References `$CLAUDE_GARDEN_STATE` and `/garden:` commands
- No corresponding hooks or documentation exist
- Unknown if this feature is actually used or active

### Frontmatter Generation System

**Location**: `todos/docgen-lookover/scripts/`

Multiple Python scripts but:

- No CLI entry point for human use
- No configuration file support (hardcoded paths)
- No migration path for existing docs without frontmatter
- Queue management DB-based but no tools to inspect/clear queue

### jq Skill Test Completeness

**Location**: `.skogai/plugin/skills/skogai-jq/`

Tests are extensive but gaps:

- No negative tests (invalid input rejection)
- Error messages from jq filters not validated
- `try-transform` and `pipe` test success path only
- `schema-validation` doesn't verify error message format

______________________________________________________________________

## Dependency & Compatibility Issues

### Soft Dependencies

**Location**: `todos/docgen-lookover/scripts/`

`frontmatter_daemon.py` requires:

- Ollama server running (localhost:11434) - no fallback
- Specific model (qwen3:8b) - silent failure if not pulled
- watchdog library - imported without try-catch

`process_queue.py` requires:

- SQLite database at `.docgen/docs.db` - created elsewhere, not documented

### Python Version Assumptions

**Location**: Multiple Python scripts

- Uses `asyncio.wait_for()` and `async/await` (Python 3.5+)
- No version specified in setup.py or requirements.txt
- Pydantic v2 APIs but no constraint

### Hard-coded Paths

**Location**: `todos/docgen-lookover/scripts/`

- `.docgen/` paths scattered through code
- `.docgen/prompts/create-frontmatter.txt` referenced but not shown
- No support for user-configurable paths

______________________________________________________________________

## Code Smells & Anti-Patterns

### String Parsing Instead of Structured Data

**Location**: `todos/docgen-lookover/scripts/generate-frontmatter.py:34-39`

```python
def extract_output_tags(text):
    match = re.search(r'<output>(.*?)</output>', text, re.DOTALL)
```

**Issue**: Fragile; LLM output format could change

**Better**: Return JSON from Ollama directly

### Ineffective Type Checking

**Location**: `todos/docgen-lookover/scripts/watcher.py:81-85`

Checks `hasattr(event, "dest_path")` instead of checking event type

**Issue**: Brittle coupling to watchdog internals

### Silent Failures

**Location**: `todos/docgen-lookover/scripts/watcher.py:242-244`

```python
except Exception as e:
    logger.warning(f"Could not read {md_file}: {e}")
    continue  # Silently skips file
```

**Issue**: File corruption may go unnoticed

______________________________________________________________________

## Recommendations (Priority Order)

1. **Complete .skogai Setup** - Implement missing rules, plan, and todos subsystems
1. **Remove Dead Code** - Delete commented-out hooks or re-enable with tests
1. **Add Integration Tests** - Test docgen daemon end-to-end
1. **Validate Ollama Responses** - Parse YAML frontmatter, validate required fields
1. **Document Database Schema** - Define process_queue table structure
1. **Add Deployment Docs** - Systemd service, monitoring, recovery procedures
1. **Fix Subprocess Calls** - Use absolute paths, validate model existence
1. **Add File Integrity Checks** - Backup before overwrite, verify after write
1. **Implement Proper Logging** - Structured logging across Python modules
1. **Complete Skill Tests** - Add negative tests, error message validation

______________________________________________________________________

## Summary

**Strengths**:

- Architecturally sound (jq skill, hooks system)
- Well-structured marketplace plugin system
- Comprehensive jq transformations with tests

**Weaknesses**:

- Operational gaps (unfinished daemon, missing tests, incomplete setup)
- Docgen system risky for production without validation
- Missing error handling and deployment infrastructure

**Assessment**: The codebase demonstrates solid architectural choices but requires operational maturity before production use.
