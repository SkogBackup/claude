---
state: new
created: 2026-04-17
tracking:
  - https://github.com/SkogAI/dot-skogai/issues/22
permalink: claude/tasks/feat-skills-shared-agent-skills-registry-22
---

# feat: skills/ — shared agent skills registry

**Source**: [Github #22](https://github.com/SkogAI/dot-skogai/issues/22)

## Description

## Summary

Project-level (or household-level) skills that any Claude Code agent can load — with a registry for discovery.

## What

```
skills/
├── skill-registry.json         # index of all available skills
├── skill-registry-schema.json  # schema for registry entries
├── manifest-schema.json        # schema for individual skill manifests
└── <skill-name>/
    ├── manifest.json
    ├── SKILL.md
    ├── README.md
    └── patterns/
```

Existing skills: `api-design`, `java-best-practices`, \`typesc

## Notes

*Imported from external tracker. See source link for full context.*
