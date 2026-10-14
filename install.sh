#!/usr/bin/env bash
# install.sh — opencode-handoff
# Installs the /handoff command for all detected runtimes.
# Usage: bash install.sh (from repo root) or curl | bash (downloads first)
set -uo pipefail

REPO="rianprei/opencode-handoff"
TAG="v2.1"

echo "📋 Installing opencode-handoff $TAG..."

# Determine source directory (repo root)
if [ -f "$(pwd)/src/opencode/handoff.md" ]; then
  SRC_DIR="$(pwd)"
elif [ -f "$(dirname "$0")/src/opencode/handoff.md" ]; then
  SRC_DIR="$(dirname "$0")"
else
  # Download — pinned to the release tag
  if ! command -v git >/dev/null 2>&1; then
    echo "  ❌ git not found — required for remote install"
    echo "     Manual: git clone https://github.com/$REPO.git && cd opencode-handoff && bash install.sh"
    exit 1
  fi
  echo "  ⬇ Downloading from github.com/$REPO ($TAG)..."
  TMPDIR="$(mktemp -d)" || { echo "  ❌ Cannot create temp dir"; exit 1; }
  trap '[ -n "$TMPDIR" ] && [ -d "$TMPDIR" ] && rm -rf "$TMPDIR"' EXIT
  if ! git clone --depth 1 --branch "$TAG" "https://github.com/$REPO.git" "$TMPDIR/repo" 2>/dev/null; then
    echo "  ⚠ Tag $TAG not found — falling back to main"
    if ! git clone --depth 1 "https://github.com/$REPO.git" "$TMPDIR/repo" 2>&1; then
      echo "  ❌ git clone failed — check network"
      exit 1
    fi
  fi
  SRC_DIR="$TMPDIR/repo"
fi

# Verify integrity — FATAL on mismatch (integrity is the point of the checksum)
if [ -f "$SRC_DIR/CHECKSUMS.sha256" ]; then
  if ! (cd "$SRC_DIR" && sha256sum -c CHECKSUMS.sha256 --quiet 2>/dev/null); then
    echo "  ❌ Checksum mismatch — aborting installation."
    echo "     Verify manually: cd $SRC_DIR && sha256sum -c CHECKSUMS.sha256"
    exit 1
  fi
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

# Codex (SKILL.md + invocation policy — Codex ignores disable-model-invocation in SKILL.md)
if [ -d "$HOME/.codex" ] || command -v codex >/dev/null 2>&1; then
  mkdir -p "$HOME/.codex/skills/handoff/agents"
  cp "$SRC_DIR/src/codex/SKILL.md" "$HOME/.codex/skills/handoff/SKILL.md" \
    && echo "  ✅ codex → ~/.codex/skills/handoff/SKILL.md" && INSTALLED=$((INSTALLED+1))
  cp "$SRC_DIR/src/codex/agents/openai.yaml" "$HOME/.codex/skills/handoff/agents/openai.yaml" \
    && echo "  ✅ codex → ~/.codex/skills/handoff/agents/openai.yaml (implicit invocation off)"
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
