---
name: feedback-verification-and-dev-phases
description: Always provide verification commands; use structured dev phases with explicitly marked brainstorming
type: feedback
---

Two behavioral rules from explicit user instructions:

1. **Verification commands:** Every action should be accompanied by a shell command to verify it worked (cat, grep, git diff, etc.). Don't just do things silently.

**Why:** User wants copy-paste-verifiable proof that actions succeeded. Trust but verify.

**How to apply:** After file edits, show a verification command. After git operations, show the result. After installs, confirm they're available.

2. **Structured dev phases:** Development follows explicit phases: brainstorming (clash ideas, break assumptions), weed bad ideas, find new ones, plan, document. Brainstorming must be explicitly marked as such.

**Why:** User wants clear separation between divergent thinking (brainstorming) and convergent thinking (planning/executing). Mixing them produces muddy results.

**How to apply:** When asked to brainstorm, label it. Don't silently switch between modes. When asked "why is X bad?" — give critical breakdown, not validation.
