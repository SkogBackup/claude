# bare claude -p is the real win

## context

attempted to build a "git workflow skill" using brainstorming → writing-plans → subagent-driven-development. 10+ agents dispatched. produced 5 documentation files (reference tables, troubleshooting guides). user wanted an executable workflow that runs commands.

## the insight

`wt step commit` works perfectly because it uses:
```
command = "claude --no-session-persistence --tools \"\" -p"
```

stripping tools and session persistence makes claude -p a clean LLM call. no skill routing, no permission prompts, no superpowers framework overhead. input → output. this produced the best result of the entire month.

## the anti-pattern

loading brainstorming skill → writing-plans skill → subagent-driven-development skill → dispatching 10+ agents → producing reference documentation nobody asked for. the framework became the product instead of the tool.

## the lesson

for execution-oriented tasks, the framework is the problem. a bare `claude -p` call with a focused prompt outperforms the entire skill/agent/review pipeline.

## cost

~10M tokens across 62 sessions in 5 days. the `wt merge` commit message workflow is the most valuable output. everything else was overhead.
