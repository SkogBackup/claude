# Source Material Provenance Audit

*HMS Astute — Nelson Squadron, 2026-02-27*

## Executive Summary

The skill collection draws from 8 source documents in `docs/`. Synthesis is generally faithful on claims it chooses to include, but systematically leaves valuable material on the table. Most common drift pattern: **generalization without attribution** — specific production findings restated as general principles, losing evidentiary weight and boundary conditions.

---

## Source Utilization Summary

| Source | Faithfulness | Material Used | Key Omissions |
|--------|-------------|---------------|---------------|
| Vercel d0 blog | Excellent | ~90% | "Doing model's thinking for it" framing |
| Factory compression paper | Good | ~80% | Method names stripped, incremental merge mechanism |
| Netflix talk | Partial | ~30% | Simple vs easy, essential/accidental complexity, pattern preservation bias |
| Manus/Peak Ji blog | Good | ~60% | Logit masking, don't-get-few-shotted, 10x cost specifics |
| Anthropic context engineering blog | Good | ~65% | Pokemon memory example, compaction tuning methodology |
| Anthropic long-running harness blog | **Not used** | ~0% | Initializer pattern, progress files, incremental development |
| Karpathy HN capsule | Excellent | ~90% | Meta-observations (not relevant) |
| Research compilations | Selective | ~40% | Dynamic few-shot, ReAct brittleness, ConsensAgent, LATS |

---

## The 4 Biggest Gaps

### 1. Long-Running Agent Harness (0% used)
The Anthropic "Effective Harnesses for Long-Running Agents" blog describes initializer agent + coding agent pattern, `claude-progress.txt` for inter-session state, feature lists as JSON (not markdown), premature-victory detection, and agents leaving environments in broken states. **None appears in any skill** despite `hosted-agents` and `project-development` existing.

### 2. Netflix Talk's Core Argument (~70% unused)
The three-phase workflow got extracted as a "compression technique." But the talk's actual argument — Fred Brooks' "No Silver Bullet," Rich Hickey's "simple vs. easy," and "AI doesn't have that option — it treats every pattern as a requirement" — was the diagnostic framework, not the technique. Pattern preservation bias (LLMs treating technical debt as requirements) is absent.

### 3. Manus Production Techniques (~40% unused)
- **Logit masking for tool selection**: constrain tool choices without invalidating KV-cache. Production-unique.
- **"Don't get few-shotted"**: structured variation to prevent agents from repeating patterns in their own context. Novel failure mode.
- **10x cost differential** ($0.30 vs $3.00/MTok cached vs uncached): the economic argument that makes KV-cache "the single most important metric."

### 4. Research Compilation Findings (~60% unused)
- Dynamic few-shot selection: 16% -> 52% accuracy (Claude 3 Sonnet)
- ReAct brittleness: 40-90% invalid actions depending on model
- ConsensAgent weighted voting, Free-MAD anti-conformity
- LATS (Monte-Carlo Tree Search + LLM reasoning)
- Instruction Hierarchy for prompt injection defense

---

## Drift Patterns

### Generalization Without Attribution

| Source claim | Skill version | What's lost |
|---|---|---|
| Manus: "$0.30 vs $3.00/MTok, 10x" | "KV-cache optimization reduces cost and latency" | The economic argument |
| Factory Research: scores 3.70/3.44/3.35 | "Anchored iterative/regenerative/opaque" | Which production systems |
| Netflix: "AI treats every pattern as a requirement" | Not included | Diagnostic insight |
| Vercel: "We were doing the model's thinking for it" | "Tools were constraining reasoning" | Self-diagnostic framing |

### Missing Failure Modes from Production Sources

1. **"Don't get few-shotted"** (Manus) — agents repeating patterns from own context
2. **Pattern preservation bias** (Netflix) — LLMs treating technical debt as requirements
3. **Premature victory declaration** (Anthropic harness) — agents declaring done too early
4. **Environment left in broken state** (Anthropic harness) — undocumented bugs between sessions

---

## What's Faithfully Synthesized

- All Vercel metrics match exactly (274.8s -> 77.4s, 80% -> 100%, ~102k -> ~61k tokens)
- All Factory Research scores match (3.70, 3.44, 3.35; compression ratios 98.6%, 98.7%, 99.3%)
- Karpathy pipeline faithfully reproduced ($58, ~1 hour, 930 queries)
- RULER benchmark finding preserved (50% of 32K+ models fail at 32K)
- Observation percentage (83.9%) faithfully cited

Where skills include specific numbers, they are accurate. The collection does not fabricate or distort quantitative claims — it omits them.
