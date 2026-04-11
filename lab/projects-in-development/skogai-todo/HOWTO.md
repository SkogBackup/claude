# skogai-todo howto

quick practical guide for using taskwarrior to manage skogai work.

## setup

```bash
cd /skogai/.worktrees/skogai-todos/dev/skogai-todo

# use wrapper script (easiest)
./t ready

# or add to PATH for global access
export PATH="/skogai/.worktrees/skogai-todos/dev/skogai-todo:$PATH"
t ready

# or use taskwarrior directly
task rc:./taskrc ready

# or alias in shell config
alias t='task rc:/skogai/.worktrees/skogai-todos/dev/skogai-todo/taskrc'
```

## daily workflow

```bash
# what should i work on?
t ready

# what's blocked?
t waiting

# what am i currently doing?
t active

# start work on task 3
t 3 start

# finish it
t 3 done

# stop working on it (pause)
t 3 stop
```

## creating tasks

```bash
# simple
t add "fix n+1 query in users controller"

# with priority and tags
t add "implement dark mode" priority:H +feature +ui

# with project
t add "refactor csv export" project:skogai priority:M +refactor

# with dependencies (do task 5 after task 3)
t add "write tests for auth" depends:3
```

## priority levels

- `priority:H` - high (critical, blocking, bugs)
- `priority:M` - medium (important features, refactors)
- `priority:L` - low (nice-to-have, polish)

## tags (suggested)

- `+bug +feature +refactor +docs +test`
- `+rails +ui +api +db +perf`
- `+blocked` (waiting on external)

## querying

```bash
# high priority pending work
t status:pending priority:H

# all rails-related
t +rails

# bugs only
t +bug status:pending

# specific project
t project:skogai status:pending

# json export for scripting
t export project:skogai | jq
```

## dependencies

```bash
# task 5 depends on tasks 2 and 3
t 5 modify depends:2,3

# what blocks task 5?
t 5 info

# what does task 2 block?
t +BLOCKING id:2

# see all blocked work
t waiting
```

## modifications

```bash
# change priority
t 3 modify priority:H

# add tags
t 3 modify +urgent +rails

# remove tags
t 3 modify -refactor

# change description
t 3 modify "new description here"

# add project
t 3 modify project:skogai

# add annotation (notes)
t 3 annotate "found root cause in user.rb:234"
```

## advanced

```bash
# undo last action
t undo

# edit task in $EDITOR
t 3 edit

# delete task (marks as deleted, not destroyed)
t 3 delete

# show all info about task
t 3 info

# custom filter + count
t +bug status:pending count

# burndown (requires install)
t burndown.daily

# summary
t summary

# stats
t stats
```

## scripting examples

```bash
# export to json
t export status:pending project:skogai > work.json

# get next task id
NEXT_ID=$(t add "new task" | grep -oP 'Created task \K\d+')

# mark all +refactor as low priority
t +refactor modify priority:L

# list ready work for claude
t ready rc.verbose=nothing rc.report.ready.columns=id,description
```

## workflow patterns

### code review → todos

```bash
# during review, capture findings
t add "fix error handling in auth" priority:H +bug +rails
t add "extract payment logic" priority:M +refactor depends:12
t add "add validation tests" priority:M +test depends:12
```

### feature development

```bash
# plan feature
t add "implement oauth login" priority:H +feature +auth
t add "add oauth tests" priority:H +test depends:15
t add "update oauth docs" priority:L +docs depends:15,16

# work through them
t ready      # shows task 15
t 15 start
# ... do work ...
t 15 done
t ready      # now shows tasks 16 (unblocked)
```

### triage pending work

```bash
# see all pending
t status:pending

# prioritize critical items
t +bug modify priority:H

# defer low-value work
t +nice-to-have modify priority:L

# identify dependencies
t 5 modify depends:3
```

## integration with git

```bash
# reference tasks in commits
git commit -m "fix n+1 query (task 3)"

# complete task after merge
t 3 done
t 3 annotate "merged in commit abc123"
```

## tips

- use `t ready` as your default "what's next?" command
- `t active` shows what you're currently working on
- dependencies automatically block/unblock work
- annotations are great for linking to commits/PRs
- export to json for scripting/automation
- tags are free-form - use what makes sense
- priority affects urgency scoring for smart sorting

## migration from old system

```bash
# old markdown todos → taskwarrior
grep "^# " todos/001-ready-p1-fix-mailer.md | head -1  # get title
t add "fix mailer test" priority:H +bug +rails

# bulk import from old system
for f in todos/*-ready-*.md; do
  DESC=$(basename "$f" | cut -d'-' -f4- | sed 's/.md$//' | tr '-' ' ')
  PRI=$(echo "$f" | grep -oP 'p\d' | tr 'p123' 'HML')
  t add "$DESC" priority:$PRI
done
```

## config location

- config: `./taskrc`
- data: `./.taskdata/` (gitignored)
- hooks: `./hooks/` (optional automation)

all task commands must use `rc:./taskrc` or alias `t` to point to it.
