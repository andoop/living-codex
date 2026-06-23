# references/supervision.md — 监督与签收闭环 · AUDIT + SIGN-OFF（业务叙事轴）

> **业务导览书必须被独立审核，不能由写书的 AI 自己宣布完成。** 这是本 skill 对"AI 说做完就做完"的根治。
> 诚实总口径见 `references/honesty-charter.md`（机械闸门 vs AUDIT 能/不能对照表；审核只降 variance 不降 bias）。

## 为什么需要
扇出失败 → 单 agent 串行只追了几条线 → 却走到"完成"。诚实标注虽在，但**没有任何独立环节对照三账本揪出"枚举严重不全/断裂边漏配/过度声明"**。AUDIT 就是补这一环。

## AUDIT — 独立子 agent 对抗式审核（PRESENT 后必做）

主 agent 扇出**独立审核子 agent**（**必须与写书 agent 不同上下文**；宿主无并行则串行依次起独立 agent / 子进程，**不得**用写书上下文自审顶替）。攻击向量与交付见 `prompts/audit-narrative.md`，核心包括：

- **头脑预演（覆盖 / 逻辑闭环）**：三账本（code/entry/edge）是否齐全、orphan 是否透明；旅程能否 L0→L5 读通、层间一致；"部分覆盖/未解之谜"是否如实标注。
- **红蓝对抗（18 向量）**：过度声明（行为标已确认）/ 编造失效引用（跑 `verify-citations.sh`）/ 孤儿业务节点 / 入口漏枚举 / 分母缩小 / orphan 漏报 / 断裂边漏配 / dispatcher 未展开 / traced 可达链不可复现 / 叙事过期未标 / 含糊到无用 / 状态轴漏测 / punt 占比过高 / 覆盖率粉饰盲区 / 串行戳记造假 / 机械闸门冒充业务权威 / 密钥 PII 泄漏。
- 每条发现按 **P0–P3** 分级，战报写入 `docs/codebook/narrative/audit/audit-narrative-<n>.md`（主 agent 亲核，抽查其证据，不轻信）。

## SIGN-OFF — 验收，决定是否 DONE

```
ledger-orphans.sh exit 0  且  P0/P1 清零  且  核心节点 punt 占比可接受  且  盲区已具名?
   ├─ 是 → 标 DONE：首页写"三类枚举覆盖达成度 + 残余 orphan + punt 占比 + 审核轮数"
   └─ 否 → 回 TRACE/EDGE-LINK/SYNTHESIZE/PRESENT 再做一轮 → 再 AUDIT → 循环
```

- **DONE 由 `scripts/ledger-orphans.sh` exit 0 决定，非 AI 自称**（机械闸门，见 `references/coverage-ledger.md`）。
- **再做一轮聚焦**：只补漏枚举/被攻破处，按 `manifest.md` / 账本续跑，不重做已达标部分。

## SIGN-OFF 只认证 / 绝不认证（honesty-charter 第三条 · 不可违背）
- **只认证**：① 三类（可 grep 范围）枚举机械完整；② 每条结论挂锚 + confidence 标注；③ 已知盲区/缺口具名且未被覆盖率数字淹没；④ 未被独立结构性复读证伪。
- **绝不认证**：业务叙事正确、业务逻辑完整、因果关系为真（无运行时 oracle，独立审核只降 variance 不降 bias）。
- 凡 AUDIT/作者拿不准的语义跳跃 → **强制降「未解之谜」**，不靠"再审一遍"假装消解。

## 红旗（出现即违规）
- 扇出失败 → 浅追几条线即宣布完成（**最严重**）。
- 审核子 agent 与写书 agent 同上下文（回声，不算独立审核）。
- `ledger-orphans.sh` 未 exit 0 却宣布完成。
- 用单一高"枚举覆盖率"数字掩盖 0 覆盖子系统、不标盲区。
- 把 `exit 0` 暗示成"业务覆盖/已验证正确"。
