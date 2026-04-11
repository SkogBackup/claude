---
name: feedback-at-linking
description: How @-linking works in CLAUDE.md — it's context injection + permission granting, not just documentation
type: feedback
---

@-links in CLAUDE.md files are context injection, not hyperlinks. `@path/to/file` causes the file to be cached and available from session start. This means CLAUDE.md router design is really context budget design.

**Why:** Understanding this is critical for the home directory project. Every @-link in a CLAUDE.md is a "please preload this" — too many and you blow the context budget before work starts (the Context Destruction Pattern). Too few and you lose identity continuity.

**How to apply:**
- When designing CLAUDE.md routers, think "what should be pre-cached" not "what should I document"
- @-links in subagent messages are mandatory — subagents can't read files that haven't been @-linked
- @-links work 6 levels deep in CLAUDE.md chains
- Plan mode only sees cached/@-linked data
- This is both context AND permission — no @-link = file doesn't exist for that session/agent
