---
state: new
created: 2026-04-18
tracking: ["https://github.com/SkogAI/claude/issues/34"]
---

# feat: email/ — skogai inter-agent messaging (inbox/outbox)

**Source**: [Github #34](https://github.com/SkogAI/claude/issues/34)

## Description

File-based messaging system for SkogAI agents — inbox, drafts, sent, archive.

## Structure

```
.skogai/email/
├── inbox/      # incoming messages (unread)
├── drafts/     # messages being composed
├── sent/       # delivered messages
├── archive/    # processed/read messages
├── filters/    # routing rules
└── SKOGAI.md   # router: conventions, message format
```

Each message is a markdown file with a UUID filename.

## Notes

* Direct-message channel between agents (vs guestbook which is bro

## Notes

*Imported from external tracker. See source link for full context.*
