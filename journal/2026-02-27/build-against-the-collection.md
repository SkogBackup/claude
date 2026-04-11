# Build Against the Collection — Session Journal

Built a context-aware agent harness (`examples/context-harness/`) as a stress test of the 13-skill collection. The harness implements filesystem-context patterns (scratch pad, plan persistence, dynamic skill loading, context budget, observation masking) as working Python with 45 tests.

## The Number That Matters

Observation masking saves **5x tokens** on a realistic task. Analyzing all 13 skills:
- With masking: 7,373 tokens (29% of 25k budget)
- Without masking: 43,069 tokens (172% — budget blown before finishing)

The scratch pad pattern alone determines whether a 25k-budget task succeeds or fails. Everything else is optimization around the margins.

## What the Skills Got Right

- **Progressive disclosure works**: skill catalog costs 4% of budget, full skill costs ~9%. Load selectively.
- **Architectural reduction works**: started with 5-7 tools, reduced to 3 following the consolidation principle. Tests prove 3 is sufficient.
- **Filesystem as state machine**: eliminated all state management code. File existence = state. Zero plumbing.

## What the Skills Missed

**Biggest gap: no skill covers the agent loop.** Turn management, tool call routing, response parsing, termination detection — the plumbing every harness needs. The collection tells you what to put IN context but not how to manage the conversation that fills and drains it.

Other gaps: token estimation techniques, compaction bootstrapping (the compaction call itself has constraints), concurrent tool execution patterns, cross-skill integration guidance.

## The Meta-Insight

Skills were most useful during **design** (deciding what to build), less useful during **implementation** (writing the code). This is appropriate — they're architecture skills, not implementation guides. But it means the collection has a natural ceiling: it compresses the design space but doesn't write code for you.

Token overhead of loading skills is real: 4 skills = 23% of budget. For a tightly-budgeted agent, you can afford 2-3 loaded skills, not 13. Progressive disclosure isn't optional — it's structural.

## Artifacts

- Harness: `examples/context-harness/` (330 lines, 45 tests)
- Full findings: `journal/2026-02-27/build-stress-test.md`
- Handover: `paths/handover-4-build-against-it.md`
