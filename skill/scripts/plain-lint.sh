#!/usr/bin/env bash
# plain-lint.sh — 白话/OKF advisory 体检（【不阻断】，仅提示）
#
# 与机械闸门（ledger-orphans.sh）不同：本脚本【绝不】决定 DONE，只给 PRESENT/AUDIT 一份
# advisory 清单，供人/审核子 agent 抽查。退出码恒为 0（除用法错误=2）。
#
# 查三件 advisory 事：
#   (1) 术语泄漏：线上正文出现常见框架/库名黑名单（未解释术语）
#   (2) frontmatter 缺 type：发布 concept 顶部无 YAML frontmatter 或缺 type
#   (3) 闸门裸 token（R1）：narrative 文档含 ledger-orphans.sh 会匹配的裸 token
#       （会污染 entry/edge/state derived 致 GATE_MISMATCH 误报，见 plain-language.md §3.1）
#
# 用法：plain-lint.sh --narrative <NARRATIVE_DIR>
# 说明：index.md/log.md 不要求 frontmatter；portraits/ 与 *-ledger/manifest 为证据层，术语从宽。

set -u

NARR=""
while [ $# -gt 0 ]; do
  case "$1" in
    --narrative) NARR="${2:-}"; shift 2 ;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 2 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done
[ -n "$NARR" ] && [ -d "$NARR" ] || { echo "ERR: --narrative <dir> 必填且须存在" >&2; exit 2; }

if ! command -v grep >/dev/null 2>&1; then
  echo "DEGRADE: 无 grep —— 跳过 advisory 体检（不影响 DONE）"
  exit 0
fi

echo "=== plain-lint advisory（不阻断 · 仅提示，供人/AUDIT 抽查）==="
echo "narrative=$NARR"
echo "---"

# (1) 术语黑名单（线上正文未解释术语）—— 证据层/账本从宽，仅扫 L0/L1/journeys/rules/glossary
TERMS='Tauri|tiny_http|Zustand|LanceDB|pdfium|tokio|Mermaid|IPC\b|#\[tauri'
echo "[1] 术语泄漏（线上正文黑名单命中，advisory）："
found1=0
while IFS= read -r f; do
  hits=$(grep -nE "$TERMS" "$f" 2>/dev/null || true)
  if [ -n "$hits" ]; then
    echo "  - ${f#$NARR/}:"; echo "$hits" | sed 's/^/      /'; found1=1
  fi
done < <(find "$NARR" -type f -name '*.md' \
          ! -path '*/portraits/*' ! -name '*-ledger.md' ! -name 'manifest.md' \
          ! -name 'index.md' ! -name 'log.md' 2>/dev/null)
[ "$found1" -eq 0 ] && echo "  （无命中）"

# (2) frontmatter 缺 type（发布 concept；index/log 豁免）
echo "[2] frontmatter 缺失/缺 type（advisory）："
found2=0
while IFS= read -r f; do
  base=$(basename "$f")
  case "$base" in index.md|log.md) continue ;; esac
  # 首行须是 '---'，且前 10 行内有 'type:'
  if [ "$(head -n1 "$f" 2>/dev/null)" != "---" ] || ! head -n 10 "$f" 2>/dev/null | grep -q '^type:'; then
    echo "  - ${f#$NARR/}: 顶部无合规 frontmatter 或缺 type"; found2=1
  fi
done < <(find "$NARR" -type f -name '*.md' 2>/dev/null)
[ "$found2" -eq 0 ] && echo "  （全部齐备）"

# (3) 闸门裸 token（R1 · 全 narrative 文档，尤其 glossary）
GATE='WorkManager|enqueue\(|\.enqueue\b|sendBroadcast\(|postSticky\(|EventBus[^.]*\.post\(|checkSelfPermission\(|checkPermission\(|[A-Z0-9_]*(TTL|EXPIR|TIMEOUT)[A-Z0-9_]*|isEnabled\(|FeatureFlag|featureFlag'
echo "[3] 闸门裸 token 污染风险（R1 · advisory · 见 plain-language.md §3.1）："
found3=0
while IFS= read -r f; do
  hits=$(grep -nE "$GATE" "$f" 2>/dev/null || true)
  if [ -n "$hits" ]; then
    echo "  - ${f#$NARR/}: 含可能污染 ledger-orphans 的裸 token —— 改描述性写法/打断字面"; found3=1
  fi
done < <(find "$NARR" -type f -name '*.md' 2>/dev/null)
[ "$found3" -eq 0 ] && echo "  （无裸 token）"

echo "---"
echo "ADVISORY_DONE：以上为提示，不影响 DONE（DONE 仍由 ledger-orphans.sh + AUDIT 决定）。"
exit 0
