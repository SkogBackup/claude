# gptme-contrib team mapping — first real agent team run

## what happened

Mapped the entire gptme-contrib monorepo (76K lines, 493 files, 12 packages, 13 plugins, 7 skills) into a reusable Claude Code skill at `skills/gptme/`. Used Claude Code Agent Teams (TeamCreate + Agent tool) to parallelize the work across 5 agents.

## the team

- **core-packages** (blue) — gptodo, gptme-sessions, gptme-runloops. Delivered 3 thorough references. Found Thompson sampling bandits in sessions, no tests in any core package.
- **comm-packages** (green) — gptmail, gptme-voice, gptme-whatsapp. Fast delivery. Key finding: gptme-whatsapp has full native CC backend support.
- **util-packages** (yellow) — gptme-contrib-lib, activity-summary, dashboard, lessons-extras. Got stuck on cold-start, needed explicit step-by-step nudge to unblock. Eventually delivered all 4.
- **plugins-mapper** (purple) — all 13 plugins. First to finish. Deep dives on gptme-claude-code bridge and gptme-gptodo coordinator pattern.
- **skills-scripts** (orange) — skills, scripts, tools, dotfiles. Found Linear Agent Framework in scripts/, 9 script categories total.

Coordinator (me) handled tasks 6-7: claude-code integration reference and final SKILL.md synthesis.

## learnings

1. **Agent cold-start**: `util-packages` went idle 3 times before actually starting work. Explicit step-by-step instructions with "use the Read tool on X right now" unblocked it. Other agents started immediately from their prompts.

2. **Team overhead is worth it for breadth**: 5 agents read ~286 Python files in parallel in ~10 minutes. Sequential would have burned through context reading all that source.

3. **Coordinator pattern works**: I didn't read any source files myself — agents did all the reading, I synthesized their findings into the integration reference. Matches the gptme-runloops TeamRun design.

4. **Shutdown dance**: Agents sometimes miss or delay shutdown requests. Need to send shutdown, wait for approval, then TeamDelete. The idle notifications between are noise — just wait.

## key technical findings

- **CLAUDECODE env stripping** is THE critical pattern for CC nesting — appears in 3 separate packages
- **gptme-whatsapp** has the most complete CC integration (--resume, --append-system-prompt-file, stdin closing)
- **Thompson sampling** in gptme-sessions is surprisingly sophisticated — contextual arms, hierarchical fallback, graded rewards
- **No tests exist** for the 3 core packages (gptodo, gptme-sessions, gptme-runloops)
- **CC backend limitation**: can't restrict tools, so TeamRun coordinator gets full capabilities instead of gptodo-only

## deliverables

- `skills/gptme/SKILL.md` — 113-line router
- 14 reference files in `skills/gptme/references/` — 2,289 lines total
- Committed and pushed as `cf3acc8` (skill) + `01f59c8` (cache refresh)

## also this session

- Fixed CLAUDE.md routing chain (previous session's work verified)
- Created `.skogai/.worktrees → .claude/worktrees` symlink for gptodo
- Explored gptodo spawn/worktree, gptme-sessions signals/post-session, gptme-runloops help
- Created 10 audit tasks for @-link review in auto-load chain
- Tested gptodo worktree create + spawn (spawn broken, symlink fixed)
