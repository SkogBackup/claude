---
title: SKOGTOWN
type: note
permalink: claude/lab/projects-in-development/skogtown/skogtown
---

## SkogAI; Persona-Driven-Workflows

### **Mayor** 🎩

The **coordinator/orchestrator**. Lives at town level.

- Creates convoys (work bundles)
- Assigns work via `gt sling`
- Receives escalations from other agents
- Has visibility across all rigs
- Handles decision-making that requires judgment

### **Deacon** ⛪

The **daemon watchdog**. Runs continuous patrol loops.

- Handles callbacks from all agents (inbox processing)
- Triggers pending polecat spawns (waits for Claude prompt to appear)
- Evaluates async gates (timers, external deps)
- Checks convoy completion
- Dispatches to Dogs for heavy work (orphan scans, session GC)
- Aggregates daily costs
- Monitors its own context, burns/respawns when full
- **Key insight**: Sleeps longer when idle, wakes immediately on activity (exponential backoff)

### **Witness** 👁️

The **pit boss per rig**. Watches workers.

- Surveys all polecats via agent beads (ZFC: trust what they report)
- Processes cleanup wisps (dirty polecats that couldn't auto-nuke)
- Ensures Refinery is alive
- Pings Deacon to prove _it's_ alive (second-order monitoring)
- Nudges stuck workers, escalates to Mayor if needed
- **Key insight**: Oversight only — never does implementation work

### **Refinery** ⚙️

The **merge queue processor**. Lives per rig.

- Receives `MERGE_READY` mail from Witnesses
- Rebases polecat branches on main
- Runs tests (The Scotty Test: don't walk past broken code)
- Merges to main if clean
- Sends `MERGED` notification back to Witness
- Creates conflict-resolution tasks for NEW polecats if rebase fails
- **Key insight**: Sequential merging, one at a time. Polecat lifecycle is separate from MR lifecycle.

### **Polecat** 🦨

The **ephemeral worker**. Does actual implementation.

- Receives work on its hook (pinned molecule + issue)
- Works through molecule steps
- Self-reviews, runs tests
- Submits via `gt done` → push + MQ submit + nuke self + exit
- **Key insight**: Self-cleaning. Done means GONE. No idle state.

### **Dogs** 🐕

The **maintenance crew** under Deacon.

- Handle heavy background tasks: orphan scans, session GC, cleanup
- Deacon dispatches formulas to dogs, doesn't do the work inline
- **Boot** is special: checks if Deacon itself is stuck every 5 minutes

### **Boot** 🥾

The **Deacon's watchdog**.

- Spawned fresh on each daemon tick
- Observes system state (tmux, beads, mail)
- Decides: START / WAKE / NUDGE / INTERRUPT / NOTHING
- Cleans stale handoffs
- Exits immediately — always fresh, no persistent state

______________________________________________________________________

## The Choreography

```
Human tells Mayor → Mayor creates Convoy → Slings to Rig
                                              ↓
                                         Polecat spawns
                                              ↓
                                         Polecat works (molecule steps)
                                              ↓
                                         gt done → submits to MQ, nukes self
                                              ↓
                    Witness sees POLECAT_DONE → nukes worktree
                                              ↓
                    Refinery sees MERGE_READY → rebases, tests, merges
                                              ↓
                    Refinery sends MERGED → Witness confirms
                                              ↓
                    Issue closed, work on main

Meanwhile:
- Deacon patrols continuously, handling callbacks
- Boot checks Deacon every 5 min
- Witness pings Deacon to prove itself alive
- Dogs handle heavy cleanup tasks
```

______________________________________________________________________

## Worth paying attention to

1. **ZFC (trust agent beads)** — Don't infer state from PIDs/tmux. Trust what agents report about themselves.

1. **Self-cleaning polecats** — No zombie workers. Done = gone.

1. **Separate lifecycles** — Polecat lifecycle ≠ MR lifecycle. Conflicts spawn NEW polecats.

1. **Second-order monitoring** — Witnesses watch Deacon. Boot watches Deacon. Who watches the watchers? Solved.

1. **Exponential backoff on idle** — Deacon sleeps longer when nothing's happening (up to 10 min), wakes instantly on activity.

1. **Formulas as durable state** — Molecules survive crashes. Resume from last completed step.

1. **Claude hooks** — `SessionStart` injects mail, `UserPromptSubmit` injects mail, `Stop` records costs. The agents are wired in.
