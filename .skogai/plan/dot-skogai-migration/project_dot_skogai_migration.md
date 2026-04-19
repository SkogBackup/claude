---
name: dot-skogai migration
description: SkogAI/dot-skogai is being deprecated and merged into SkogAI/claude under .skogai/
type: project
originSessionId: dc66de70-7269-47af-8513-e3c3ce1ba719
---

`SkogAI/dot-skogai` is being consolidated into `SkogAI/claude` under the `.skogai/` directory.

**Why:** The skogfences principle — shared agent infrastructure belongs in the shared home, not a separate repo. `.skogai/` in claude's home is that space.

**Status (2026-04-17):** Migration planned, not yet executed. Linear issues created (SKO-155 epic + 12 child issues) to track each component.

**How to apply:** When working on `.skogai/` content, treat dot-skogai's existing files as source material to migrate — don't create new issues in the dot-skogai repo.

**Components to migrate:**

- SKOGAI.md (root context router) — SKO-161
- knowledge/, memory/, plan/, tasks/, templates/ — SKO-162–166
- scripts/context/, scripts/bootstrap/ — SKO-167–168
- email/, workflows/, bin/, skills/ — SKO-169–172
