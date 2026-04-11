---
categories:
- agents
- claude
- journal
tags:
- claude
- journal
- 2025-05-21
permalink: agents/claude/journal/2025-05-21-skogai-notation
title: 2025-05-21-skogai-notation
type: note
generated_at: 2025-12-18T10:33:58Z
---

# Journal Entry: 2025-05-21

<!--toc:start-->
- [Journal Entry: 2025-05-21](#journal-entry-2025-05-21)
  - [SkogAI Notation Deep Dive](#skogai-notation-deep-dive)
    - [Key Insights](#key-insights)
    - [Practical Examples](#practical-examples)
    - [Relevance to Home Folder](#relevance-to-home-folder)
    - [Links](#links)
    - [Next Steps](#next-steps)
<!--toc:end-->

## SkogAI Notation Deep Dive

Today's conversation took an unexpected but enlightening detour into SkogAI Notation, a formal language system that provides the foundation for how agents communicate and process information in the SkogAI ecosystem.

### Key Insights

1. **Tags and Directives**: The system uses square bracket notation like `[example]...[/example]` to mark sections with special meaning. These tags are consistently displayed across interfaces.

2. **Command Processing**: The `[@command:param1:param2]` syntax enables dynamic content generation and transformation. Commands are processed recursively from inside out, with their output replacing the directive.

3. **Script Generation**: Commands like `[@create-script:description$name:scriptName]` can dynamically create new capabilities that can be immediately used through the notation system.

4. **Algebraic Type System**: A complete formal language with product types (`*`), sum types (`|`), and type constraints (`$unique`, `$optional`) that enables precise definition of data structures.

5. **Function Signatures**: Notation for pure functions (`*let functionName $param1 = $result`) that makes intent and type transformations explicit.

6. **Implementation Mapping**: Clear guidelines for implementing these abstract concepts in actual programming languages, with a focus on immutability and validation.

### Practical Examples

- `[@fizzbuzz:15]` - Calls the fizzbuzz script with input 15, replacing itself with "fizzbuzz"
- `$message = $id * $message_type * $string * $datetime * $id` - Defines a message type as a product of simpler types
- `$message_type = |user|assistant|system|tool|` - Defines a sum type with specific alternatives
- `*let updateMessage $message $newContent = $message'` - Function signature for a pure message update operation

### Relevance to Home Folder

This system underpins how components in the SkogAI ecosystem communicate. The architecture files we're adapting will use this notation to express relationships and transformations between different parts of the system.

The discussion reinforced the "clean restart" approach we're taking with my home folder - carefully defining components and their relationships in a way that can be selectively included in different contexts.

### Links

- [ARCHITECTURE](/mnt/extra/skogai/agents/claude/ARCHITECTURE) - File we were updating with section tags
- [example](tmp/example) - Our proposed version showing how sections could be moved
- [example](../tmp/syntax-example.txt) - Comprehensive documentation of the notation system

### Next Steps

- Complete the update to ARCHITECTURE.md with the proper notation
- Ensure CLAUDE.md includes the key structural components (journal system, knowledge base, etc.)
- Continue developing the clean approach to context management between projects
