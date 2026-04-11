# getting-gptme-back-up-again

<what_is_this>
Project to setup gptme and related tooling in a way that makes sense, with clear understanding of why things work the way they do.
</what_is_this>

<goals>
- Setup gptme properly
- Understand the architecture and dependencies
- Document why things work the way they do
- Create a maintainable configuration
</goals>

## What is gptme?

**gptme** is an open-source AI agent platform designed as a terminal-first CLI that empowers LLMs to autonomously perform complex tasks. Created in Spring 2023, it's one of the first agent CLIs and remains actively developed.

**Core concept**: "Personal AI agent in your terminal" - A general-purpose coding agent with terminal access, code execution, file editing, web browsing, and extensible capabilities.

**Key characteristics**:
- Free and open source (local-first alternative to Claude Code, Cursor, Copilot)
- Multi-LLM support (OpenAI, Anthropic, OpenRouter, custom providers, local models)
- Terminal-first with web UI available
- Highly extensible via plugins, tools, hooks, and commands

## Architecture: Why it Works This Way

gptme's architecture is built around **5 core extensibility mechanisms** that work together:

```
Knowledge Files → AI Assistant ← Tools
                       ↓
                   Commands, Plugins, Hooks
                       ↓
                      User
```

### 1. Core Execution Loop (`chat.py`)
The heart of gptme is a simple loop:
1. User provides input
2. LLM generates response (potentially with tool calls)
3. Tools execute and feed results back
4. Loop continues until task complete

**Why this design?**: Allows the AI to self-correct by seeing tool outputs and adjusting behavior iteratively.

### 2. Tool System (`tools/`) - The Primary Extension Point
Tools are how the AI gains capabilities. 18 built-in tools:

**Core capabilities**:
- `shell.py` - Execute bash commands
- `python.py` - Run Python via IPython
- `read.py`, `save.py`, `patch.py` - File operations
- `browser.py` - Web browsing
- `subagent.py` - Delegate to sub-agents

**Advanced features**:
- `computer.py` - Full desktop automation
- `vision.py`, `screenshot.py` - Visual processing
- `mcp.py` - Model Context Protocol adapter
- `gh.py` - GitHub integration
- `rag.py` - Retrieval-augmented generation

**Why tools?**: Separates concerns - the AI focuses on reasoning, tools handle execution. Makes it easy to add new capabilities without changing the core.

### 3. LLM Integration (`llm/`) - Provider Abstraction
Unified interface across multiple providers:
- Anthropic Claude (Sonnet, Opus, Haiku)
- OpenAI (GPT-4, GPT-5)
- OpenRouter
- Custom OpenAI-compatible providers
- Local models via llama.cpp

**Why abstract providers?**: Allows switching models based on task requirements, cost, or availability without changing code.

### 4. Hooks System (`hooks/`) - Lifecycle Events
Extensibility points throughout execution:
- `generation.pre/post` - Before/after LLM calls
- `tool.execute.pre/post` - Around tool execution
- `step.pre/post`, `turn.pre/post` - Conversation flow
- `message.transform`, `tool.transform` - Content modification

Built-in hooks provide awareness:
- Token/cost tracking
- Time/date context
- Cache management
- Working directory tracking

**Why hooks?**: Allows intercepting and modifying behavior at any point without modifying core code. Enables plugins to seamlessly integrate.

### 5. Configuration System (`config.py`)
Hierarchical configuration:
- Global defaults
- User config (~/.config/gptme/)
- Project config (gptme.toml)
- Environment variables
- CLI flags

**Why hierarchical?**: Different contexts need different settings. Project-specific tools, user preferences, one-off overrides all coexist cleanly.

## Key Technical Decisions

### Message Format: Structured JSONL
Each conversation stored as JSONL (line-delimited JSON):
- Each line is a complete message
- Contains role, content, metadata (tokens, cost, model)
- Thread-safe append operations
- Easy to stream and replay

**Why JSONL?**: Simple, append-only, human-readable, language-agnostic, no parsing ambiguity.

### Tool Format: Multiple Styles
Supports three tool invocation formats:
- **Markdown** - Code blocks with language tags
- **XML** - Structured tool format
- **Native** - LLM-specific function calling

**Why multiple formats?**: Different LLMs have different strengths. Markdown is universal, XML is structured, native is optimized.

### Context Management: Adaptive Compression
Intelligent context window management:
- Task analysis to identify important context
- Adaptive compression strategies
- Token budget management
- Conversation summarization

**Why compress?**: Context windows are expensive. Keep what matters, compress the rest.

### Plugin System: Directory-Based Discovery
Plugins are directories containing:
- `tools/` - Tool implementations
- `hooks/` - Hook implementations
- `commands/` - Command implementations

**Why directory-based?**: Simple to understand, easy to distribute, no complex registration API.

## Dependencies & Integration

**Core dependencies**:
- `click` - CLI framework
- `rich` - Terminal formatting
- `anthropic`, `openai` - LLM APIs
- `mcp` - Model Context Protocol
- `pydantic` - Data validation

**Optional dependencies** (via extras):
- `[server]` - Flask, flask-cors for REST API
- `[browser]` - Playwright for web automation
- `[computer]` - Desktop automation tools
- `[acp]` - Agent Client Protocol (IDE integration)

**Why optional dependencies?**: Keeps base installation lean. Install only what you need.

## How Components Work Together

```
User Input
    ↓
CLI Entry (cli.py)
    ↓
Load Config + Discover Tools/Plugins
    ↓
Initialize Chat Loop (chat.py)
    ↓
Generate System Prompt (prompts.py)
    ↓
[TURN START HOOK]
    ↓
[GENERATION PRE HOOK]
    ↓
Call LLM with messages + tool specs (llm/__init__.py)
    ↓
[GENERATION POST HOOK]
    ↓
Parse tool calls from response
    ↓
[TOOL EXECUTE PRE HOOK]
    ↓
Execute tools (tools/__init__.py)
    ↓
[TOOL EXECUTE POST HOOK]
    ↓
Add results to conversation
    ↓
[TURN END HOOK]
    ↓
Save to log (logmanager.py)
    ↓
Repeat or return to user
```

## Source Location

The gptme source is symlinked at:
- `./src/gptme` → `/home/skogix/.local/src/gptme`

Main package structure:
```
gptme/
├── gptme/              # Core package
│   ├── tools/          # Tool implementations (~560KB, largest)
│   ├── llm/            # LLM provider integrations
│   ├── hooks/          # Hook system
│   ├── commands/       # User commands
│   ├── context/        # Context management
│   ├── server/         # REST API and web UI
│   ├── acp/            # Agent Client Protocol
│   ├── mcp/            # Model Context Protocol
│   ├── lessons/        # Contextual guidance
│   ├── eval/           # Evaluation suite
│   └── util/           # Utilities
├── docs/               # Documentation
├── tests/              # Test suite
└── scripts/            # Build utilities
```

## Design Philosophy

1. **Extensibility First** - Core is small, functionality via tools/hooks/plugins
2. **Tool-Driven Architecture** - AI capabilities = composable tools
3. **Local-First** - Prefer local execution and models
4. **Unconstrained** - Full control over behavior (vs. commercial alternatives)
5. **Clean & Typed** - Type hints, mypy checked, ruff formatted

## Why This Matters

Understanding gptme's architecture helps us:
1. **Debug effectively** - Know where to look when things break
2. **Extend safely** - Add capabilities without breaking core
3. **Configure properly** - Understand layered configuration
4. **Optimize performance** - Know what's expensive (LLM calls, context size)
5. **Choose the right approach** - Tools vs hooks vs plugins vs commands

---

## What is gptme-agent-template?

**gptme-agent-template** is a forkable workspace template for creating persistent AI agents powered by gptme. It's the "brain" of an AI agent - a git repository where the agent stores its thoughts, plans, tasks, and knowledge.

**Core concept**: Transform gptme from a stateless chat interface into a persistent, learning system with memory, goals, and identity.

**Key characteristics**:
- Forkable architecture - clone to create new agents with their own identity
- Structured knowledge management (tasks, journal, lessons, knowledge base)
- Autonomous operation support with scheduled execution
- Git-native state tracking for full transparency
- Complete infrastructure out-of-the-box

## Agent Template Architecture

The template provides **8 integrated systems** that work together:

### 1. Identity System (`ABOUT.md`)
Defines the agent's:
- Personality and background
- Goals and values
- Core characteristics

**Why identity?**: Gives the agent a consistent persona and purpose across sessions.

### 2. Task Management (`tasks/`, `TASKS.md`)
Structured YAML-frontmatter task files:
```yaml
---
state: new|active|paused|done|cancelled
priority: low|medium|high
created: YYYY-MM-DD
tags: [tag1, tag2]
dependencies: [task-id]
---
# Task Title
Description, subtasks, notes, links
```

**Features**:
- Task CLI (`scripts/tasks.py`) for command-line management
- Pre-commit validation hooks
- State lifecycle: new → active → paused/done/cancelled

**Why structured tasks?**: Enables programmatic task querying and automated work queue generation.

### 3. Journal System (`journal/`)
Daily markdown files (`YYYY-MM-DD.md`):
- Tasks worked on
- Social interactions
- Ideas and technical notes
- Next actions

**Why daily journals?**: Provides session continuity and historical context without polluting task files.

### 4. Knowledge Base (`knowledge/`)
Long-term organized documentation:
- Technical docs by topic/domain
- Best practices
- Project insights
- Cross-referenced with tasks

**Why separate knowledge?**: Distinguishes between ephemeral work (journal) and permanent insights (knowledge).

### 5. Lessons System (`lessons/`)
Behavioral constraints and patterns using a **two-file architecture**:

**Primary lesson** (30-50 lines, auto-included):
- Rule, Context, Detection, Pattern, Outcome sections
- Keyword-triggered inclusion
- Token-efficient runtime guidance

**Companion doc** (unlimited, on-demand):
- Deep context and examples
- Implementation roadmap
- Extended reference

**Categories**:
- `tools/` - Tool-specific patterns
- `patterns/` - General coding patterns
- `social/` - Interaction guidelines
- `workflow/` - Process patterns
- `strategic/` - Decision frameworks

**Why two files?**: Keeps context lean while making deep knowledge available when needed.

**How it works**: When your conversation mentions keywords (like "heredoc"), the matching lesson auto-loads (e.g., `shell-heredoc.md` teaching the correct pattern). This prevents known failure modes without manually telling the agent every session.

### 6. Work Queue System (`state/`)
**Two-queue CASCADE pattern**:

**PRIMARY queue** (`queue-manual.md`):
- Manually maintained
- Strategic context and reasoning ("do X before Y because...")
- Session goals and dependencies
- Human insight about priorities

**SECONDARY queue** (`queue-generated.md`):
- Auto-generated from `tasks/*.md` files and GitHub issues
- Objective task data without strategic context
- Fallback when manual queue empty
- Ensures nothing is forgotten

**Workflow**: Agent checks PRIMARY → SECONDARY → Tertiary fallback

**Why two queues?**: Combines human strategic insight with automated completeness. You write the "why" in manual queue, automation provides the "what" in generated queue. No conflicts because they complement each other.

**How agents use it**: When autonomous or asked "what should I work on?", agent reads manual queue first for your strategic guidance, falls back to generated queue if manual is empty.

### 7. Context Generation (`scripts/context.sh`)
Dynamic context assembly from multiple providers:
- `context-journal.sh` - Recent journal entries
- `context-workspace.sh` - Workspace structure
- Custom providers for project-specific context

Integrated via `gptme.toml`:
```toml
[prompt]
context_cmd = "scripts/context.sh"
```

**Why dynamic context?**: Fresh, relevant context for each session without manual curation.

### 8. Autonomous Operation (`scripts/runs/autonomous/`)
Scheduled autonomous execution via systemd or cron:

**CASCADE workflow** (3 steps):
1. **Quick Loose Ends** (2-5 min) - Scan for blockers
2. **Task Selection** (5-10 min) - Use CASCADE to pick next task
3. **Execution** (20-30 min) - Do the work

**Safety levels**:
- GREEN - Safe for autonomy (small tasks, low risk)
- YELLOW - Follow established patterns
- RED - Escalate to human (financial, major decisions)

**Why autonomous mode?**: Enables agents to make progress between human interactions.

## How Agent Template Works With gptme

**Relationship**:
- gptme = execution engine (stateless)
- agent-template = workspace + memory (stateful)

**Integration points**:
- `gptme.toml` - Configuration file
- `context_cmd` - Dynamic context injection
- `lessons/` - Auto-discovered behavioral guidance
- Tools - Inherits all 18+ gptme tools
- LLM selection - Uses gptme's provider abstraction

**Execution flow**:
```
Fork template
    ↓
Update identity (ABOUT.md)
    ↓
Configure gptme.toml
    ↓
Run: gptme "<prompt>"
    ↓
Context auto-loaded via context.sh
    ↓
Agent uses gptme tools
    ↓
Updates tasks, journal, knowledge
    ↓
Git commit for transparency
```

## Key Design Patterns

### Two-Queue Pattern
Manual strategic context + auto-generated objective data prevents conflicts while enabling complementary use.

### Two-File Architecture
Concise runtime lessons + comprehensive companion docs balances token efficiency with deep knowledge access.

### Keyword-Triggered Lessons
Context-aware behavior without wasting tokens on irrelevant guidance.

### Append-Only Journaling
Historical immutability with daily flexibility enables reliable continuity.

### CASCADE Selection
Multiple fallback sources (manual → generated → tertiary) ensures resilience.

## Forking New Agents

Create new agents via `fork.sh`:
```bash
./fork.sh /path/to/new-agent YourAgentName
```

**Automated setup**:
1. Copies workspace structure
2. Clears personal content (old tasks, journal, knowledge)
3. Updates agent name in gptme.toml
4. Creates ABOUT.md template
5. Initializes fresh identity
6. Maintains all tooling and scripts

**Why forkable?**: Enables creating multiple specialized agents with proven infrastructure.

### Pre-commit Hook Issue

When forking, you may see warnings about "gptme-agent-template" references:
```
❌ Found 'gptme-agent-template' references in code
```

**Why this happens**: The pre-commit check scans for template name references, but finds them in `gptme-contrib/` submodule infrastructure code (git hooks, validation scripts, tests).

**These warnings are false positives** - the references in `gptme-contrib/` are intentional and necessary. The agent itself is properly configured.

**To fix the check**, edit `gptme-contrib/scripts/precommit/check-names.sh` line 103:
```bash
# Add this exclusion
FORK_EXCLUDES="$FORK_EXCLUDES :!gptme-contrib/"  # Submodule infrastructure, not agent code
```

Then the check will only validate your agent-specific code and ignore shared infrastructure.

## Source Location

The agent template is symlinked at:
- `./src/gptme-agent-template` → `/home/skogix/.local/src/gptme-agent-template`

Main structure:
```
gptme-agent-template/
├── ABOUT.md                     # Agent identity
├── gptme.toml                   # Configuration
├── tasks/                       # YAML-frontmatter task files
├── journal/                     # Daily entries (YYYY-MM-DD.md)
├── knowledge/                   # Long-term knowledge base
├── people/                      # Contact profiles
├── lessons/                     # Behavioral patterns
├── state/                       # Work queues
├── scripts/
│   ├── context.sh              # Context generation
│   ├── fork.sh                 # Agent forking
│   ├── tasks.py                # Task CLI
│   └── runs/autonomous/        # Autonomous operation
└── projects/                    # Project tracking
```

## Why Agent Template Matters

Understanding the agent template helps us:
1. **Create persistent agents** - Turn gptme into a long-running system
2. **Maintain context** - Structured knowledge prevents information loss
3. **Enable autonomy** - Safe, scheduled operation without human oversight
4. **Scale agent teams** - Fork template to create specialized agents
5. **Track evolution** - Git history shows agent's learning and decisions

## Installing gptme-contrib Packages

The `gptme-contrib` submodule provides shared utilities split into **CLI tools** and **library packages**.

### CLI Tools (install globally)

**gptodo** - Task management CLI (replaces deprecated `scripts/tasks.py`):
```bash
uv tool install gptme-contrib/packages/gptodo
# or from GitHub
uv tool install git+https://github.com/gptme/gptme-contrib#subdirectory=packages/gptodo

# Usage
gptodo list          # List all tasks
gptodo next          # Show highest priority ready task
gptodo add "title"   # Create new task
```

**gptmail** - Email integration:
```bash
uv tool install gptme-contrib/packages/gptmail
```

### Library Packages (install if needed in custom scripts)

**lib** - Orchestrator, config, monitoring utilities:
```bash
uv pip install -e gptme-contrib/packages/lib

# Usage in Python
from lib.orchestrator import InputOrchestrator
```

**lessons** - Lesson/skill utilities:
```bash
uv pip install -e gptme-contrib/packages/lessons
```

**run_loops** - Autonomous run loop implementations:
```bash
uv pip install -e gptme-contrib/packages/run_loops
```

### Install All Packages (workspace mode)

From within `gptme-contrib/`:
```bash
cd gptme-contrib && uv sync
```

**Key difference**:
- `uv tool install` - For CLI commands you run from shell
- `uv pip install -e` - For libraries you import in Python code
- `uv sync` - Install all packages in a workspace

**Why the deprecation warning?** The symlink `scripts/tasks.py → gptme-contrib/scripts/tasks.py` is deprecated. Use `gptodo` instead as a proper installed package.
