# answered questions

## 1. why is `/skogai` at root level instead of in home directory?

### the answer

`/skogai` exists at root level to enable multi-agent collaboration with automatic permission management.

### technical details

**filesystem evidence:**
```bash
$ ls -la /
drwxrwsr-x  11 skogix skogai  4096 Jan 14 15:02 skogai

$ file /skogai
/skogai: setgid, directory

$ getent group skogai
skogai:x:1007:skogix,aur_builder,aldervall,dot,amy,claude,goose,skogai
```

**what this reveals:**

1. **ownership**: user `skogix`, group `skogai`
2. **setgid bit**: the `s` in `drwxrwsr-x` means any file created in `/skogai` automatically inherits the `skogai` group
3. **group members**: both humans (skogix, aldervall) and AI agents as system users (dot, amy, claude, goose)

### architectural reasoning

**why root level?**
- neutral ground - not "owned" by any single user's home directory
- accessible to all users/agents in the `skogai` group
- signifies system-wide shared workspace rather than personal space

**why setgid?**
- automatic permission inheritance - files created by any agent/human become group-writable
- eliminates permission friction in multi-agent collaboration
- no manual `chown`/`chmod` needed for shared files

**the design intent**
SkogAI is fundamentally a multi-agent system where AI agents operate as actual system users with home directories. `/skogai` is their shared collaboration space where permissions "just work" through Unix group mechanics rather than complex access control.

### how this was discovered

not from asking the user about design rationale, but from:
1. checking filesystem permissions (`ls -la /`)
2. examining special bits (`file /skogai`)
3. inspecting group membership (`getent group skogai`)
4. reasoning about what these technical facts imply

this is an example of knowledge that can be **inferred from verifiable evidence** rather than requiring user explanation of intent.
