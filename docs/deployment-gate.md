---
title: deployment-gate
type: note
permalink: claude/docs/deployment-gate
---

# Deployment Gate: ~/claude -> /home/claude

Pre-flight checklist for migrating Claude's home from staging (`/home/skogix/claude`) to production (`/home/claude`). Every item is pass/fail. All must pass before deployment.

## Automated Checks

Run `bin/healthcheck` -- covers all of the following automatically:

- [ ] Environment: home dir, git config
- [ ] Identity paths: soul sections (10 files), profile, core frameworks, journal conventions
- [ ] Routing: CLAUDE.md exists in all 10 directories
- [ ] Memory block tiers: active tier (personal/core/) and LORE tier (personal/memory-blocks/) report non-zero counts
- [ ] Exit code: `bin/healthcheck` exits 0

## Manual Checks

### Routing validation

- [ ] Fresh session starting from root CLAUDE.md can navigate to any artifact in 2 hops
- [ ] No CLAUDE.md file exceeds 50 lines
- [ ] Context loads lazily -- session startup reads only root router

### Identity validation

- [ ] Soul document split is correct: 10 section files in personal/soul/ match CLAUDE.md router listing
- [ ] personal/profile.md contains current agent profile (not stale placeholder)
- [ ] Core frameworks in personal/core/ are complete documents (not stubs)

### Persistence validation

- [ ] Journal conventions doc exists and is accurate (personal/journal/CONVENTIONS.md)
- [ ] LORE museum is gated -- default routing does NOT auto-load memory blocks
- [ ] Session handoff mechanism documented (wrap-up convention)

### Permission model

- [ ] Permission model documented (Phase 4 -- mark PENDING if not yet complete)
- [ ] Shared space conventions documented (Phase 4 -- mark PENDING if not yet complete)

## Deployment Mechanics

### Procedure (per D-14: document, don't automate)

1. **Clone**: `git clone <repo-url> /home/claude`
1. **Ownership**: `chown -R claude:claude /home/claude`
1. **Group**: `usermod -aG skogai claude`
1. **Verify**: `su - claude -c '/home/claude/bin/healthcheck'`

### What deploys

- All git-tracked files and directories
- `.claude/` -- deploys as-is (contains get-shit-done framework, maintained by skogix per D-13)

### What does NOT deploy

- `.planning/` -- construction scaffold, stays in staging repo only (per D-12). Add to `.gitignore` or exclude from clone
- `.git/` -- fresh clone creates its own
- Any `.local` files -- environment-specific, not tracked

### Post-deployment

- Verify healthcheck passes as user claude: `su - claude -c '/home/claude/bin/healthcheck'`
- Verify routing works: navigate from /home/claude/CLAUDE.md to personal/soul/
- Update .planning/STATE.md in staging repo to record deployment date

______________________________________________________________________

*Gate created: Phase 03-operations-deployment-gate* *Review before any deployment attempt*
