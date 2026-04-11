# submodules → gita + symlinks migration

migrated ~/claude/ from git submodules to gita-managed repos in ~/.local/src/ with symlinks.

## why

submodules cause pain: detached HEAD, two-step commits, sync friction on startup. claude code's cache layer makes them show up as "ghosts" even when deinited. gita already managed repos in ~/.local/src/ — duplicating them as submodules made no sense.

## what changed

1. removed all 5 submodules (marketplace, worktrunk, claude-memory, gptme-contrib, small-hours)
2. registered 17 repos in gita under `src` group, all in ~/.local/src/
3. added `freeze.csv` as bootstrap/restore source of truth (includes URLs, paths, branches)
4. created symlinks: projects/ and marketplaces/ → ~/.local/src/ for legacy compatibility
5. added idempotency principle to CLAUDE.md conventions
6. cleaned .envrc (removed submodule update lines)
7. dumped scaling questions to inbox (200+ SkogAI repos, bootstrap script, group taxonomy)

## key learnings

- `gita freeze` is the real source of truth, not repos.csv (which lacks URLs)
- `gita clone -f -p` needs `-p` to preserve original paths — without it clones into cwd
- clone errors on existing dirs but still registers them — functional but not idempotent
- gita has a bug in `f_clone` dry-run path (unpacks 3 values from 2-value return)

## commits

- b5b338a: remove all git submodules
- 2e3c8a0: register all src repos in gita
- 9b3510f: commit the freeze.csv
- 3e86ecc: add idempotency principle and update structure
- 11fece4: add symlinks from projects/ and marketplaces/ to src
- 719d1a9: remove submodule lines from .envrc, add scaling tasks to inbox
