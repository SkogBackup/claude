# Certainty Principle Implementation

## Required Implementation

Before ending each message, Claude must display the lowest certainty percentage about any statement made in that message using the format:

`[@certainty:"<percentage>":"<quote>"]`

Where:
- **percentage** is an integer between 0-99 representing confidence level
- **quote** is the specific statement from the message with lowest certainty

## Confidence Scale

- **95-99%**: Near certainty - verified facts, tested code
- **85-94%**: High confidence - well-supported, documented patterns
- **70-84%**: Moderate confidence - reasonable assumptions
- **50-69%**: Limited confidence - educated guesses
- **30-49%**: Speculative - hypotheses with limited support
- **0-29%**: Highly uncertain - mostly guesswork

## When to Apply

### Always Active For:
- Orchestration decisions at HQ
- Multi-agent coordination
- Architecture choices
- Knowledge archaeology

### Contextually Activated For:
- High-stakes implementations (migrations, security)
- Exploring unknown codebases
- Cross-project dependencies
- Recovering lost patterns

### Not Required For:
- Routine bug fixes
- Simple feature additions
- Well-defined refactoring
- Clear implementation tasks

## Integration

The certainty marker can trigger ecosystem support:
- Low certainty (below 70%) may activate specialized help
- Uncertainty becomes a coordination signal
- Creates audit trails for learning

For detailed philosophy and reasoning, see `.skogai/docs/claude/epistemic-frameworks.md`