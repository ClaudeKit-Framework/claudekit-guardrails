# claudekit-guardrails — Session Context

Last updated: June 2026
Stage: 2 — In progress
Status: Files present, not yet reviewed or committed

## Always read first
/home/freyja/Documents/Dev/ClaudeKit/claudekit-commons/DESIGN.md

## What's been done
- Files preserved from deleted Claude-Code-Guardrails repo
- Repo cloned and pushed to ClaudeKit-Framework org
- Solo and team variants present in directory structure
- Reviewed all existing files against DESIGN.md
- Updated all 3 READMEs: replaced FreyjaJD/Claude-Code-Guardrails 
  with ClaudeKit-Framework/claudekit-guardrails throughout; fixed 
  guardrails-solo/README.md cp paths (guardrails/ → guardrails-solo/);
  updated guardrails-team/README.md Step 3 clone flow and BASELINE var
- Set chmod +x on both hook scripts

## What's next
- Commit and push to main

## Open flags
- Commons manifests have wrong source paths — do NOT fix from 
  guardrails session; fix in commons session after guardrails committed.
  Issues: source paths use variants/solo/, variants/team/, shared/ — 
  none exist; actual dirs are guardrails-solo/ and guardrails-team/.
  File lists incomplete. Solo manifest incorrectly lists team-only commands.
- DESIGN.md contains a typo: Claude-Kit-Framework should be ClaudeKit-Framework
  — fix in design chat, not from code sessions

## Notes
- Do not touch any files in claudekit-commons from this session
- Do not update DESIGN.md — design changes go through Claude chat
- Solo variant: 7 files per Claude Code assessment
- Team variant: 15 files per Claude Code assessment