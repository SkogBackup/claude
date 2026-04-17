---
title: research-git-conversations
type: note
permalink: claude/lab/projects-in-development/skogdiff/research-git-conversations
---

# Git-native agent memory: Beads and comparable systems

**Beads** implements a dual-persistence architecture where JSONL files serve as git-tracked source of truth while SQLite provides sub-100ms local query performance. This pattern—git for durability, local database for speed—has emerged as the dominant approach among systems linking code commits to semantic intent, with variations in how they handle memory decay, multi-agent concurrency, and conversation-to-code traceability.

## Beads storage architecture uses JSONL with SQLite caching

The `.beads/` directory maintains a carefully partitioned structure separating git-tracked sources of truth from local-only caches:

```
.beads/
├── issues.jsonl          # Git-tracked source of truth (one JSON object per line)
├── deletions.jsonl       # Tombstone manifest for deletion propagation
├── config.yaml           # Project configuration
├── beads.db              # SQLite cache (gitignored)
├── bd.sock               # Daemon Unix socket (gitignored)
└── export_hashes.db      # Export tracking (gitignored)
```

Each entity in `issues.jsonl` follows a flat structure with **one JSON object per line**, enabling clean git diffs and append-friendly merges. A typical entry contains `id`, `title`, `description`, `status`, `priority`, `type`, `created_at`, `updated_at`, and critically a `jsonl_content_hash` field for change detection. The system supports entity types including `bug`, `feature`, `task`, `epic`, `molecule`, and `agent`.

The SQLite layer maintains identical data plus additional tables: `dirty_issues` tracks entities needing export, `blocked_issues_cache` provides **25x performance improvement** for dependency queries, and `events` stores complete audit trails. Write operations flow through a `FlushManager` with 500ms-5s debouncing, writing to a temporary file before atomic rename.

## Hash-based IDs eliminate merge conflicts in multi-agent workflows

Beads generates identifiers using **SHA256 content hashing** with a configurable prefix (default `bd-`), producing IDs like `bd-a1b2` (4-6 characters). The hash inputs include all substantive fields, enabling timestamp-independent change detection—the importer skips unchanged issues by comparing content hashes.

```
bd-a1b2         # Base hash ID
bd-a3f8e9.1     # Hierarchical child (epic → task)
bd-a3f8e9.1.1   # Nested child (task → subtask)
```

This approach solves the multi-agent concurrency problem that plagues sequential IDs. When multiple agents or developers create issues simultaneously on different branches, hash-based IDs **inherently avoid collisions**—different content produces different hashes. Hierarchical IDs enable epic→task relationships where the parent's hash becomes the prefix and children get `.1`, `.2`, `.3` suffixes via `store.GetNextChildID()`.

## Commits link to tasks through convention and events

Rather than embedding metadata in commit messages, Beads relies on a **convention-based system**: developers include the issue ID in parentheses at the commit message end (e.g., `git commit -m "Fix auth validation bug (bd-abc)"`). The `bd doctor` command then detects **orphaned issues**—work committed but issues not closed.

The `events` table provides comprehensive audit trails with typed event records:

| Event Type             | Purpose                                         |
| ---------------------- | ----------------------------------------------- |
| `EventCreated`         | Issue creation with initial state               |
| `EventStatusChanged`   | State transitions (open → in_progress → closed) |
| `EventCompacted`       | Memory decay applied                            |
| `EventDependencyAdded` | Blocking relationship established               |

All write operations require an `actor` parameter, resolved in priority order: `--actor` flag → `BD_ACTOR` env → `BEADS_ACTOR` env → `git config user.name` → `$USER` → `"unknown"`. This enables attribution across multi-agent scenarios.

The synchronization mechanism includes a **30-second transaction window** where multiple issue changes get flushed together, avoiding commit spam. Pre-push hooks guarantee DB↔JSONL consistency before remote sync.

## Compaction implements semantic memory decay for agents

Beads' compaction system addresses context window limitations by **summarizing old closed tasks**. Each issue has a `CompactionLevel` field (0 = full detail, higher = more compacted), and the workflow operates in three phases:

```bash
# 1. Analyze candidates (closed 30+ days by default)
bd admin compact --analyze --json --no-daemon

# 2. Generate summary externally (LLM/agent)
# Agent reads full content, produces compressed version

# 3. Apply summary permanently
bd admin compact --apply --id bd-42 --summary summary.txt
```

Compacted issues display with indicators: `bd-a3f8: Implement user auth 🗜️` shows status, original size (**4521 bytes**), compressed size (**2314 bytes**, 49% reduction), and compaction tier. This is a **permanent, graceful decay mechanism**—detailed content replaced with concise summaries.

The deletion system uses **tombstones**: deleted issues become `status='tombstone'` to prevent resurrection during cross-clone sync. The `deletions.jsonl` append-only manifest tracks tombstones, and import sanitization removes deleted issues before upsert. Git history serves as fallback when the deletion manifest is pruned.

## Comparable systems take divergent architectural approaches

Research identified **11 systems** implementing git-semantic linking with distinct trade-offs:

**Git Context Controller (GCC)** creates a `.GCC/` directory with a 3-tiered hierarchy: high-level planning files, commit-level summaries, and fine-grained execution traces. Agents call `COMMIT` when reasoning subgoals complete, `BRANCH` for isolated exploration. This achieved **48% resolution on SWE-Bench-Lite** (SOTA), demonstrating that persistent reasoning traces enable cross-agent collaboration—different LLMs can pick up context from files.

**DiffMem** separates "surface" from "depth": Markdown files store **current-state knowledge only**, while git history captures temporal evolution. An in-memory BM25 index enables fast retrieval, with multi-depth context assembly (basic → wide → deep → temporal). The key insight: querying current files is fast; reconstructing history via `git show <commit>:file.md` handles temporal queries without bloating working files.

**Tigs** uses **git notes attached to commits**—a non-invasive approach that never rewrites commit hashes. YAML documents parsed from Claude Code, Gemini CLI, and other tool logs get linked to commits through a TUI. The `push --notes` / `pull --strategy=union` mechanism enables team synchronization while preserving commit integrity.

**Aider** takes the tightest git integration approach: **every LLM edit gets its own commit** with descriptive messages and `(aider)` attribution. The `--chat-history-file` stores conversation in Markdown, while a repository map analyzes the entire codebase to build compact context. The `/diff` and `/undo` commands operate directly on git history.

## Architectural patterns reveal four distinct strategies

Analysis reveals four implementation patterns with clear trade-offs:

| Pattern                    | Example    | Storage             | Pros                          | Cons               |
| -------------------------- | ---------- | ------------------- | ----------------------------- | ------------------ |
| **Dual-layer**             | Beads      | JSONL + SQLite      | Fast queries, git portability | Sync complexity    |
| **Git notes**              | Tigs       | YAML in notes       | Non-invasive, survives rebase | Manual linking     |
| **Markdown current-state** | DiffMem    | .md files           | Human-readable, lean context  | Index rebuild cost |
| **Database-backed**        | Claude-Mem | SQLite + embeddings | Semantic search               | Not portable       |

The **dual-layer pattern** (Beads, GitHub Copilot Memory) has emerged as most robust for multi-agent scenarios. Copilot's approach adds **citation-based verification**: memories store specific code locations, and before use the agent verifies citations against current branch state. If code contradicts memory, store corrected version; if valid, refresh timestamp. This elegantly handles stale data.

**Memory decay** proves critical for long-horizon agents. Three approaches dominate:

- **Compaction** (Beads): LLM-generated summaries replace detailed content
- **Auto-compaction** (Claude Code): Summarizes at 80% context window usage
- **Citation verification** (Copilot): Real-time staleness detection

For **conversation-to-code traceability**, git-ai's approach of storing attribution metadata (model, prompt, line counts) in git notes provides compliance-ready audit trails that survive `merge --squash`, `rebase`, and `cherry-pick` operations.

## Implementation recommendations for git-based agent memory

For **task/issue tracking**, Beads' architecture represents current best practice: JSONL for append-friendly git operations, hash-based IDs preventing merge conflicts, SQLite for query performance, and background daemon with debounced flush.

For **conversation history**, the DiffMem pattern—Markdown files for current state, git commits for history, hybrid BM25+semantic search—keeps context windows lean while preserving full temporal queries via `git diff` and `git log` APIs.

For **code traceability**, git notes (Tigs, git-ai) provide the cleanest separation: metadata stays out of commit messages, survives rebase operations, and enables team synchronization through `git push/pull --notes`.

## Conclusion

The Beads architecture demonstrates that **git can serve as a distributed database** when paired with local caching. Its JSONL storage achieves merge-friendliness through append-only patterns and hash-based IDs; the SQLite layer provides sub-100ms queries; and compaction implements graceful memory decay for long-running agents.

Compared to alternatives, Beads uniquely solves multi-agent concurrency (hash IDs), provides both git portability and query speed (dual-layer), and implements semantic memory decay (compaction)—though it requires more infrastructure than simpler approaches like DiffMem's Markdown-only pattern. For teams building AI coding agents that need durable, queryable, mergeable task state, the JSONL+SQLite dual-persistence pattern with content-addressed IDs represents the current architectural frontier.
