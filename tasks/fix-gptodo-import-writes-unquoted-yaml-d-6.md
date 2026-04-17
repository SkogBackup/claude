---
state: new
created: 2026-04-17
tracking:
  - https://github.com/SkogAI/dot-skogai/issues/6
tags:
  - bug
  - github
permalink: claude/tasks/fix-gptodo-import-writes-unquoted-yaml-d-6
---

# fix(gptodo): import writes unquoted YAML dates in created field

**Source**: [Github #6](https://github.com/SkogAI/dot-skogai/issues/6)

## Description

## Bug

`gptodo import` writes `created: 2026-03-06` in task frontmatter. YAML parses this as a date object, not a string. `gptodo check` then fails with:

```
Field created must be str or datetime
```

## Expected

```yaml
created: "2026-03-06"
```

## Actual

```yaml
created: 2026-03-06
```

## Workaround

```bash
sed -i 's/^created: \([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)$/created: "\1"/' tasks/*.md
```

## Fix

Quote the date string when writing frontmatter in the import command.

## Notes

*Imported from external tracker. See source link for full context.*
