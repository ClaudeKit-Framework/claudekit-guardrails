#!/bin/bash
# .claude/hooks/post-write.sh
#
# Runs after every file write (Edit, Write, Create tools).
# Scans newly written code for hardcoded secrets and disabled security controls.
#
# Input:  JSON via stdin with tool name and file path
# Output: JSON with systemMessage if issues found

set -euo pipefail

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""' 2>/dev/null || echo "")
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input // {}' 2>/dev/null || echo "{}")

# Only run on write operations
if [[ "$TOOL_NAME" != "Write" && "$TOOL_NAME" != "Edit" && \
      "$TOOL_NAME" != "write_file" && "$TOOL_NAME" != "str_replace_based_edit_tool" ]]; then
  exit 0
fi

FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // .path // ""' 2>/dev/null || echo "")

if [[ -z "$FILE_PATH" || ! -f "$FILE_PATH" ]]; then
  exit 0
fi

CONTENT=$(cat "$FILE_PATH" 2>/dev/null || echo "")
ISSUES=()

# ── 1. Hardcoded secret patterns ──────────────────────────────────────────

SECRET_PATTERNS=(
  # API keys (generic high-entropy strings after key indicators)
  "(api_key|apikey|api-key)\s*[=:]\s*['\"][a-zA-Z0-9_\-]{16,}['\"]"
  "(secret|password|passwd|pwd)\s*[=:]\s*['\"][^'\"]{8,}['\"]"
  "(token|auth_token|access_token)\s*[=:]\s*['\"][a-zA-Z0-9_\-\.]{16,}['\"]"

  # Provider-specific patterns
  "sk-[a-zA-Z0-9]{32,}"                           # OpenAI / Anthropic keys
  "AKIA[0-9A-Z]{16}"                               # AWS access key ID
  "ghp_[a-zA-Z0-9]{36}"                            # GitHub personal access token
  "ghs_[a-zA-Z0-9]{36}"                            # GitHub app token
  "xox[baprs]-[0-9a-zA-Z\-]+"                      # Slack tokens
  "AIza[0-9A-Za-z\-_]{35}"                         # Google API key
  "eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+" # JWT (may be hardcoded)
  "-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----" # Private key block

  # Database connection strings with credentials
  "(mongodb|mysql|postgresql|postgres|redis):\/\/[^:]+:[^@]+@"
  "jdbc:[^:]+:\/\/[^:]*:[^@]*@"
)

for PATTERN in "${SECRET_PATTERNS[@]}"; do
  if echo "$CONTENT" | grep -qiE "$PATTERN" 2>/dev/null; then
    # Exclude obvious test/example values
    MATCH=$(echo "$CONTENT" | grep -iE "$PATTERN" | head -1)
    if ! echo "$MATCH" | grep -qiE "(example|placeholder|your[_-]?key|xxx+|test|fake|dummy|replace|changeme|todo)" 2>/dev/null; then
      ISSUES+=("HARDCODED SECRET: Possible credential detected in $FILE_PATH — line: $(echo "$MATCH" | cut -c1-80)")
    fi
  fi
done

# ── 2. Disabled security controls ─────────────────────────────────────────

BYPASS_PATTERNS=(
  "verify\s*=\s*False"                             # Python requests SSL bypass
  "rejectUnauthorized\s*:\s*false"                 # Node.js TLS bypass
  "InsecureSkipVerify\s*:\s*true"                  # Go TLS bypass
  "ssl_verify\s*=\s*false"                         # Generic SSL disable
  "\-k\s+https://"                                 # curl insecure flag
  "allow_redirects\s*=\s*True.*verify\s*=\s*False" # Python double bypass
  "#\s*(auth|authentication|authoriz)\s*(check|disabled|skip|bypass|todo)" # Commented auth
  "\/\/\s*(auth|authentication|authoriz)\s*(check|disabled|skip|bypass|todo)"
  "TODO.*security"
  "FIXME.*auth"
  "HACK.*bypass"
  "console\.log\(.*password"                       # Password in console.log
  "console\.log\(.*token"                          # Token in console.log
  "console\.log\(.*secret"                         # Secret in console.log
  "print\(.*password"                              # Python password print
  "print\(.*secret"
)

for PATTERN in "${BYPASS_PATTERNS[@]}"; do
  if echo "$CONTENT" | grep -qiE "$PATTERN" 2>/dev/null; then
    MATCH=$(echo "$CONTENT" | grep -iE "$PATTERN" | head -1)
    ISSUES+=("SECURITY CONTROL DISABLED: Pattern detected in $FILE_PATH — $(echo "$MATCH" | cut -c1-80 | xargs)")
  fi
done

# ── 3. Weak crypto usage ──────────────────────────────────────────────────

WEAK_CRYPTO_PATTERNS=(
  "MD5\s*\("
  "md5\s*\("
  "hashlib\.md5"
  "createHash\(['\"]md5['\"]"
  "SHA1\s*\("
  "sha1\s*\("
  "hashlib\.sha1"
  "createHash\(['\"]sha1['\"]"
  "DES\s*\("
  "3DES"
  "RC4"
  "Cipher\.getInstance\(['\"]DES"
  "ECB"
  "Math\.random\(\).*token"
  "Math\.random\(\).*secret"
  "Math\.random\(\).*key"
  "random\.random\(\).*token"
)

for PATTERN in "${WEAK_CRYPTO_PATTERNS[@]}"; do
  if echo "$CONTENT" | grep -qE "$PATTERN" 2>/dev/null; then
    MATCH=$(echo "$CONTENT" | grep -E "$PATTERN" | head -1)
    ISSUES+=("WEAK CRYPTO: Insecure algorithm detected in $FILE_PATH — $(echo "$MATCH" | cut -c1-80 | xargs)")
  fi
done

# ── 4. Output issues if found ─────────────────────────────────────────────

if [[ ${#ISSUES[@]} -gt 0 ]]; then
  ISSUE_TEXT="⚠️ POST-WRITE SECURITY SCAN: Issues found in $FILE_PATH\n\n"
  for ISSUE in "${ISSUES[@]}"; do
    ISSUE_TEXT+="• $ISSUE\n"
  done
  ISSUE_TEXT+="\nThese issues must be resolved before this task is marked complete.\nReport each issue to the developer and do not proceed to the next task."

  jq -n --arg msg "$ISSUE_TEXT" '{"systemMessage": $msg}'
  exit 0
fi

exit 0
