# Changelog

## v0.1.0 — 15 May 2026

**Initial release.** First version of guardrails templates, developed through
iterative design and internal review against the covered standards. Not yet
independently audited.

### Added

- **`guardrails/`** — 8-file template for solo developers:
  lean `CLAUDE.md`, `SECURITY-QUICK-REF.md`, `.claudeignore`,
  `.claude/settings.json`, `/create-adr` slash command, ADR structure
- **`guardrails-team/`** — 16-file template for teams and regulated workloads:
  full `CLAUDE.md`, `SECURITY.md` (9 regulatory sections H1–H9),
  `managed-settings.json`, `Makefile` (`make setup/hooks/deploy-settings/verify`),
  `.gitattributes`, pre-tool-call and post-write security hooks,
  `/security-review`, `/create-adr`, `/compliance-check` slash commands,
  ADR structure, `src/auth/CLAUDE.md` module example
- **Seven-layer governance architecture** — Layers 1–4 technical
  (cannot be bypassed), Layers 5–6 instructional, Layer 7 reference
- **Australian law coverage** — Privacy Act 1988 (Cth) + APPs + NDB scheme,
  Privacy and Other Legislation Amendment Act 2024, Cyber Security Act 2024,
  SOCI Act 2018, ACSC Essential Eight, APRA CPS 234 — added to all relevant
  files: SECURITY.md H8/H9, both CLAUDE.md compliance flag tables,
  compliance-check.md Steps 1 and 2, create-adr.md, ADR docs,
  SECURITY-QUICK-REF.md, Data Residency section (APP 8 cross-border disclosure)
- **ISO 27001 supplier assessment** — Anthropic as third-party supplier
  under A.5.19–22 added to H7
- **GDPR legal basis (Art. 6)** — six lawful bases added to H1; absent
  from initial drafts despite being the most fundamental GDPR requirement
- **APP 8 cross-border disclosure** — added to Data Residency section;
  sending Australian personal information to Anthropic constitutes an
  overseas disclosure requiring protective steps
- **HaveIBeenPwned k-anonymity requirement** — specified that only the
  first 5 characters of the SHA-1 hash should be sent; sending full
  passwords or hashes to a third party is a privacy violation
- **Context window management** — 70%/85%/90% thresholds with concrete
  actions added to both CLAUDE.md files
- **Existing project instructions** — guardrails-team README includes
  nine-step guide for adding guardrails to a project with existing code,
  including merge strategies for conflicting CLAUDE.md and SECURITY.md files

### Fixed — legal and standards accuracy

- GDPR breach notification: Art. 33 (supervisory authority, 72 hours)
  vs Art. 34 (data subjects, high-risk only) correctly distinguished
- HIPAA: "may constitute a reportable breach" corrected — it triggers a
  risk assessment under 45 CFR §164.402, not automatic reportability;
  15-minute timeout correctly attributed to NIST SP 800-63B (addressable
  implementation specification, not mandatory under HIPAA)
- PCI-DSS: requirement numbers corrected throughout to v4.0.1 precision
  (Req 3.2 → Req 3.2.1; Req 3.3 → Req 3.3.1); track data added to the
  logging prohibition
- CCPA/CPRA: third threshold added (>50% annual revenues from
  selling or sharing personal information — previously omitted)
- EU AI Act: Art. 11 scope corrected (applies to providers of high-risk
  systems under Annex III only, not all AI-assisted development);
  Art. 50 scope corrected (specific disclosure categories, not a blanket
  requirement for all AI use)
- Privacy Act 1988 (Cth) penalty: corrected to the statutory figure —
  the greater of $50M, 3× the benefit obtained, or 30% of adjusted turnover
  (serious or repeated interference)
- Privacy Act small business exemption: "schools" removed as a named
  exclusion (not in the Act); replaced with actual statutory categories
  (health service providers, contracted government service providers,
  organisations that trade in personal information)
- ISO 27001 A.8.30 framed as reasonable extension of the outsourced
  development control, not an explicit requirement of the standard

### Fixed — technical and functional

- `.gitattributes`: removed incorrect Git LFS lines (`filter=lfs
  diff=lfs merge=lfs -text`) applied to shell scripts — caused silent
  failures on repos without Git LFS and overrode `text eol=lf`
- `.gitattributes` and guardrails-team README: three locations claimed
  `.gitattributes` "preserves hook execute permissions" — factually wrong;
  `.gitattributes` cannot preserve execute bits; all corrected to "ensures
  consistent line endings"
- `pre-tool-call.sh`: replaced `grep -P` with `python3` inline scripts for
  Unicode and hidden-character detection — macOS BSD grep does not support
  `-P` so checks were silently doing nothing on macOS
- `managed-settings.json`: removed `"Bash(cat *)"` from allow list — allows
  `cat ~/.aws/credentials` via bash, bypassing `.claudeignore` file exclusions
  which only block the Claude Code Read tool, not bash commands
- `managed-settings.json`: fixed `mcpServers._comment` and `._example` fields
  which were being parsed as actual MCP server definitions
- `managed-settings.json`: `_notes` field stripping added to Makefile
  `deploy-settings` target and manual deployment instructions
- Both `settings.json` files: removed stray separator string from JSON
  allow arrays (was not a valid allow rule)
- Guardrails README "from scratch" block: fixed broken command sequence —
  cloned repo then tried to copy from a path that no longer existed after
  renaming the clone

### Fixed — structural and consistency

- H8 (Privacy Act) and H9 (Cyber Security Act): relocated into Part 6
  (Regulatory Compliance) — were incorrectly placed after Part 7 (ADRs)
  following initial Australian law addition
- ADR trigger list made consistent across all five locations:
  SECURITY.md Part 7, guardrails-team CLAUDE.md list and paragraph,
  create-adr.md, docs/decisions/README.md
- CSP `frame-ancestors 'none'` propagated to security-review.md and
  SECURITY-QUICK-REF.md (was already in SECURITY.md A02)
- Australian law propagated to all relevant locations including
  compliance-check.md Steps 1 and 2
- Context window 85% instruction changed from "stop non-essential work"
  (vague) to "complete the current atomic task, then run /compact"
- File count corrected (7 → 8) in root README comparison table
- "OWASP Agentic AI Top 10" removed — claimed in guardrails-team README
  but not in SECURITY.md standards table and not published as a formal
  OWASP standard
- Double blank lines removed throughout; triple `---` separator at
  SECURITY.md end collapsed to single
