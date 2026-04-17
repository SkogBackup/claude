---
name: navigate-skogai
description: Use this to *ALWAYS* when trying to navigate any SkogAI projects, documentation or configuration. Use when exploring the SkogAI ecosystem or anything SkogAI-related.
permalink: claude/lab/projects-in-development/navigate-skogai/navigate-skogai/skill
---

\<essential_principles>

SkogAI is a multi-agent collaboration system where both humans (skogix, aldervall) and AI agents (dot, amy, claude, goose) operate as system users. `/skogai` exists at root level with setgid permissions, making it a shared workspace where files automatically inherit group ownership. This enables seamless collaboration between agents and humans without permission friction.

**Knowledge philosophy:**

- real knowledge explains WHY/HOW/WHEN, not WHAT/WHERE
- directory listings teach nothing
- design rationale, historical context, architectural intent = valuable
- always verify with user before adding new knowledge to this skill

\</essential_principles>

<intake>

What do you need?

1. Navigate to **/skogai** (dash-skogai) - main ecosystem
1. Navigate to **.skogai** (dot-skogai) - project-specific metadata
1. Update this skill with new knowledge

**Intent-based routing:** If context is clear, route directly. Otherwise ask.

</intake>

<routing>

| Response                                          | Action                                |
| ------------------------------------------------- | ------------------------------------- |
| 1, "/skogai", "dash-skogai", "main", "root level" | Load `references/dash-skogai.md`      |
| 2, ".skogai", "dot-skogai", "project", "metadata" | Load `references/dot-skogai.md`       |
| 3, "update", "add knowledge", "fill [@todo]"      | `workflows/update-skill-knowledge.md` |

**Progressive disclosure:** References load only navigation info needed. Detailed methodology in dev/ folder.

</routing>

\<reference_index>

## Navigation References

All in `references/`:

**/skogai (dash-skogai):** dash-skogai.md - root-level shared workspace **.skogai (dot-skogai):** dot-skogai.md - project-specific configuration

\</reference_index>

\<workflows_index>

## Workflows

All in `workflows/`:

| Workflow                  | Purpose                                              |
| ------------------------- | ---------------------------------------------------- |
| update-skill-knowledge.md | Add verified knowledge to skill with user checkpoint |

\</workflows_index>

\<success_criteria>

Navigation is successful when:

- user finds what they need based on intent, not menu selection
- only relevant reference content is loaded (progressive disclosure)
- file naming conventions are understood (dash/dot prefixes)
- architectural reasoning is clear (not just "what's in this folder")

Skill maintenance is successful when:

- new knowledge added only after user checkpoint review
- focus on design rationale, not directory listings
- [@todo] markers replaced with verified knowledge only

\</success_criteria>
