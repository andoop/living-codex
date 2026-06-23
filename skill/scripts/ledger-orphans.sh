#!/usr/bin/env bash
# ledger-orphans.sh — 业务叙事三账本 + 状态轴的【确定性自推导机械闸门】
#
# 镜像 coverage-check.sh 的纪律：AI 无权自称"枚举完整"；由本脚本自推导分母、
# 与账本声明数比对，不一致即 exit≠0。DONE 由本脚本 exit 0 决定，非 AI 自称。
#
# 【它只证三类「可 grep 范围内」枚举完整】（见 references/honesty-charter.md 第二条）：
#   (i)   code 分母  = find 套 .codebookignore 的 in-scope 全集
#   (ii)  入口根    = 可 grep 的框架注册表候选（机械抽取 count-gate）
#   (iii) 连边 fire 端 = 限【跨进程/异步解耦】边界（不含进程内同步导航）
#   (iv)  状态触发器 = 仅【有稳定签名】子类（权限 API / TTL 常量 / flag 读取）；guard/裸 if 不计
#
# 【它绝不证、也绝不暗示】：业务细节已穷尽 / 因果链已验证 / L3 分支已覆盖 / traced 关系为真 /
#   不可 grep 的入口·连边·状态已穷尽。exit 0 = "枚举与连边登记完整"，绝不 = "不留细节已达成"。
#
# grep/find 能力缺失时：对应分母【显式降级】为"未机械确认"（rc=3），而非假装通过。
#
# 退出码：0 = 四类机械核对全部一致（COVERAGE_GATE_OK）
#         1 = 至少一类账本声明数 ≠ 自推导数（GATE_MISMATCH，禁止宣布完成）
#         2 = 用法/路径错误
#         3 = 能力缺失，部分分母未机械确认（DEGRADED，"全覆盖"声明不可用）
#
# 用法：
#   ledger-orphans.sh --root <PROJECT_ROOT> --narrative <NARRATIVE_DIR> [--ignore <.codebookignore>]
#
# 账本侧约定（机械可读锚点行，主 agent 写账本时必须落这些行）：
#   coverage-ledger.md : 行 "CODE_DENOM_CLAIMED: <n>"   (账本声明的 code 分母文件数)
#   entry-ledger.md    : 行 "ENTRY_CAND_CLAIMED: <n>"   (账本声明的入口候选数)
#   edge-ledger.md     : 行 "EDGE_FIRE_CLAIMED: <n>"    (账本声明的跨进程 fire 端数)
#   state 账本(任一)   : 行 "STATE_SIG_CLAIMED: <n>"    (账本声明的稳定签名状态触发器数)

set -u

ROOT=""
NARR=""
IGNORE=""

while [ $# -gt 0 ]; do
  case "$1" in
    --root)      ROOT="${2:-}"; shift 2 ;;
    --narrative) NARR="${2:-}"; shift 2 ;;
    --ignore)    IGNORE="${2:-}"; shift 2 ;;
    -h|--help)
      grep '^#' "$0" | sed 's/^# \{0,1\}//'
      exit 2 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

[ -n "$ROOT" ] && [ -d "$ROOT" ] || { echo "ERR: --root <dir> 必填且须存在" >&2; exit 2; }
[ -n "$NARR" ] && [ -d "$NARR" ] || { echo "ERR: --narrative <dir> 必填且须存在" >&2; exit 2; }
[ -z "$IGNORE" ] && IGNORE="$ROOT/.codebookignore"

# 能力探测：grep/find 缺失 → 降级
DEGRADED=0
for tool in grep find sed; do
  command -v "$tool" >/dev/null 2>&1 || { echo "DEGRADE: 缺少 $tool —— 相关分母未机械确认"; DEGRADED=1; }
done

RC=0

# ---- 读账本声明锚点 -------------------------------------------------
claimed() {
  # $1 = 锚点前缀(如 CODE_DENOM_CLAIMED:)  在 NARR 下所有 .md 中找第一处
  local key="$1" val=""
  val=$(grep -rho "^${key}[[:space:]]*[0-9]\+" "$NARR" 2>/dev/null | head -n1 \
        | grep -o '[0-9]\+' | head -n1)
  echo "${val:-MISSING}"
}

report_gate() {
  # $1=名称 $2=自推导数 $3=账本声明数
  local name="$1" derived="$2" cl="$3"
  if [ "$cl" = "MISSING" ]; then
    echo "GATE[$name]: derived=$derived claimed=<缺锚点行> -> 账本未声明，无法机械核对 (rc=1)"
    RC=1
    return
  fi
  if [ "$derived" = "NA" ]; then
    echo "GATE[$name]: derived=<未机械确认> claimed=$cl -> 降级 (rc=3)"
    [ "$RC" -lt 3 ] && [ "$RC" -ne 1 ] && RC=3
    return
  fi
  if [ "$derived" -eq "$cl" ] 2>/dev/null; then
    echo "GATE[$name]: derived=$derived claimed=$cl -> OK"
  else
    echo "GATE[$name]: derived=$derived claimed=$cl -> MISMATCH (rc=1)"
    RC=1
  fi
}

# ---- (i) code 分母：find 套 .codebookignore 独立计数 ---------------
derive_code_denom() {
  if [ "$DEGRADED" -eq 1 ]; then echo "NA"; return; fi
  local count
  if [ -f "$IGNORE" ]; then
    # 逐文件过滤：剔除匹配 .codebookignore 任一非空非注释模式的路径
    count=$(find "$ROOT" -type f 2>/dev/null \
      | grep -v -E '/\.git/' \
      | grep -v -F -f <(grep -v -e '^[[:space:]]*$' -e '^[[:space:]]*#' "$IGNORE") \
      2>/dev/null | wc -l | tr -d ' ')
  else
    echo "DEGRADE: 无 .codebookignore（$IGNORE）—— code 分母未按排除规则机械确认" >&2
    count=$(find "$ROOT" -type f 2>/dev/null | grep -v -E '/\.git/' | wc -l | tr -d ' ')
  fi
  echo "${count:-NA}"
}

# ---- (ii) 入口根：可 grep 的框架注册表候选机械抽取 ----------------
derive_entry_cand() {
  if [ "$DEGRADED" -eq 1 ]; then echo "NA"; return; fi
  local n=0 hits
  # AndroidManifest 组件
  hits=$(grep -rho -E '<(activity|service|receiver|provider)[ >]' "$ROOT" \
         --include='AndroidManifest.xml' 2>/dev/null | wc -l | tr -d ' ')
  n=$((n + ${hits:-0}))
  # 路由注解 token
  hits=$(grep -rho -E '@(RequestMapping|GetMapping|PostMapping|Path|Route)\b' "$ROOT" 2>/dev/null | wc -l | tr -d ' ')
  n=$((n + ${hits:-0}))
  # META-INF/services 行
  if [ -d "$ROOT" ]; then
    while IFS= read -r svc; do
      hits=$(grep -c -v -e '^[[:space:]]*$' -e '^[[:space:]]*#' "$svc" 2>/dev/null)
      n=$((n + ${hits:-0}))
    done < <(find "$ROOT" -type f -path '*/META-INF/services/*' 2>/dev/null)
  fi
  # 事件总线订阅者 + 动态注册
  hits=$(grep -rho -E '@Subscribe\b|registerReceiver\(' "$ROOT" 2>/dev/null | wc -l | tr -d ' ')
  n=$((n + ${hits:-0}))
  echo "$n"
}

# ---- (iii) 连边 fire 端：限【跨进程/异步解耦】，不含进程内同步导航 --
derive_edge_fire() {
  if [ "$DEGRADED" -eq 1 ]; then echo "NA"; return; fi
  local n=0 hits
  # 跨进程/异步解耦：enqueue / publish/post(EventBus) / sendBroadcast / 跨进程 Intent
  # 注意：普通 startActivity(进程内同步导航) 故意【排除】，避免信号淹没。
  hits=$(grep -rho -E '\benqueue\(|\.enqueue\b|WorkManager|\bsendBroadcast\(|\bpostSticky\(|EventBus[^.]*\.post\(' "$ROOT" 2>/dev/null | wc -l | tr -d ' ')
  n=$((n + ${hits:-0}))
  echo "$n"
}

# ---- (iv) 状态触发器：仅稳定签名子类（guard/裸 if 不计） -----------
derive_state_sig() {
  if [ "$DEGRADED" -eq 1 ]; then echo "NA"; return; fi
  local n=0 hits
  # 权限校验 API
  hits=$(grep -rho -E 'checkSelfPermission\(|checkPermission\(|ContextCompat\.checkSelfPermission' "$ROOT" 2>/dev/null | wc -l | tr -d ' ')
  n=$((n + ${hits:-0}))
  # TTL / 过期常量（稳定命名）
  hits=$(grep -rho -E '\b[A-Z0-9_]*(TTL|EXPIR|TIMEOUT)[A-Z0-9_]*\b' "$ROOT" 2>/dev/null | wc -l | tr -d ' ')
  n=$((n + ${hits:-0}))
  # feature-flag 读取 API（稳定签名）
  hits=$(grep -rho -E '\bisEnabled\(|featureFlag|FeatureFlag|\.flag\(' "$ROOT" 2>/dev/null | wc -l | tr -d ' ')
  n=$((n + ${hits:-0}))
  # 注意：guard/泛化 if 无稳定签名(grep if 会洪泛) -> 故意不计，降人工/AUDIT 抽样 + 盲区声明。
  echo "$n"
}

echo "=== ledger-orphans 机械闸门（只证可 grep 范围枚举完整，不证业务覆盖/正确）==="
echo "root=$ROOT narrative=$NARR ignore=$IGNORE degraded=$DEGRADED"
echo "---"

report_gate "code-denom"  "$(derive_code_denom)"  "$(claimed 'CODE_DENOM_CLAIMED:')"
report_gate "entry-cand"  "$(derive_entry_cand)"  "$(claimed 'ENTRY_CAND_CLAIMED:')"
report_gate "edge-fire"   "$(derive_edge_fire)"   "$(claimed 'EDGE_FIRE_CLAIMED:')"
report_gate "state-sig"   "$(derive_state_sig)"   "$(claimed 'STATE_SIG_CLAIMED:')"

echo "---"
case "$RC" in
  0) echo "COVERAGE_GATE_OK: 四类可 grep 枚举与账本声明一致。"
     echo "  注意：这【不】证明业务细节/因果/分支已尽，也【不】证不可 grep 的入口/连边/状态已穷尽。" ;;
  1) echo "GATE_MISMATCH: 至少一类账本声明 ≠ 自推导数 —— 禁止宣布完成，先对齐分母/补 orphan。" ;;
  3) echo "DEGRADED: 部分分母未机械确认 —— '趋零/全覆盖'声明不可用，须首页显式降级声明。" ;;
esac
exit "$RC"
