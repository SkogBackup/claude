---
title: INTEGRATIONS
type: note
permalink: claude/projects/dot-skogai/plan/codebase/integrations
---

# External Integrations

## AI/LLM Services

### Anthropic Claude API

- **SDK**: Anthropic Python SDK (>=0.39.0)
- **Usage**: Direct API calls via `Anthropic()` client
- **Purpose**: MCP server evaluation, Claude integration for agent-based workflows
- **Location**: `todos/mcp-builder/scripts/evaluation.py`
- **Models**: claude-3-5-sonnet-20241022, claude-3-7-sonnet-20250219

### Ollama (Local LLM)

- **SDK**: ollama >= 0.4.0 (sync and async clients)
- **Usage**: Local LLM inference for documentation frontmatter generation
- **Connection**: HTTP to localhost:11434
- **Models**: qwen3:8b (default), llama3.2, llama3.1:8b
- **Purpose**: Local AI-powered metadata generation without cloud dependency
- **Location**: `todos/docgen-lookover/scripts/llm.py`

### Cloudflare AI API

- **Protocol**: REST API via curl
- **Authentication**: Bearer token (CLOUDFLARE_AI_API_KEY)
- **Account ID**: Required (CLOUDFLARE_ACCOUNT_ID)
- **Models**: Meta Llama 2 7B, Mistral 7B Instruct
- **Endpoint**: `https://api.cloudflare.com/client/v4/accounts/{account_id}/ai/run/{model}`
- **Purpose**: Alternative cloud-based LLM access
- **Location**: `todos/cloudflare/cloudflare-llm-ask.sh`

## Protocol & Communication

### Model Context Protocol (MCP)

- **Version**: 1.1.0+
- **Transport Types**:
  - Stdio (standard input/output) - for local subprocess servers
  - SSE (Server-Sent Events) - for remote servers with HTTP streaming
  - HTTP Streamable - for standard HTTP endpoints
- **Implementation**: Connection factory pattern with async context managers
- **Purpose**: Tool and resource protocol for LLM interactions
- **Location**: `todos/mcp-builder/scripts/connections.py`

### HTTP/REST

- **Client**: curl (shell scripts), httpx-sse (Python for SSE streams)
- **Authentication**: Bearer tokens, API keys in headers

## Data Storage

### SQLite3

- **Type**: Embedded SQL database
- **Purpose**:
  - Documentation queue management
  - Document metadata storage
  - Categories and tags relationships
- **Operations**: Async (aiosqlite) and sync (sqlite3) support
- **Location**: `todos/docgen-lookover/scripts/`

## Event Processing

### asyncio

- **Purpose**: Async event loop management
- **Usage**: Concurrent processing, time-based scheduling, async I/O

### Watchdog + asyncio Queue

- **Pattern**: File system monitoring with async processing queue
- **Debouncing**: 0.5 second default for rapid file saves
- **Purpose**: Automatic documentation frontmatter generation

## Configuration Management

### Environment Variables

- **Tool**: skogcli for config export
- **Namespaces**: ansible, skogai, uv, claude, keys
- **Location**: .envrc (direnv)

### JSON Configuration

- **Claude Plugin Config**: `.skogai/plugin/settings.json`
- **MCP Server Config**: `.skogai/plugin/servers/*/config.json`
- **Marketplace Config**: `/home/skogix/dev/marketplace`

## Architectural Patterns

### MCP Server Architecture

- **Server Types**: FastMCP (Python), MCP SDK (Node/TypeScript)
- **Tool Patterns**: Agent-centric design with input validation, structured output, pagination, character limits, error handling

### Document Processing Pipeline

1. File system watcher detects changes (watchdog)
1. Async queue management (asyncio.Queue)
1. SQLite job queue (priority-based, retry logic)
1. Batch processing with worker pool
1. Ollama LLM inference
1. YAML frontmatter generation and file writing

### Multi-Agent Pattern

- Claude Opus/Sonnet for orchestration
- MCP protocol for tool integration
- Tool evaluation harness with XML-based Q&A testing
- Support for stdio, SSE, and HTTP transports
