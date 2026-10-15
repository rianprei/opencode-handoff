#!/usr/bin/env bash
# install.sh — opencode-handoff
# Installs the /handoff command for all detected runtimes.
# Usage: bash install.sh (from repo root) or curl | bash (downloads first)
set -uo pipefail

REPO="rianprei/opencode-handoff"
TAG="v2.6"

echo "📋 Installing opencode-handoff $TAG..."

# Determine source directory (repo root)
if [ -f "$(pwd)/src/opencode/handoff.md" ]; then
  SRC_DIR="$(pwd)"
elif [ -f "$(dirname "$0")/src/opencode/handoff.md" ]; then
  SRC_DIR="$(dirname "$0")"
else
  # Download — pinned to the release tag, NO fallback (a pin that degrades is not a pin)
  if ! command -v git >/dev/null 2>&1; then
    echo "  ❌ git not found — required for remote install"
    echo "     Manual: git clone https://github.com/$REPO.git && cd opencode-handoff && bash install.sh"
    exit 1
  fi
  echo "  ⬇ Downloading from github.com/$REPO ($TAG)..."
  TMPDIR="$(mktemp -d)" || { echo "  ❌ Cannot create temp dir"; exit 1; }
  trap '[ -n "$TMPDIR" ] && [ -d "$TMPDIR" ] && rm -rf "$TMPDIR"' EXIT
  if ! git clone --depth 1 --branch "$TAG" "https://github.com/$REPO.git" "$TMPDIR/repo" 2>/dev/null; then
    echo "  ❌ Tag $TAG not found — aborting (no fallback to a mutable ref)."
    echo "     Install manually from a verified clone: git clone --branch $TAG https://github.com/$REPO.git"
    exit 1
  fi
  SRC_DIR="$TMPDIR/repo"
fi

# Verify integrity — FATAL on mismatch AND on absence (a missing gate is the worst failure)
if [ -f "$SRC_DIR/CHECKSUMS.sha256" ]; then
  if ! (cd "$SRC_DIR" && sha256sum -c CHECKSUMS.sha256 --quiet 2>/dev/null); then
    echo "  ❌ Checksum mismatch — aborting installation."
    echo "     Verify manually: cd $SRC_DIR && sha256sum -c CHECKSUMS.sha256"
    exit 1
  fi
else
  echo "  ❌ CHECKSUMS.sha256 absent — aborting installation (integrity unverifiable)."
  exit 1
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

# Codex — legacy discovery path (~/.codex/skills), still read by current Codex builds.
# NOTE: we deliberately do NOT install to ~/.agents/skills/handoff — that directory is a
# SHARED namespace (Claude Code reads it too) and a skill named "handoff" there collides
# with the /handoff command in Claude Code. If Codex drops the legacy path, rename there.
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
