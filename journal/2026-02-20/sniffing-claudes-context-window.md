# I sniffed my own AI's context window — here's what I found

after ~5000 hours working with claude code, i finally built the tooling to
see exactly what gets sent to the API on every message. turns out the context
window is way less "yours" than you think.

## the numbers

fresh session, before saying a single word:

| category | tokens | % of 200k |
|----------|--------|-----------|
| system prompt | 5,000 | 2.5% |
| system tools | 21,300 | 10.7% |
| MCP tools | 5,600 | 2.8% |
| memory/CLAUDE.md | 4,200 | 2.1% |
| skills | 179 | 0.1% |
| compact buffer | 3,000 | 1.5% |
| **total before "hi"** | **~36,000** | **18%** |

36k tokens gone. and that's *after* spending weeks trimming my own config
files down to ~4k.

## where it actually goes

**system tools: 21.3k** — the biggest surprise. every built-in tool (Bash,
Read, Edit, Grep, Glob, Write, Task, etc.) ships with a full JSON schema
and behavioral instructions. you also get tools you'll never use. i have a
Jupyter notebook editor loaded on every session despite never touching a
notebook in 5000 hours.

**MCP tools: 5.6k** — i had a chrome browser MCP auto-enabled without
realizing it. 18 tools at ~313 tokens each, plus the security instructions
baked into the system prompt telling claude not to click phishing links or
enter bank account numbers into forms.

**system prompt: 5k** — behavioral rules, git safety protocol, tone
instructions, security rules. you can't change any of this.

**my stuff: 4.2k** — the part i actually control and care about. CLAUDE.md
files, auto-memory, definitions.

## the bugs i found

### duplicate injection via symlinks

`~/.claude` was a symlink to `/skogai/config/claude/`. claude code loads the
global CLAUDE.md from both the symlink path *and* the resolved path — but
doesn't deduplicate. same 131 tokens injected twice.

fix: make `~/.claude` a real directory instead of a symlink.

### stale cached files

CLAUDE.md supports `@`-linking other files:
```
@~/docs/skogix/user.md
@~/docs/skogix/definitions.md
```

these get cached at some point and keep getting injected even if you delete
the source files. i had removed references to those files but they were still
showing up in the context — potentially weeks-old cached versions.

the only reliable "cache bust" i found: include `@filename` in your chat
message, which forces a fresh read.

### the invisible cost of "free" features

chrome MCP alone costs ~5.6k in tool schemas + an unknown chunk of the
system prompt for security rules. disabling it when you're not browsing
reclaims that instantly.

## how i did it

two approaches combined:

1. **traffic sniffing** — intercepting the outgoing API requests to see the
   raw payload. this shows you *exactly* what the model receives, no
   guessing.

2. **`/context` command** — claude code's built-in context usage breakdown.
   shows estimated token usage by category with a nice visual bar. not as
   precise as sniffing but gives you the overview at a glance.

3. **session diffing** — comparing the API payload against git diffs in
   claude's message history to identify what changed between turns.

the combination is what makes it powerful: `/context` tells you the budget,
traffic sniffing tells you the truth, and diffing tells you the delta.

## what i'm doing about it

migrating from a symlinked config dir to a real `~/.claude/` directory.
the plan:

- **keep**: session data, transcripts, plans, tasks, teams, memory,
  settings, keybindings, history, plugin configs
- **drop**: let claude code regenerate its managed files (internal state,
  credentials, debug logs, telemetry, caches, shell snapshots)
- **hard link**: files that need to be visible from multiple paths — no more
  symlink resolution weirdness

every item tracked as a separate issue in beads for granular progress.

## takeaways

1. **you're paying ~36k tokens before typing anything.** on a 200k window
   that's 18%. on a model with effective quality around 16k tokens, that's
   more than double your useful context burned on overhead.

2. **disable MCPs you're not using.** each one adds tool schemas that eat
   context on every single message.

3. **symlinks in config dirs cause duplicate injections.** use real
   directories or hard links.

4. **`@`-linked files in CLAUDE.md get cached and can go stale.** be aware
   that what you see in your files isn't necessarily what the model sees.

5. **build observability into your AI tooling.** you can't optimize what you
   can't measure. the moment i could see the actual payload, i found three
   bugs in ten minutes.
