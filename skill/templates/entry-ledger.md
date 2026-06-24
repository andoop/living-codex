---
type: ledger
title: "入口账本"
description: "证据层 · 框架注册表入口候选枚举账本"
tags: ["证据层", "账本", "入口"]
timestamp: "{{YYYY-MM-DD}}"
---

<!-- frontmatter 置于 ENTRY_CAND_CLAIMED: 锚点行之上；行首锚定 grep 不受影响 -->

# 入口账本 · {{项目}}

> 见 `references/entry-ledger.md`。入口**字面存在性**可「已确认」（grep 核验）；**归类「推断」**。
> 入口候选**从框架权威注册表独立派生**（AndroidManifest.xml / 路由注解 / DI 模块 / SPI），**无视 code-only 过滤**。
> 入口分母无机械底线（agent 未知框架入口 = 承认盲区）；可 grep 候选经 `ledger-orphans.sh` count-gate。

---

## 入口候选 → 枚举状态

| 入口候选 | 类别 | 取证位置（注册表/符号） | 字面存在 | 枚举状态 | dispatcher 多分支? |
|---|---|---|---|---|---|
| `{{Activity}}` | UI/Activity | `AndroidManifest.xml :: <activity>` | 已确认 | 已枚举 → [[journeys/{{j}}]] | 否 |
| `{{Receiver}}` | 事件总线/广播 | `@Subscribe` @ {{文件}} | 已确认 | **entry-orphan（未枚举）** | — |
| `{{Service}}` | 后台任务 | `META-INF/services/{{..}}` | 已确认 | 显式排除：{{理由}} | — |
| `{{dispatcher}}` | 命令分发 | `when(action)` @ {{文件}} | 已确认 | 已枚举 → 逐 action 展开 | **是 → {{action1,action2…}}** |

## entry-orphan（派生候选中未枚举者，显式列出）
- `{{候选}}`〔entry-orphan：未枚举为业务旅程，原因待查〕

## 机械抽取核对（count-gate）
- AndroidManifest component 数：{{机械抽取数}} vs 账本候选数：{{账本数}} → {{一致 / exit≠0}}
- 路由注解 token 数 / `META-INF/services` 行数 / `@Subscribe` 点数：{{…}}
- {{若 grep 缺失}}：⚠️ **入口分母未机械确认**。

## 盲区声明（不可删）
agent 未知的框架入口类型 = 承认盲区；其 handler 若被别流程认领则 code/entry 双分母同时失明，靠 AUDIT 红队兜底，不假装零遗漏。
