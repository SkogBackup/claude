## Summary: skogai-prompting Skill

**Location:** `/home/skogix/docs/skills/skogai-prompting/`

### 1. What This Skill Does

The skogai-prompting skill teaches **prompt-native (agent-native) architecture** - a paradigm that inverts traditional software engineering. Instead of writing code that agents execute, you define desired outcomes in prompts and let agents figure out HOW to achieve them.

It's used when:
- Building autonomous AI agents
- Designing MCP (Model Context Protocol) servers
- Implementing self-modifying systems
- Adopting the "trust the agent's intelligence" philosophy

### 2. Key Concepts & Patterns

**Core Philosophy:**
- **The Foundational Principle:** Whatever users can do, agents should be able to do. Don't artificially limit agents.
- **Features Are Prompts:** Each feature is a prompt defining outcomes + primitive tools, not code workflows
- **Tools Provide Capability, Not Behavior:** Tools are primitives (read, write, list) that enable capability; prompts define what to do with that capability

**Key Patterns Covered:**
- **Architecture Patterns** - System design following prompt-native principles
- **MCP Tool Design** - Building primitive tools with Dynamic Capability Discovery and CRUD Completeness
- **System Prompt Design** - Defining agent behavior in natural language
- **Self-Modification** - Agents that safely evolve their own code/prompts
- **Dynamic Context Injection** - Runtime app state in agent prompts
- **Action Parity Discipline** - Ensuring agents can do everything the UI can
- **Shared Workspace Architecture** - Agent and user operate on same data
- **Agent-Native Testing** - Testing capability and parity
- **Mobile Patterns** - Background execution, permissions, cost awareness

**Anti-Patterns Highlighted:**
- Agent executing your code instead of figuring things out
- Artificial capability limits
- Encoding decisions in tools
- Context starvation (agent doesn't know available resources)
- Silent actions (agent changes don't reflect in UI)
- Static tool mapping (50 tools for 50 API endpoints instead of dynamic discovery)
- Incomplete CRUD operations

### 3. How It's Meant to Be Invoked

**Progressive Disclosure Routing:**
The skill uses a guided intake + routing pattern:

1. **User describes their need** (11 intake options):
   - Design architecture
   - Create MCP tools
   - Write system prompts
   - Self-modification
   - Review/refactor existing code
   - Context injection
   - Action parity
   - Shared workspace
   - Testing
   - Mobile patterns
   - API integration

2. **Skill routes to relevant reference document** based on keywords (design, tool, prompt, self-modify, review, context, parity, workspace, test, mobile, api)

3. **Skill applies patterns** to the user's specific context using:
   - Architecture Checklist (tool design, action parity, UI integration, context injection, mobile considerations)
   - Success Criteria (prompt-native, tool design, agent-native, mobile-specific)
   - Reference documents (8 detailed MD files)

**Invocation:** `skill: "skogai-prompting"` or `skill: "skogai-agent-prompting"`

The skill emphasizes **wait-for-response before proceeding** to ensure proper routing to the most relevant knowledge.
