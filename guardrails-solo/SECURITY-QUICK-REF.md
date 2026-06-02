# SECURITY-QUICK-REF.md

One-page security reference for solo projects. Read before any security,
auth, data handling, or infrastructure task.

For full regulatory detail, testing toolchain, NIST frameworks, and
infrastructure standards — use `guardrails-team/SECURITY.md`.

---

## OWASP Web Top 10 — Key Rules Per Category

> The OWASP Top 10:2025 reflects the current published edition. Category
> numbers may shift in future releases. Verify at owasp.org/Top10 on review.

| # | Risk | What to do |
|---|---|---|
| A01 | Broken Access Control | Auth check inside every function; deny-by-default; verify ownership |
| A02 | Security Misconfiguration | Security headers on all responses; no debug mode in production; no default credentials |
| A03 | Supply Chain | Exact version pins; lockfile committed; SRI on CDN assets |
| A04 | Cryptographic Failures | AES-256-GCM, bcrypt/Argon2id, TLS 1.2+; never MD5/SHA-1/DES/ECB |
| A05 | Injection | Parameterised queries; argument arrays for shell; DOMPurify for HTML |
| A06 | Insecure Design | Rate limiting; input size limits; account lockout; threat model new features |
| A07 | Auth Failures | ≤15 min token expiry; server-side logout; no tokens in localStorage; MFA for admin |
| A08 | Integrity Failures | SRI on CDN; validate package signatures; protect CI/CD pipeline configs |
| A09 | Logging Failures | Log auth/authz events; never log passwords/tokens/PANs; include correlation IDs |
| A10 | Error Handling | Generic errors to clients; full detail server-side; fail closed on exceptions |

---

## Security Headers — Required on Every Response

```
Content-Security-Policy: default-src 'self'; frame-ancestors 'none'
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: camera=(), microphone=(), geolocation=()
```

`frame-ancestors 'none'` in CSP is the modern replacement for `X-Frame-Options: DENY`.
Keep both for older browser compatibility.
Remove `X-Powered-By`. Set `HttpOnly; Secure; SameSite=Strict` on all cookies.

---

## Approved vs Prohibited Cryptography

| Use | Approved | Never use |
|---|---|---|
| Symmetric encryption | AES-256-GCM, ChaCha20-Poly1305 | DES, 3DES, RC4, ECB mode |
| Asymmetric | RSA-2048+ (4096 preferred), Ed25519 | RSA <2048 |
| Hashing (data integrity) | SHA-256, SHA-384, SHA-512 | MD5, SHA-1 |
| Password hashing | bcrypt (cost ≥12), Argon2id, scrypt | MD5, SHA-1, plaintext, any reversible encoding |
| Random (security) | `crypto.randomBytes`, `secrets` module, `os.urandom` | `Math.random()`, `random.random()` |
| Transport | TLS 1.3 (1.2 minimum) | SSL, TLS 1.0, TLS 1.1 |

---

## Compliance Triggers — Know When a Rule Applies

| If you handle... | Framework | Hard rules |
|---|---|---|
| Personal data of Australian individuals | Privacy Act 1988 (Cth) / APPs | Collect only what is necessary (APP 3); publish a privacy policy (APP 1); notify of collection purpose (APP 5); restrict cross-border transfers (APP 8); APP 11 security obligations; notify OAIC + individuals if eligible data breach (NDB scheme) |
| Personal data of EU residents | GDPR | Minimise data; build erasure/access rights; document retention; flag cross-border transfers |
| US health information (PHI) | HIPAA | No PHI in AI context ever; encrypt at rest + in transit; log every PHI access; BAA with third parties |
| Payment card data | PCI-DSS v4.0.1 | Never touch raw card data — always tokenise; never log PANs/CVVs; no CHD in logs |
| California users at scale | CCPA/CPRA | Right to know, delete, opt out, correct — build the mechanism before launch |
| AI features interacting with users | EU AI Act | Disclose AI use in applicable contexts; no prohibited practices (social scoring, subliminal manipulation) |

If any of these apply and you are solo, consider whether `guardrails-team`
is appropriate — the regulatory obligations do not scale down with team size.

---

## Containers & CI/CD — Key Rules

**Docker / containers:**
- Never use `privileged: true` or run containers as root — add `USER` in Dockerfile
- Never put secrets in `ENV` instructions — use environment injection at runtime
- Use multi-stage builds to keep dev dependencies out of production images
- Scan images before deploying: `docker scout` or Trivy

**CI/CD pipelines (GitHub Actions, GitLab CI, etc.):**
- Pin action versions to a commit SHA, not a tag (`uses: actions/checkout@abc123`)
- Never print secret environment variables in pipeline logs
- Use OIDC-based cloud authentication instead of long-lived service account keys
- Require manual approval before any production deployment step

---

## Architecture Decision Records

Create an ADR (`/create-adr`) when you make any of these decisions:
- Authentication and session strategy
- Encryption algorithm or library
- Any third-party service receiving user data
- Data retention and deletion approach
- Deviation from any rule in `CLAUDE.md`

ADRs are useful evidence if you later pursue ISO 27001, SOC 2, PCI-DSS,
GDPR, or Privacy Act 1988 (Cth) compliance — they demonstrate that security
and privacy decisions were deliberate rather than accidental.

---

*Full detail on all frameworks including Privacy Act 1988 (Cth), Cyber Security Act 2024,
SOCI Act, GDPR, HIPAA, PCI-DSS, SOC 2, ISO 27001, and EU AI Act:
see SECURITY.md in the guardrails-team template.*
