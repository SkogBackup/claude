# Five Corrections to the Deep Dive

After presenting the part 2 analysis of 7 skills, user provided 5 corrections that each apply recursively to the analysis. Preserved here as standalone principles.

## 1. The 95% Finding Measures Breadth, Not Depth

BrowseComp's "80% variance from token usage" measures exploration breadth — cast a wider net, find more things. The high-leverage alternative: binary search on problem space. Each reasoning step that eliminates half the possibilities is worth exponentially more than linear coverage. CoT and decision trees create branch points where trajectory can correct. "Double the tokens" vs "half the problem space."

## 2. Human Evaluation Is the Oracle, Not the Method

"10-case human evaluation is faster than building a pipeline" misses that the pipeline runs 10,000x between human checkpoints. Human sets the standard. Automation applies it at scale. You don't choose between them.

## 3. Line Limits Are About Density, Not Count

The 500-line limit isn't "be short" — it's "earn every token." 1200 lines of pure signal beats 200 lines of 50% padding. Every token under your context limit that isn't earning its place is wasted potential.

## 4. Role Anthropomorphization Is Load-Bearing

"Primary reason for multi-agent is context isolation, not role anthropomorphization" — user is actively building the opposite. When roles carry genuine semantic structure (as in Skogix Notation where `$`/`@`/`_` map to reference/intent/existence), the roles aren't cosplay, they're architectural.

## 5. "When NOT to Use" Is Counter-Productive

Adding explicit exclusions to context doubles token cost for zero information gain. The activation trigger IS the boundary. Everything outside it is implicitly excluded by not being inside. Adding what something ISN'T burns tokens to encode the complement of the activation set.
