#!/usr/bin/env bash
# pack-context.sh — 可选：用 repomix 打包 territory 文件给叶子 agent（活典 Living Codex）
#
# 用途：把一个 territory 的文件清单打包成单文件上下文，便于只读叶子 agent 读取。
#       【可选增强：缺 repomix 时退出 0 降级】——主 agent 改为按文件清单逐个读取，结构不缺失。
#
# 退出码：0 = 成功 或 优雅降级（无 repomix）；2 = 用法错误。
#
# 用法：pack-context.sh <output.md> <file1> [file2 ...]
# 纯 shell 包装；唯一可选外部依赖 repomix。

set -u

[ $# -lt 2 ] && { echo "usage: $0 <output.md> <file1> [file2 ...]" >&2; exit 2; }

out="$1"; shift

if ! command -v repomix >/dev/null 2>&1; then
  echo "repomix 未安装 -> 降级：主 agent 请按文件清单逐个读取，跳过打包。"
  echo "待读文件清单："
  for f in "$@"; do echo "  - $f"; done
  exit 0   # 优雅降级，不报错
fi

# 构造 include glob（repomix 用逗号分隔）
include=""
for f in "$@"; do
  include="${include:+$include,}$f"
done

echo "repomix 打包 -> $out"
repomix --include "$include" --output "$out" --style markdown
rc=$?
if [ $rc -ne 0 ]; then
  echo "repomix 失败(rc=$rc) -> 降级：主 agent 改为逐个读取。"
  exit 0   # 仍降级，不阻断
fi
echo "done: $out"
exit 0
