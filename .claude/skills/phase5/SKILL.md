---
name: phase5
description: Load full Phase 5 (skogai-live-chat-implementation) context — decisions, architecture, routing stack, known bugs. Use when working on chat-io, skogparse routing, or [@agent:"msg"] implementation.
---

Load and summarize the Phase 5 context from the planning directory. Read these files in order:

1. @.planning/phases/05-skogai-live-chat-implementation/05-CONTEXT.md — decisions (D-01–D-10), architecture, known bugs, canonical refs
2. @.planning/phases/05-skogai-live-chat-implementation/05-HANDOVER.md — contract definition, open questions
3. @.planning/phases/05-skogai-live-chat-implementation/05-01-PLAN.md — Wave 1 plan: chat-io contract spec + routing script
4. @.planning/phases/05-skogai-live-chat-implementation/05-02-PLAN.md — Wave 2 plan (if needed)

After reading, provide a focused summary:

- Current phase status and what's been built vs pending
- Key decisions the user needs to respect (especially D-01 through D-06)
- Active files to work with (bin/route-message.sh, docs/chat-io-contract.md, lab/fakechat/server.ts)
- Known pitfalls: skogparse.sh wrong path, inline operator routing exclusion, JSON envelope unwrapping

If plan files reference artifacts that should exist (bin/route-message.sh, docs/chat-io-contract.md), check whether they're present and report status.
