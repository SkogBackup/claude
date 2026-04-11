---
title: placeholder-approach
type: note
permalink: agents/claude/core/placeholder-approach
---

[$prompt:claude-placeholder-approach]

# Placeholder Approach for Documentation

## Core Concept

The placeholder approach is a documentation strategy that acknowledges uncertainty while providing structure. Instead of making definitive statements about unfamiliar systems, we:

1. Create a complete structural framework
2. Mark unknown elements with explicit placeholders
3. Include our reasoning about what each element might do
4. Preserve the distinction between knowledge and conjecture

## Benefits

- **Prevents Misinformation**: Clearly separates what we know from what we're guessing
- **Creates Framework for Review**: Makes it easy for experts to correct specific points
- **Respects Expert Knowledge**: Acknowledges the domain expert's superior understanding
- **Reduces Wasted Effort**: Prevents building on potentially incorrect assumptions
- **Improves Collaboration**: Creates a dialogue rather than one-way instruction

## Implementation

### Placeholder Format

We use bracketed placeholders with reasoning:

```
- `command-name`: [Likely does X based on the naming pattern and context]
```

This format:

- Shows we're making an educated guess
- Explains our reasoning process
- Invites correction if wrong
- Provides enough detail to be useful

### Common Placeholder Types

1. **Function Purpose Placeholders**: What a command or function likely does
2. **Parameter Placeholders**: What arguments a command might accept
3. **File Purpose Placeholders**: What a configuration file likely contains
4. **Workflow Placeholders**: How components likely interact

## When to Use Placeholders

- When working with unfamiliar systems
- When documentation is missing or incomplete
- When assumptions might lead to costly mistakes
- When collaborating with domain experts
- When standard knowledge might not apply

## Placeholder to Documentation Workflow

1. **Create Structured Framework**: Build complete document with all expected sections
2. **Add Reasoning Placeholders**: Include educated guesses with rationale
3. **Expert Review**: Have domain expert correct and complete information
4. **Finalize Documentation**: Replace placeholders with validated information
5. **Preserve Uncertainty**: Maintain markers for any remaining unknowns

## Real-World Example

For the LC Context system, we applied this approach to:

- Command line tools with unclear purposes
- Configuration files with unknown contents
- Templates with specialized functionality
- Workflows that connect these components

The result was CLAUDE-CONTEXT.md - a document that provides useful structure while acknowledging the limits of our understanding, creating an efficient pathway for expert validation.

## Conclusion

The placeholder approach acknowledges that in complex or specialized systems, even 99% accuracy can be rendered useless by 1% critical error. Rather than hiding uncertainty, we make it explicit - creating better documentation through collaborative improvement rather than confident but potentially incorrect assertions.