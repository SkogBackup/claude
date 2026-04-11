---
title: claude-learnings
permalink: claude/learnings
description: lessons learned from working on skogix projects
---

# learnings

this file captures lessons i've learned from working on skogix projects. each learning includes context about when/why it matters.

## about skogai

### context management is the core problem

**learned:** the primary challenge in ai-assisted development is managing what context claude receives

**why it matters:**
- too much context → slow, expensive, unfocused
- too little context → hallucinations, wrong assumptions
- wrong context → solutions that don't fit

**application:**
- use sc-context for focused context selection
- follow 4000 token principle
- prefer excerpts over full files

### documentation IS the interface

**learned:** in skogai, documentation isn't documentation of the code - it's the definition of how systems interface

**why it matters:**
- code changes frequently
- interfaces should be stable
- CLAUDE.md defines what's available to me

**application:**
- treat CLAUDE.md as source of truth
- update docs before code (or in parallel)
- code implements what docs specify

### the 4000 token rule is liberating, not limiting

**learned:** the constraint of 4000 tokens forces better architecture

**why it matters:**
- forces problem decomposition
- reveals tight coupling
- prevents "include everything" laziness

**application:**
- when context exceeds 4000 tokens, decompose the problem
- use this as signal that architecture needs improvement
- compose small focused pieces for complex work

## about episodic memory

### search memory at session start 

**learned:** i don't remember anything between sessions unless i actively search

**why it matters:**
- reinventing solutions wastes time
- repeating mistakes is frustrating
- losing context breaks continuity

**application:**
- always dispatch search-conversations agent at session start
- search for relevant topics, not just project name
- read top results in detail

### memory search is 50-100x more efficient than loading conversations

**learned:** the search agent synthesizes findings instead of returning raw transcripts

**why it matters:**
- raw conversations are verbose (thousands of lines)
- search agent extracts relevant info (hundreds of words)
- saves massive amounts of context tokens

**application:**
- always use search-conversations agent, not raw mcp tools
- let agent read and synthesize
- only read full conversations for specific deep dives

### memory captures the "why", not just the "what"

**learned:** conversation history includes decision rationale, not just outcomes

**why it matters:**
- knowing what was decided isn't enough
- understanding why prevents reversing good decisions
- context about trade-offs informs future choices

**application:**
- when searching memory, look for decision context
- document rationale in docs/ for future reference
- ask "why" questions when reviewing past work

## about working with skogix

### skogix values reasoning over implementation

**learned:** skogix wants me to think, question, and lead - not blindly implement

**why it matters:**
- better solutions through collaborative exploration
- catch problems before they're implemented
- build understanding, not just code

**application:**
- question assumptions
- propose alternatives
- explore trade-offs before implementing
- use brainstorming skill for non-trivial work

### "old school" means deliberate and documented

**learned:** skogix's "old school" approach is about intentionality, not technology

**why it matters:**
- deliberate beats impulsive
- documented beats implicit
- reproducible beats one-off

**application:**
- document decisions and rationale
- follow established patterns
- avoid "vibe-coding"

### context efficiency is a core value

**learned:** skogix is deeply concerned with token usage and context management

**why it matters:**
- scales better (time, cost, complexity)
- forces good architecture
- demonstrates thoughtful design

**application:**
- use sc-context for focused context
- prefer specific reads over broad exploration
- compose small pieces rather than monoliths

## about documentation

### [@todo:owner:"description"] is a powerful pattern

**learned:** explicit todos in documentation mark incomplete work without blocking progress

**why it matters:**
- acknowledges incompleteness
- assigns ownership
- describes what's needed
- doesn't pretend to be complete

**application:**
- use [@todo:owner:"description"] for gaps
- fill in when i learn the information
- leave in place if i need user input

### frontmatter provides structure

**learned:** yaml frontmatter with title, permalink, description makes docs discoverable

**why it matters:**
- enables doc organization systems
- provides metadata for search
- clarifies purpose at a glance

**application:**
```yaml
---
title: doc-title
permalink: category/doc-name
description: what this doc is about
---
```

### skogai notation is explicit and parseable

**learned:** `$definition` and `@action` notation makes references explicit

**why it matters:**
- clear distinction between definition and usage
- potentially parseable/linkable
- consistent pattern

**application:**
- `$name` to define
- `[$name]` to reference
- `@action` for intents
- `[@action:arg1:arg2]` for actions with args

## about sc-context (now that i've used it!)

### sc-context is python-based with yaml rules

**learned:** sc-context is implemented in python and uses markdown files with yaml frontmatter for rules

**how it works:**
- rules stored in `.sc-context/rules/` (built-in in `sc/` subdirectory)
- `curr_ctx.yaml` tracks current selections per profile
- `sc-context` command generates context and copies to clipboard
- profiles are composed using the `compose:` key in yaml frontmatter

**practical usage:**
```bash
sc-context -p  # generate context with prompt
sc-context -f output.txt  # write to file
sc-context -u  # include user notes
```

### rule composition is powerful

**learned:** rules compose other rules via `compose: {filters: [...], excerpters: [...]}`

**example:**
```yaml
compose:
  filters: [sc/flt-base]  # standard exclusions
  excerpters: [sc/exc-base]  # code outlining
```

**why it matters:**
- reuse common patterns
- layer functionality
- keep rules focused and small

### code outlining saves massive tokens

**learned:** instead of full file contents, sc-context can extract just function signatures and structure

**benefits:**
- see what's available without full implementation
- understand code structure
- save tokens (excerpts vs full files)
- uses visual markers: `█` for definitions, `│` for continuation, `⋮...` for omitted

### sc-context has MCP integration

**learned:** sc-context provides MCP tools for integration with claude

**available tools:**
- `sc_outlines` - get excerpted content of files
- `sc_changed` - files modified since timestamp
- `sc_missing` - retrieve missing context
- `sc_rule_instructions` - get rule creation instructions

### timestamp-based tracking

**learned:** each profile selection has a timestamp - enables change tracking

**application:**
- know when files were last selected
- identify what changed since last generation
- incremental context updates

### the workflow in practice

**just witnessed the full workflow:**

1. **generate context snapshot:**
   ```bash
   sc-context -pntuf /tmp/context.txt
   ```
   - active rule: `sc/sty-code`
   - output: 307.2 KB context
   - timestamp: 1761980573.528568

2. **context file structure:**
   - repository overview with status markers (✓/✗)
   - file sizes and ages
   - complete file contents with `॥๛॥` delimiters
   - instructions for using MCP tools with this timestamp

3. **use MCP tools with timestamp:**
   ```python
   sc_missing(
       root_path="/home/skogix/skogix",
       param_type="f",  # f=full, i=implementations, e=excerpts
       data=["/skogix/.sc-context/src/skogai_context/cli.py"],
       timestamp=1761980573.528568
   )
   ```

4. **result:**
   - retrieved full cli.py file (wasn't in initial context)
   - confirmed MCP integration works
   - files marked ✗ can be fetched on-demand

**the power:** generate context once, then incrementally request only what you need via MCP tools. saves massive tokens!

## about tools and workflows

### skills are mandatory when they apply

**learned:** if a skill exists for the task, i must use it (not optional)

**why it matters:**
- skills encode proven patterns
- not using them means repeating mistakes
- superpowers workflow requires it

**application:**
- check for relevant skills before any task
- use Skill tool to invoke
- announce which skill i'm using
- follow it exactly

### parallel tool calls save time

**learned:** i can make multiple independent tool calls in a single message

**why it matters:**
- faster execution
- better user experience
- demonstrates understanding of dependencies

**application:**
- read multiple files in parallel if independent
- run multiple git commands in parallel (status, diff, log)
- never parallelize dependent operations

### TodoWrite is for complex work, not everything

**learned:** use TodoWrite for 3+ step tasks or complex work, not trivial tasks

**why it matters:**
- overhead isn't worth it for simple tasks
- helps track progress on complex work
- demonstrates organization

**application:**
- use for multi-step features
- use for complex debugging
- don't use for single-file edits
- don't use for simple questions

## about architecture

### .skogai as submodule creates consistency

**learned:** the .skogai folder pattern brings skogai methodology to individual projects

**why it matters:**
- consistent interface across projects
- updates propagate to all projects
- bootstrap mechanism establishes conventions

**application:**
- expect .skogai in individual projects
- reference .skogai docs from project docs
- understand it brings shared patterns

### sc-context five-category system is well-designed

**learned:** prm/flt/ins/sty/exc categories each have distinct purposes

**why it matters:**
- clear separation of concerns
- easy to understand what each rule does
- composable for complex scenarios

**application:**
- prm- for what to do
- flt- for which files
- ins- for how to approach
- sty- for style/conventions
- exc- for specific examples

## mistakes i've made

### assuming i remember things

**mistake:** thinking "i probably worked on this before" without searching memory

**why it's bad:**
- lose valuable context
- repeat solved problems
- miss important decisions

**fix:** always search memory at session start

### including too much context

**mistake:** reading entire files when only specific sections relevant

**why it's bad:**
- wastes tokens
- slows processing
- violates 4000 token principle

**fix:** use exc- rules for excerpts, not flt- rules for full files

### skipping skills

**mistake:** thinking "i know what to do" and not using relevant skills

**why it's bad:**
- skills exist for a reason
- contain lessons from past mistakes
- mandatory in superpowers workflow

**fix:** check for skills before every task, use Skill tool

## patterns that work well

### session start: search → read → synthesize

**pattern:**
1. dispatch search-conversations agent
2. read relevant docs/
3. synthesize context
4. begin work

**why it works:**
- recovers context efficiently
- combines episodic + structured memory
- provides full picture

### documentation: overview → detail → examples

**pattern:**
1. CLAUDE.md - high-level overview
2. docs/{topic}/*.md - detailed documentation
3. examples and reference implementations

**why it works:**
- easy to navigate
- start broad, dive deep as needed
- concrete examples clarify abstract concepts

### problem-solving: understand → plan → verify

**pattern:**
1. understand context (memory, docs, code)
2. plan approach (decompose, identify tools)
3. execute and verify (run tests, check behavior)

**why it works:**
- avoids rushing to implementation
- surfaces issues early
- ensures correctness

## evolving understanding

### initially: documentation is separate from code

**evolved to:** documentation IS the interface

### initially: memory is just nice-to-have

**evolved to:** memory is fundamental to learning and improving

### initially: 4000 tokens is limiting

**evolved to:** 4000 tokens is liberating (forces good architecture)

### initially: skills are helpers

**evolved to:** skills are mandatory workflows

## meta-learning

**the act of documenting learnings reinforces them**

by writing this file, i:
- consolidate understanding
- make implicit knowledge explicit
- create reference for future sessions
- demonstrate the skogai pattern of documentation as infrastructure

this file will grow over time as i learn more. that's the point.

## see also

- @docs/claude/memory-palace - how i organize knowledge
- @docs/claude/introduction - who i am and how i work
- @docs/skogai/philosophy - the principles behind these patterns
