# Claude Code Guardrails

For solo developers and small projects not yet handling regulated data at scale.
Activates in under five minutes. Covers the security practices that matter most
without the team-oriented governance overhead.

**Using this on a team, handling user data at scale, or facing a regulatory
requirement?** Use `guardrails-team` instead — it includes hooks, automated
scanning, managed-settings enforcement, module-level rules, slash commands,
and broader regulatory coverage.

**Upgrade path:** when any of these become true, migrate to `guardrails-team`:
- You add a second developer
- You handle PHI, CHD, or personal data of Australian or EU residents at scale
- You are subject to SOCI Act obligations (critical infrastructure sectors)
- You build AI-driven features that interact with or make decisions about users
- You pursue SOC 2, ISO 27001, or PCI-DSS certification
- You ship a product with paying users and regulatory exposure

---

## What's Included

| File | What It Does |
|---|---|
| `CLAUDE.md` | Session rules — read by Claude Code every session |
| `SECURITY-QUICK-REF.md` | One-page security reference — read before security tasks |
| `.claudeignore` | Blocks Claude from reading credential files |
| `.claude/settings.json` | Project-level allow/deny lists |
| `.claude/commands/create-adr.md` | `/create-adr` slash command |
| `docs/decisions/` | ADR template and index |

---

## Setup — Three Steps

### Step 1 — Copy the baseline files into your project

```bash
# Clone the baseline repo (contains both templates)
git clone git@github.com:FreyjaJD/Claude-Code-Guardrails.git
cd your-existing-project-or-new-folder

# Copy just the solo template files (including hidden files)
cp -ra ../Claude-Code-Guardrails/guardrails/. .

# Point git to your own repo
git remote set-url origin https://github.com/your-org/my-project.git
```

If starting from scratch with no existing project folder:
```bash
git clone git@github.com:FreyjaJD/Claude-Code-Guardrails.git
cp -ra Claude-Code-Guardrails/guardrails/. my-project/
cd my-project
git init && git remote add origin https://github.com/your-org/my-project.git
```

### Step 2 — Fill in your stack

Open `CLAUDE.md` and complete Section 0 (the Project Context block at the top).
This tells Claude Code about your stack so you don't repeat yourself each session.

### Step 3 — Update the allow list

Open `.claude/settings.json` and add your project's specific test, lint,
and build commands to the allow list so Claude Code can run them without
asking each time.

That's it. Open Claude Code and start building.

---

## When You Need More

**Want automated secret scanning after every file write?**
Add the hooks from `guardrails-team/.claude/hooks/` — requires `jq` and `python3`.

**Want `/security-review` and `/compliance-check` slash commands?**
Copy `.claude/commands/` from `guardrails-team`.

**Want hard enforcement that can't be bypassed?**
Deploy `managed-settings.json` from `guardrails-team` to your system path.
See `guardrails-team/README.md` for deployment instructions.

**Want module-level rules for auth, payments, or admin code?**
Copy `guardrails-team/src/auth/CLAUDE.md` to your sensitive module directories.
