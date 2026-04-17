---
title: test-routing-prompt
type: note
permalink: claude/lab/projects-in-development/claude-routing-via-claude-md-files/test-routing-prompt
---

hello claude! testing the "routing" from only loading the @CLAUDE.md at the start and seeing if you have enough information loaded via @-links to explain the routing table without any extra actions needed :)

test questions to answer WITHOUT reading any additional files:

1. what projects are in dev/?
1. what's in the tmp/ directory?
1. what scripts exist in scripts/?
1. what configuration files are in config/?
1. what is skogai-core-additions? (you should know the brief description but not implementation details)
1. where would i find the taskwarrior-based todo management?
1. if i wanted to work on workflow commands, where would i go?

expected behavior:

- answer 1-7 directly from loaded context
- for deeper questions (like "how does plan command work?") you should acknowledge what route to follow: "I see it's in skogai-core-additions from dev/, to understand implementation I'd need to load @skogai-core-additions/CLAUDE.md"

the goal: you should be able to navigate/orient the entire repository without extra reads, but acknowledge when you'd need to dive deeper for implementation details.
