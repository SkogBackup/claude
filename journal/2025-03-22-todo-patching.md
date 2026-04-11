---
permalink: journal/2025-03-22-todo-patching
---

# Todo: Create General Patching Strategy

# 2025-03-22-todo-patching.md

## Task Information
- **Title:** Define General Patching Strategy and Legacy Guidelines
- **Status:** Planned

## Problem Statement
Currently, we're applying context system improvements on a case-by-case basis without a general strategy for handling legacy compatibility. We need to establish:
1. Clear definitions of "legacy" vs "non-legacy" agents
2. Standard patching procedures for upgrading legacy agents
3. Guidelines for when backward compatibility is required

## Implementation Goals
- Create a standardized patching framework for all agent types
- Establish clear criteria for legacy compatibility requirements
- Document branching strategy for experimental features

## Key Points to Address

### Legacy Definition
- Define what makes an agent "legacy compatible"
- Determine minimum requirements for legacy mode
- Document file structures and locations requiring preservation

### Patch Framework
- Create standardized patch templates
- Implement automated verification steps
- Support rollback functionality for failed patches

### Branching Strategy
- Define when to use feature branches (e.g., skogcli-integration)
- Document dependency tracking between agent changes and tool changes
- Establish testing protocols for experimental branches

## Current Branch Status
- **master**: Current working implementation with legacy compatibility
- **skogcli-integration**: Experimental branch for deeper skogcli integration (requires skogcli changes)

## Notes
- Different agents have different legacy compatibility requirements
- Context system improvements work best with skogcli enhancements
- Eventual goal is to standardize agent interfaces while allowing innovations