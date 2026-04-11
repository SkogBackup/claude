<overview>
How @-linking works in Claude Code — the proactive import system for passing file contents and permissions to agents and subagents simultaneously. Critical when routing through workflows or dispatching subagents.
</overview>

<what_it_does>
`@path/to/file` in CLAUDE.md or a user message causes that file to be:

- Collected and cached at session start (proactive import — no active lookup needed)
- Available to read immediately
- Effectively `cat /path/to/file >> context`

**@ is the source of truth.** The Read tool often returns cached content. @ always expands from the real filesystem at prompt-time.
</what_it_does>

<where_it_works>
- **CLAUDE.md files** (global and project-level) — loaded at session start, up to six levels deep
- **User messages** — `@inbox.md` appended literally to the message; small changes show as git diff between cached and current version
- **Messages to subagents** — a message to a subagent is a user message in the backend; @ works the same way
</where_it_works>

<permissions>
@-linking is **both context AND permission** — it simultaneously:

1. Passes file contents into the prompt
2. Grants the agent permission to access that path

Permission rules:
- A file must have been @-linked actively by the user somewhere (directly or indirectly)
- Opening a session in a path approves reading in that directory
- @-linking something outside the session path triggers an additional approval prompt
- Subagents follow the same permission flow as the parent
- Dotfiles/folders follow restrictive rules (hidden by default)
- `.claude/settings.json` needs explicit linking despite being a settings file
</permissions>

<rules_for_agents>
**Always @-link files in messages to subagents.** A subagent cannot read files that haven't been linked. Treat @-links like function arguments.

| Context | Rule |
|---------|------|
| Subagent messages | @-link every file the subagent needs to read |
| Plan mode | Works against cached data only — if not @-linked or previously read, it doesn't exist |
| Glob/Grep in subagents | Only searches what's been cached/permitted — no @-link = no results, silently |
| Workflows | @-link referenced files when routing, not just naming them |

**Never assume a subagent can "just look it up."** No @-link = no access, with no error to indicate why.
</rules_for_agents>

<known_unknowns>
- **Recursive depth:** Works six levels deep (last confirmed)
- **Memory files:** Likely do NOT support @ unless linked from elsewhere first
- **Globs:** Only `@a`, `@~/`, `@/`, `@./` — no wildcard patterns
- **Resolution:** Relative to the file being read; pwd for user messages
- **Guarantee:** A @-link is a "please read" not a contract — not guaranteed to be included in context if limits are exceeded
</known_unknowns>
