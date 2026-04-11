# Zellij Research & Migration Plan

Personal planning doc for transitioning from tmux to zellij, with focus on agent/session-sharing workflows.

## Goals

- Replace tmux with zellij as primary multiplexer
- Command-driven interaction (CLI over keybinds for automation)
- Session sharing for AI agents and collaboration via web client
- Integrate with existing infra (cloudflare/wireguard/tunneling)

---

## Phase 1: Current State Audit

### Keybindings outside multiplexers

Document what's already claimed to avoid conflicts:

| Context          | Prefix/Keys           | Notes |
| ---------------- | --------------------- | ----- |
| i3               | `$mod+...`            |       |
| nvim             | `<leader>`, `<C-...>` |       |
| kitty/alacritty  |                       |       |
| shell (zsh/bash) |                       |       |

**Action:** Run through a session noting any `Ctrl+<key>` combos you rely on heavily.

### Current tmux patterns worth preserving

- [ ] Session naming conventions
- [ ] Layout habits (how many panes, typical arrangements)
- [ ] Any scripts/aliases that wrap tmux commands
- [ ] Remote-specific vs local-specific usage patterns

---

## Phase 2: Zellij Fundamentals

### Config basics

- [ ] Locate default config: `zellij setup --dump-config > ~/.config/zellij/config.kdl`
- [ ] Learn KDL syntax basics (it's minimal, won't take long)
- [ ] Understand config structure: keybinds, themes, plugins, options

### Modal system

Zellij uses modes rather than a prefix key:

| Mode    | Purpose                   | Default entry |
| ------- | ------------------------- | ------------- |
| Normal  | Default, pane interaction | `Esc`         |
| Pane    | Pane management           | `Ctrl+p`      |
| Tab     | Tab management            | `Ctrl+t`      |
| Resize  | Resize panes              | `Ctrl+n`      |
| Scroll  | Scrollback/copy           | `Ctrl+s`      |
| Session | Session management        | `Ctrl+o`      |
| Locked  | Pass all keys through     | `Ctrl+g`      |

- [ ] Spend time in each mode, understand transitions
- [ ] Decide: adapt to modes or remap to prefix-style?

### Panes, tabs, sessions hierarchy

```
Session
└── Tab (like tmux windows)
    └── Pane (splits within a tab)
```

- [ ] Practice: create/close/navigate panes
- [ ] Practice: create/close/rename tabs
- [ ] Practice: detach/attach/list sessions

### Layouts

- [ ] Explore built-in layouts: `zellij --layout <name>`
- [ ] Create a custom layout file for typical workspace
- [ ] Understand layout file syntax

### Floating panes

New concept vs tmux:

- [ ] Toggle floating: `zellij action toggle-floating-panes`
- [ ] Create floating: `zellij run --floating -- <cmd>`
- [ ] Evaluate: useful for agent output? temporary tasks?

---

## Phase 3: CLI & Scripting (Agent Use Case)

### Core commands to master

```bash
# Session management
zellij -s <name>                      # create/attach
zellij list-sessions
zellij attach <name>
zellij kill-session <name>
zellij delete-session <name>

# Running commands
zellij run -- <cmd>                   # new pane
zellij run --floating -- <cmd>        # floating pane
zellij run --in-place -- <cmd>        # replace current

# Actions (operate on focused session)
zellij action new-pane
zellij action new-pane --direction <down|right|up|left>
zellij action focus-next-pane
zellij action move-focus <direction>
zellij action close-pane
zellij action write-chars "<text>"
zellij action write <byte>            # 10 = Enter, 3 = Ctrl+C
zellij action dump-screen
zellij action dump-layout
zellij action toggle-floating-panes
```

- [ ] Build a cheatsheet of commands for agent use
- [ ] Test `dump-screen` output format — what exactly comes back?
- [ ] Test `dump-layout` — useful for session state?

### Limitations to understand

- [ ] Pane targeting: no `-t session:tab.pane` equivalent — how to work around?
- [ ] Focus requirements: actions need session focus — implications for multi-session agent work?
- [ ] Scrollback access: `dump-screen` = viewport only. Full history options?

### Pipe & plugin system

Escape hatch for advanced automation:

- [ ] Read plugin docs: <https://zellij.dev/documentation/plugins>
- [ ] Understand `zellij pipe` basics
- [ ] Evaluate: needed for your use case or overkill?

---

## Phase 4: Web Client & Session Sharing

### Basic usage

```bash
zellij -s myagent --web --web-port 7777
# Access at http://localhost:7777/sessions/myagent
```

- [ ] Test locally, verify it works with your terminal fonts/colors
- [ ] Test from another device on LAN

### Browser limitations to check

- [ ] Key combos that browsers intercept (Ctrl+W, Ctrl+T, etc.)
- [ ] Copy/paste behavior
- [ ] Performance/latency feel
- [ ] Mobile browser usability (if relevant)

### Integration with your infra

- [ ] Cloudflare tunnel to expose securely
- [ ] Auth layer (cloudflare access? nginx basic auth? custom?)
- [ ] Verify websocket passthrough works

### Agent interaction patterns

- [ ] Agent connects via web vs agent has shell access — different approaches?
- [ ] How does an agent know when command output is "done"?
- [ ] Conventions: dedicated pane for agent? naming? layout?

---

## Phase 5: Integration Points

### Nvim terminal vs zellij panes

Current approach:

- [ ] Document when you use `:terminal` vs multiplexer splits
- [ ] Decide if this changes with zellij

### Environment variables

- [ ] Test `SSH_AUTH_SOCK` behavior on reattach
- [ ] Test `EDITOR`, `VISUAL` propagation
- [ ] Any custom env vars your workflow depends on?

### Kitty/Alacritty interaction

- [ ] Zellij scrollback vs terminal scrollback — clear on the boundary?
- [ ] Kitty graphics protocol passthrough — working?
- [ ] True color — just verify it works

---

## Phase 6: Migration Steps

### Parallel running period

- [ ] Keep tmux config intact
- [ ] Use zellij for local work, tmux for remote initially (or vice versa)
- [ ] Note friction points and missing features

### Config to build

- [ ] Keybindings that match muscle memory where sensible
- [ ] Theme that matches terminal theme
- [ ] Default layout for agent sessions
- [ ] Aliases/scripts for common operations

### Retire tmux

- [ ] Identify last blockers
- [ ] Archive tmux config
- [ ] Update any automation/scripts that assumed tmux

---

## Resources

- Zellij docs: <https://zellij.dev/documentation/>
- Zellij GitHub: <https://github.com/zellij-org/zellij>
- KDL spec: <https://kdl.dev/>
- Config examples: <https://github.com/zellij-org/zellij/tree/main/example>

---

## Notes & Discoveries

_Running log as you work through this:_

- example token: token_1: f6e8a7c7-c66e-4761-92c4-02a1686b830b
