# CLAUDE.md — Authentication Module

These rules apply to all code in `src/auth/` and override the root `CLAUDE.md`
where more specific guidance is given. Root rules still apply in full.

This is an example of a module-level CLAUDE.md. Copy this pattern to:
`src/payments/CLAUDE.md`, `src/admin/CLAUDE.md`, `src/api/CLAUDE.md`
or any directory where stricter, context-specific rules are needed.

---

## Elevated Review Requirement

Every change in this directory requires human review before merge.
No exception. Auth bugs are the highest-impact class of security vulnerability.

State this at the start of any auth task:
"I am working in the auth module. Every change here requires your explicit
review before it is considered complete."

---

## Auth-Specific Rules

**Password handling**
- bcrypt with cost factor ≥12 or Argon2id only
- Never store, log, or transmit plaintext passwords at any point
- Never compare passwords with `==` or `===` — use constant-time comparison
- Validate password complexity server-side — never trust client-side only

**Tokens**
- Access tokens: ≤15 minute expiry, signed with RS256 or ES256 (not HS256
  in multi-service environments where the secret would need to be shared)
- Refresh tokens: rotate on every use; invalidate on logout; store
  hashed in database (never plaintext)
- Never store tokens in localStorage or sessionStorage
- Include: `iss`, `sub`, `aud`, `iat`, `exp` claims in every JWT

**Session management**
- Generate session IDs with CSPRNG (min 128 bits entropy)
- Invalidate server-side on logout — client-side deletion is not enough
- HttpOnly, Secure, SameSite=Strict on all session cookies
- Regenerate session ID on privilege escalation (login, role change)
- 15-minute inactivity timeout for sensitive operations

**Multi-factor authentication**
- TOTP (RFC 6238) or WebAuthn preferred over SMS
- MFA required for: admin accounts, password reset, email change,
  payment method changes
- Backup codes: generate 8–12, store hashed, single-use, displayed once only

**Account security**
- Lockout after 5 failed attempts; use exponential backoff
  (e.g. 30s, 60s, 5m, 15m — exact values are implementation choices;
  NIST SP 800-63B requires rate limiting but does not mandate specific delays)
- Alert user on: new device login, password change, email change
- Password reset tokens: single-use, 15-minute expiry, sent via email only
- Never reveal whether an email address is registered (prevents enumeration)

**OAuth / SSO**
- Validate `state` parameter to prevent CSRF on OAuth flows
- Validate `redirect_uri` against strict allowlist
- Use PKCE for all authorisation code flows
- Never use the implicit flow

---

## Logging Requirements (Auth Module)

Log every event below. Include: timestamp (ISO 8601 UTC), user ID,
IP address, user agent, and outcome.

- Login attempt (success and failure)
- Account lockout triggered
- Password reset requested and completed
- MFA enabled, disabled, or bypassed
- OAuth authorisation initiated and completed
- Session created, refreshed, and invalidated
- Admin action on any user account

Never log: passwords, tokens, OTP codes, or backup codes.

---

## Testing Requirement (Auth Module — Stricter Than Project Baseline)

Minimum coverage: 90% — stricter than the general project recommendation.

Required test cases for every auth function:
- Valid credentials / happy path
- Invalid credentials (wrong password, expired token, wrong user)
- Brute force / lockout behaviour
- Token expiry and rotation
- Session invalidation on logout
- MFA enforcement and bypass attempts
- Edge cases: empty input, Unicode, extremely long strings

---

## ADR Requirement

Any change to the auth strategy, token format, session mechanism, or MFA
approach requires an ADR before implementation. Run `/create-adr`.
