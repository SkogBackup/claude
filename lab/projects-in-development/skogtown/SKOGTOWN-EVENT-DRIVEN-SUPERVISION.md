---
title: SKOGTOWN-EVENT-DRIVEN-SUPERVISION
type: note
permalink: claude/lab/projects-in-development/skogtown/skogtown-event-driven-supervision
---

## 1. SkogAI; Event-Driven-Orchestration

```
┌─────────────────────────────────────────────────────────────────┐
│                    BEADS HIERARCHY                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   PERMANENT (stored in .beads/issues.jsonl, git-tracked)        │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │  Epic        Long-running initiatives                   │   │
│   │  Task        Concrete work items                        │   │
│   │  Bug         Defects to fix                             │   │
│   │  Convoy      Work bundle (tracks multiple issues)       │   │
│   │  Agent       Agent identity/state                       │   │
│   │  MR          Merge request (in merge queue)             │   │
│   └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│   EPHEMERAL (wisps, in-memory or .beads-wisp/, auto-squash)     │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │  Wisp        Lightweight, auto-destroyed after runs     │   │
│   │  Patrol      Single patrol cycle record                 │   │
│   │  Session     Cost tracking for one session              │   │
│   │  Gate        Async coordination primitive               │   │
│   └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│   DURABLE WORKFLOWS                                             │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │  Formula     TOML template (deacon-patrol, polecat-work)│   │
│   │  Molecule    Instantiated formula with state            │   │
│   │              Survives crashes, resume from last step    │   │
│   └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

Key Commands:
  bd create "title"          Create issue
  bd list --status=open      List issues
  bd show <id>               View issue
  bd close <id>              Close issue
  bd sync                    Sync with git
  bd ready                   Find unblocked work
  bd mol pour <formula>      Instantiate molecule
  bd mol status              Check current molecule
```

**Key insight**: Wisps get "squashed" into digest beads. This prevents log pollution while maintaining audit trails. Example: 5 patrol cycle wisps → 1 "Digest: deacon-patrol" bead.

______________________________________________________________________

## 2. The Communication System — How Agents Talk

```
┌──────────────────────────────────────────────────────────────────┐
│                    COMMUNICATION CHANNELS                        │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│   MAIL (async, persistent, archived after processing)            │
│   ┌────────────────────────────────────────────────────────────┐ │
│   │  gt mail inbox              Check your messages            │ │
│   │  gt mail send <addr> -s -m  Send message                   │ │
│   │  gt mail archive <id>       Archive processed message      │ │
│   │                                                            │ │
│   │  Message Types:                                            │ │
│   │  • POLECAT_DONE     — Worker completed                     │ │
│   │  • MERGE_READY      — Ready for merge queue                │ │
│   │  • MERGED           — Branch merged to main                │ │
│   │  • WITNESS_PING     — Health check ping                    │ │
│   │  • HELP             — Agent needs assistance               │ │
│   │  • HANDOFF          — Context transfer on respawn          │ │
│   │  • DOG_DONE         — Background task complete             │ │
│   └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│   NUDGE (real-time, ephemeral, for immediate attention)          │
│   ┌────────────────────────────────────────────────────────────┐ │
│   │  gt nudge <agent> "message"                                │ │
│   │                                                            │ │
│   │  Triggers Claude's UserPromptSubmit hook → mail injected   │ │
│   │  Used for: wake ups, gentle prods, status checks           │ │
│   └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│   FEED (event log, append-only JSONL, observable)                │
│   ┌────────────────────────────────────────────────────────────┐ │
│   │  gt feed --since 10m        Recent events                  │ │
│   │  bd activity --follow       Subscribe to changes           │ │
│   │                                                            │ │
│   │  Event types: session_start, session_death, nudge,         │ │
│   │               bead_created, bead_closed, etc.              │ │
│   └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│   ESCALATION (priority-based routing)                            │
│   ┌────────────────────────────────────────────────────────────┐ │
│   │  critical: bead → mail:mayor → email:human → sms:human     │ │
│   │  high:     bead → mail:mayor → email:human                 │ │
│   │  medium:   bead → mail:mayor                               │ │
│   │  low:      bead only                                       │ │
│   │                                                            │ │
│   │  Stale threshold: 4 hours (triggers re-escalation)         │ │
│   └────────────────────────────────────────────────────────────┘ │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

**Key insight**: Mail must be archived after processing. Inbox hygiene is enforced — accumulation indicates problems.

______________________________________________________________________

## 3. The Lifecycle System — Birth, Work, Death, Rebirth

```
┌──────────────────────────────────────────────────────────────────┐
│                    SESSION LIFECYCLE                             │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│   CLAUDE HOOKS (wired into Claude Code's lifecycle)              │
│   ┌────────────────────────────────────────────────────────────┐ │
│   │  SessionStart:      gt prime && gt mail check --inject     │ │
│   │  PreCompact:        gt prime (re-inject context)           │ │
│   │  UserPromptSubmit:  gt mail check --inject                 │ │
│   │  Stop:              gt costs record                        │ │
│   └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│   CONTEXT MANAGEMENT                                             │
│   ┌────────────────────────────────────────────────────────────┐ │
│   │  gt prime       Load full role context into session        │ │
│   │  gt context     Check context usage                        │ │
│   │  gt handoff     Clean session transfer (mail + respawn)    │ │
│   │  gt seance      Query predecessor sessions                 │ │
│   │                                                            │ │
│   │  Context HIGH (>80%)?                                      │ │
│   │    → Write handoff mail                                    │ │
│   │    → Exit cleanly                                          │ │
│   │    → Daemon respawns fresh session                         │ │
│   └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│   DEATH WARRANT SYSTEM (stuck agent termination)                 │
│   ┌────────────────────────────────────────────────────────────┐ │
│   │                                                            │ │
│   │   Witness/Deacon files warrant → Dog processes             │ │
│   │                                                            │ │
│   │   INTERROGATION (3 attempts with exponential backoff):     │ │
│   │     Attempt 1: "Respond ALIVE within 60s"                  │ │
│   │     Attempt 2: "Respond ALIVE within 120s"                 │ │
│   │     Attempt 3: "Respond ALIVE within 240s" (final)         │ │
│   │                                                            │ │
│   │   OUTCOMES:                                                │ │
│   │     PARDONED  — Agent responded, warrant cancelled         │ │
│   │     EXECUTED  — 3 failures, tmux session killed            │ │
│   │     ALREADY_DEAD — Target gone before processing           │ │
│   │                                                            │ │
│   │   Total grace period: 7 minutes before forced termination  │ │
│   │                                                            │ │
│   └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│   POLECAT SELF-CLEANING                                          │
│   ┌────────────────────────────────────────────────────────────┐ │
│   │  gt done:                                                  │ │
│   │    1. Push branch to origin                                │ │
│   │    2. Create MR bead in merge queue                        │ │
│   │    3. Nuke worktree                                        │ │
│   │    4. Exit session                                         │ │
│   │                                                            │ │
│   │  Done means GONE. No idle state. No waiting for merge.     │ │
│   └────────────────────────────────────────────────────────────┘ │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

**Key insight**: Agents are designed to be stateless across sessions. Context is reconstructed via `gt prime`. Handoffs are mail-based. The system assumes agents will crash/restart.

______________________________________________________________________

## 4. The Work Orchestration System — Getting Things Done

```
┌──────────────────────────────────────────────────────────────────┐
│                    WORK FLOW                                     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│   GUPP: "If there is work on your hook, YOU MUST RUN IT."        │
│                                                                  │
│   ┌────────────────────────────────────────────────────────────┐ │
│   │                                                            │ │
│   │  Human tells Mayor    "Build feature X"                    │ │
│   │         │                                                  │ │
│   │         ▼                                                  │ │
│   │  Mayor creates Convoy  gt convoy create "Feature X" ...    │ │
│   │         │                                                  │ │
│   │         ▼                                                  │ │
│   │  Mayor slings work     gt sling issue-123 gastown          │ │
│   │         │                                                  │ │
│   │         ▼                                                  │ │
│   │  Polecat spawns        (work lands on hook)                │ │
│   │         │                                                  │ │
│   │         ▼                                                  │ │
│   │  Polecat executes      (GUPP: work on hook = run it)       │ │
│   │         │                                                  │ │
│   │         ▼                                                  │ │
│   │  gt done              (submit to MQ, nuke self, exit)      │ │
│   │         │                                                  │ │
│   │         ▼                                                  │ │
│   │  Refinery merges       (rebase, test, push to main)        │ │
│   │         │                                                  │ │
│   │         ▼                                                  │ │
│   │  Convoy auto-closes    (all tracked issues done)           │ │
│   │                                                            │ │
│   └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│   HOOKS                                                          │
│   ┌────────────────────────────────────────────────────────────┐ │
│   │  gt hook               Check your assigned work            │ │
│   │  gt mol status         Check molecule progress             │ │
│   │                                                            │ │
│   │  Hook = pinned molecule + issue                            │ │
│   │  Hook having work IS the assignment (no confirmation)      │ │
│   └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│   CONVOYS                                                        │
│   ┌────────────────────────────────────────────────────────────┐ │
│   │  gt convoy create "name" issue-1 issue-2 ...               │ │
│   │  gt convoy list                                            │ │
│   │  gt convoy show <id>                                       │ │
│   │                                                            │ │
│   │  Convoys track multiple issues across rigs                 │ │
│   │  Auto-close when all tracked issues complete               │ │
│   │  Support cross-prefix tracking (hq-* can track gt-*)       │ │
│   └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│   GATES (async coordination)                                     │
│   ┌────────────────────────────────────────────────────────────┐ │
│   │  Timer gate    — Wait N seconds                            │ │
│   │  GitHub gate   — Wait for PR/CI                            │ │
│   │  Human gate    — Wait for human input                      │ │
│   │  Mail gate     — Wait for specific message                 │ │
│   │                                                            │ │
│   │  Deacon evaluates gates during patrol                      │ │
│   │  Closed gate → resume blocked molecule                     │ │
│   └────────────────────────────────────────────────────────────┘ │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

______________________________________________________________________

## 5. The Git Integration — Code Flow

```
┌──────────────────────────────────────────────────────────────────┐
│                    GIT ARCHITECTURE                              │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│   RIG STRUCTURE                                                  │
│   ┌────────────────────────────────────────────────────────────┐ │
│   │  gastown/                                                  │ │
│   │  ├── .repo.git/          Bare repository                   │ │
│   │  ├── polecats/           Worker worktrees (gitignored)     │ │
│   │  │   ├── nux/            Polecat "nux" worktree            │ │
│   │  │   └── toast/          Polecat "toast" worktree          │ │
│   │  ├── refinery/           Merge queue processor             │ │
│   │  ├── witness/            Monitoring agent                  │ │
│   │  └── crew/               Human workspaces                  │ │
│   │      └── emil/           Crew member workspace             │ │
│   └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│   MERGE QUEUE (MQ)                                               │
│   ┌────────────────────────────────────────────────────────────┐ │
│   │                                                            │ │
│   │  Polecat pushes branch → MR bead created → Queue           │ │
│   │                              │                             │ │
│   │                              ▼                             │ │
│   │                         Refinery picks up                  │ │
│   │                              │                             │ │
│   │                    ┌────────┴────────┐                     │ │
│   │                    ▼                 ▼                     │ │
│   │              Rebase OK          Conflicts                  │ │
│   │                    │                 │                     │ │
│   │                    ▼                 ▼                     │ │
│   │              Run tests         Create conflict             │ │
│   │                    │           resolution task             │ │
│   │                    ▼           (NEW polecat)               │ │
│   │              Merge to main                                 │ │
│   │                    │                                       │ │
│   │                    ▼                                       │ │
│   │              Delete branch                                 │ │
│   │              Close MR bead                                 │ │
│   │              Send MERGED                                   │ │
│   │                                                            │ │
│   └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│   BEADS SYNC                                                     │
│   ┌────────────────────────────────────────────────────────────┐ │
│   │  bd sync                                                   │ │
│   │                                                            │ │
│   │  .beads/issues.jsonl → beads-sync branch → remote          │ │
│   │                                                            │ │
│   │  JSONL format = append-only = minimal conflicts            │ │
│   │  Custom merge driver handles concurrent edits              │ │
│   └────────────────────────────────────────────────────────────┘ │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

**Key insight**: Polecat lifecycle ≠ MR lifecycle. Polecats are gone after `gt done`. If conflicts arise, the Refinery spawns a _new_ polecat to resolve them. No zombie workers.

______________________________________________________________________

## 6. The Supervision Hierarchy — Who Watches Whom

```
┌──────────────────────────────────────────────────────────────────┐
│                    SUPERVISION TREE                              │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│                          ┌─────────┐                             │
│                          │  Human  │                             │
│                          └────┬────┘                             │
│                               │ (escalation destination)         │
│                               ▼                                  │
│                          ┌─────────┐                             │
│                          │  Mayor  │  Town coordinator           │
│                          └────┬────┘                             │
│                               │                                  │
│              ┌────────────────┼────────────────┐                 │
│              ▼                ▼                ▼                 │
│         ┌─────────┐      ┌─────────┐      ┌─────────┐            │
│         │ Deacon  │      │  Rig 1  │      │  Rig 2  │            │
│         │ (Daemon)│      │         │      │         │            │
│         └────┬────┘      └────┬────┘      └────┬────┘            │
│              │                │                │                 │
│              │         ┌──────┼──────┐   ┌─────┼─────┐           │
│              │         ▼      ▼      ▼   ▼     ▼     ▼           │
│              │     Witness Refinery Polecats  ...    ...         │
│              │         │                                         │
│              │         │ WITNESS_PING                            │
│              │◄────────┘ (proves Witness is alive)               │
│              │                                                   │
│         ┌────┴────┐                                              │
│         │  Dogs   │  Background workers (pool of 5)              │
│         └────┬────┘                                              │
│              │                                                   │
│         ┌────┴────┐                                              │
│         │  Boot   │  Checks Deacon every 5 min                   │
│         └─────────┘  (the watchdog's watchdog)                   │
│                                                                  │
│   MONITORING FLOWS:                                              │
│   ┌────────────────────────────────────────────────────────────┐ │
│   │  Deacon → patrols all rigs, processes callbacks            │ │
│   │  Witness → watches Polecats in its rig                     │ │
│   │  Witness → pings Deacon (second-order monitoring)          │ │
│   │  Boot → checks if Deacon is alive (daemon-level)           │ │
│   │  Dogs → execute cleanup/recovery tasks for Deacon          │ │
│   └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│   FAILURE DETECTION:                                             │
│   ┌────────────────────────────────────────────────────────────┐ │
│   │  Agent bead last_activity stale?  → File death warrant     │ │
│   │  Session not in tmux?             → Mark orphaned          │ │
│   │  No response to health check?     → Escalate timeout       │ │
│   │  Deacon silent for >5 min?        → Witness alerts Mayor   │ │
│   │  Boot can't find Deacon?          → Daemon restarts it     │ │
│   └────────────────────────────────────────────────────────────┘ │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

**Key insight**: "Who watches the watchers?" is solved through layered monitoring. Witnesses ping Deacon. Boot checks Deacon. Deacon can restart Mayor. The system is designed to self-heal.

______________________________________________________________________

## Summary: The Gas Town Philosophy

| Principle                   | Meaning                                         |
| --------------------------- | ----------------------------------------------- |
| **GUPP**                    | Work on hook = run it. No waiting.              |
| **MEOW**                    | Break work into atomic molecules                |
| **ZFC**                     | Trust agent beads, not PIDs                     |
| **Self-cleaning**           | Done = gone. No zombie workers.                 |
| **Discovery over tracking** | Observe reality each patrol cycle               |
| **Events over state**       | Mail triggers action, not polling               |
| **Preserve and re-land**    | Conflicts → new task, not discard               |
| **Exponential backoff**     | Idle → sleep longer. Activity → wake instantly. |
