#!/usr/bin/env bash
# coverage-check.sh <manifest.md> — 确定性 DONE 闸门（--coverage full 模式）。
# 作用：数 manifest 里还有多少 "- [ ]" 未勾。**只有 0 才 exit 0**；否则 exit 1。
# 用法：AI 无权自称完成；由编排循环反复调用本脚本，exit 1 就必须继续 grind，
#       直到 exit 0（COVERAGE_COMPLETE）才允许进 SYNTHESIZE / 宣布完成。
set -u
M="${1:-docs/codebook/manifest.md}"
[ -f "$M" ] || { echo "NO_MANIFEST: $M"; exit 2; }

todo=$(grep -c '^[[:space:]]*- \[ \]' "$M" 2>/dev/null || echo 0)
done=$(grep -c '^[[:space:]]*- \[x\]' "$M" 2>/dev/null || echo 0)
skip=$(grep -c '^[[:space:]]*- \[~\]' "$M" 2>/dev/null || echo 0)
total=$((todo + done + skip))

printf 'manifest=%s total=%s done=%s skipped=%s remaining=%s\n' "$M" "$total" "$done" "$skip" "$todo"
if [ "$total" -gt 0 ]; then
  printf 'progress=%s%%\n' "$(( (done + skip) * 100 / total ))"
fi

if [ "$todo" -eq 0 ] && [ "$total" -gt 0 ]; then
  echo "COVERAGE_COMPLETE"
  exit 0
else
  echo "COVERAGE_INCOMPLETE: $todo file(s) not yet portrayed — MUST CONTINUE; do NOT declare done."
  exit 1
fi
