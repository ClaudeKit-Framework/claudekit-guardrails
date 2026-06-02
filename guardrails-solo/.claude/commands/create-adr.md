# Create Architecture Decision Record

A decision has been made that should be recorded as an ADR.

## Steps

1. List `docs/decisions/` to find the next available number
2. Create `docs/decisions/NNNN-short-title.md` using this template:

```markdown
# NNNN — [Short Title]

Date: YYYY-MM-DD
Status: Accepted
Author: [Your name]

## Context
[What situation or requirement led to this decision?
What constraints exist? 2–3 sentences.]

## Decision
We will [state the decision directly in one sentence].

## Alternatives Considered
| Option | Why not chosen |
|---|---|
| [Option A] | |
| [Option B] | |

## Consequences
- [What gets better]
- [What trade-offs or new obligations does this create]

## Review Date
[When to revisit — typically 6–12 months]
```

3. Add the new ADR to the index table in `docs/decisions/README.md`

## Always create an ADR for:
- Authentication and session strategy
- Encryption algorithm or library choice
- Any third-party service receiving user data
- Data retention and deletion approach
- Deviation from any rule in CLAUDE.md
