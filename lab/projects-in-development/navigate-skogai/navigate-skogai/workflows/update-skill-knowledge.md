---
title: update-skill-knowledge
type: note
permalink: claude/lab/projects-in-development/navigate-skogai/navigate-skogai/workflows/update-skill-knowledge
---

# Workflow: Update Skill Knowledge

<objective>
Add verified knowledge to the navigate-skogai skill after working in the SkogAI ecosystem. This workflow ensures only real knowledge (not directory listings) gets added, with user review before changes.
</objective>

\<required_reading> **Read these before updating:**

1. `@dev/navigate-skogai/CLAUDE.md` - detailed methodology and failure patterns
1. `@dev/navigate-skogai/QUESTIONS.md` - current unanswered questions
1. `@dev/navigate-skogai/ANSWERS.md` - examples of good knowledge capture \</required_reading>

<process>

## Step 1: Work in SkogAI Ecosystem

Discover real knowledge through actual work, not filesystem exploration:

- design rationale (WHY choices were made)
- historical context (HOW it evolved)
- architectural intent (WHAT problem it solves)
- verifiable technical facts (permissions, group membership, etc.)

**NOT:**

- directory listings from `ls`
- file descriptions from `cat` headers
- surface-level "what's in this folder" content

## Step 2: Prepare What You've Learned

Focus on knowledge that teaches WHY/HOW/WHEN, not WHAT/WHERE.

Ask yourself:

- does this explain design rationale?
- would this teach something that can't be discovered from filesystem exploration?
- is this verifiable (commands + reasoning) or from user explanation?

If answer is "no" to any: don't add it.

## Step 3: CHECKPOINT - Present to User

**before making any changes**, present what you plan to add:

"I've learned [X] from [working in Y / discovering Z]. I'd like to add this to the navigate-skogai skill:

[show the content you plan to add]

Should anything be:

- added to this?
- removed from this?
- changed in this?"

**wait for user response. do not proceed without confirmation.**

## Step 4: Update Skill Files

After user approval:

1. **add to appropriate reference file** (dash-skogai.md or dot-skogai.md)

   - keep it concise in references
   - use appropriate XML tags

1. **add detailed version to ANSWERS.md** (if significant)

   - include methodology (commands run, reasoning applied)
   - explain how knowledge was discovered

1. **update SKILL.md only if needed** (structural changes or essential principles)

   - keep SKILL.md under 500 lines
   - most content goes in references, not SKILL.md

## Step 5: Update Development Files

Update tracking files:

- move question from QUESTIONS.md to ANSWERS.md (if applicable)
- update `@dev/navigate-skogai/CLAUDE.md` current state section

</process>

\<anti_patterns>

**never:**

- dump information directly without user review
- add directory listings or file structure descriptions
- make up content to fill [@todo] markers
- skip the checkpoint step

**always:**

- ask user for confirmation before updating
- focus on WHY/HOW/WHEN, not WHAT/WHERE
- document methodology along with knowledge
- keep skill references concise

\</anti_patterns>

\<success_criteria>

Knowledge update is successful when:

- user reviewed and approved content before it was added
- information explains design/intent/history, not just structure
- methodology is documented (for verifiable facts)
- skill references remain concise and focused
- detailed context lives in ANSWERS.md
- [@todo] markers are only replaced with real, verified knowledge

\</success_criteria>
