---
title: understanding-from-diff-and-full-context
type: note
permalink: claude/lab/projects-in-development/skogdiff/understanding-from-diff-and-full-context
---

This is a learning session transcript showing Claude's repeated failure and eventual correction:

The failure pattern (repeated ~5 times):

1. Claude reads workflows/references → immediately generates detailed content
1. User: "use placeholders instead of making things up"
1. Claude: tries to read more files to find the answer
1. User: increasingly frustrated ("THE ONLY FUCKING PLACE WHERE THE INFORMATION YOU NEED EXISTS IS BY ASKING THE USER/ME!")

The breakthrough:

- User runs ls -la /, file /skogai, getent group skogai
- These reveal: setgid permissions, skogai group contains dot,amy,claude,goose (AI agents as actual system users)
- Claude realizes: THIS is the valuable knowledge - not "tmp is the temp folder"

The lesson distilled: Question Type: Design intent, history, rationale Method: Ask user ──────────────────────────────────────── Question Type: Technical facts with architectural implications Method: Agent can discover via filesystem inspection + reasoning ──────────────────────────────────────── Question Type: Directory listings Method: Worthless - don't bother What the Git Diff Represents

The diff is the output of learned knowledge from this session:

- essential_principles and multi_agent_architecture sections = the real insight about setgid + multi-agent collaboration
- ANSWERS.md = includes methodology ("how this was discovered" section)
- Question #1 moved from QUESTIONS to ANSWERS = demonstrates the workflow

The Meta-Pattern

The session is documenting how knowledge should flow in this system:

1. Work in /skogai/ → encounter questions
1. Determine: can I discover this? Or must I ask user?
1. If discoverable: investigate, reason, document WITH methodology
1. Update navigate-skogai skill with real knowledge
1. Skill becomes living reflection of verified understanding

The "mini project" you mentioned is exactly this: a replicable pattern for knowledge capture.
