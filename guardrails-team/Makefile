# Makefile — Claude Code Guardrails
# Run `make setup` after cloning this repo as a new project.
# Run `make help` to see all available targets.

.PHONY: help setup hooks verify deploy-settings clean

# ── Detect OS ──────────────────────────────────────────────────────────────
OS := $(shell uname -s 2>/dev/null || echo Windows)

ifeq ($(OS),Darwin)
  MANAGED_SETTINGS_PATH := $(HOME)/Library/Application Support/Claude/managed-settings.json
  MANAGED_SETTINGS_DIR  := $(HOME)/Library/Application Support/Claude
else ifeq ($(OS),Linux)
  MANAGED_SETTINGS_PATH := $(HOME)/.config/Claude/managed-settings.json
  MANAGED_SETTINGS_DIR  := $(HOME)/.config/Claude
else
  MANAGED_SETTINGS_PATH := $(APPDATA)/Claude/managed-settings.json
  MANAGED_SETTINGS_DIR  := $(APPDATA)/Claude
endif

# ── Default target ─────────────────────────────────────────────────────────

help:
	@echo ""
	@echo "Claude Code Guardrails — Available Commands"
	@echo "────────────────────────────────────────────"
	@echo "  make setup           Run all setup steps (hooks + verify)"
	@echo "  make hooks           Make hook scripts executable"
	@echo "  make deploy-settings Deploy managed-settings.json to system path"
	@echo "  make verify          Check all layers are correctly configured"
	@echo "  make help            Show this message"
	@echo ""
	@echo "Quick start after cloning:"
	@echo "  1. make setup"
	@echo "  2. make deploy-settings   (once per machine)"
	@echo "  3. Edit CLAUDE.md Section 0 with your project stack"
	@echo "  4. Edit .claude/settings.json with your project commands"
	@echo ""

# ── Setup (run once after cloning) ────────────────────────────────────────

setup: hooks verify
	@echo ""
	@echo "✅ Setup complete."
	@echo ""
	@echo "Next steps:"
	@echo "  1. Run: make deploy-settings   (once per developer machine)"
	@echo "  2. Edit CLAUDE.md Section 0    (fill in your project stack)"
	@echo "  3. Edit .claude/settings.json  (add your project commands)"
	@echo "  4. Add module CLAUDE.md files  (copy src/auth/CLAUDE.md pattern)"
	@echo "  5. Run: /create-adr in Claude Code for your first decisions"
	@echo ""

# ── Layer 3: Make hooks executable ────────────────────────────────────────

hooks:
	@echo "→ Making hooks executable..."
	@chmod +x .claude/hooks/*.sh
	@echo "  ✓ .claude/hooks/pre-tool-call.sh"
	@echo "  ✓ .claude/hooks/post-write.sh"

# ── Layer 1: Deploy managed-settings.json ─────────────────────────────────

deploy-settings:
	@echo "→ Deploying managed-settings.json..."
	@echo ""
	@echo "  This copies managed-settings.json to your system path."
	@echo "  It applies to ALL Claude Code projects on this machine."
	@echo "  Target: $(MANAGED_SETTINGS_PATH)"
	@echo ""
	@read -p "  Proceed? [y/N] " CONFIRM; \
	if [ "$$CONFIRM" = "y" ] || [ "$$CONFIRM" = "Y" ]; then \
		mkdir -p "$(MANAGED_SETTINGS_DIR)" && \
		python3 -c "\
import json, sys; \
data = json.load(open('managed-settings.json')); \
data.pop('_readme', None); \
data.pop('_notes', None); \
json.dump(data, open('$(MANAGED_SETTINGS_PATH)', 'w'), indent=2); \
print('  ✓ Deployed (_readme and _notes fields removed)')" && \
		echo "  ✓ Done. Restart Claude Code to apply."; \
	else \
		echo "  ✗ Skipped. Run make deploy-settings when ready."; \
	fi

# ── Verify all layers ─────────────────────────────────────────────────────

verify:
	@echo "→ Verifying setup..."
	@echo ""

	@# Layer 2 — .claudeignore
	@if [ -f ".claudeignore" ]; then \
		echo "  ✓ Layer 2: .claudeignore present"; \
	else \
		echo "  ✗ Layer 2: .claudeignore MISSING"; \
	fi

	@# Layer 3 — Hooks executable
	@if [ -x ".claude/hooks/pre-tool-call.sh" ]; then \
		echo "  ✓ Layer 3: pre-tool-call.sh is executable"; \
	else \
		echo "  ✗ Layer 3: pre-tool-call.sh NOT executable — run: make hooks"; \
	fi

	@if [ -x ".claude/hooks/post-write.sh" ]; then \
		echo "  ✓ Layer 3: post-write.sh is executable"; \
	else \
		echo "  ✗ Layer 3: post-write.sh NOT executable — run: make hooks"; \
	fi

	@# jq installed
	@if command -v jq >/dev/null 2>&1; then \
		echo "  ✓ jq installed ($(shell jq --version 2>/dev/null))"; \
	else \
		echo "  ✗ jq NOT installed — hooks will not work"; \
		echo "    macOS:  brew install jq"; \
		echo "    Linux:  sudo apt-get install jq"; \
	fi

	@# python3 installed (required by hooks for portable Unicode scanning)
	@if command -v python3 >/dev/null 2>&1; then \
		echo "  ✓ python3 installed ($(shell python3 --version 2>/dev/null))"; \
	else \
		echo "  ✗ python3 NOT installed — hook Unicode scanning will not work"; \
		echo "    macOS:  brew install python3"; \
		echo "    Linux:  sudo apt-get install python3"; \
	fi

	@# Layer 4 — .claude/settings.json
	@if [ -f ".claude/settings.json" ]; then \
		echo "  ✓ Layer 4: .claude/settings.json present"; \
	else \
		echo "  ✗ Layer 4: .claude/settings.json MISSING"; \
	fi

	@# Layer 5 — CLAUDE.md
	@if [ -f "CLAUDE.md" ]; then \
		echo "  ✓ Layer 5: CLAUDE.md present"; \
	else \
		echo "  ✗ Layer 5: CLAUDE.md MISSING"; \
	fi

	@# Layer 7 — SECURITY.md
	@if [ -f "SECURITY.md" ]; then \
		echo "  ✓ Layer 7: SECURITY.md present"; \
	else \
		echo "  ✗ Layer 7: SECURITY.md MISSING"; \
	fi

	@# Layer 1 — managed-settings.json deployed
	@if [ -f "$(MANAGED_SETTINGS_PATH)" ]; then \
		echo "  ✓ Layer 1: managed-settings.json deployed to system path"; \
	else \
		echo "  ⚠ Layer 1: managed-settings.json NOT deployed to system path"; \
		echo "    Run: make deploy-settings"; \
		echo "    Path: $(MANAGED_SETTINGS_PATH)"; \
	fi

	@# ADR directory
	@if [ -d "docs/decisions" ]; then \
		echo "  ✓ ADR directory present (docs/decisions/)"; \
	else \
		echo "  ✗ ADR directory MISSING — create docs/decisions/"; \
	fi

	@# .gitattributes
	@if [ -f ".gitattributes" ]; then \
		echo "  ✓ .gitattributes present (hook permissions preserved in Git)"; \
	else \
		echo "  ⚠ .gitattributes MISSING — hook permissions may not survive git clone"; \
	fi

	@echo ""
