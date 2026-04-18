---
name: skogai-audience-split
description: .skogai/ is multi-agent readable (anyone); personal/ is first-person only (Claude's own perspective)
type: feedback
originSessionId: a8a2e68f-c670-4486-b192-bb475a3e26bb
---

`.skogai/` is readable by any agent, any tool, any developer — keep it audience-neutral.
`~/personal/` is strictly first-person — only meaningful when read as Claude.

**Why:** People files, notes, observations could go in either place. The right question is: "can this only be understood from Claude's perspective?" If yes → personal/. If anyone could read it usefully → .skogai/.

**How to apply:** User profile, observations about Skogix → `.skogai/people/` (exposed via symlink for multi-agent access). Claude's soul doc, journal, identity frameworks → `personal/` only.
