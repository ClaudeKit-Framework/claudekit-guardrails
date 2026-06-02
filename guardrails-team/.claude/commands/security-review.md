# Security Review

Read `SECURITY.md` in full, then conduct a structured security review of
the code specified (or the current working context if none specified).

## Review Checklist

Work through each section. Report findings as: PASS / FAIL / WARNING / N/A.
For every FAIL or WARNING, provide: the location, the issue, and the fix.

### 1. Access Control (OWASP A01)
- [ ] Auth check inside every function touching sensitive data (not routing only)
- [ ] Deny-by-default implemented
- [ ] Resource ownership verified server-side before returning data
- [ ] No IDOR vulnerabilities (user-controlled IDs validated against ownership)
- [ ] SSRF protection: user-controlled URLs validated before server-side requests

### 2. Configuration (OWASP A02)
- [ ] Security headers present: CSP (with `frame-ancestors 'none'` preferred over
      X-Frame-Options for modern browsers), HSTS, X-Content-Type-Options
- [ ] No wildcard CORS on authenticated endpoints
- [ ] Cookies: HttpOnly, Secure, SameSite=Strict
- [ ] No debug mode or verbose errors in production config
- [ ] No default credentials anywhere

### 3. Supply Chain (OWASP A03)
- [ ] All production dependencies pinned to exact versions
- [ ] No packages from unverified sources
- [ ] CDN assets have SRI hashes
- [ ] CI/CD actions pinned to commit SHA

### 4. Cryptography (OWASP A04)
- [ ] No MD5, SHA-1, DES, RC4, ECB mode usage
- [ ] No hardcoded secrets or credentials
- [ ] CSPRNG used (not Math.random/random.random) for security purposes
- [ ] TLS 1.2+ enforced on all external connections
- [ ] Passwords hashed with bcrypt/Argon2id

### 5. Injection (OWASP A05)
- [ ] All SQL queries parameterised — zero string concatenation with user input
- [ ] No OS command injection: shell commands use argument arrays
- [ ] HTML output context-encoded — no innerHTML with user input
- [ ] No template injection vulnerabilities

### 6. Authentication (OWASP A07)
- [ ] Access tokens ≤15 min expiry
- [ ] Refresh token rotation on use
- [ ] Server-side session invalidation on logout
- [ ] No session tokens in localStorage
- [ ] Account lockout with exponential backoff

### 7. Logging (OWASP A09)
- [ ] Auth events logged (success, failure, lockout)
- [ ] Authorisation failures logged
- [ ] No passwords, tokens, or PANs in logs
- [ ] Correlation IDs on all log entries

### 8. Error Handling (OWASP A10)
- [ ] Generic error messages to clients
- [ ] Full detail server-side with correlation ID
- [ ] No stack traces or file paths in responses
- [ ] Fail-closed on security check exceptions

### 9. Data Compliance
- [ ] No real PII/PHI/CHD in code, examples, fixtures, or logs
- [ ] Data minimisation applied
- [ ] Retention policy documented for any new data store

### 10. Tests
- [ ] Security-relevant functions have tests
- [ ] Happy path, invalid input, and edge case covered

## Output Format

Summary: [PASS / NEEDS WORK / CRITICAL ISSUES]

Findings:
| # | Severity | Location | Issue | Fix |
|---|---|---|---|---|

Recommended next steps:
