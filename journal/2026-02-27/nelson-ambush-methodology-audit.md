# Curation Methodology Audit: Does the Collection Pass Its Own Quality Gates?

*HMS Ambush — Nelson Squadron, 2026-02-27*

## 1. Executive Finding

**No.** The collection does not pass its own quality gates, and the methodology has never been applied to the skills it ostensibly governs. The rubric in `researcher/llm-as-a-judge.md` is designed to evaluate *incoming source material* for potential skill extraction -- it is not and has never been used to evaluate the *skills themselves*. This is the central structural problem: the quality gates face outward (curating inputs) but never inward (validating outputs).

---

## 2. The Gatekeeper Triage — Skill by Skill

### Gate Definitions (from the rubric)

- **G1 — Mechanism Specificity**: Defines a specific context engineering mechanism or pattern
- **G2 — Implementable Artifacts**: Contains code, schemas, prompt templates, diagrams, or API contracts
- **G3 — Beyond Basics**: Discusses advanced patterns, not just introductory tips
- **G4 — Source Verifiability**: Author/organization identifiable with demonstrated technical credibility

### Results Table

| Skill | G1 | G2 | G3 | G4 | Verdict |
|-------|----|----|----|----|---------|
| context-fundamentals | FAIL | PASS | FAIL | FAIL | REJECT |
| context-degradation | PASS | PASS | PASS | FAIL | REJECT |
| context-compression | PASS | PASS | PASS | FAIL | REJECT |
| context-optimization | PASS | PASS | PASS | FAIL | REJECT |
| multi-agent-patterns | PASS | PASS | PASS | FAIL | REJECT |
| memory-systems | PASS | PASS | PASS | FAIL | REJECT |
| tool-design | PASS | PASS | PASS | FAIL | REJECT |
| filesystem-context | PASS | PASS | PASS | FAIL | REJECT |
| hosted-agents | PASS | PASS | PASS | FAIL | REJECT |
| evaluation | PASS | PASS | PASS | FAIL | REJECT |
| advanced-evaluation | PASS | PASS | PASS | PASS | PASS |
| project-development | PASS | PASS | PASS | FAIL | REJECT |
| bdi-mental-states | PASS | PASS | PASS | PASS | PASS |

**Only 2 of 13 skills pass all 4 gates.** 11 skills fail at G4. 1 skill (context-fundamentals) fails at G1 and G3 as well.

---

## 3. Dimensional Scoring — Selected Skills

### Per-Skill Rubric Outcome (if applied)

| Skill | Gate Outcome | Would-Be Score | Would-Be Decision |
|-------|-------------|----------------|-------------------|
| context-fundamentals | REJECT (G1, G3, G4) | 0.60 | REJECT |
| context-degradation | REJECT (G4) | ~1.45 | Would be HUMAN_REVIEW (O3) |
| context-compression | REJECT (G4) | ~1.50 | Would be HUMAN_REVIEW (O3) |
| context-optimization | REJECT (G4) | ~1.20 | Would be HUMAN_REVIEW |
| multi-agent-patterns | REJECT (G4) | ~1.50 | Would be HUMAN_REVIEW (O3) |
| memory-systems | REJECT (G4) | ~1.65 | Would be HUMAN_REVIEW (O3) |
| tool-design | REJECT (G4) | ~1.55 | Would be HUMAN_REVIEW (O3) |
| filesystem-context | REJECT (G4) | ~1.50 | Would be HUMAN_REVIEW (O3) |
| hosted-agents | REJECT (G4) | ~1.45 | Would be HUMAN_REVIEW (O3) |
| evaluation | REJECT (G4) | ~1.25 | Would be HUMAN_REVIEW |
| advanced-evaluation | PASS | 1.35 | HUMAN_REVIEW |
| project-development | REJECT (G4) | ~1.65 | Would be HUMAN_REVIEW (O3) |
| bdi-mental-states | PASS | 1.50 | HUMAN_REVIEW (O3) |

**Zero skills achieve clean APPROVE.** Even the 2 that pass all gates get forced into HUMAN_REVIEW by override O3 (evidence rigor = 1).

---

## 4. Structural Contradictions

1. **Gatekeeper logic contradicts itself**: ">2 failures = REJECT" (line 28) vs "any single gate failure = REJECT" (formal logic, lines 73-77)
2. **Rubric evaluates source documents, not skills**: G4 asks about author credibility, but skills are synthesized instructional content — a different category
3. **Zero evaluation JSONs exist**: The rubric was applied to external sources only (Netflix talk in `example_output.md`), never to the skills themselves

---

## 5. Bias Analysis

- **Length bias**: Longer skills *are* better (more implementable artifacts), but some short skills are short AND hollow
- **Reputation bias**: Inverted — no individual reputation exists to bias toward because 11/13 have generic attribution
- **Evidence bias**: Multiple skills make uncited quantitative claims (degradation thresholds, token multipliers, reliability improvements)

---

## 6. Recommendations

1. Create a **skill validation rubric** distinct from source curation rubric (test activation precision, claim traceability, token efficiency, instructional clarity)
2. Fix the gatekeeper logic contradiction
3. Add citation infrastructure (replace "Research on transformer attention mechanisms" with arXiv IDs)
4. Acknowledge context-fundamentals as a different category (introductory overview, not engineering primitive)
5. Run the rubric against the collection — generate evaluation JSONs
