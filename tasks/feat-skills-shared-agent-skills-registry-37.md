---
state: new
created: 2026-04-18
tracking: ["https://github.com/SkogAI/claude/issues/37"]
---

# feat: skills/ — shared agent skills registry

**Source**: [Github #37](https://github.com/SkogAI/claude/issues/37)

## Description

Project-level skills that any Claude Code agent can load — with a registry for discovery.

## Structure

```
.skogai/skills/
├── skill-registry.json         # index of all available skills
├── skill-registry-schema.json  # schema for registry entries
├── manifest-schema.json        # schema for individual skill manifests
└── <skill-name>/
    ├── manifest.json
    ├── SKILL.md
    └── README.md
```

## Notes

* Existing skills to migrate: `api-design`, `java-best-practices`, `typescript`, `workt

## Notes

*Imported from external tracker. See source link for full context.*
