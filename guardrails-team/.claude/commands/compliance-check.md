# Compliance Check

Read `SECURITY.md` Part 6 (Regulatory Compliance), then assess the current
task or feature against the applicable regulatory frameworks.

## Step 1 — Identify Applicable Frameworks

Answer each question:

- Does this feature process personal data of Australian individuals? → **Privacy Act 1988 (Cth) / APPs**
- Does this involve a ransomware payment or notifiable cyber incident (AU)? → **Cyber Security Act 2024**
- Does this feature process personal data of EU residents? → **GDPR**
- Does this feature handle US health information (PHI)? → **HIPAA**
- Does this feature process, store, or transmit payment card data? → **PCI-DSS v4.0.1**
- Does this serve California residents at scale? → **CCPA/CPRA**
- Does this feature use AI to interact with or make decisions about users? → **EU AI Act**
- Is the organisation pursuing SOC 2 certification? → **SOC 2**
- Is the organisation ISO 27001 certified or pursuing it? → **ISO 27001**

## Step 2 — Run Applicable Checks

### Privacy Act 1988 (Cth) / APPs
- [ ] Only personal information reasonably necessary is collected (APP 3)
- [ ] Privacy policy published describing collection, use, and disclosure (APP 1)
- [ ] Individuals notified of collection purpose at or before time of collection (APP 5)
- [ ] Personal information used/disclosed only for primary purpose or expected secondary purpose (APP 6)
- [ ] Cross-border disclosures: reasonable steps taken to ensure comparable protection (APP 8)
- [ ] Reasonable steps in place to protect personal information (APP 11)
- [ ] Mechanism for individuals to access their personal information (APP 12)
- [ ] Sensitive information (health, biometric, racial/ethnic, etc.) handled with consent
- [ ] NDB scheme: process exists to assess and notify OAIC + individuals of eligible breaches
- [ ] Automated decision-making disclosure planned for privacy policy (required December 2026)

### Cyber Security Act 2024 (Cth)
- [ ] If a ransomware/extortion payment is made: report to Dept of Home Affairs
      within 72 hours via cyber.gov.au
- [ ] If a SOCI-regulated entity: cyber incident reporting procedures align with
      12-hour (critical) and 72-hour (other) ACSC reporting timelines

### GDPR
- [ ] Only necessary data collected (minimisation)
- [ ] Legal basis for processing documented
- [ ] No real PII in AI tool context
- [ ] User rights (access, erasure, portability) architecture exists
- [ ] Data retention and deletion schedule documented
- [ ] Cross-border transfer mechanism in place if data leaves EEA
- [ ] DPIA flagged if high-risk processing (profiling, biometrics, monitoring at scale)

### HIPAA
- [ ] **No PHI in Claude Code context at any point**
- [ ] Minimum necessary standard applied
- [ ] AES-256 at rest, TLS 1.2+ in transit
- [ ] Every PHI access logged with: user, timestamp, record, action
- [ ] BAA in place with all third-party services receiving PHI
- [ ] Session timeout implemented on PHI-accessing sessions — 15 minutes is
      the widely adopted baseline per NIST SP 800-63B; HIPAA §164.312(a)(2)(iii)
      makes this addressable (document exception if a different value is used)
- [ ] Human security review scheduled before deployment

### PCI-DSS v4.0.1
- [ ] **No raw card data touched — tokenisation used**
- [ ] Change control documentation prepared (Req 6.4)
- [ ] Human security review of AI-generated code scheduled (Req 6.3.2)
- [ ] No PANs, CVVs, PINs, or track data (magnetic stripe) in logs (Req 3.3.1)
- [ ] CDE network segmentation maintained
- [ ] SAD not stored after authorisation (Req 3.2.1)

### CCPA/CPRA
- [ ] Right to know mechanism exists
- [ ] Right to delete mechanism exists
- [ ] Right to opt out of sale/sharing exists
- [ ] No sale/sharing of personal data without consent

### EU AI Act
- [ ] Feature does not fall under prohibited practices (in force Feb 2025)
- [ ] If high-risk (Annex III): technical documentation prepared (Art. 11)
- [ ] If high-risk: logging sufficient for post-hoc investigation (Art. 12)
- [ ] Human oversight mechanism in place for AI-driven decisions
- [ ] AI use disclosed to end users where applicable (Art. 50)
- [ ] Flagged for legal review if Annex III classification is uncertain

### SOC 2
- [ ] Evidence trail showing AI-assisted code was reviewed before deployment
      (commit messages, PR descriptions, or code review records — per auditor requirements)
- [ ] Rate limiting and circuit breakers included (Availability)
- [ ] Data integrity checksums for critical pipelines (Processing Integrity)

### ISO 27001
- [ ] Change management documented (A.8.32)
- [ ] Production data not used in development (A.8.31)
- [ ] Security requirements specified before implementation began (A.8.26)

## Step 3 — Output

Report: which frameworks apply, pass/fail for each check, and any
remediation needed before this feature can be considered compliant.

If an ADR is warranted by any finding, run `/create-adr`.
