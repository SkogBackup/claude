---
title: problems-and-ideas
type: note
permalink: claude/lab/projects-in-development/skogfences/problems-and-ideas
---

# skogfences: problems, solutions, and ideas

a well to draw from. not all of these are problems - some are questions, some are edge cases, some are "have you thought about this?"

______________________________________________________________________

## ownership and permissions

### file ownership in shared spaces

- human creates file in `/skogai` → owned by human
- agent creates file in `/skogai` → owned by agent
- who can edit what? setgid helps with group, but owner differs
- **question:** is this a problem or a feature? (audit trail of who created what)

### the sticky bit question

- `/skogai` with sticky bit = only owner can delete their files
- without sticky bit = anyone in group can delete anything
- **which is right?** collaboration vs protection

### umask inheritance

- what umask do agents run with?
- if agent creates 600 files, human can't read them
- if agent creates 666 files, security suffers
- **need:** consistent umask policy for shared spaces

______________________________________________________________________

## git complications

### commit authorship

- agent commits as `claude` user
- human commits as `skogix` user
- mixed history - is this good? (clear attribution) or bad? (messy)
- **idea:** maybe it's exactly right - you can `git log --author=claude`

### git credentials

- where are they stored?
- can agent push to remotes?
- should agent EVER have write access to remotes?
- **current status:** ?

### gitconfig location

- global gitconfig in agent's home?
- project-level overrides?
- **risk:** agent misconfigures git, breaks workflows

______________________________________________________________________

## process and system boundaries

### process visibility

- agents can `ps aux` and see all processes
- including your other work, other agents, system services
- user isolation doesn't hide process list
- **question:** is this a problem? probably low risk but worth noting

### /tmp is shared

- world-readable, world-writable
- agents can see temp files from other processes
- sensitive data might land there
- **mitigation:** per-user tmp dirs? `TMPDIR=/home/claude/tmp`?

### /proc access

- agents can read `/proc` for any process (mostly)
- environ, cmdline, fd info
- **question:** acceptable? or need namespace isolation?

______________________________________________________________________

## network and external access

### unrestricted network

- agents can hit any endpoint
- exfiltrate to anywhere
- current model: trust the agent, isolate the filesystem
- **question:** is filesystem isolation enough?

### ssh agent forwarding

- if SSH_AUTH_SOCK is set and accessible, agent can use your ssh keys
- even without seeing the key files
- **check:** is the socket in a protected location?

### api keys and secrets

- agent legitimately needs some (anthropic api key, etc.)
- where do these live?
- agent's home? shared config? env vars?
- **risk:** env vars visible in `/proc/*/environ`

______________________________________________________________________

## multi-agent scenarios

### agent-to-agent isolation

- claude can't see amy's home (good)
- but they share `/skogai` workspace
- can they interfere with each other's work?
- **idea:** per-agent workspaces within `/skogai`?

### resource contention

- multiple agents running simultaneously
- cpu, memory, disk io
- **question:** cgroups for resource limits?

### communication between agents

- should agents be able to talk to each other?
- if yes: how? shared files? sockets? dbus?
- if no: how to prevent?

______________________________________________________________________

## persistence and state

### agent home as state

- agent's home accumulates state over time
- learned preferences, caches, history
- **good:** persistence across sessions
- **bad:** cruft accumulation, stale state

### backup and restore

- how to backup agent homes?
- how to restore to known-good state?
- **idea:** agent home as git repo (version the state itself)

### migration

- move agent to new machine
- tar up home, restore elsewhere?
- what about machine-specific paths?

______________________________________________________________________

## privilege and escalation

### wheel group membership

- `claude : claude wheel skogai`
- wheel = sudo access
- **question:** should agents EVER have sudo?
- **current:** presumably password-protected, but still...

### setuid binaries

- if agent can execute setuid binaries, isolation is partial
- most systems have some
- **risk level:** low but nonzero

### capability inheritance

- linux capabilities might leak through
- **check:** what capabilities does agent process have?

______________________________________________________________________

## practical friction

### installing dependencies

- agent needs a package: `pip install foo`
- where does it go? system-wide? agent's home? project venv?
- agent can't sudo apt install
- **solution:** all deps in project or agent home, never system

### editor integration

- human uses neovim
- agent proposes changes via tool calls
- how does human review? (current: git diff)
- **question:** is the git diff workflow smooth enough?

### debugging access issues

- agent can't read a file
- how do you diagnose?
- agent can't run `ls -la /home/skogix` to check
- **need:** clear error messages, diagnostic tools agent CAN run

______________________________________________________________________

## ideas bucket

### per-project agent instances

- not one global `claude` user
- `claude-skogai`, `claude-otherproject`
- complete isolation between projects

### read-only collaboration mode

- agent can see shared space but not modify
- "advisor mode" - suggests changes, human applies
- explicit write grant for specific tasks

### time-limited sessions

- agent user locked after N hours of inactivity
- forces explicit "wake up" for new work
- prevents background drift

### agent home as git repo

- version control the agent's state
- rollback to known-good configuration
- diff what changed after a bad session

### network namespaces

- agent can only reach specific endpoints
- whitelist anthropic api, nothing else
- **heavy:** requires root/caps to set up

### structured handoff protocol

- explicit "i'm done, here's what i did" message
- commit + summary as atomic handoff
- clear session boundaries

### audit log

- append-only log of agent actions
- what files touched, what commands run
- human-readable, agent-append-only

______________________________________________________________________

## open questions

1. what's the threat model? malicious agent? buggy agent? nosy agent?
1. is "can't see home" enough, or need "can't see anything outside workspace"?
1. how do you handle legitimate secrets the agent needs?
1. what's the recovery path when agent breaks something?
1. how do multiple humans share the same agent setup?
1. should agents be able to spawn subprocesses? (they currently do)
1. what about gui applications? clipboard? display?

______________________________________________________________________

## things to verify in current setup

- [ ] agent cannot read `/home/skogix/`
- [ ] agent cannot read `/home/skogix/.ssh/`
- [ ] agent cannot access ssh agent socket
- [ ] shared space permissions are correct (setgid, group write)
- [ ] git commits attribute correctly
- [ ] agent's TMPDIR is isolated
- [ ] env vars don't leak secrets to `/proc`
- [ ] wheel membership requires password for sudo
- [ ] other agents (amy, goose, dot) are equally isolated
