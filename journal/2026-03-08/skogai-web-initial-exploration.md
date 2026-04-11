# skogai-web initial exploration & automation planning

## what happened
First session in the skogai-web monorepo. Explored both sub-projects (skogai-blog photography portfolio, skogai-intro MOJJU landing page), created CLAUDE.md, connected Supabase MCP, and ran the automation recommender.

## key discoveries
- Two Lovable-generated apps with completely separate Supabase instances and git repos
- Intro project has 23 seeded posts driving all CMS content via JSONB metadata
- Blog has a Pexels API fallback when DB is empty (hardcoded API key — security issue)
- Zero CI/CD infrastructure: no tests, no hooks, no GitHub Actions
- Commit conventions exist in .skogai/ docs but nothing enforces them

## automation recommendations generated
- context7 MCP for live docs (shadcn, Supabase SDK, React Query)
- Pre-commit hooks: block .env edits, block auto-generated types.ts edits
- Skills: create-migration, dev-both (parallel commands across apps)
- Subagents: ui-reviewer, security-reviewer

## next steps
- Plan and implement pre-commit hooks + CI/CD gitflow (user's request, deferred to next session)
- Consider adding blog's Supabase project as second MCP server
- Move Pexels API key to env var
