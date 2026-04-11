---
name: Use project venvs for Python execution
description: Always use project-specific venv Python interpreters, never system pip install
type: feedback
---

Use project-specific venv Python for running code (e.g. `/tmp/brain-mcp/.venv/bin/python`). Never use system `pip install` or `python -m pip install`.

**Why:** Skogix uses uv and project venvs exclusively. System pip installs are not welcome.

**How to apply:** When testing Python code in a project, find the `.venv/bin/python` first. Use `PYTHONPATH=` override if testing source tree changes against an installed venv.
