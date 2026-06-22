#!/usr/bin/env bash
# verify-citations.sh — 「已确认」结论的机械 grep 回查（活典 Living Codex）
#
# 用途：对一条「已确认」结论，核验其被引符号/字符串是否在被引文件里【字面存在】。
#       字面存在 ≠ 语义/行为为真。本脚本只回答「字面存在性」。
#
# 退出码：0 = 命中（保留已确认）；1 = 未命中（应降级为「推断」）；2 = 用法/文件错误。
#
# 用法：
#   verify-citations.sh <file> <symbol-or-string>
#   verify-citations.sh --batch <citations.tsv>   # 每行: <file>\t<symbol>
#
# 纯 shell（grep/sed），无外部依赖。可选增强：缺失不影响 skill 结构，但
# 【无本脚本或等价 grep 能力时，「已确认」档不可用，全部降级为「推断」】(见 provenance.md)。

set -u

usage() {
  echo "usage: $0 <file> <symbol>" >&2
  echo "       $0 --batch <citations.tsv>  (cols: file<TAB>symbol)" >&2
  exit 2
}

verify_one() {
  # $1=file $2=symbol  -> echo HIT|MISS|NOFILE
  local file="$1" sym="$2"
  if [ ! -f "$file" ]; then
    echo "NOFILE"
    return
  fi
  # 固定字符串 + 词边界匹配(-Fw)：避免短符号被长符号子串掩护误判命中
  # （如 resolveEventKey 不再误命中 resolveUploadEventKey）。多词符号(如 "pub fn run")亦按整体词边界。
  if grep -Fwq -- "$sym" "$file"; then
    echo "HIT"
  else
    echo "MISS"
  fi
}

[ $# -lt 1 ] && usage

if [ "$1" = "--batch" ]; then
  [ $# -ne 2 ] && usage
  tsv="$2"
  [ ! -f "$tsv" ] && { echo "batch file not found: $tsv" >&2; exit 2; }
  total=0; hit=0; miss=0; nofile=0; rc=0
  # 读 TSV：file<TAB>symbol，跳过空行与 # 注释
  while IFS=$'\t' read -r file sym _rest; do
    case "$file" in ''|\#*) continue;; esac
    [ -z "${sym:-}" ] && continue
    total=$((total+1))
    res=$(verify_one "$file" "$sym")
    case "$res" in
      HIT)    hit=$((hit+1));    echo "HIT     $file :: $sym";;
      MISS)   miss=$((miss+1));  echo "MISS    $file :: $sym   -> 降级为「推断」"; rc=1;;
      NOFILE) nofile=$((nofile+1)); echo "NOFILE  $file :: $sym   -> 降级为「推断」"; rc=1;;
    esac
  done < "$tsv"
  echo "---"
  echo "total=$total hit=$hit miss=$miss nofile=$nofile"
  exit $rc
fi

[ $# -ne 2 ] && usage
res=$(verify_one "$1" "$2")
case "$res" in
  HIT)    echo "HIT     $1 :: $2"; exit 0;;
  MISS)   echo "MISS    $1 :: $2   -> 降级为「推断」"; exit 1;;
  NOFILE) echo "NOFILE  $1 :: $2   -> 降级为「推断」"; exit 1;;
esac
