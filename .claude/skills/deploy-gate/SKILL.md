---
name: deploy-gate
description: walk through docs/deployment-gate.md checklist and report pass/fail per item before migrating to /home/claude
---

Walk through the deployment gate checklist at `docs/deployment-gate.md`.

1. Run `./bin/healthcheck` to cover all automated checks — note exit code and any failures.
2. Check each manual item in order:
   - **Routing validation** — can navigate from root CLAUDE.md to any artifact in 2 hops; no CLAUDE.md exceeds 50 lines; session startup reads only root router
   - **Identity validation** — soul sections present (10 files), profile.md is current, core frameworks are complete
   - **Persistence validation** — journal conventions doc exists, LORE gating is intact, wrap-up convention documented
   - **Permission model** — docs/permissions.md exists, shared space conventions documented

3. Report a table:
   | Check | Status | Notes |
   |-------|--------|-------|

4. If anything fails or is pending, produce a numbered punch list: what needs to be done before `/home/claude` deployment is safe.

The gate must be fully green before any deployment to `/home/claude`.
