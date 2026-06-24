---
type: glossary
title: "术语白话表"
description: "把正文里不得不出现的产品级术语翻译成大白话"
tags: ["术语", "导航"]
timestamp: "{{YYYY-MM-DD}}"
---

# 术语白话表 · {{产品名}}

> 收录正文里**必须保留**的产品级术语（去术语三类处置中的 (b) 类，见 `references/plain-language.md` §2）。
> 每条 = 术语 + 一句白话 +（可选）线下锚点。正文首次出现该术语时链 `[[glossary#<词条>]]`。
> 这是**白话翻译层**，不是堆术语的地方；纯实现库名（(c) 类）应下沉到各文档证据区，不进这里。

> ⚠️ **写法约束（R1 · 见 plain-language.md §3.1）**：本表提及代码名时**不得写机械闸门正则匹配的裸 token**
> （`WorkManager` / `enqueue(` / `sendBroadcast(` / `checkSelfPermission(` / 大写 `TTL`·`TIMEOUT`·`EXPIR` / `isEnabled(` / `FeatureFlag` …），
> 否则会污染 `ledger-orphans.sh` 的 entry/edge/state 分母致 `GATE_MISMATCH` 误报。改用描述性写法或用连字符/小写打断字面（如「Work-Manager 那一类」）。

---

## {{术语 A}}
{{一句白话：它替用户/系统做成了什么事}}。
〔技术细节见 [[portraits/{{module}}]] 证据区〕

## {{术语 B}}
{{一句白话}}。
