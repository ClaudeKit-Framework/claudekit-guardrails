# Claude Code Guardrails

Security governance templates for Claude Code. AI coding tools can read
credential files, run shell commands, install packages, and write code that
ships to production. Left ungoverned, this creates real security and
compliance risk.

Add these guardrails to any project and Claude Code starts behaving like a
security-aware developer: following your rules, flagging adherence
obligations, creating audit records, and asking before doing anything
dangerous.

Two templates: **`guardrails-solo`** (solo developer, 5 min setup) and
**`guardrails-team`** (teams + regulated data, ~1 hr + MDM deployment).

> [!WARNING]
> **Early development — not audited.** This project is under active development
> and has not been independently reviewed by legal counsel or security auditors.
> Standards references and adherence rules are included in good faith but must
> be independently verified before use in regulated environments. This is a
> starting point, not a certified adherence solution. Use at your own risk.

---

## Seven-Layer Governance Model

| Layer | File | What It Does | Bypassable? |
|---|---|---|---|
| 1 — Org enforcement | `managed-settings.json` | Hard permission controls; disables `--dangerously-skip-permissions` | No — deployed via MDM |
| 2 — File exclusions | `.claudeignore` | Blocks Claude reading credential and sensitive files | No — technical control |
| 3 — Automated hooks | `.claude/hooks/` | Scans for injection and secrets before/after every tool call | No — runs automatically |
| 4 — Project permissions | `.claude/settings.json` | Allow/deny lists specific to this project | Only by Layer 1 |
| 5 — Root instructions | `CLAUDE.md` | Session rules, prohibitions, adherence flags | Soft — relies on model |
| 6 — Module rules | `src/auth/CLAUDE.md` etc. | Stricter rules for sensitive directories | Soft — relies on model |
| 7 — Standards reference | `SECURITY.md` | Full standards detail; ADR guidance | Reference only |

Layers 1–4 are technical controls. A developer cannot override them with a prompt.

---

## Which Template?

| | `guardrails-solo` | `guardrails-team` |
|---|---|---|
| **Best for** | Solo developers, side projects, early-stage products | Teams, regulated data, regulatory requirements |
| **Setup time** | ~5 minutes | ~1 hour + MDM deployment |
| **Files** | 8 | 16 |
| **Layers active** | 2, 4, 5, 7 | All 7 |
| **Regulatory coverage** | Quick-reference (AU, EU, US) | Full — see [Standards Covered](#standards-covered) |
| **Slash commands** | `/create-adr` | `/create-adr`, `/security-review`, `/compliance-check` |
| **Automated hook scanning** | ✗ | ✓ |
| **MDM enforcement** | ✗ | ✓ |
| **Module-level rules** | ✗ | ✓ example included |

**Upgrade path:** Start with `guardrails-solo`. Move to `guardrails-team` when you
add a second developer, handle personal data at scale, face regulatory
obligations (SOCI Act, HIPAA, PCI-DSS), or pursue SOC 2 / ISO 27001. The
upgrade is additive — your `CLAUDE.md` content, `.claudeignore` additions,
and ADRs all carry forward.

---

## Quick Start

```bash
# ── guardrails-solo ───────────────────────────────────────────────────────
git clone git@github.com:ClaudeKit-Framework/claudekit-guardrails.git
cp -ra claudekit-guardrails/guardrails-solo/. my-project/
cd my-project
git init && git remote add origin https://github.com/your-org/my-project.git
# 1. Fill in CLAUDE.md Section 0 (your stack, test command, key dirs)
# 2. Update .claude/settings.json allow list with your project's commands
# 3. Open Claude Code — active layers take effect immediately

# ── guardrails-team ───────────────────────────────────────────────────────
git clone git@github.com:ClaudeKit-Framework/claudekit-guardrails.git
cp -ra claudekit-guardrails/guardrails-team/. my-project/
cd my-project
git init && git remote add origin https://github.com/your-org/my-project.git
make setup              # Makes hooks executable; runs verification checklist
make deploy-settings    # Copies managed-settings.json to system path (once per machine)
# 1. Fill in CLAUDE.md Section 0
# 2. Update .claude/settings.json allow list
# 3. Run /create-adr for first architectural decisions
```

See each template's `README.md` for full setup steps, MDM deployment paths,
existing-project merge instructions, and verification checklists.

---

## What's In Each Template

### `guardrails-solo/`

```
CLAUDE.md                    Session rules — read every session
SECURITY-QUICK-REF.md        One-page security reference
.claudeignore                Blocks Claude from reading credential files
.claude/settings.json        Project-level allow/deny lists
.claude/commands/
  create-adr.md              /create-adr slash command
docs/decisions/
  README.md                  ADR format guide
  0000-template.md           ADR template
README.md                    Setup guide
```

### `guardrails-team/`

```
CLAUDE.md                    Full session rules — read every session
SECURITY.md                  Full standards and adherence reference
.claudeignore                Extended file exclusions
.gitattributes               LF line endings for hook scripts across all OS
Makefile                     make setup / hooks / deploy-settings / verify
managed-settings.json        Org-level enforcement template (deploy separately)
.claude/settings.json        Project-level allow/deny lists
.claude/hooks/
  pre-tool-call.sh           Injection detection; dangerous command blocking
  post-write.sh              Secret scanning; disabled security control detection
.claude/commands/
  security-review.md         /security-review — OWASP checklist review
  create-adr.md              /create-adr — Architecture Decision Record creation
  compliance-check.md        /compliance-check — regulatory framework assessment
docs/decisions/
  README.md                  ADR guide with compliance reasons
  0000-template.md           Full ADR template
src/auth/CLAUDE.md           Example module-level rules (copy for payments, admin etc.)
README.md                    Full setup guide including existing project instructions
```

---

## Standards Covered

### `guardrails`

| Standard | Coverage |
|---|---|
| OWASP Top 10:2025 | Rule-per-category table in SECURITY-QUICK-REF.md |
| OWASP LLM Top 10:2025 | Prompt injection, output handling, agency in CLAUDE.md |
| Privacy Act 1988 (Cth) / APPs | Compliance trigger and hard rules |
| GDPR (EU 2016/679) | Compliance trigger and hard rules |
| HIPAA (45 CFR Parts 160, 164) | No PHI in AI context; trigger and hard rules |
| PCI-DSS v4.0.1 | Never touch raw card data; trigger and hard rules |
| CCPA / CPRA | Trigger and hard rules |
| EU AI Act (Reg. EU 2024/1689) | AI feature disclosure; prohibited practices |

### `guardrails-team` (all of the above plus)

| Standard | Section in SECURITY.md |
|---|---|
| NIST SSDF SP 800-218 v1.1 + 218A (GenAI Profile) | Part 3 |
| NIST Cybersecurity Framework 2.0 | Part 3 |
| NIST AI RMF 1.0 | Part 3 |
| Privacy & Other Legislation Amendment Act 2024 (AU) | H8 |
| Cyber Security Act 2024 (Cth) | H9 |
| Security of Critical Infrastructure Act 2018 (SOCI Act) | H9 |
| ACSC Essential Eight | H9 |
| APRA Prudential Standard CPS 234 | H9 |
| SOC 2 (AICPA Trust Services Criteria) | H6 |
| ISO/IEC 27001:2022 | H7 |
| CIS Controls v8 | Parts 1, 5 |

---

## Keeping Current

Review and update when:

- OWASP publishes a new Top 10 edition
- Australian privacy or cybersecurity legislation changes (Privacy Act
  Tranche 2 reforms are expected; Children's Online Privacy Code will be
  published by the OAIC)
- EU AI Act high-risk obligations take effect (August 2, 2026) — assess
  whether any systems built with AI tools fall under Annex III
- A security incident reveals a gap in the instructions
- Claude Code ships changes to permission syntax, hook formats, or
  managed-settings keys
- Anthropic publishes updated security documentation

Tag each review as a release (`v1.1.0`, `v2.0.0` etc.) so projects
initialised from these guardrails can track which version they used.

See [CHANGELOG.md](CHANGELOG.md) for full version history.

---

## Contributing

Found a broken command, a wrong legal reference, or a missing standard?
Open an issue. Accuracy matters — errors in governance templates propagate
into the projects that use them.

**[Bug report](../../issues/new?template=bug_report.yml)** — command
that doesn't work, file path that's wrong, instruction that fails

**[Standards accuracy](../../issues/new?template=standards_accuracy.yml)**
— incorrect legal reference, wrong compliance detail, misattributed requirement

**[Improvement](../../issues/new?template=improvement.yml)** — missing
control, coverage gap, or usability suggestion

Not sure how to write it up? Run `/report-issue` in Claude Code in this
repo and follow the prompts.
