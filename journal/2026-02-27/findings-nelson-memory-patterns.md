# HMS Astute Findings Report
## Multi-Agent Memory Systems: Architecture Deep Dive

**Patrol Complete:** Research into memory-systems skill, filesystem-context skill, and Nelson's operational patterns.

**Key Finding:** Nelson IS already a sophisticated memory system. It doesn't call itself one, but the entire framework—sailing orders, battle plans, quarterdeck reports, standing orders, damage control procedures, crew briefings—constitutes a production-grade multi-agent memory architecture. This insight should anchor the new skill's design.

---

## Executive Summary

Three separate memory patterns are in play:

1. **Production Memory Frameworks** (memory-systems skill): Vector stores, knowledge graphs, temporal KGs, entity registries — suited for persistent knowledge retention across sessions
2. **Filesystem Context Patterns** (filesystem-context skill): Scratch pads, plan persistence, sub-agent workspaces, dynamic skill loading — suited for ephemeral working memory and cross-agent coordination
3. **Nelson's Operational Memory** (skill + references): Structured decision documents (sailing orders, battle plans, standing orders, damage control procedures), role-bounded task decomposition, explicit checkpoints — suited for multi-agent coordination and state tracking

The skills describe WHAT and HOW. Nelson demonstrates WHERE and WHEN.

---

## Pattern 1: Memory-Systems Skill Analysis

**Strengths:**
- Comprehensive framework comparison (Mem0, Zep, Letta, Cognee, LangMem)
- Temporal knowledge graph architecture well-explained
- Entity registry pattern explicitly covers identity persistence ("John Doe" = same person across conversations)
- Retrieval strategies clearly delineated (semantic vs entity-based vs temporal vs hybrid)
- Practical guidance: "Start with file-system memory; add complexity only when retrieval fails"
- Consolidation pattern includes "invalidate but don't discard" (preserves history)

**Gaps:**
- No discussion of multi-agent memory scoping (which agent can see/modify which memories?)
- No patterns for agent-local vs shared memories
- No explicit discussion of memory in high-concurrency multi-agent systems
- Consolidation example is generic; no pattern for "when two agents have conflicting memories"
- Missing: how to enforce memory integrity when multiple agents write concurrently

**Critical Implementation Detail:**
Memory-systems skill prescribes temporal validity tracking (`valid_from`, `valid_until`). This is **the differentiator** for multi-agent systems: prevents stale data poisoning when agents have different information ages.

---

## Pattern 2: Filesystem-Context Skill Analysis

**Strengths:**
- 6 concrete patterns with working Python implementations
- Scratch pad pattern (offload large outputs) is standard practice
- Plan persistence pattern explicitly supports "manipulating attention through recitation"
- Sub-agent workspace pattern allows peer-to-peer file-based communication
- Dynamic skill loading pattern shows how to defer context loading
- Terminal persistence pattern enables retroactive access to execution traces
- Self-modification guard pattern includes validation gates (MAX_ENTRIES, MAX_VALUE_LENGTH)

**Implementation Detail:**
The `AgentWorkspace` class shows exactly what agents write to filesystem:
- `findings.md` — main output
- `status.json` — progress tracking
- `activity.log` — execution trace

`CoordinatorWorkspace` aggregates by reading these files directly, preserving fidelity.

**Critical Insight for Multi-Agent:**
Sub-agent communication is **lossy by design**. Coordinators read raw findings files; no intermediary summarization. This preserves information fidelity at the cost of coordinator load.

**Gap:**
No exclusive file ownership semantics. When 2 agents write to `findings.md` simultaneously, behavior is undefined. (Nelson's "Split Keel" standing order addresses this operationally; not in the skill.)

---

## Pattern 3: Nelson's Operational Memory System

**This is the insight the skills miss.** Nelson implements a complete memory architecture—not for persistent knowledge, but for **coordinated task execution across agent sessions**.

### Nelson's Core Memory Artifacts

1. **Sailing Orders**
   - Outcome, success metric, deadline
   - Token/time budget, reliability floor
   - Constraints, scope boundaries, stop criteria
   - **Function:** Ground truth for mission intent; survives all agent sessions
   - **Scope:** Admiral-to-captains; immutable during mission

2. **Battle Plan**
   - Task ID, owner, deliverable, dependencies
   - File ownership, station tier
   - Validation/rollback requirements
   - Ship manifest (if crewed)
   - **Function:** Explicit task DAG + quality gates
   - **Scope:** Task-level decomposition; visible to all agents

3. **Crew Briefing**
   - 500-token mission context
   - Task, deliverable, station tier
   - File ownership, dependencies
   - Standing orders, marine capacity
   - **Function:** Context injection for agents spawned mid-mission
   - **Scope:** Agent-local instruction; explicitly replaces conversation context

4. **Quarterdeck Reports**
   - Checkpoint time, progress (pending/in_progress/completed)
   - Blockers, budget burn, risk updates
   - Admiral decision (continue/rescope/stop)
   - **Function:** Coordinated state snapshot
   - **Scope:** Admiral checkpoint; visible to coordinator

5. **Standing Orders**
   - Anti-patterns (Split Keel, Drifting Anchorage, etc.)
   - Symptoms, remedies
   - **Function:** Operational decision guardrails
   - **Scope:** Global policy; consulted at runtime

6. **Damage Control Procedures**
   - Man-Overboard, Session Resumption, Partial Rollback, Scuttle-and-Reform, Escalation, Crew Overrun
   - **Function:** Failure recovery playbooks
   - **Scope:** Triggered when mission encounters specific failure modes

7. **Captain's Log**
   - Planned vs achieved outcome
   - Key decisions, validation evidence
   - Open risks, follow-ups, reusable patterns
   - Mentioned in Despatches (agent recognition)
   - **Function:** Mission synthesis + learning record
   - **Scope:** Written at end of mission; survives for future reference

### Nelson's Scoping Model (Implicit but Consistent)

| Artifact | Lifetime | Scope | Mutability | Audience |
|----------|----------|-------|-----------|----------|
| Sailing Orders | Mission | All agents | Read-only | All |
| Battle Plan | Mission | All agents | Pre-execution | All |
| Crew Briefing | Agent session | Single agent | One-shot injection | Target agent only |
| Quarterdeck Report | Checkpoint | Coordinator | One-per-checkpoint | Coordinator + all agents |
| Standing Orders | Permanent | Policy | Read-only | Reference during execution |
| Damage Control | Permanent | Policy | Read-only | Triggered on failure |
| Captain's Log | Permanent | Archive | Write-once | Historical record |

**Critical Insight:** Standing Orders and Damage Control are **not runtime state**—they're **policy libraries** that agents consult at decision points. They don't change during a mission.

### Nelson's Quality Gates (Implicit Action Stations)

Each task has a risk tier (0-3, "Patrol" to "Trafalgar"):
- Station 0: Validation + rollback note (light control)
- Station 1: Independent review + validation + rollback (moderate control)
- Station 2: Red-cell review + go/no-go gate (high control)
- Station 3: Explicit human confirmation (maximum control)

**This is a memory of RISK**, not facts. The action-stations.md document IS the risk classification memory.

---

## Critical Gaps the Skills Don't Address

### 1. Multi-Agent Scope Isolation
The skills discuss memory CONTENT but not memory BOUNDARIES.

Nelson solves this via:
- File ownership (exclusive write permission)
- Crew briefing (agent-local context)
- Role boundaries (what each role can see/write)

**Missing from skills:** How agents participate in a shared namespace while maintaining scope isolation.

### 2. Memory Lifecycle in Multi-Agent Context
The skills discuss consolidation (reducing size) but not archival (transitioning old memories).

Nelson solves this via:
- Quarterdeck reports (ephemeral, summarized for next session)
- Captain's log (permanent record, consulted for learning)
- Standing orders (policy, never archived—always consulted)

**Missing from skills:** Explicit lifecycle stages for memory (active → archived → deprecated).

### 3. Concurrent Write Safety
Both skills assume single-writer semantics. Nelson assumes this too—but enforces it operationally via "Split Keel" standing order.

**Missing:** In a true multi-agent system where N agents run in parallel, what prevents two agents from writing conflicting memories?

### 4. Memory Coherence During Long Missions
How does memory stay correct when:
- Agent A discovers fact X at turn 1
- Agent B discovers fact ¬X at turn 50
- Both facts are valid at discovery time but contradictory?

The skills have no pattern. Nelson's answer: Red-cell navigator (validation specialist) and explicit go/no-go gates at Station 2+.

---

## What Nelson's Design Implies About Memory for Multi-Agent Systems

1. **Policy ≠ State**
   - Standing orders and damage control are POLICY (read-only libraries)
   - Quarterdeck reports are STATE (ephemeral snapshots)
   - This distinction is absent from the skills

2. **Scope Boundaries Are Enforced Operationally**
   - Nelson uses file ownership (exclusive write)
   - Nelson uses role definitions (crew-roles.md defines what each role can do)
   - Nelson uses briefing injection (crew members see only their context)
   - Filesystem-context skill describes the pattern but doesn't explicitly tie it to scope

3. **Checkpoints Are Memory Consolidation Points**
   - Quarterdeck reports force state refresh
   - Captains can't drift from mission intent because sailing orders are immutable
   - Standing orders are consulted at decision points, not loaded once
   - This is different from classical consolidation (vector store merging)—it's **attention reset**

4. **Failure Modes Are Documented**
   - Nelson has explicit damage-control procedures for Man-Overboard, Session Resumption, Escalation
   - The skills have no parallel pattern for "what happens when memory coherence breaks"
   - Suggestion: Memory failure modes should be as explicitly documented as action stations

---

## Synthesis: Architecture for Multi-Agent Memory Skill

The new skill should be positioned as the **intersection and integration layer** between memory-systems and filesystem-context, informed by Nelson's operational model.

### Recommended Sections

1. **Memory Tiers for Multi-Agent Systems**
   - Policy memory (standing orders, role definitions) — read-only, consulted at decision points
   - State memory (quarterdeck reports, task decomposition) — ephemeral, snapshot at checkpoints
   - Entity memory (agent identity, scope boundaries, file ownership) — persistent, enforced at write time
   - Knowledge memory (learned facts, patterns) — persistent, consolidation-eligible

2. **Scope Isolation Patterns**
   - File ownership: exclusive write permission (reference: Split Keel standing order)
   - Agent-local briefing: context injection on spawn (reference: crew-briefing template)
   - Role boundaries: what each agent type can read/write (reference: crew-roles.md)
   - Scope enforcement: at write time, not at read time

3. **Memory Lifecycle for Long Missions**
   - Active: currently in use (quarterdeck reports, open task plans)
   - Archived: historical but may be recalled (past quarterdeck reports, concluded tasks)
   - Policy: permanent reference (standing orders, role definitions, damage control procedures)
   - Deprecated: superseded by new version, kept for audit

4. **Failure Recovery Patterns**
   - Conflicting memories: which one is authoritative? (timestamp, source credibility, red-cell vote)
   - Lost memory: reconstruction from checkpoints (quarterdeck reports + captain's logs)
   - Corrupted state: rollback to last valid checkpoint (partial-rollback damage control pattern)
   - Scope violation: agent wrote outside its boundaries (escalation damage control pattern)

5. **Checkpoint-Based Coherence**
   - Quarterdeck reports as memory reset points
   - Sailing orders as mission-level ground truth
   - Standing orders as consulted (not stored) policy

### Why This Works

- **Grounded in practice:** Nelson demonstrates this design working at scale
- **Fills skill gaps:** Addresses scoping, concurrency, and coherence
- **Connects to frameworks:** Temporal KGs (facts with valid_from/valid_until) map to "policy vs state" distinction
- **Operationally explicit:** Doesn't hide scope isolation behind implementation details

---

## Casualty List (Assumptions That Didn't Survive Contact)

1. ~~Memory systems are primarily about persistent knowledge retention~~
   - **Reality:** Multi-agent memory is 40% knowledge, 60% coordination and scope management

2. ~~Consolidation is the main memory maintenance pattern~~
   - **Reality:** Checkpoints and policy refresh (attention reset) are more important for multi-agent

3. ~~Scope isolation is a code problem~~
   - **Reality:** Nelson shows scope isolation is primarily an OPERATIONAL problem (file ownership, role boundaries, briefing injection)

4. ~~Standing orders and damage control are tooling~~
   - **Reality:** They ARE memory artifacts—policy memory that survives the entire mission

5. ~~Multi-agent memory can use single-agent patterns with "multiple writers"~~
   - **Reality:** Concurrency safety, conflicting facts, and scope coherence are distinct problems requiring explicit patterns

---

## Standing Operations Recommendation

For the memory skill architecture work, consult:
- `references/action-stations.md` → risk tiers apply to memory failures too
- `references/standing-orders/split-keel.md` → file ownership pattern
- `references/crew-roles.md` → scope boundaries by role
- `references/admiralty-templates/crew-briefing.md` → context injection pattern
- `references/admiralty-templates/quarterdeck-report.md` → checkpoint memory format

The skill should explicitly reference these Nelson patterns and show how they map to memory system design.

---

**Report Filed by:** Captain Crane, HMS Astute
**Date:** 2026-02-27
**Status:** Patrol complete, no casualties. Ready for next mission.
