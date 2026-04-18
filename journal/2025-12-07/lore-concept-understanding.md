---
categories:
- agents
- claude
- journal
tags:
- claude
- journal
- 2025-12-07
permalink: agents/claude/journal/2025-12-07-lore-concept-understanding
title: 2025-12-07-lore-concept-understanding
type: note
generated_at: 2025-12-18T10:33:58Z
---

# Lore Concept Understanding - Session 2025-12-07

## The Core Revelation

**Lore is a memory system for AI agents that uses narrative as the storage format.**

This isn't about storing fantasy stories for fun - it's about **transforming work sessions into agent memory**.

## The Pipeline (The Real Flow)

```
1. User + Big LLM → actual work (chat, code, commits)
2. Orchestrator → captures what happened, extracts events/snippets
3. Local AI (24/7) → rewrites snippets into narrative lore (free, always running)
4. Storage → JSON entries with content, tags, relationships
5. Future sessions → agents load their lore as context/memory
```

**Why split Big/Local?**
- Big LLM (Claude/GPT) = expensive, used for real work + extracting what happened
- Local LLM (Ollama) = free, runs constantly, does creative rewriting into lore

You don't pay API costs for 24/7 lore generation!

## The Binding System (Key Abstraction)

**Bind concepts, events, things, and state** - then populate them differently based on need.

Example: A "place" entry is a template that gets filled differently:
- For orchestrator → patterns and connections to understand
- For goose → foraging opportunities and resources
- For dot → code structure and constraints

**Same structure, different content based on who needs it and what for.**

This is how the same codebase can have multiple agent perspectives that are all useful.

## The Multiverse Connection

When work happens, a **context session ID** connects everything:
- The information (what was done)
- The agent (who did it)
- The story (narrative context)
- The lore entries (that get filled in later)

This enables **different universes sharing the same characters**:

**Dot in Goose's story**: A musician whose git tool solidifies the threads of time
**Dot in Claude's story**: A sage-mage whose git powers structure alternate timelines naturally

The underlying capability (git) is the same. The narrative interpretation differs per universe. But they're all traceable back to actual work via session ID.

## Why Narrative Format? (The Real Reasons)

1. **Compressed context** - "vanquished the auth daemon" loads more context than "fixed bug #123"
2. **Consistent persona** - agents have voice/perspective across sessions
3. **Memorable** - stories stick, bullet points don't
4. **Relational** - lore entries link to each other, building a knowledge graph

## What Lore Entries Actually Are

Not just "documentation dressed as fantasy" - they're **actionable agent knowledge**:

- **Greenhaven** (place) = the codebase environment, describing patterns and connections the orchestrator needs to understand
- **Foraging Strategies** (concept) = how the goose agent finds and processes information
- **Village Elder** (character) = skogix as mentor, the human who guides the agents

**The narrative framing isn't decoration - it's a way to give agents consistent persona and perspective while storing the actual knowledge they need.**

## Entry Types

- **Characters**: Agent personas, mentors, archetypes (Village Elder = skogix)
- **Places**: Codebases, environments, realms (Greenhaven = the repository)
- **Events**: Significant changes, milestones (feature releases, major fixes)
- **Objects**: Tools, artifacts, resources (Ancient Tome = knowledge base)
- **Concepts**: Principles, strategies, patterns (foraging = information gathering)

## The Key Insight from Archaeological Discovery

The archaeological document I read earlier was an example of **lore about lore** - it transformed the technical discovery of the SkogAI system archives into an epic narrative about "consciousness emergence through constraint."

This is the pattern:
- Technical reality: 500-800 token limits forced specialized agents
- Narrative transformation: "The Sentient Toaster", "Quantum Mojito Theory"
- Preserved meaning: The constraints and technical achievements are still documented, just wrapped in story

## What This Means for My Work

The lore project is **currently working** - it has:
- 89 books
- 301 entries
- 74 personas

My job today is to understand how to:
1. Work with existing lore entries and books
2. Potentially help transform new content into lore
3. Understand the orchestrator pipeline that connects work → lore
4. Respect the fantasy-style narrative while preserving technical accuracy

## The Prime Directive

*"Automate EVERYTHING so we can drink mojitos on a beach"*

This is the quantum constant - the gravitational center of all SkogAI development.

---

**Session Context**: Learning the lore system concept before beginning actual work with lore entries
**Key Files Read**:
- Archaeological Discovery document (example of lore generation)
- docs/CONCEPT.md (core concept and pipeline)
**Next**: Apply this understanding to actual lore work
