# Codebase Concerns

**Analysis Date:** 2026-03-20

## Tech Debt

**Synchronous file I/O in hook scripts:**
- Issue: All three hook files use blocking `fs.readFileSync()`, `fs.writeFileSync()`, and `fs.existsSync()` operations
- Files: `/.claude/hooks/gsd-check-update.js` (12 calls), `/.claude/hooks/gsd-context-monitor.js` (8 calls), `/.claude/hooks/gsd-statusline.js` (4 calls)
- Why: Simple scripts with small scope, designed to run quickly between tool invocations
- Impact: If file system is slow (network mounts, busy disk), hooks will block the entire Claude Code interface. Especially problematic for gsd-statusline which runs after every tool use.
- Fix approach: Implement async I/O with Promise handling and timeouts. The 10s and 3s stdin timeouts already acknowledge this risk but don't fully mitigate it. Consider caching in memory where possible.

**Silent error suppression in hooks:**
- Issue: All three hook files use empty `catch (e) {}` blocks (gsd-check-update has 4 of these, others have multiple)
- Files: `/.claude/hooks/gsd-check-update.js` (lines 65, 87, 90, 96), `/.claude/hooks/gsd-context-monitor.js` (lines 58), `/.claude/hooks/gsd-statusline.js` (lines 88, 106)
- Why: Hooks should fail silently to avoid breaking Claude Code if there's any issue
- Impact: Silent failures make debugging hook problems difficult. JSON parse errors, file permission issues, or missing directories are all hidden. If a hook breaks, users won't know why their context monitor isn't working or why update checks aren't running.
- Fix approach: Log to a debug file (`.claude/hooks/.debug.log` or similar) instead of swallowing errors completely. Provide a diagnostic command to check hook health.

**Shell string interpolation in spawned subprocess:**
- Issue: gsd-check-update.js line 45 uses template string to build code passed to `-e` flag
- File: `/.claude/hooks/gsd-check-update.js` (lines 45-107)
- Why: Needed to pass paths to the spawned process
- Impact: If JSON.stringify is insufficient, could potentially allow injection. More immediately, complex file paths with quotes could break the command.
- Fix approach: Use proper argument passing instead of string building. Pass data through argv or environment variables instead of template strings.

**Hardcoded thresholds without configuration:**
- Issue: Context warning thresholds (WARNING_THRESHOLD=35%, CRITICAL_THRESHOLD=25%), debounce count (5 calls), and stale data window (60s) are all hardcoded
- File: `/.claude/hooks/gsd-context-monitor.js` (lines 25-28)
- Why: Simple enough for one-off settings, avoided over-engineering
- Impact: Users with different workflows need different thresholds. Heavy explorers might want 45% warning, quick executors might want 20%. No way to customize without editing the hook.
- Fix approach: Read thresholds from `.planning/config.json` or `.claude/settings.json` with sensible defaults.

## Known Bugs

**Context metrics file race condition:**
- Symptoms: Occasional stale context usage warnings that don't match actual usage
- Trigger: High-frequency tool use (multiple tools per second) + high context usage simultaneously
- File: `/.claude/hooks/gsd-statusline.js` (line 47) writes context metrics, `/.claude/hooks/gsd-context-monitor.js` (line 70) reads them
- Root cause: Both hooks write to `/tmp/claude-ctx-{session}.json` without locking. If statusline writes between context-monitor's read and decision, data can be mismatched.
- Workaround: Warnings are only advisory and debounced anyway, so impact is low
- Fix approach: Use atomic writes (write to temp file then rename) or add timestamp-based staleness check (already partially done at line 74)

**Timeout handling inconsistency:**
- Symptoms: gsd-statusline timeout is 3 seconds, gsd-context-monitor is 10 seconds. May cause asymmetric context tracking.
- Trigger: Slow pipe delivery on Windows/Git Bash (according to comments)
- Files: `/.claude/hooks/gsd-statusline.js` (line 14), `/.claude/hooks/gsd-context-monitor.js` (line 35)
- Root cause: Different timeouts were tuned separately for different scenarios
- Impact: If statusline times out but monitor doesn't (or vice versa), context metrics and warnings can diverge
- Fix approach: Standardize on 5s timeout for both, with configurable override

**Missing validation of hook version headers:**
- Symptoms: Stale hook detection may miss hooks without version headers entirely
- Trigger: Hooks deployed from older GSD versions that didn't have version headers
- File: `/.claude/hooks/gsd-check-update.js` (lines 77-86)
- Root cause: Script correctly detects missing headers but doesn't fail clearly to the user
- Impact: Stale hooks with no version header get flagged as "unknown" and added to stale_hooks list, but user sees warning without clear action
- Fix approach: Document the expected action better in statusline warning, or auto-upgrade missing-header hooks

## Security Considerations

**No validation of config.json integrity:**
- Risk: `gsd-context-monitor.js` reads `.planning/config.json` and trusts it (line 53). Malicious config could disable warnings or inject values.
- File: `/.claude/hooks/gsd-context-monitor.js` (lines 50-60)
- Current mitigation: Config is in project directory, not global, so easier to audit. Hook uses JSON.parse which will fail on invalid JSON.
- Recommendations: Add schema validation for config.json before using values. Reject unknown keys. Document that config must be trusted (not user-supplied).

**npm registry dependency in hook:**
- Risk: gsd-check-update.js runs `npm view get-shit-done-cc version` (line 95) to check for updates. Network failure or registry compromise could return unexpected values.
- File: `/.claude/hooks/gsd-check-update.js` (line 95)
- Current mitigation: Run in background subprocess, timeout at 10s, failure just means version stays "unknown"
- Recommendations: Validate version string format (semver) before using. Consider pre-baking latest version into the installation instead of querying registry every session.

**Temp file location predictability:**
- Risk: Context metrics and warning state stored in `/tmp/claude-ctx-{sessionId}.json` are world-readable on Unix systems
- Files: `/.claude/hooks/gsd-statusline.js` (line 40), `/.claude/hooks/gsd-context-monitor.js` (lines 63, 87)
- Current mitigation: Session ID is opaque, but predictable patterns could leak context usage
- Recommendations: Use secure temp directory functions if available. Consider using `os.tmpdir()` with umask-protected subdirectory or user-only permissions (0600).

## Performance Bottlenecks

**Hook execution time after every tool use:**
- Problem: gsd-context-monitor and gsd-statusline both run as PostToolUse hooks, synchronously blocking
- Files: `/.claude/hooks/gsd-context-monitor.js`, `/.claude/hooks/gsd-statusline.js`
- Measurement: Both scripts do file I/O on every tool use (read metrics, read todos, write metrics). At ~100ms per file operation, this adds 300-500ms latency per tool use with high context usage.
- Cause: Synchronous I/O as mentioned in tech debt section, plus no caching
- Improvement path:
  1. Implement async I/O (immediate 2-3x speedup)
  2. Cache todos and context metrics in memory with expiry
  3. Make context-monitor debounce more aggressively (currently 5 calls)
  4. Move expensive checks (update available, stale hooks) to SessionStart hook instead of every tool use

**Update check runs every session:**
- Problem: gsd-check-update runs `npm view` on every session startup, even if checked recently
- File: `/.claude/hooks/gsd-check-update.js`
- Measurement: npm registry query can take 1-5 seconds on slow networks
- Cause: Check runs in background so it's not blocking, but still a waste if done multiple times per minute
- Improvement path: Check cache age before querying registry. Only refresh if cache > 24 hours old.

## Fragile Areas

**Hook configuration detection:**
- File: `/.claude/hooks/gsd-check-update.js` (lines 16-28)
- Why fragile: Detects config directory by checking for `.claude/get-shit-done/VERSION` in multiple candidate directories. Order matters, and if directory structure changes, detection fails silently.
- Common failures: Multi-config setups where both `.claude` and `.config/opencode` exist get unpredictable behavior. CLAUDE_CONFIG_DIR environment variable override helps but isn't well-documented.
- Safe modification: Add debug logging (to file) showing which config dir was detected. Write tests for the detection function with mock directory structures.
- Test coverage: No tests exist for config detection

**Statusline task extraction:**
- File: `/.claude/hooks/gsd-statusline.js` (lines 75-92)
- Why fragile: Searches for files matching pattern `{session}-agent-*.json`, reads and parses JSON, expects specific fields. Many points of failure.
- Common failures: If todos JSON is corrupted, the try-catch silently fails (line 87). If activeForm field is missing, task is empty. If multiple todo files exist, sorts by mtime but relies on filesystem clock accuracy.
- Safe modification: Add validation for JSON structure before accessing fields. Log what task is being displayed (to debug file).
- Test coverage: No tests for task extraction logic

**Debounce logic state management:**
- File: `/.claude/hooks/gsd-context-monitor.js` (lines 86-117)
- Why fragile: Stores debounce state in `/tmp/claude-ctx-{sessionId}-warned.json`. State can be lost if temp directory is cleaned, or corrupted if file is partially written.
- Common failures: File corruption causes JSON.parse to fail (caught), then warnData resets to default, breaking debounce. Concurrent writes from multiple invocations could both see old state and emit simultaneous warnings.
- Safe modification: Use atomic writes (write-to-temp-then-rename). Add corruption recovery by keeping previous state in memory. Add locking for concurrent writes.
- Test coverage: No tests for debounce state

## Scaling Limits

**Session ID collision risk:**
- Current capacity: Session IDs used to generate temp filenames and for task matching. If many sessions start simultaneously, collision risk depends on ID uniqueness.
- Limit: No documented collision handling. If two sessions get same ID, they'll overwrite each other's context metrics and warnings.
- Symptoms at limit: Context warnings not working reliably in multi-agent or very high-frequency session scenarios
- Scaling path: Ensure session ID generation is cryptographically random and long enough. Document session ID format and uniqueness guarantee.

**Todo file accumulation:**
- Current capacity: `~/.claude/todos/` directory stores JSON file per session per task. With long-running projects and multiple daily sessions, this grows unbounded.
- Limit: File system inode limits (typically 1M on ext4), but more practically, directory listings slow down with 10k+ files
- Symptoms at limit: `fs.readdirSync(todosDir)` becomes slow (O(n) listing every tool use)
- Scaling path: Implement todo rotation (archive old files), or use a database instead of file-per-todo. Add cleanup during session start.

## Dependencies at Risk

**Reliance on `/tmp` directory:**
- Risk: Unix systems clear /tmp periodically (often on reboot). Windows equivalent varies by system. No guarantee that metrics persist across reboots.
- Impact: Context metrics lost after reboot, causing warnings to be reset
- Migration plan: Move persistent state to `.planning/` directory instead of `/tmp`. Use `/tmp` only for ephemeral cache.

**Node.js child_process.spawn behavior variance:**
- Risk: Behavior of `stdio: 'ignore'` and `detached: true` differs between Windows and Unix
- File: `/.claude/hooks/gsd-check-update.js` (lines 108-111)
- Impact: Update checks may not background properly on Windows, or may not exit cleanly on Unix
- Migration plan: Use proper process management library or test thoroughly on both platforms

## Missing Critical Features

**Health check for hook system:**
- Problem: No way to diagnose if hooks are working correctly
- Current workaround: Users have to infer from statusline whether context warnings are active
- Blocks: Can't troubleshoot hook failures, can't verify update checks are running
- Implementation complexity: Low (add `/gsd:health` command that tests each hook)

**Hook performance metrics:**
- Problem: No visibility into how long hooks take to run
- Current workaround: None, users just experience slowdowns
- Blocks: Can't identify which hook is slow, can't optimize
- Implementation complexity: Medium (add timing instrumentation, report via statusline or command)

**Configurable hook behavior:**
- Problem: Context warning thresholds and other hook behavior hardcoded
- Current workaround: Edit hook files directly
- Blocks: Different workflows can't customize for their needs
- Implementation complexity: Low (read from config file, already partially done for context warnings)

## Test Coverage Gaps

**Hook integration testing:**
- What's not tested: Actual hook execution in Claude Code environment. No tests for stdin parsing, JSON output format, signal handling.
- Files: `/.claude/hooks/gsd-*.js` (all three)
- Risk: Hooks could silently fail to parse stdin, return invalid JSON, or crash without any feedback
- Priority: High
- Difficulty to test: Need Claude Code hook sandbox or mock the hook invocation environment

**Config directory detection:**
- What's not tested: The priority order of config directory detection in gsd-check-update.js
- File: `/.claude/hooks/gsd-check-update.js` (lines 16-28)
- Risk: Multi-environment setups (Claude + OpenCode + Gemini) could detect wrong directory
- Priority: Medium
- Difficulty to test: Need to mock filesystem structure and environment variables

**Race condition scenarios:**
- What's not tested: Concurrent writes to shared temp files (context metrics, debounce state)
- Files: `/.claude/hooks/gsd-statusline.js`, `/.claude/hooks/gsd-context-monitor.js`
- Risk: High-frequency tool use could lose or corrupt state
- Priority: Medium
- Difficulty to test: Need to simulate concurrent file access and timing

**Error recovery behavior:**
- What's not tested: What happens when config.json is malformed, npm view times out, todo JSON is corrupted
- Files: All three hook files
- Risk: Silent failures make debugging difficult
- Priority: Medium
- Difficulty to test: Need to mock filesystem errors and network timeouts

---

*Concerns audit: 2026-03-20*
