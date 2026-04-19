# linear session ebdf03b9 — sko-183

- Date: 2026-04-19
- Issue: SKO-183 Remove Small Hours text from start page
- Repo edited: `/home/skogix/dev/small-hours`

## Summary

Implemented the requested start page text removal in `public/index.html`:

- Removed visible `Small Hours` heading (`<h1 class="title">Small Hours</h1>` block)
- Removed footer line `Party games best played in the small hours`

Kept logo image and subtitle intact.

## Validation

- Ran targeted frontend test:
  - `npm --prefix /home/skogix/dev/small-hours test -- tests/frontend/card-renderer.test.js`
  - Result: pass (16 tests)

## Git

- Local commit created in `small-hours` repo:
  - `c16345e`
  - `fix: remove small hours text from start page`
- Push failed due missing SSH agent/authentication in this session:
  - `Permission denied (publickey)`
