# Claude Code Guardrails

Security governance template for teams using Claude Code on regulated or
multi-developer projects. Use as a starting point — not a certified adherence
solution. Verify all standards references independently before relying on them
in a regulated environment.

**Solo developer or side project?** Use `guardrails-solo` instead — same
core protections, five-minute setup, no team overhead.
This template is for teams, regulated data, and regulatory requirements.

---

## What This Is

A layered security governance system across seven layers:

| Layer | File(s) | What It Does | Can Be Bypassed? |
|---|---|---|---|
| 1 — Org enforcement | `managed-settings.json` | Hard permission controls, bypass mode disabled | No — deployed to machine |
| 2 — File exclusions | `.claudeignore` | Blocks Claude reading sensitive files | No — technical control |
| 3 — Automated hooks | `.claude/hooks/` | Pre/post execution scanning | No — runs automatically |
| 4 — Project permissions | `.claude/settings.json` | Allow/deny lists for this project | Only by managed-settings |
| 5 — Root instructions | `CLAUDE.md` | Session rules and standing orders | Soft — relies on model |
| 6 — Module rules | `src/auth/CLAUDE.md` etc. | Stricter rules per sensitive module | Soft — relies on model |
| 7 — Standards reference | `SECURITY.md` | Full adherence detail and ADR guide | Reference only |

Layers 1–4 are technical controls. Layers 5–6 are instructions. Layer 7 is reference.
A secure setup requires all seven layers.

---

## Setup

Setup has two parts: **once per developer machine** (Layers 1–3), and
**once per project** (Layers 4–7). Both must be completed for full enforcement.

---

### Part 1 — Once Per Developer Machine

These steps are not per-project. Do them once on each machine that will
use Claude Code. They apply to every project on that machine.

---

#### Step 1 — Deploy managed-settings.json (Layer 1)

`managed-settings.json` is the only layer that cannot be bypassed by a developer.
It must be copied to a specific system path — it is **not** enforced by being in
the project repo.

**Before deploying:** open `managed-settings.json` and delete both the `_readme`
field and the `_notes` field — they are documentation only and must not be
present in the deployed file. The `make deploy-settings` target does this
automatically. If deploying manually, delete both fields from the JSON first.

**macOS:**
```bash
# Create the directory if it doesn't exist
mkdir -p ~/Library/Application\ Support/Claude

# Copy the template
cp managed-settings.json ~/Library/Application\ Support/Claude/managed-settings.json
```

**Windows (PowerShell):**
```powershell
# Create the directory if it doesn't exist
New-Item -ItemType Directory -Force -Path "$env:APPDATA\Claude"

# Copy the template
Copy-Item managed-settings.json "$env:APPDATA\Claude\managed-settings.json"
```

**Linux:**
```bash
mkdir -p ~/.config/Claude
cp managed-settings.json ~/.config/Claude/managed-settings.json
```

**For teams — deploy via MDM instead of manually:**
```
macOS:  Deploy as a managed preference to:
        ~/Library/Application Support/Claude/managed-settings.json
        via Jamf, Kandji, or any MDM tool

Windows: Deploy via Intune or GPO to:
        %APPDATA%\Claude\managed-settings.json

Enterprise plan: Use server-managed settings in the Claude admin console
        at claude.ai > Admin > Developer Settings > Managed Settings
        (Claude Team v2.1.38+ / Enterprise v2.1.30+ required)
        Note: incompatible with custom ANTHROPIC_BASE_URL (e.g. Bedrock routing)
```

**Verify it is working:**
```bash
claude --version  # Start Claude Code — it should pick up the settings silently
# Attempt: claude --dangerously-skip-permissions
# Expected: blocked or warning shown — if it works, managed-settings is not loaded
```

---

#### Step 2 — Install hook dependencies (jq and python3)

The security hooks require `jq` to parse JSON from Claude Code, and `python3`
to scan for hidden Unicode characters in files (macOS's built-in grep does
not support the regex features needed for this — python3 is used instead).

**jq:**

macOS: `brew install jq` · Ubuntu/Debian: `sudo apt-get install jq` · Windows: `choco install jq`

**python3:**

macOS: built-in or `brew install python3` · Ubuntu/Debian: `sudo apt-get install python3` · Windows: `winget install Python.Python.3`

**Verify both:**
```bash
jq --version      # jq-1.6 or higher
python3 --version # Python 3.8 or higher
```

---

### Part 2 — Once Per Project

Run these steps immediately after cloning this repo as the base for a
new project.

---

#### Step 3 — Clone and rename

```bash
# Clone this baseline as your new project
git clone git@github.com:FreyjaJD/Claude-Code-Guardrails.git my-new-project
cd my-new-project

# Point origin to your new project repo
git remote set-url origin https://github.com/your-org/my-new-project.git

# Or run the automated setup (does Steps 4 and 5 for you)
make setup
```

---

#### Step 4 — Make hooks executable

Git does not reliably preserve file execute permissions across operating systems.
The hooks will silently not run after a fresh clone unless you do this.

```bash
chmod +x .claude/hooks/*.sh

# Verify
ls -la .claude/hooks/
# Both files should show -rwxr-xr-x (x = executable)
```

`make setup` does this automatically. If you are not using Make, add this
step to your project's onboarding documentation so every new team member
runs it.

---

#### Step 5 — Customise CLAUDE.md Section 0

Open `CLAUDE.md` and fill in the Project Context block at the top
(Section 0). This tells Claude Code about your stack so it does not
need to be told each session.

```
Stack:        e.g. Next.js 14 / FastAPI / PostgreSQL
Language(s):  e.g. TypeScript, Python
Test command: e.g. npm test / pytest -q
Lint command: e.g. npm run lint / ruff check .
Build:        e.g. npm run build
Key dirs:     src/ (app code)  infra/ (IaC)  docs/ (ADRs)
```

---

#### Step 6 — Customise .claude/settings.json allow list

Open `.claude/settings.json` and update the `allow` list with your
stack's specific commands. The defaults cover common tools but your
project's exact test, lint, and build commands should be added so
Claude Code can run them without asking each time.

Example for a Next.js + Prisma project:
```json
"Bash(npm run dev)",
"Bash(npm run lint)",
"Bash(npm test)",
"Bash(npx prisma migrate dev)",
"Bash(npx prisma studio)"
```

---

#### Step 7 — Add module-level CLAUDE.md files

`src/auth/CLAUDE.md` is an example of a module-level rules file.
Copy the pattern to every sensitive module directory in your project:

```bash
cp src/auth/CLAUDE.md src/payments/CLAUDE.md
cp src/auth/CLAUDE.md src/admin/CLAUDE.md
cp src/auth/CLAUDE.md src/api/CLAUDE.md
```

Then edit each copy for the specific security concerns of that module.
Claude Code reads the closest `CLAUDE.md` file to the code it is working
on, so these subdirectory files add specificity without bloating the root.

---

#### Step 8 — Create your first ADR

Before writing any code, document your first architectural decisions.
In Claude Code, run:

```
/create-adr
```

Typical first ADRs for a new project:
- `0001-authentication-strategy.md`
- `0002-database-and-orm-choice.md`
- `0003-hosting-and-deployment-approach.md`

These establish the baseline record that compliance auditors (SOC 2, ISO 27001,
PCI-DSS) expect to see.

---

#### Step 9 — Extend .claudeignore for your project

Open `.claudeignore` and add any project-specific files that should never
be read by Claude Code — internal documentation, certificate stores,
proprietary config, etc. The defaults cover common patterns but every
project has unique files.

---

---

## Adding to an Existing Project

Use this section instead of Part 2 if you are adding the baseline to a
project that already has code. The machine setup (Part 1 — Steps 1 and 2)
is the same and must be completed first.

Expect this to take a day minimum. The file setup takes minutes.
The audit, findings triage, and retroactive ADRs are where the time goes.
That is normal and the point — you are finding out what you are working with.

---

### Existing Project Step 1 — Copy the baseline files

Create a branch first. Do not add governance files directly to main.

```bash
cd your-existing-project
git checkout -b security/add-baseline
```

**Do not blindly copy all files.** Several baseline files may already
exist in your project and overwriting them would destroy existing content.
Handle each category separately as described below.

---

#### Files that are safe to copy directly

These are new files unlikely to exist in any project yet:

```bash
BASELINE=../Claude-Code-Guardrails

cp $BASELINE/.claudeignore .
cp $BASELINE/managed-settings.json .
cp -r $BASELINE/docs .
cp -r $BASELINE/.claude .
make hooks
```

---

#### Files that must be merged if they already exist

**`.gitattributes`**

If your project already has one:
```bash
# Compare first
diff .gitattributes $BASELINE/.gitattributes

# Then manually add any missing lines from the baseline version
# The critical lines are the *.sh eol=lf entries for hook compatibility
```

If your project does not have one:
```bash
cp $BASELINE/.gitattributes .
```

**`Makefile`**

If your project already has one:
```bash
diff Makefile $BASELINE/Makefile
# Copy the setup, hooks, deploy-settings, and verify targets
# into your existing Makefile — do not overwrite the whole file
```

If your project does not have one:
```bash
cp $BASELINE/Makefile .
```

---

#### CLAUDE.md — always merge, never overwrite

If your project already has a `CLAUDE.md`, overwriting it loses your
existing instructions. Merge instead.

```bash
# Open both files side by side
diff CLAUDE.md $BASELINE/CLAUDE.md
```

The merge strategy depends on what your existing `CLAUDE.md` contains:

**If your existing CLAUDE.md is informal** (a few lines of coding
preferences, style notes, or task reminders) — it does not have the
security structure the baseline requires. Keep your content but
restructure around the baseline format:

1. Copy the baseline `CLAUDE.md` into place
2. Move your existing content into Section 0 (Project Context)
3. Keep all baseline security sections intact and after Section 0

**If your existing CLAUDE.md already has security sections** — compare
section by section. For each section:
- If the baseline rule is stricter: use the baseline version
- If your existing rule is stricter: keep yours and note it in Section 0
- If they conflict: use the baseline version and create an ADR
  documenting the deviation
- Never remove a baseline security rule to preserve an existing one

**If your existing CLAUDE.md was generated by an earlier version of
this baseline** — replace it with the new version and re-apply your
Section 0 project context. The security sections will have improved.

After merging, confirm these sections are present and complete:
```
[ ] Section 0  — Project Context (your stack details)
[ ] Section 2  — Absolute Prohibitions
[ ] Section 3  — Prompt Injection Defense
[ ] Section 4  — Code Security quick reference table
[ ] Section 5  — Context Window management
[ ] Section 6  — Decision Recording / ADR trigger
[ ] Section 7  — Adherence Flags
[ ] Section 8  — Human Review Gates table
[ ] Section 9  — Pre-Completion Checklist
[ ] Section 10 — Testing Requirement
[ ] Section 11 — When In Doubt
```

---

#### SECURITY.md — always merge, never overwrite

If your project already has a `SECURITY.md`, it is likely a different
kind of document — vulnerability disclosure policy, bug bounty scope,
or security contact information. That content serves a different purpose
and must be preserved.

```bash
diff SECURITY.md $BASELINE/SECURITY.md
```

**If your existing SECURITY.md is a vulnerability disclosure policy**
(responsible disclosure instructions, contact email, PGP key):
- Rename it: `mv SECURITY.md SECURITY-DISCLOSURE.md`
- Copy the baseline: `cp $BASELINE/SECURITY.md .`
- Add a note at the top of the new `SECURITY.md`:

```markdown
> For vulnerability disclosure and bug reporting, see SECURITY-DISCLOSURE.md
```

**If your existing SECURITY.md is a previous standards reference**
(similar in structure to the baseline):
- Compare section by section
- Keep whichever version of each section is more complete or more recent
- Preserve any project-specific additions (custom toolchain, internal
  regulatory requirements, project-specific data classifications)
- The baseline `SECURITY.md` must include Part 7 (ADR guidance) —
  if your existing version lacks this, add it

**If your existing SECURITY.md is something else entirely** — read it,
understand its purpose, then decide: rename it to something descriptive
and copy the baseline in, or merge the content into the appropriate
section of the baseline version.

After merging, confirm these parts are present:
```
[ ] Part 0  — Technical Controls overview
[ ] Part 1  — OWASP Web Top 10:2025 (all 10 items)
[ ] Part 2  — OWASP LLM Top 10:2025
[ ] Part 3  — NIST Frameworks
[ ] Part 4  — Security Testing Toolchain
[ ] Part 5  — Infrastructure Security
[ ] Part 6  — Regulatory Compliance (Privacy Act 1988 (Cth), GDPR, HIPAA, PCI-DSS, SOC 2, ISO 27001, EU AI Act, CCPA, Cyber Security Act 2024)
[ ] Part 7  — Architecture Decision Records (ADR guidance)
```

---

### Existing Project Step 2 — Customise CLAUDE.md for your actual stack

This step is more important for existing projects than new ones.
Section 0 must describe how your project actually works — existing
conventions, existing directory structure, existing test commands.
Claude Code will use this to understand your codebase from session one.

Also read through Sections 2–11 and note any rules that conflict with
existing patterns in your project. Do not remove the rules — instead,
add a note in Section 0 explaining the current state and the target state.
For example:

```
Note: Existing code in src/legacy/ uses MD5 for non-security checksums.
This is tracked in docs/decisions/0003-legacy-md5-migration.md.
New code must not use MD5 under any circumstances.
```

---

### Existing Project Step 3 — Update .claude/settings.json

Add your project's specific test, lint, build, and migration commands
to the allow list. Do not remove the deny rules.

---

### Existing Project Step 4 — Extend .claudeignore

Add any project-specific files that should never be read — proprietary
documentation, internal config, certificate stores, legacy credential
files that have not yet been moved to a secrets manager.

---

### Existing Project Step 5 — Run a baseline security audit

Before writing any new code, audit what already exists.
In Claude Code, run:

```
/security-review
```

Ask Claude Code to review the whole project, not a specific file.
It will work through the OWASP checklist in `SECURITY.md` and report
all findings.

**Expect to find things.** Every mature codebase that was built without
formal security governance will have findings. The output gives you a
prioritised list of what to address.

---

### Existing Project Step 6 — Triage findings

For each finding from the security review, take one of three actions.
Every finding must be actioned — leaving findings unrecorded is worse
from a compliance standpoint than a documented accepted risk.

**Fix immediately** for anything critical:
- Hardcoded secrets or credentials in code
- Disabled TLS verification
- SQL injection vulnerabilities
- Missing authentication or authorisation checks
- Passwords stored without hashing

These are not deferrable. Fix them before merging the baseline branch.

**Create a tracked issue** for medium-severity findings that need a
proper fix but are not immediately exploitable:

```bash
# Create a GitHub issue for each finding
# Tag it: security
# Include: which OWASP rule it violates, affected file, recommended fix
# Set a deadline — do not leave security issues open-ended
```

**Create an ADR to accept the risk** for findings where the rule does
not apply in your context, or where fixing it would require a major
refactor and the risk is genuinely and demonstrably low:

```
/create-adr
```

Document: what the finding is, why it is accepted, what mitigating
controls exist, and when it will be reviewed again. This is what SOC 2,
ISO 27001, and PCI-DSS auditors expect — a conscious documented decision,
not an oversight.

---

### Existing Project Step 7 — Add module-level CLAUDE.md files

Identify which directories in your existing project are security-sensitive.
Typically: auth, payments, admin, API boundaries, anything handling user data.

```bash
# Example — adjust paths to match your project structure
cp src/auth/CLAUDE.md src/payments/CLAUDE.md
cp src/auth/CLAUDE.md src/admin/CLAUDE.md
cp src/auth/CLAUDE.md src/api/CLAUDE.md
```

Edit each copy to reflect how that module actually works today —
existing token strategy, existing session approach, existing logging
patterns. Describe the current state and the target state where they differ.
Claude Code uses these to apply the right rules for each module
without needing to be told each session.

---

### Existing Project Step 8 — Create retroactive ADRs

Your existing project has already made decisions that should be recorded —
auth strategy, database choice, encryption approach, hosting, third-party
services that receive user data. These decisions exist implicitly in the
code but are not documented.

Run `/create-adr` for each major decision that was already made.
Retroactive ADRs are legitimate and expected by auditors.
Use past tense and note the date as "prior to [today's date]."

Minimum retroactive ADRs for most existing projects:
- Authentication and session strategy currently in use
- Database choice and ORM
- Any third-party service receiving user, health, or payment data
- Current encryption approach (or lack of one — document it honestly)
- Hosting and deployment approach
- Any known security debt being tracked

---

### Existing Project Step 9 — Merge and communicate

Once the baseline branch is clean and findings are triaged:

```bash
# Run verification
make verify

# Commit everything
git add .
git commit -m "security: add Claude Code guardrails

- Add CLAUDE.md, SECURITY.md, .claudeignore, managed-settings.json
- Add pre-tool-call and post-write security hooks
- Add /security-review, /create-adr, /compliance-check slash commands
- Add ADR structure in docs/decisions/
- Add module-level CLAUDE.md for sensitive modules
- Document N findings from baseline audit (see issues #X, #Y, #Z)
- Accept M risks with ADRs (see docs/decisions/)

Baseline version: v1.0.0"

git push origin security/add-baseline
# Open a PR — require security review before merging
```

Add a note to your project's onboarding documentation:
- New developers must run `make setup` and `make deploy-settings` after cloning
- `jq` must be installed for hooks to work
- Slash commands `/security-review`, `/create-adr`, `/compliance-check`
  are available in every Claude Code session

---

### Existing Project Verification Checklist

```
[ ] Baseline files copied and committed on a branch
[ ] CLAUDE.md Section 0 describes actual project stack and conventions
[ ] .claude/settings.json allow list has project-specific commands
[ ] .claudeignore extended with project-specific sensitive files
[ ] make hooks run — both scripts are executable
[ ] make deploy-settings run on each developer machine
[ ] jq installed on each developer machine
[ ] /security-review run against full codebase
[ ] All critical findings fixed before merging
[ ] All medium findings have tracked issues with deadlines
[ ] All accepted risks have ADRs in docs/decisions/
[ ] Retroactive ADRs created for existing major decisions
[ ] Module-level CLAUDE.md files added to sensitive directories
[ ] PR description documents what was found and how it was triaged
[ ] Onboarding docs updated with make setup and jq requirement
[ ] Branch merged with security review approval
```

---

### Verification Checklist

Run this after setup to confirm all layers are active:

```
[ ] managed-settings.json deployed to system path (not just in repo)
[ ] `claude --dangerously-skip-permissions` is blocked or warns
[ ] .claude/hooks/*.sh are executable (ls -la .claude/hooks/)
[ ] jq is installed (jq --version)
[ ] CLAUDE.md Section 0 filled in with project stack
[ ] .claude/settings.json allow list updated for project commands
[ ] Module-level CLAUDE.md files created for sensitive directories
[ ] First ADR created in docs/decisions/
[ ] .claudeignore extended with project-specific exclusions
[ ] .gitattributes committed (ensures consistent line endings for hook scripts across OS)
```

---

## Slash Commands

Three slash commands are available in every Claude Code session.
Invoke them by typing the command name in the Claude Code chat.

| Command | When to Use |
|---|---|
| `/security-review` | Before merging any feature — structured OWASP audit |
| `/compliance-check` | When adding features touching personal, health, or payment data |
| `/create-adr` | When a security or architecture decision is made |

---

## Repository Structure

```
├── README.md                          ← Setup guide (this file)
├── CLAUDE.md                          ← Root session instructions (read every session)
├── SECURITY.md                        ← Full standards and compliance reference
├── .claudeignore                      ← Files Claude is technically blocked from reading
├── .gitattributes                     ← Ensures consistent line endings for hook scripts across OS
├── Makefile                           ← Automates post-clone setup steps
├── managed-settings.json              ← Org enforcement template (deploy to system path)
│
├── .claude/
│   ├── settings.json                  ← Project-level permission allow/deny lists
│   ├── hooks/
│   │   ├── pre-tool-call.sh           ← Scans for injection, blocks dangerous commands
│   │   └── post-write.sh             ← Scans written files for hardcoded secrets
│   └── commands/
│       ├── security-review.md         ← /security-review slash command
│       ├── create-adr.md             ← /create-adr slash command
│       └── compliance-check.md       ← /compliance-check slash command
│
├── docs/
│   └── decisions/
│       ├── README.md                  ← ADR format and when to create one
│       └── 0000-template.md          ← Copy this for each new decision
│
└── src/
    └── auth/
        └── CLAUDE.md                  ← Example module-level rules (copy for other modules)
```

---

## Regulatory Coverage

This baseline implements requirements from:

OWASP Top 10:2025 · OWASP LLM Top 10:2025 ·
NIST SSDF (SP 800-218 v1.1 + 218A GenAI Profile) · NIST CSF 2.0 · NIST AI RMF 1.0 ·
Privacy Act 1988 (Cth) + APPs + NDB scheme · Privacy & Other Legislation Amendment Act 2024 ·
Cyber Security Act 2024 (Cth) · SOCI Act 2018 · ACSC Essential Eight · APRA CPS 234 ·
GDPR · HIPAA · PCI-DSS v4.0.1 · SOC 2 · ISO/IEC 27001:2022 ·
EU AI Act (Reg. EU 2024/1689) · CCPA/CPRA · CIS Controls v8

See `SECURITY.md` for full detail on each standard.

---

## Keeping This Baseline Up to Date

Review and update this baseline when:
- OWASP publishes a new Top 10 (typically every 3–4 years)
- Your regulatory obligations change
- A security incident reveals a gap
- Claude Code ships significant new features that change the attack surface

Tag each review as a release in this repo so projects can track which
baseline version they were initialised from (e.g. `v1.0.0 — May 2026`).
