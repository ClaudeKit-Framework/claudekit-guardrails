# claudekit-guardrails — Session Context

Last updated: June 2026
Stage: 2 — Complete
Status: Done, pushed to main

## Always read first
/home/freyja/Documents/Dev/ClaudeKit/claudekit-commons/DESIGN.md

## What's been done
- Files preserved from deleted Claude-Code-Guardrails repo and committed
- README.md URLs updated to ClaudeKit-Framework/claudekit-guardrails
- Hook scripts confirmed executable (100755)
- Solo and team variants confirmed with correct file structure
- SESSION-CONTEXT.md added

## File structure
guardrails-solo/ — 7 files:
  CLAUDE.md, .claude/settings.json, .claudeignore,
  .claude/commands/create-adr.md,
  docs/decisions/0000-template.md, docs/decisions/README.md,
  SECURITY-QUICK-REF.md

guardrails-team/ — 16 files:
  CLAUDE.md, .claude/settings.json, .claudeignore,
  .claude/commands/create-adr.md,
  .claude/commands/security-review.md,
  .claude/commands/compliance-check.md,
  .claude/hooks/pre-tool-call.sh, .claude/hooks/post-write.sh,
  docs/decisions/0000-template.md, docs/decisions/README.md,
  SECURITY.md, SECURITY-QUICK-REF.md,
  managed-settings.json, Makefile, .gitattributes,
  src/auth/CLAUDE.md (copied to docs/examples/module-claude-md-auth.md)

## Open flags
- Known bug from original repo: post-write.sh hook skips markdown 
  files — secrets in .md files go unscanned. Needs fixing.
- Four framework gaps logged as issues in original repo — 
  carry forward and address in a future session

## What's next
- No further Stage 2 work
- Future: fix markdown hook bug
- Future: address four framework gaps from original repo

## Notes
- Do not touch commons files from this session
- Do not update DESIGN.md — design changes go through Claude chat
- Solo commands: /create-adr only
- Team commands: /create-adr, /security-review, /compliance-check
- Org name is ClaudeKit-Framework (one hyphen, not three)