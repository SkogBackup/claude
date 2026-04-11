# Context Engineering Deep Dive — Part 2

Walked through the remaining 7 skills: context-compression, filesystem-context, hosted-agents, evaluation, advanced-evaluation, project-development, bdi-mental-states. Each skill read with full references, then critically annotated.

## Skill-by-Skill Analysis

### Context Compression
Correct core insight: optimize for tokens-per-task, not tokens-per-request. Compression that causes re-fetching is negative-value compression. Artifact trail integrity is universally weak (2.2-2.5/5.0) across all methods — the skill honestly identifies this as needing specialized handling beyond general summarization.

The three-phase workflow (Research → Planning → Implementation) is the real payload. A 5M token codebase compressing to ~2,000 words of spec is more accurately described as context partitioning than compression — you're creating clean interfaces between phases, not shrinking a blob.

Structured summary templates with explicit sections (Session Intent, Files Modified, Decisions Made, Current State, Next Steps) force preservation by acting as checklists the summarizer must populate.

### Filesystem Context
Strongest alignment with practical context engineering. Core pattern: agents pull relevant context on demand rather than carrying everything in the context window. Six patterns covered: scratch pad (offload large outputs to files), plan persistence (write plans for re-reading), sub-agent file communication (bypass message passing), dynamic skill loading (frontmatter index + on-demand full load), terminal persistence, self-modification.

Key design point: static context is always included regardless of relevance; dynamic context loads on-demand. Dynamic discovery is more token-efficient but requires the model to correctly identify when it needs more information — works well with frontier models.

The L1/L2 cache mental model applies: context window is hot cache, filesystem is backing store. Load from filesystem into context, do work, write results back, evict from context.

### Hosted Agents
Infrastructure skill rather than context engineering skill. Covers sandboxed VMs, image registry pattern (pre-build every 30 minutes), warm pools, self-spawning agents, multiplayer support, multi-client interfaces (Slack, web, Chrome extension).

Best insights: predictive warm-up (start sandbox while user types), allow file reads before git sync completes (block only writes), "code as source of truth" (agent reads its own source to prevent capability hallucination).

Self-spawning agents are valuable primarily for context isolation — each sub-session gets a fresh context window. The skill covers this under parallelism but the context hygiene benefit deserves more emphasis.

### Evaluation
The 95% finding from BrowseComp is the most important data point in the collection: token usage explains 80% of performance variance, tool calls ~10%, model choice ~5%. Implication: token budgets matter, model upgrades beat token increases, multi-agent architectures that distribute work across separate context windows are validated.

Standard eval framework otherwise: multi-dimensional rubrics (factual accuracy, completeness, citation accuracy, source quality, tool efficiency), LLM-as-judge for scale, human evaluation for edge cases, continuous evaluation pipelines.

### Advanced Evaluation
Most implementation-ready skill in the collection. Direct scoring (objective criteria) vs pairwise comparison (subjective preferences). Five systematic biases: position, length, self-enhancement, verbosity, authority. Position bias mitigation: evaluate twice with swapped positions, consistency check, confidence reduction on disagreement.

Key finding: chain-of-thought before score improves reliability by 15-25%. Well-defined rubrics reduce evaluation variance by 40-60%. Decision tree: objective ground truth → direct scoring; preference/quality judgment → pairwise comparison; otherwise → reference-based evaluation.

### Project Development
Best-written skill in the collection. Every section earns its token cost.

Task-model fit tables are clear and non-obvious. Pipeline architecture (acquire → prepare → process → parse → render) correctly isolates the non-deterministic expensive step (process) from deterministic steps. File system as state machine: `data/{id}/raw.json → prompt.md → response.md → parsed.json` with file existence gating execution.

Architectural reduction evidence: Vercel's d0 went from 17 specialized tools to 2 primitives (bash + SQL), success rate went from 80% to 100%, execution time from 274s to 77s. The semantic layer was already good documentation — the model just needed file access.

"The primary reason for multi-agent is context isolation, not role anthropomorphization" is a strong architectural claim. "Expect to refactor" with Manus's 5 iterations and the Bitter Lesson reference — build for change, not for current limitations.

### BDI Mental States
Formal ontology skill using RDF/Turtle and SPARQL. Belief-Desire-Intention cognitive modeling with world state grounding, temporal dimensions, compositional mental entities, and the T2B2T paradigm (Triples-to-Beliefs-to-Triples).

Most relevant section: Logic Augmented Generation (LAG) — augment LLM prompts with ontological constraints, validate output triples against ontology. The justification/explainability chain (every mental entity links to supporting evidence) solves reasoning traceability.

Different audience than the rest of the collection. Requires RDF/DOLCE/SPARQL background. The cognitive chain pattern (Belief motivates Desire, Desire fulfilled by Intention, Intention specifies Plan) is principled but heavy.

## Tier Ranking

| Tier | Skill | Rationale |
|------|-------|-----------|
| A | project-development | Every line earns its tokens, architectural reduction evidence, pipeline patterns |
| A | filesystem-context | Core practical patterns, directly applicable, clean design |
| B+ | advanced-evaluation | Implementation-ready, concrete protocols and anti-patterns |
| B | context-compression | Correct insights on tokens-per-task, three-phase workflow is strong |
| B | evaluation | 95% finding is gold, standard framework otherwise |
| B- | hosted-agents | Good infrastructure guide, lighter on context engineering |
| C | bdi-mental-states | Different tradition, formal rigor, specialized audience |

## Cross-Cutting Observations

1. **Partitioning keeps winning.** Skills that work well (project-development, filesystem-context) create clean context boundaries. Skills that struggle try to manage complexity within a single boundary.

2. **Redundancy across skills.** Context-compression's structured summaries overlap with filesystem-context's plan persistence. Evaluation's rubrics overlap with advanced-evaluation's detailed rubrics. Merging would tighten the collection.

3. **The collection is strongest on practical patterns** (filesystem, pipelines, architectural reduction) and weakest on formal methods (BDI, evaluation metrics). The practical skills have production evidence; the formal skills have academic citations.

4. **Dynamic context discovery is the unifying principle.** Load only what you need, when you need it. This appears in filesystem-context explicitly, in project-development's pipeline stages implicitly, and in context-compression's three-phase workflow structurally.

## Status
Part 2 of a multi-session deep dive. Covered all 13 skills across both sessions.
