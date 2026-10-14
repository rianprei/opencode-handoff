#!/usr/bin/env bash
# install.sh — opencode-handoff
# Installs the /handoff command for all detected runtimes.
# Usage: bash install.sh (from repo root) or curl | bash (downloads first)
set -uo pipefail

REPO="rianprei/opencode-handoff"

echo "📋 Installing opencode-handoff..."

# Determine source directory (repo root)
if [ -f "$(pwd)/src/opencode/handoff.md" ]; then
  SRC_DIR="$(pwd)"
elif [ -f "$(dirname "$0")/src/opencode/handoff.md" ]; then
  SRC_DIR="$(dirname "$0")"
else
  # Download
  if ! command -v git >/dev/null 2>&1; then
    echo "  ❌ git not found — required for remote install"
    echo "     Manual: git clone https://github.com/$REPO.git && cd opencode-handoff && bash install.sh"
    exit 1
  fi
  echo "  ⬇ Downloading from github.com/$REPO..."
  TMPDIR="$(mktemp -d)" || { echo "  ❌ Cannot create temp dir"; exit 1; }
  trap '[ -n "$TMPDIR" ] && [ -d "$TMPDIR" ] && rm -rf "$TMPDIR"' EXIT
  if ! git clone --depth 1 "https://github.com/$REPO.git" "$TMPDIR/repo" 2>&1; then
    echo "  ❌ git clone failed — check network"
    exit 1
  fi
  SRC_DIR="$TMPDIR/repo"
fi

# Verify integrity
if [ -f "$SRC_DIR/CHECKSUMS.sha256" ]; then
  (cd "$SRC_DIR" && sha256sum -c CHECKSUMS.sha256 --quiet 2>/dev/null) || \
    echo "  ⚠ Checksum mismatch — verify manually with: cd $SRC_DIR && sha256sum -c CHECKSUMS.sha256"
fi

INSTALLED=0

# opencode
if [ -d "$HOME/.config/opencode" ] || command -v opencode >/dev/null 2>&1; then
  mkdir -p "$HOME/.config/opencode/commands"
  cp "$SRC_DIR/src/opencode/handoff.md" "$HOME/.config/opencode/commands/handoff.md" \
    && echo "  ✅ opencode → ~/.config/opencode/commands/handoff.md" && INSTALLED=$((INSTALLED+1))
fi

# Claude Code
if [ -d "$HOME/.claude" ] || command -v claude >/dev/null 2>&1; then
  mkdir -p "$HOME/.claude/commands"
  cp "$SRC_DIR/src/claude/handoff.md" "$HOME/.claude/commands/handoff.md" \
    && echo "  ✅ claude → ~/.claude/commands/handoff.md" && INSTALLED=$((INSTALLED+1))
fi

# Codex
if [ -d "$HOME/.codex" ] || command -v codex >/dev/null 2>&1; then
  mkdir -p "$HOME/.codex/skills/handoff"
  cp "$SRC_DIR/src/codex/SKILL.md" "$HOME/.codex/skills/handoff/SKILL.md" \
    && echo "  ✅ codex → ~/.codex/skills/handoff/SKILL.md" && INSTALLED=$((INSTALLED+1))
fi

# Grok Build
if [ -d "$HOME/.grok" ] || command -v grok >/dev/null 2>&1; then
  mkdir -p "$HOME/.grok/skills/handoff"
  cp "$SRC_DIR/src/grok/SKILL.md" "$HOME/.grok/skills/handoff/SKILL.md" \
    && echo "  ✅ grok → ~/.grok/skills/handoff/SKILL.md" && INSTALLED=$((INSTALLED+1))
fi

if [ "$INSTALLED" -eq 0 ]; then
  echo "  ❌ No runtime detected (opencode / claude / codex / grok)"
  exit 1
fi

echo "🎉 Done — $INSTALLED runtime(s) updated."
echo "   Next long session: run /handoff before the context fills. Fresh session: /handoff load <path>."
