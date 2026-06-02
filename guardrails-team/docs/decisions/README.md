# Architecture Decision Records

This directory contains Architecture Decision Records (ADRs) for this project.

An ADR is a short document that captures a significant decision made during
development — what was decided, why, what alternatives were considered,
and what the consequences are.

---

## Why We Keep ADRs

ADRs are required by several compliance frameworks this project operates under:

- **ISO 27001 A.8.32** — change decisions must be documented with rationale
- **SOC 2** — auditors require evidence of *why* security controls were chosen
- **PCI-DSS Req 6.4** — change impact documentation and approval records
- **GDPR Art. 5(2)** — accountability principle: demonstrate why processing decisions were made
- **Privacy Act 1988 (Cth) APP 1** — privacy management plan; ADRs evidence privacy decisions were deliberate
- **EU AI Act Art. 11** — technical documentation for systems built with AI assistance
- **HIPAA §164.316(b)** — policies and procedures retained for 6 years

Beyond compliance, ADRs prevent the most common team failure: making the same
decision twice because no one can remember why it was made the first time.

---

## When to Create an ADR

Create one when a decision is made that:
- Would be hard to understand later without context
- Involves a security or compliance trade-off
- Affects more than one developer or more than one sprint

**Always create an ADR for:**
- Authentication and session management strategy
- Encryption algorithm, library, or key management approach
- Any third-party service that will receive user, health, or payment data
- Data retention, deletion, or archival policy
- Privacy Act 1988 (Cth), PCI-DSS, HIPAA, or GDPR scope decisions
- Choice between two viable security approaches
- Any deviation from `CLAUDE.md` or `SECURITY.md` rules

**In Claude Code:** run `/create-adr` and the ADR will be created
and filled in automatically based on your session context.

---

## Naming Convention

```
NNNN-short-descriptive-title.md
```

Examples:
```
0001-authentication-strategy.md
0002-database-encryption-approach.md
0003-stripe-for-payment-tokenisation.md
0004-gdpr-data-retention-policy.md
0005-session-storage-httponly-cookies.md
```

Increment `NNNN` sequentially. Never reuse a number.

---

## ADR Lifecycle

| Status | Meaning |
|---|---|
| **Draft** | Under discussion — not yet finalised |
| **Accepted** | Decision made — implementation in progress or complete |
| **Superseded** | Replaced by a newer ADR — link to the replacement |
| **Deprecated** | No longer applies — not replaced by anything |

**ADRs are never deleted.** If a decision changes, mark the old one
`Superseded by NNNN` and create a new one explaining the change.

---

## Template

Copy `0000-template.md` for each new ADR.

---

## Index

| # | Title | Status | Date | Frameworks |
|---|---|---|---|---|
| [0000](0000-template.md) | Template | — | — | — |

*Add each new ADR to this table.*
