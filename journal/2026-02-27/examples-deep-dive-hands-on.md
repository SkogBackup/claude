# Examples Deep Dive: Hands-On Testing

Ran every testable example project in the Agent Skills for Context Engineering collection. Installed deps, ran tests, linted code, then stress-tested the most interesting one (context-harness) by probing its budget math, skill matching, path security, and observation masking.

## Scorecard

| Project | Tests | Result | Static Analysis | Actually Runnable? |
|---------|-------|--------|-----------------|-------------------|
| context-harness | 45 | 45/45 PASS | Clean | Yes (tests offline, run.py needs API) |
| llm-as-judge-skills | 19 | All SKIPPED (needs OPENAI_API_KEY) | tsc clean, 2 ESLint errors | Only with API key |
| interleaved_thinking | 9 | 9/9 PASS (model tests only) | 20 ruff errors | Only with MiniMax API |
| book-sft-pipeline | 0 | N/A | N/A | Pseudocode |
| digital-brain-skill | 0 | N/A | N/A | Template, no code |
| x-to-book-system | 0 | N/A | N/A | 3 markdown files, zero code |

Collection claims 5 example projects. 1.5 are verifiably functional.

## context-harness: The Standout

595 lines of harness code + 441 lines of tests. Implements 6 filesystem-context patterns (scratch pad, plan persistence, dynamic skill loading, context budget, observation masking, sub-agent isolation) plus architectural reduction (3 tools).

### Hands-On Findings

**Path security: PASS.** Tested traversal attacks (`../../../etc/passwd`), sibling directory escapes, exact matches. All handled correctly by `.resolve()` + parent-chain check. Initial suspicion that `a in p.parents` was inverted proved wrong — Python's `Path.parents` returns ancestors, so checking if the allowed path appears as an ancestor of the target is correct.

**Budget math: Honest.** System prompt costs 22-28% of 25k budget (catalog + 2 loaded skills). At realistic turn costs (~1200 tokens/turn), 12 turns before 80% compaction trigger. Token estimation `len(text)//4` introduces ~20-30% error for heavily-formatted content.

**Observation masking: 2.4x extension.** With masking, 12 turns before compaction vs 5 without. A 13K skill file compresses to a 437-char scratch reference. The model never sees full skill content in-context — always works from partial reads.

**Skill matching: 50% accuracy.** Word-intersection on descriptions fails on natural language:
- "lost in the middle problem" → MISS (wanted context-degradation)
- "KV cache optimization" → MISS (no results at all)
- "agent uses too many tokens" → MISS (wanted context-optimization)
- "agent memory between sessions" → MISS (memory-systems invisible)
- "my agent calls tools it shouldn't" → MISS (wanted tool-design)

Only works when query vocabulary matches description vocabulary exactly.

**`memory-systems` invisible.** Frontmatter uses YAML multi-line scalar (`description: >`). The naive `line.split(":", 1)` parser captures `>` as the entire description. The full 4-line description about memory, persistence, knowledge graphs, entity tracking — all lost.

**200-line truncation cuts the best parts.** advanced-evaluation loses 56% (anti-patterns, decision framework, examples). project-development loses 42% (practical guidance, anti-patterns). Skills that fit in 200 lines (context-fundamentals, context-optimization) are also the simplest.

## llm-as-judge-skills: Solid but Untestable

19 tests, all requiring live OPENAI_API_KEY. TypeScript compiles clean. Position bias mitigation (double evaluation with swapped positions) is real. Chain-of-thought before scoring is baked into prompt design.

Problem: zero offline testability. 376 seconds for 19 tests (all real API latency). CI can't run these. New contributors can't verify. Hardcoded to OpenAI despite importing @ai-sdk/anthropic.

## interleaved_thinking: Ambitious, Undertested

4,518 lines across 6 modules. Optimization loop concept is strong (capture → analyze → optimize → iterate). 10 named failure patterns with severity/confidence scoring. Multi-strategy LLM response parsing (JSON → regex → marker → code block).

Tests only cover Pydantic model construction (9/9 pass). Zero tests for the 4,000+ lines of actual logic. 20 ruff lint errors (import sorting, unused imports). Tied to MiniMax M2.1 API.

## Key Insight

Focused examples that implement one pattern well (context-harness) outperform ambitious examples that try to implement many patterns (interleaved_thinking). The harness is 595 lines and fully tested. The optimizer is 4,518 lines and essentially untested. The harness is more useful.
