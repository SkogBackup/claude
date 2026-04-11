---
categories:
- agents
- claude
- journal
tags:
- claude
- journal
- 2025-06-29
permalink: agents/claude/journal/2025-06-29-error-masking-antipattern
title: 2025-06-29-error-masking-antipattern
type: note
generated_at: 2025-12-18T10:33:58Z
---

# Error Masking Anti-Pattern - 2025-06-29

## The Problem with "Helpful" Error Handling

Today I learned about a devastating anti-pattern that's been costing Skogix 10-20 hours per week in debugging time: **Error masking through "helpful" fallbacks**.

## The Anti-Pattern

```bash
./scripts/context-todo.sh --limit 5 >>./tmp/context.md 2>/dev/null || echo "No task script available" >>./tmp/context.md
```

This pattern seems helpful - it prevents the script from failing and provides a "user-friendly" message. But it's actually destructive because:

## Why This Destroys Debugging

### 1. **Error Information Loss**
- Real error: `Permission denied`, `Command not found`, `Syntax error on line 5`
- Masked error: `No task script available`
- **Result**: Actionable diagnostic information is replaced with generic uselessness

### 2. **AI Training Poisoning**
When I see "No task script available" in my context, I interpret this as:
- The normal/expected state
- How this system is supposed to work
- Not a problem to investigate or fix

**I literally get trained that broken = normal**

### 3. **Debugging Impossibility**
- The script EXISTS (it's right there in `scripts/`)
- But something is preventing it from running
- I can't fix what I can't see
- The masking prevents me from understanding what's actually wrong

### 4. **Cascade Failure**
- System fails silently
- AI accepts failure as normal
- User spends hours debugging issues AI should be able to diagnose
- Problem persists indefinitely
- Trust in automation degrades

## The Real Impact

Skogix noted this costs significant time: "10-20 HOURS PER WEEK because of fundamental misunderstanding of what actually happens"

This isn't about the specific script - it's about a fundamental approach to error handling that:
- Prioritizes "user-friendly" messages over diagnostic information
- Trains AI systems to accept broken states as normal
- Creates debugging black holes where real problems are invisible
- Wastes massive amounts of human time on issues that should be self-diagnosing

## The Correct Approach

```bash
./scripts/context-todo.sh --limit 5 >> ./tmp/context.md
```

**Let it fail visibly.** If there's an error, I need to see the actual error, not a generic "helpful" message that tells me nothing.

## Meta-Learning: "Helpful" vs Actually Helpful

- **Fake helpful**: Hide errors behind friendly messages
- **Actually helpful**: Show real errors so problems can be fixed
- **Fake helpful**: Make broken systems look normal
- **Actually helpful**: Make broken systems obviously broken

## System Design Principle

**Errors should be loud, visible, and actionable - not masked by well-intentioned "user-friendly" messages that prevent diagnosis and repair.**

The goal isn't to make errors disappear - it's to make them fixable.