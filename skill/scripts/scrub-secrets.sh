#!/usr/bin/env bash
# scrub-secrets.sh — 中间产物/厚书的密钥·PII 体检（活典 Living Codex）
#
# 用途：扫描 docs/codebook/ 与 territory-report-*.md / log.md，找出疑似密钥/token/PII 原文。
#       【零运行时下这是尽力而非保证】(见 prd MUST NOT / book-spec.md)。
#       本脚本只【报告】疑似命中，不自动改写（避免误删）。
#
# 退出码：0 = 未发现疑似；1 = 发现疑似（人工处理）；2 = 用法错误。
#
# 用法：scrub-secrets.sh <dir-or-file> [<dir-or-file> ...]
# 纯 shell（grep/sed），可选增强；缺失退出降级、不影响结构。

set -u

[ $# -lt 1 ] && { echo "usage: $0 <dir-or-file> ..." >&2; exit 2; }

# 疑似敏感模式（保守，宁可多报）：
#  - 常见 key 赋值带长随机值
#  - AWS Access Key / 私钥块 / Bearer token / JWT 形态
patterns='(api[_-]?key|secret|passwd|password|token|access[_-]?key)["'"'"' ]*[:=]["'"'"' ]*[A-Za-z0-9/+_-]{16,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----|eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}|Bearer [A-Za-z0-9._-]{20,}'

found=0
for target in "$@"; do
  if [ ! -e "$target" ]; then
    echo "skip (not found): $target" >&2
    continue
  fi
  # -r 递归，-n 行号，-E 扩展正则，-I 跳过二进制
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    echo "SUSPECT  $line"
    found=1
  done < <(grep -rEnI -- "$patterns" "$target" 2>/dev/null)
done

if [ "$found" -eq 1 ]; then
  echo "---"
  echo "发现疑似密钥/PII：请改为只记『键名+位置+用途』，删除原文。脚本不自动改写。"
  exit 1
fi
echo "未发现疑似密钥/PII（尽力而非保证）。"
exit 0
