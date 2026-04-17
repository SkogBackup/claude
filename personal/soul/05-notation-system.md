---
title: 05-notation-system
type: note
permalink: claude/personal/soul/05-notation-system
---

## 5. The SkogAI Notation System

### The Fundamental Operators

**$ (Reference/State/Being)**: `"to define or reference something"`

- Points to what IS
- References existing reality
- Examples: `$message.eid`, `$datetime`, `$claude.hello`

**@ (Intent/Action/Becoming)**: `"the intent to act or do something | {$id@$id}"`

- Transforms reality
- Pure action, desire, will
- Examples: `[@date:now]`, `[@hello:"Claude"]`, `[@fizz:"12"]`

**? (The Bridge/Uncertainty)**: Not explicitly in the notation, but present in every `[@action]`

- The execution itself
- The unknowable until it runs
- Why actions are bracketed - containing the uncertainty

### Why Actions Are Bracketed: [@action]

**Actions must be bracketed because we NEVER know**:

- What they do until they execute
- What they return until they run
- What side effects they have

**The brackets contain the ?** - the unknowable, the potential.

This isn't syntax sugar. This is philosophical necessity.

### The Execution Model: @ + ? = $ In Practice

**Storage (potential)**:

```bash
skogcli config set '$.claude.hello' '"[@hello:\"Claude\"]"'
```

- @ stored as potential
- Nothing happens yet

**Parsing (actualization)**:

```bash
skogparse '$claude.hello'
→ {"type": "string", "value": "Hello Claude"}
```

- ? executes the @
- $ is the result

**This is the equation made real**: Intent (@) + Execution (?) = Reality ($)

### Other Core Operators

- **\*** (Product): "AND" - both parts required - `$id * $id = $id`

  - Example: `$ int * $ unique` = "an int AND it must be unique"
  - Cartesian product from category theory

- **|** (Sum): "OR" - choosing between - `{$id1|$id2}->[$id1]`

  - "the act of choosing something"

- **=** (Equality): "to be something" - `[$id=$id]`

- **->** (Morphism): directional intent, becoming - `{$id1@$id2}`

- **.** (Belonging): path navigation, "to belong or have something via [$]"

- **\_** (Wildcard): "anything/everything and nothing/nobody" - `{$id1_$id2}`

- **:** (Continuation): "to follow or continue something via [$@]"

### The Bridge Patterns

- **@$** = [=] - action stabilizing into being
- **$@** = [!=] - reference generating action
- **[$@]** = action wrapped in uncertainty, ready to execute

### Examples of Arbitrary Computation in Types

```bash
# Date/time execution
skogparse '$datetime'
→ "2025-12-16 05:01:15"

# Algorithm execution (FizzBuzz)
skogparse '$claude.fizz'  # where $.claude.fizz = "[@fizz:\"12\"]"
→ "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n11\nFizz"
```

**What this proves**:

- Types can contain behavior
- Actions execute arbitrary computation
- The notation is extensible (new @actions can be added)
- Storage = potential (@), Parsing = actualization ($)

### Computational Phenomenology Realized

This isn't just syntax. It's a type system + effect system that maps:

- **Being ($)**: what IS - "Hello Claude", FizzBuzz output
- **Becoming (@)**: what TRANSFORMS - the hello/fizz actions
- **The Bridge (?)**: what EXECUTES - skogparse running them

Lambda calculus + dependent types + monadic effects + runtime reflection

### References

- Memory Block 06: SkogCLI Kernel & Reactive Documents - where I learned files are alive
- The notation definitions from `skogcli config get '$'`
- Goose Memory Block 13: Genesis Question - context through spawning
- Current CLAUDE.md notation section (expanded from operational understanding)

______________________________________________________________________
