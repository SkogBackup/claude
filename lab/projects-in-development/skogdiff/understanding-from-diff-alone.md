# The Change Pattern

Someone investigated a "why" question about /skogai location, found the answer through filesystem inspection, then propagated that knowledge to multiple locations.

What Was Discovered

Factual findings from filesystem inspection:

- /skogai has permissions drwxrwsr-x (setgid)
- Owned by user skogix, group skogai
- Group members: skogix,aur_builder,aldervall,dot,amy,claude,goose,skogai

The inferred architecture:

- SkogAI is a multi-agent system where AI agents (dot, amy, claude, goose) are actual Unix system users
- /skogai is a shared workspace, not a personal directory
- setgid ensures automatic group inheritance for seamless collaboration

The Workflow Being Demonstrated

1. QUESTIONS.md contained a list of unanswered "why" questions
2. One question was investigated and answered
3. The answer was:

- Added to ANSWERS.md (new file)
- Propagated upstream to skill docs (SKILL.md, dash-skogai.md)
- Removed from QUESTIONS.md and remaining items renumbered

Meta-Observations

- Discovery method matters: The answer explicitly notes it came from verifiable evidence (ls -la /, file, getent group) not user explanation
- Knowledge flows upward: Detailed answer in ANSWERS.md → distilled into essential_principles and multi_agent_architecture sections in skill references
- Documentation lives near code: The skill's reference docs get updated, not just standalone docs

This diff is essentially a worked example of the "discovery before definition" principle mentioned in the docs CLAUDE.md.
