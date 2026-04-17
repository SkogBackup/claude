# Findings: Claude's Home

## Architecture

- skogfences principle: agents are unix users with their own space
- Context Destruction Pattern (anti-pattern): bulk preloading instead of lazy CLAUDE.md routing
- LORE museum (personal/memory-blocks/) = historical archive, not active constraints
- Three-tier permissions: private (claude:claude), shared-read (:skogai), shared-write (guestbook/)

## SkogAI Ecosystem

- 332 repos under skogai org
- Gas Town: ~/gt/ shared workspace
- Sibling agents: dot (gptme), amy, goose, aldervall, letta
- Dolt database backend
- Dot built manually what Claude gets natively via Claude Code

## Phase 5: skogparse

- Binary at `/home/skogix/.local/bin/skogparse --execute`
- Output format: `{"type":"string","value":"..."}` — always unwrap `.value`
- Only messages starting with `[@` are routed; plain text bypasses
- Avoid `skogparse.sh` MCP tool (hardcodes wrong path)

## Planning Migration

- Current: GSD framework under `.planning/` (skogix's tooling in claude's home)
- Target: skogai-planning-with-files under `.skogai/plan/<project>/`
- `.planning/memory/` (auto-memory) migrates separately or stays
- Migration is iterative — `.planning/` coexists until all references updated
