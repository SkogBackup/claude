# Context Engineering Reference Card

Dense working reference distilled from critical analysis of all 13 skills in Agent-Skills-for-Context-Engineering. Two views preserved: the collection's claims and SkogAI corrections.

---

## Skill Tiers (Build Priority)

| Tier | Skill | Use When |
|------|-------|----------|
| A | project-development | Designing pipelines, choosing architecture, task-model fit decisions |
| A | filesystem-context | Any agent that reads/writes files, context loading strategy |
| B+ | advanced-evaluation | Building eval harnesses, LLM-as-judge, bias mitigation |
| B | context-compression | Handover between phases, structured summaries |
| B | evaluation | Setting up metrics, understanding what drives performance |
| B | context-fundamentals | Onboarding someone else; you already know this |
| B | context-optimization | KV-cache tuning, observation masking, compaction |
| B | multi-agent-patterns | Choosing supervisor vs peer-to-peer vs hierarchical |
| B | tool-design | Reducing tool surface area, error handling |
| B- | context-degradation | Diagnosing why output quality dropped |
| B- | memory-systems | Deciding between file-based vs framework memory |
| B- | hosted-agents | Infrastructure planning for sandboxed agents |
| C | bdi-mental-states | Only if building formal ontology / RDF pipelines |

---

## The 10 Patterns That Earn Their Tokens

**1. Dynamic Context Discovery** -- Load only what you need, when you need it. Frontmatter index at startup, full content on activation. Unifying principle across the strongest skills. Collection and SkogAI align here.

**2. Pipeline Architecture** (acquire -> prepare -> process -> parse -> render) -- Isolate the non-deterministic expensive step (LLM call) from deterministic steps. File existence gates execution: `raw.json -> prompt.md -> response.md -> parsed.json`. Source: project-development skill.

**3. Architectural Reduction** -- Vercel d0: 17 tools -> 2 (bash + SQL). Success 80% -> 100%. Time 274s -> 77s. Collection says this is the direction. SkogAI says this is a waypoint; destination is zero explicit tools, plain text intents. "When to use it" is 70% of tool design.

**4. L1/L2 Cache Mental Model** -- Context window = hot cache. Filesystem = backing store. Load into context, do work, write back, evict. Source: filesystem-context skill.

**5. Structured Summary Templates** -- Force preservation with explicit sections: Session Intent, Files Modified, Decisions Made, Current State, Next Steps. Checklist structure prevents drift. Solves artifact trail integrity (universally weak at 2.2-2.5/5.0). Source: context-compression skill.

**6. Three-Phase Workflow** (Research -> Planning -> Implementation) -- 5M token codebase compressing to ~2,000 words of spec. More accurately: context partitioning, not compression. Clean interfaces between phases. Source: context-compression skill.

**7. Self-Spawning for Context Hygiene** -- Sub-agents primarily valuable for fresh context windows, not just parallelism. Collection covers under parallelism. SkogAI: context isolation is the real win; partitioning is the default, not the nuclear option.

**8. Predictive Warm-Up** -- Start sandbox while user types. Allow file reads before git sync completes, block only writes. Source: hosted-agents skill.

**9. Position Bias Mitigation** -- Evaluate twice with swapped positions. Consistency check. Reduce confidence on disagreement. Most implementation-ready eval technique. Source: advanced-evaluation skill.

**10. CoT Before Score** -- Chain-of-thought before scoring improves eval reliability 15-25%. Well-defined rubrics reduce variance 40-60%. Source: advanced-evaluation skill.

---

## Where Collection and Philosophy Diverge

These are the productive tensions. Both views preserved because each is correct in its context.

### Effective Context Limit

- **Collection**: 70% of context window as warning threshold (140k at 200k window)
- **SkogAI**: 25k effective limit for real implementation work
- **Resolution**: Both right for different tasks. Exploration/search can use large windows. Execution hits the wall at ~25k.

### Lost-in-Middle

- **Collection**: U-curve from BOS attention sink; put important content at edges
- **SkogAI**: Proximity > position; +/-8k from focus is the real attention range
- **Resolution**: Edge placement is a weak heuristic. Keeping related context together within 8k of focus is stronger.

### Telephone Game Between Agents

- **Collection**: Information loss between agents is a risk to mitigate (anti-pattern)
- **SkogAI**: Intentional lossy compression maintains 20,000m strategic altitude (feature)
- **Resolution**: Depends on what you are compressing. Strategic intent should survive lossy handoff. Implementation details should not be in the handoff at all.

### Multi-Agent Motivation

- **Collection**: Primary reason is context isolation, not role anthropomorphization
- **SkogAI**: Roles carry genuine semantic structure; load-bearing, not cosplay
- **Resolution**: Not mutually exclusive. Context isolation is the mechanism. Semantic roles are the architecture that makes the isolation boundaries meaningful.

### "When NOT to Use" Sections

- **Collection**: Skills include explicit exclusion criteria
- **SkogAI**: Doubles token cost for zero information gain; activation trigger IS the boundary
- **Resolution**: SkogAI is correct for context-loaded skills. Exclusions encode the complement of the activation set, which is infinite.

### 95% Finding (BrowseComp)

- **Collection**: Token usage explains 80% of performance variance (more tokens = better)
- **SkogAI**: That measures exploration breadth; for execution, decision quality matters more (smarter tokens > more tokens)
- **Resolution**: 80% figure applies to search/research tasks. For execution, each good reasoning branch point halves the problem space -- exponential vs linear payoff.

---

## Quick Decision Trees

### Memory Strategy
```
Do you genuinely outgrow files?
  No  -> markdown files + git temporal layer
  Yes -> Do you need graph queries across entities?
    No  -> structured JSON/YAML files
    Yes -> Graphiti or similar (but verify you actually need it)
```

### Eval Method
```
Objective ground truth exists?
  Yes -> Direct scoring with rubric
  No  -> Preference/quality judgment?
    Yes -> Pairwise comparison (swap positions, check consistency)
    No  -> Reference-based evaluation
```

### When to Partition into Sub-Agents
```
Context approaching 25k? -> Partition
Need parallel exploration? -> Partition
Different phases of work? -> Partition (fresh context per phase)
Single focused task under 25k? -> Stay in one context
```

### Tool Count Decision
```
Can the agent accomplish this with bash + file access?
  Yes -> Don't add a tool
  No  -> Is the tool's "when to use" trigger unambiguous?
    Yes -> Add it, but write the trigger before the implementation
    No  -> Redesign until the trigger is obvious
```

---

## The Pruning Test

```
full_context_output - starved_context_output = delta
```

Only the delta is IP. Everything the LLM produces identically with or without your context is inference from its training data. Your context should contain ONLY what changes the output.

---

## Collection Gaps Identified

1. **No skill on context partitioning as a first-class concept.** Partitioning appears in filesystem-context, project-development, and multi-agent-patterns but never gets its own treatment. Arguably the most important pattern.

2. **Redundancy between skills.** Context-compression's structured summaries overlap filesystem-context's plan persistence. Evaluation rubrics overlap advanced-evaluation rubrics. Merging would tighten the collection.

3. **Formal vs practical tension.** Practical skills (filesystem, pipelines) have production evidence. Formal skills (BDI, evaluation metrics) have academic citations. Different audiences, same collection.

4. **Observation masking underspecified.** "Always keep a unique callable reference in place when masking" -- the collection covers masking but not the critical detail of maintaining the retrieval handle.

5. **Context as budget, not just window.** No treatment of context as a budget to be allocated. The budget framing (every token spent here is a token not spent there) is more actionable than the capacity framing.

---

## Key Numbers

| Metric | Value | Source |
|--------|-------|--------|
| Effective context limit (execution) | ~25k tokens | SkogAI practical experience |
| Attention proximity range | +/-8k tokens from focus | SkogAI practical experience |
| Token usage -> performance variance | 80% | BrowseComp (exploration tasks) |
| Tool calls -> performance variance | ~10% | BrowseComp |
| Model choice -> performance variance | ~5% | BrowseComp |
| CoT-before-score reliability gain | 15-25% | Advanced-evaluation skill |
| Well-defined rubric variance reduction | 40-60% | Advanced-evaluation skill |
| Artifact trail integrity (all methods) | 2.2-2.5 / 5.0 | Context-compression skill |
| Vercel tool reduction | 17 -> 2 | Project-development skill |
| Vercel success rate after reduction | 80% -> 100% | Project-development skill |
| Vercel execution time after reduction | 274s -> 77s | Project-development skill |

---

*Distilled 2026-02-27 from two deep-dive sessions covering all 13 skills. HMS Kent, Nelson Squadron.*
