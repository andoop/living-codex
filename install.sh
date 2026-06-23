#!/usr/bin/env bash
# Living Codex installer — copies the narrator skill into your AI agent.
# Works two ways:
#   • piped:  curl -fsSL .../install.sh | bash            (downloads the skill)
#             curl -fsSL .../install.sh | bash -s kiro    (force a platform)
#   • local:  ./install.sh [platform] [--uninstall]       (uses ./skill next to it)
# Zero runtime deps for the skill itself; the installer needs git only on the piped path.
# Supported platforms: kiro | claude | cursor | codex | generic
set -euo pipefail

REPO_URL="https://github.com/andoop/living-codex.git"
SKILL_NAME="narrator"
PROJECT_ROOT="${LIVING_CODEX_TARGET:-$PWD}"

log() { printf '[living-codex] %s\n' "$*"; }
die() { printf '[living-codex] ERROR: %s\n' "$*" >&2; exit 1; }

# --- locate skill source: local copy next to this script, else download repo ---
CLEANUP=""
cleanup() { [ -n "$CLEANUP" ] && rm -rf "$CLEANUP" || true; }
trap cleanup EXIT

SELF="${BASH_SOURCE[0]:-}"
SKILL_SRC=""
if [ -n "$SELF" ]; then
  SELF_DIR="$(cd "$(dirname "$SELF")" 2>/dev/null && pwd || true)"
  if [ -n "$SELF_DIR" ] && [ -f "$SELF_DIR/skill/SKILL.md" ]; then
    SKILL_SRC="$SELF_DIR/skill"
    log "using local skill: $SKILL_SRC"
  fi
fi
if [ -z "$SKILL_SRC" ]; then
  command -v git >/dev/null 2>&1 || die "git is required for the piped install. Either install git, or clone the repo and run ./install.sh locally."
  CLEANUP="$(mktemp -d)"
  log "downloading skill from $REPO_URL ..."
  git clone --depth 1 "$REPO_URL" "$CLEANUP/living-codex" >/dev/null 2>&1 || die "git clone failed ($REPO_URL)"
  SKILL_SRC="$CLEANUP/living-codex/skill"
fi
[ -f "$SKILL_SRC/SKILL.md" ] || die "skill/SKILL.md not found at $SKILL_SRC"

# --- parse args (safe under set -u even with no args) ---
UNINSTALL=0
PLATFORM=""
for arg in "$@"; do
  case "$arg" in
    --uninstall) UNINSTALL=1 ;;
    kiro|claude|cursor|codex|generic) PLATFORM="$arg" ;;
    *) die "unknown arg: $arg (use one of: kiro claude cursor codex generic [--uninstall])" ;;
  esac
done

detect_platforms() {
  out=""
  [ -d "$PROJECT_ROOT/.kiro" ] && out="$out kiro" || true
  if [ -e "$PROJECT_ROOT/CLAUDE.md" ] || [ -d "$PROJECT_ROOT/.claude" ]; then out="$out claude"; fi
  [ -d "$PROJECT_ROOT/.cursor" ] && out="$out cursor" || true
  if [ -d "$PROJECT_ROOT/.codex" ] || [ -d "$PROJECT_ROOT/.agents" ]; then out="$out codex"; fi
  [ -z "$out" ] && out="generic" || true
  printf '%s' "$out"
}

dest_dir() {
  case "$1" in
    kiro)    printf '%s' "$PROJECT_ROOT/.kiro/skills/$SKILL_NAME" ;;
    claude)  printf '%s' "$PROJECT_ROOT/.claude/skills/$SKILL_NAME" ;;
    cursor)  printf '%s' "$PROJECT_ROOT/.cursor/skills/$SKILL_NAME" ;;
    codex)   printf '%s' "$PROJECT_ROOT/.agents/skills/$SKILL_NAME" ;;
    generic) printf '%s' "$PROJECT_ROOT/skills/$SKILL_NAME" ;;
  esac
}

install_one() {
  plat="$1"; dest="$(dest_dir "$plat")"
  if [ "$UNINSTALL" -eq 1 ]; then
    if [ -d "$dest" ]; then rm -rf "$dest"; log "removed $dest"; else log "nothing at $dest"; fi
    return
  fi
  mkdir -p "$dest"
  cp -R "$SKILL_SRC/." "$dest/"
  log "installed → $dest"
}

if [ -n "$PLATFORM" ]; then PLATS="$PLATFORM"; else PLATS="$(detect_platforms)"; fi
log "target project : $PROJECT_ROOT"
log "platform(s)    : $PLATS"
for p in $PLATS; do install_one "$p"; done

if [ "$UNINSTALL" -eq 0 ]; then
  cat <<'EOF'

[living-codex] Done. Restart your agent, then in the agent run:
    narrate --journey <一条业务旅程>     # 首次推荐：先剥一条跑通
    narrate .                            # 再铺全项目业务旅程
Output → <project>/docs/codebook/narrative/  (Obsidian-compatible)
Commands → https://github.com/andoop/living-codex/blob/main/docs/commands.md
Honesty model → https://github.com/andoop/living-codex/blob/main/docs/honesty.md
EOF
fi
