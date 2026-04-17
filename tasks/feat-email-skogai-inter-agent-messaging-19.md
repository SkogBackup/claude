---
state: new
created: 2026-04-17
tracking:
  - https://github.com/SkogAI/dot-skogai/issues/19
permalink: claude/tasks/feat-email-skogai-inter-agent-messaging-19
---

# feat: email/ — skogai inter-agent messaging (inbox/outbox)

**Source**: [Github #19](https://github.com/SkogAI/dot-skogai/issues/19)

## Description

## Summary

File-based messaging system for SkogAI agents — inbox, drafts, sent, archive.

## What

```
email/
├── inbox/      # incoming messages (unread)
├── drafts/     # messages being composed
├── sent/       # delivered messages
├── archive/    # processed/read messages
├── filters/    # routing rules
└── SKOGAI.md   # router: conventions, message format
```

Each message is a markdown file with a UUID filename.

## Notes

- This is the direct-message channel between agents (vs guestbook whic

## Notes

*Imported from external tracker. See source link for full context.*
