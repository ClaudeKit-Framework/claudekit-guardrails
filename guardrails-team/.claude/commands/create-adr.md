# Create Architecture Decision Record

A security or compliance decision has been made (or is being made) that
needs to be recorded as an ADR.

## Steps

1. Identify the next available ADR number by listing `docs/decisions/`
2. Ask the developer for the short title if not already provided
3. Create `docs/decisions/NNNN-short-title.md` using the template below
4. Fill in all sections based on what has been discussed this session
5. Confirm the completed ADR with the developer before saving

## ADR Template to Use

```markdown
# NNNN — [Short Title]

Date: [YYYY-MM-DD]
Status: Draft | Accepted | Superseded by NNNN | Deprecated
Compliance: [List applicable frameworks: Privacy Act 1988 (Cth) / GDPR / HIPAA / PCI-DSS / SOC 2 / ISO 27001 / EU AI Act]
Author: [Developer name or "AI-assisted — reviewed by Developer Name"]

---

## Context

[What situation, requirement, or problem led to this decision?
What constraints exist (regulatory, technical, team capability)?
What is at stake if the wrong decision is made?]

## Decision

[State the decision clearly and directly.
"We will use X" not "We considered X".]

## Alternatives Considered

| Option | Pros | Cons | Rejected Because |
|---|---|---|---|
| [Option A] | | | |
| [Option B] | | | |

## Consequences

**Positive:**
- [What gets better]

**Negative / Trade-offs:**
- [What gets worse or what new risks are introduced]

**Compliance impact:**
- [Which regulatory requirements does this satisfy or create obligations for]

## Implementation Notes

[Any specific implementation constraints, version requirements,
configuration details, or things the next developer needs to know]

## Review Date

[Set a date to revisit this decision — typically 6–12 months,
or when the underlying technology or regulation changes]
```

## Decisions That Always Require an ADR

- Authentication and session management strategy
- Encryption algorithm or library choice
- Any third-party service receiving user, health, or payment data
- Data retention, deletion, or archival policy
- Privacy Act 1988 (Cth), PCI-DSS, HIPAA, or GDPR scope decisions
- Choice between two viable security approaches
- Any deviation from CLAUDE.md or SECURITY.md rules
