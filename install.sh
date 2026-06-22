#!/usr/bin/env bash
# Living Codex installer — copies the cartographer skill into your AI agent.
# Zero runtime deps. Pure-methodology skill; optional scripts degrade gracefully.
#
# Usage:
#   ./install.sh                 # auto-detect agent(s) in the current project
#   ./install.sh kiro            # force a specific platform
#   ./install.sh --uninstall kiro
#
# Supported platforms: kiro | claude | cursor | codex | generic
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SRC="$SCRIPT_DIR/skill"
PROJECT_ROOT="${LIVING_CODEX_TARGET:-$PWD}"
SKILL_NAME="cartographer"

log()  { printf '[living-codex] %s\n' "$*"; }
die()  { printf '[living-codex] ERROR: %s\n' "$*" >&2; exit 1; }

[ -f "$SKILL_SRC/SKILL.md" ] || die "skill/ not found next to install.sh"

UNINSTALL=0
PLATFORM=""
for arg in "$@"; do
  case "$arg" in
    --uninstall) UNINSTALL=1 ;;
    kiro|claude|cursor|codex|generic) PLATFORM="$arg" ;;
    *) die "unknown arg: $arg" ;;
  esac
done

detect_platforms() {
  local found=()
  [ -d "$PROJECT_ROOT/.kiro" ]   && found+=("kiro")
  [ -e "$PROJECT_ROOT/CLAUDE.md" ] || [ -d "$PROJECT_ROOT/.claude" ] && found+=("claude")
  [ -d "$PROJECT_ROOT/.cursor" ] && found+=("cursor")
  [ -d "$PROJECT_ROOT/.codex" ] || [ -d "$PROJECT_ROOT/.agents" ] && found+=("codex")
  [ ${#found[@]} -eq 0 ] && found+=("generic")
  printf '%s\n' "${found[@]}"
}

dest_dir() {
  case "$1" in
    kiro)    printf '%s\n' "$PROJECT_ROOT/.kiro/skills/$SKILL_NAME" ;;
    claude)  printf '%s\n' "$PROJECT_ROOT/.claude/skills/$SKILL_NAME" ;;
    cursor)  printf '%s\n' "$PROJECT_ROOT/.cursor/skills/$SKILL_NAME" ;;
    codex)   printf '%s\n' "$PROJECT_ROOT/.agents/skills/$SKILL_NAME" ;;
    generic) printf '%s\n' "$PROJECT_ROOT/skills/$SKILL_NAME" ;;
  esac
}

install_one() {
  local plat="$1" dest; dest="$(dest_dir "$plat")"
  if [ "$UNINSTALL" -eq 1 ]; then
    [ -d "$dest" ] && { rm -rf "$dest"; log "removed $dest"; } || log "nothing at $dest"
    return
  fi
  mkdir -p "$dest"
  cp -R "$SKILL_SRC/." "$dest/"
  log "installed → $dest"
}

PLATS=()
if [ -n "$PLATFORM" ]; then PLATS=("$PLATFORM"); else mapfile -t PLATS < <(detect_platforms); fi
log "target project: $PROJECT_ROOT"
log "platforms: ${PLATS[*]}"
for p in "${PLATS[@]}"; do install_one "$p"; done

if [ "$UNINSTALL" -eq 0 ]; then
  cat <<EOF

[living-codex] Done. Restart your agent, then run:
    codex map . --depth L2 --personas architect,newgrad,security,sre
Output → <project>/docs/codebook/ (Obsidian-compatible). Honesty-first: see skill/references/provenance.md
EOF
fi
