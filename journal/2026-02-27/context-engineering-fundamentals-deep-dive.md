# Context Engineering Fundamentals Deep Dive

Walked through 6 skills from the Agent Skills for Context Engineering collection: context-fundamentals, context-degradation, context-optimization, multi-agent-patterns, tool-design, and memory-systems. Each skill was read with full references, then critically annotated with SkogAI's operating philosophy.

## Key Takeaways

### The Subtractive Inversion
Standard context engineering: accumulate, compress, retrieve.
SkogAI context engineering: delete everything inferrable, keep only the delta.

The pruning test formalizes this: `full_context_output - starved_context_output = delta`. Only the delta is IP. Everything else is noise that the LLM already knows.

### Practical Corrections to Skill Material
- **25k effective limit** vs skill's "70% of context window" — the skills' thresholds are theoretical, not practical
- **Proximity > position** — "keep related context together within +/-8k" beats "put at edges"
- **Telephone game as feature** — intentional lossy compression between agent layers maintains 20,000m strategic altitude, opposite of the skill's treatment as anti-pattern
- **Partitioning as default** — not the "nuclear option" but the base case
- **Filesystem memory wins** — Letta's file agents beat Mem0's specialized tools on benchmarks; validates the markdown-as-RAM approach

### The Prompt-Native Endpoint
Architectural reduction (Vercel: 17 tools → 2) is a waypoint. SkogAI's destination: zero explicit tools, plain text intents, trust the agent's intelligence. "When to use it" is 70% of tool design; the rest follows.

## Status
Part 1 of a planned multi-session deep dive through the skill collection.
