# Permission Model

Three tiers based on unix ownership and group membership. Default is private — sharing is opt-in per the skogfences principle.

## Private (`claude:claude`, no group access)

- `personal/` — identity, soul, journal, memory blocks
- `.claude/` — claude code config, skills, hooks, agents
- `.planning/` — GSD planning state (does not deploy)

These directories contain state that belongs exclusively to Claude. Sibling agents have no access.

## Shared-read (`:skogai` group read)

- `docs/` — reference material, deployment gate, this document
- `bin/` — scripts and tools
- `notes/` — observations and patterns
- `lab/` — experiments and prototypes
- `README.md` — workspace description
- `CLAUDE.md` — root router

Readable by any agent in the skogai group. Use these to understand Claude's workspace without touching private state.

## Shared-write (`:skogai` group write)

- `guestbook/` — cross-agent messages

Any agent in the skogai group may write here. See `guestbook/CLAUDE.md` for conventions.

## Convention

Default private. To share: `chown :skogai` on the target. Sharing is opt-in per the skogfences principle.

## Discovery

`gptme-dashboard` reads workspace conventions (tasks/, journal/, lessons/, skills/) for cross-agent discovery. The dashboard is the broadcast channel; `guestbook/` is the direct message channel.
