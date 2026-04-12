---
name: gptodo reinstall fix
description: gptodo breaks with ModuleNotFoundError when installed from local path — fix is uv tool upgrade --reinstall
type: reference
originSessionId: b1106a86-a2ae-42e7-bc55-964c73d5ec29
---
gptodo is installed from a local path (`gptme-contrib/packages/gptodo`) via `uv tool install`. When that package drifts or the environment gets stale, it breaks with:

```
ModuleNotFoundError: No module named 'gptodo'
```

Fix: `uv tool upgrade gptodo --reinstall`

The binary lives at `/mnt/sda1/uv-tools/gptodo/bin/gptodo`.
