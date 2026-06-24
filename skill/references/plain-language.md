# references/plain-language.md — 白话纪律 + 分层呈现 + OKF frontmatter（核心新规范）

> 落实 PRD G2/G4/G5、M9、M10、D1/D4。验证 TC1/TC2/TC4/TC7。
> 单一真源：模板 / `narrative-book-spec.md` / `narrative-model.md` / `SKILL.md` 均**引用本文件**，不各自复述白话规则。
> 一切白话化只作用于**呈现与措辞层**，不放宽任何 confidence 语义、不升格行为结论、不取消机械闸门/AUDIT（见 `honesty-charter.md`）。

---

## 1. 分层呈现：线上 / 线下（above / below the line）

每个发布 concept 文档分两层，读者**默认只读"线上"**，需核验时展开"线下"：

| 层 | 放什么 | 给谁读 | 形态 |
|---|---|---|---|
| **线上（正文 body）** | 白话产品/交互叙事："用户做什么、系统给什么、为什么"。**零未解释术语**，面向不懂该项目的小白。关键结论**编号**①②③ | 默认读者（小白） | 正文，不折叠 |
| **线下（`## 证据与可信度`）** | confidence 三档 + `文件 + 可 grep 符号/字符串` 锚点 + Mermaid「非验证协议」caption + 证据时间线。**按线上同号①②③逐条列**，可绑定 | 要核验的人 | 文档末尾 `<details>` 折叠区 |

- **线上↔线下编号绑定**（M2）：线上每条关键结论标 ①②③；线下证据区按**同号**列 confidence + 锚点，逐条可绑定，不靠人脑配对。
- 线下证据区可折叠（`<details>`），但**诚实信号默认可见总则**（见 §6）规定的信号**不得**藏进默认折叠。

---

## 2. 去术语三类处置（D4 · 白话纪律）

正文叙事**不得出现未经解释的专业/技术术语**（框架名/类型名/函数名/库名）。遇到术语三选一：

- **(a) 业务词替代**：能用业务词说清的，直接替代，正文不出现技术名。
- **(b) 必留产品级术语**：不可避免的产品级术语，**首次出现就地一句白话解释**，或链到 `glossary.md`。
- **(c) 纯实现细节术语**：实现库/框架名（如 HTTP 服务库、前端状态库、PDF 渲染库）**移到线下证据区**，正文不出现，或仅以"（技术细节见证据区）"带过。

### ≥3 个"术语→白话"对照（示范，可扩充进 glossary）

| 技术术语 | 白话 |
|---|---|
| `invoke`（前端调后端） | 前端请后端帮忙干活 |
| `tiny_http` | 程序自带的一个小型网页服务（不用额外装服务器） |
| `Zustand store` | 前端的"共享记事本"，各界面都能读写的同一份状态 |
| `IPC` | 前端和后端两个程序之间互相喊话 |
| `向量库 / LanceDB` | 一个"按意思相近"找东西的资料库 |

> 对照原则：**先说它替用户/系统做成了什么事，再（可选）在括号或证据区附技术名**。不是删掉可追溯性，是把技术名下沉到线下。

---

## 3. glossary 机制

- 落 `docs/codebook/narrative/glossary.md`（OKF concept，`type: glossary`，模板 `templates/glossary.md`）。
- 收录 §2 (b) 类"必留产品级术语 → 白话解释"；正文术语首次出现链到它（`[[glossary#<词条>]]`）。
- glossary 是**白话翻译层**，不是堆术语的地方；每条 = 术语 + 一句白话 + （可选）线下锚点。

### 3.1 glossary / 正文 **必须避开机械闸门裸 token**（R1 · 实测约束 · 不改脚本）

`scripts/ledger-orphans.sh` 的 entry/edge/state 三类分母 **grep 整个 `$ROOT`、不套 `.codebookignore`**，而 `docs/codebook/narrative/` 在 `$ROOT` 内。**实测**：narrative 文档（尤其 glossary）里写**裸的闸门 token** 会污染 derived 计数，造成 `GATE_MISMATCH` 误报（fail-safe 方向=过度阻断 DONE，可恢复，但浪费一轮）。**实测数据**：一个含 6 个裸 token 的 `glossary.md` 使 `edge-fire` derived 3→6、`state-sig` 3→6，把本应 `COVERAGE_GATE_OK` 的闸门翻成 `GATE_MISMATCH`。

**约束（守 N5：不改 `ledger-orphans.sh` 逻辑，只约束写法）**：narrative 正文/glossary 提及代码名时，**不得写下列闸门正则匹配的裸形**，改用**描述性写法**或**插入分隔符 / 用小写**打断字面匹配：

| 闸门类别 | 触发正则（节选） | 禁止的裸写法 | 安全写法 |
|---|---|---|---|
| edge-fire | `WorkManager` | `WorkManager` | "后台任务调度器（代码里叫 Work-Manager 那一类）" |
| edge-fire | `\benqueue\(` `\.enqueue\b` | `enqueue(` `.enqueue` | "排进队列（代码里的 en-queue 调用）" |
| edge-fire | `\bsendBroadcast\(` | `sendBroadcast(` | "发系统广播（send-Broadcast 那种调用）" |
| edge-fire | `EventBus[^.]*\.post\(` `\bpostSticky\(` | `EventBus.post(` `postSticky(` | "往事件总线丢一条消息" |
| state-sig | `checkSelfPermission\(` `checkPermission\(` | `checkSelfPermission(` | "检查有没有权限（check-Self-Permission 式调用）" |
| state-sig | `[A-Z0-9_]*(TTL\|EXPIR\|TIMEOUT)[A-Z0-9_]*`（**大写**） | `TTL` `SESSION_TTL` `TIMEOUT` | 用小写 `ttl`/`timeout`，或写"过期时长常量（命名里带 t-t-l）" |
| state-sig | `\bisEnabled\(` `featureFlag` `FeatureFlag` `\.flag\(` | `isEnabled(` `FeatureFlag` | "功能开关（is-Enabled 式读取）" |

> 要点：① 正则区分大小写 → 小写形（`ttl`/`workmanager`）不触发；② edge/state 多数锚 `(` 或 camelCase → 用连字符/空格/零宽断开即可（实测 `Work-Manager` 不匹配）；③ **反引号包裹不够**（`grep -rho` 不看 markdown）。④ **TTL/EXPIR/TIMEOUT 即使裸大写单词也匹配** —— 实测一句"名字带 TTL 的常量"就让 `state-sig` 3→4，故连散文里都要避开大写形。
> **作业纪律**：PRESENT 写完 glossary/正文后，**必须重跑一次 `ledger-orphans.sh`**；若 derived 较预期偏高，先排查是不是 narrative 文档里的裸 token 污染（而非真的漏账），按上表改写后复跑。

---

## 4. OKF frontmatter 规范

每个**发布 concept `.md`** 顶部带 OKF 风格 YAML frontmatter：

```yaml
---
type: journey            # 必填，见下取值集
title: 上传一份文件        # 荐：白话产品级标题
description: 用户选文件后系统如何把它存好  # 荐：一句白话摘要
tags: [上传, 离线]         # 荐：领域/功能标签（白名单见 §5）
timestamp: 2026-06-24     # 荐：ISO 日期
---
```

**`type` 取值集**（与产物一一对应）：
`product` / `domain-map`(L1-domains) / `journey` / `rule` / `portrait` / `ledger`(coverage/entry/edge/state-ledger/manifest 共用) / `blind-spots` / `audit` / `glossary`。

**覆盖范围**：
- 有独立模板者（`product`/`journey`/`rule`/`portrait`/三 ledger/`index`/`log`/`glossary`）：frontmatter 写进模板。
- 无独立模板的产物（`domain-map`=L1-domains / `blind-spots` / `audit/*` / `state-ledger` / `manifest`）：由 `narrative-book-spec.md` 强制要求 frontmatter（主 agent 按 spec 生成时补）。
- **保留文件 `index.md` / `log.md` 不带 frontmatter**（OKF §6/§7：导航/变更史文件本身不是 concept）。
- ledger 类 frontmatter **置于 `*_CLAIMED:` 锚点行之上**，行首锚定的 grep 不受影响（实测 `ledger-orphans.sh` 仍正常抓取）。

---

## 5. frontmatter 内容纪律（M9 · 不得成为过度声明/术语旁路）

**全部机读字段**（`title`/`description`/`tags` 及任何自定义键——OKF/gbrain 最先消费的"答案"facet）：

- **不得含未标记的行为/连边/因果结论**（行为结论一律留 body，受三档约束）。
- **不得泄漏未解释术语**（框架名/类型名/函数名/库名）。
- 只能写**产品定位级事实**或显式**"编者摘要"**。

### `tags` 白名单

- ✅ 允许：**领域/功能标签**，如 `tags: [上传, 离线, 鉴权]`。
- ❌ 禁止：**行为结论标签**，如 `tags: [自动重试]`、`tags: [失败回滚]`（行为结论须 body + 三档）。
- ❌ 禁止：**纯术语标签**，如 `tags: [LanceDB]`、`tags: [Tauri]`。

### 例外（证据层 concept 从宽）

`type: portrait` / `type: ledger` 是**证据层（below the line）**，其 frontmatter 可用**描述性技术命名**（如 `title: rust-backend 画像`）：术语泄漏扫描（AUDIT 向量19）对其**从宽**（按 P2/P3 记，不 gating）。
> **但行为结论过度声明（向量23 / M9）对所有字段一律不豁免**——证据层 frontmatter 也不得写未标记行为结论。
> 证据层 frontmatter 同样受 §3.1 闸门裸 token 约束（用 `Work-Manager` 式打断写法）。

---

## 6. 诚实信号默认可见总则（M10 · 贯穿所有"线上"呈现面）

白话化与"线下折叠"**只允许下沉**：细节 / 锚点 / 完整三档释义图例 / 账本指针 / 数字明细。
以下诚实信号**必须对默认读者（小白）首屏可见、不可只藏进默认折叠的 `<details>`**：

1. **每文档章首白话可信度声明**（承载"推断"默认基线，D5）。
2. **`已确认` / `未解之谜` 例外**（M8）：`已确认`（仅字面存在）线上行内可见；`未解之谜`（没查清）线上行内保留或上浮该文档"还不知道什么"gap 小节（**`已确认` 不上浮 gap，gap 只装"未知"**）。
3. **L0 首页 `honesty-charter` 第五条声明清单的全部诚实信号行本身**——草稿不替代核验 / 覆盖率冠"枚举" / 机械闸门不证业务覆盖 / AUDIT·SIGN-OFF 不认证业务正确 / 入口·连边·状态无机械底线=承认盲区的非对称声明 / **多角色串行须标"不等同独立交叉验证"** / 快照"grep 命中≠未过期" / 核心节点 punt 占比。

**消歧（不留口子）**：第五条**每一条信号行本身默认可见**，仅其完整释义/账本指针/数字明细可折叠下沉——**不存在"只折叠部分信号"的口子**。L0 顶部须有**默认可见的一行白话 honesty banner** +「详见证据与边界」。M8 与本条对单条例外、frontmatter、首页清单**施加同一可见性标准**。

---

## 7. 白话 ≠ 含糊（交叉引用 usefulness-floor.md）

线上白话**仍须达决策级具体度**：白话不是降低具体度的借口。
- ❌ 白话含糊：「断网时它会想办法把文件存好」（无决策价值）。
- ✅ 白话决策级：「断网时它会自己反复重试，最多试 3 次，还不行就把这次任务标成失败、等下次联网再说」（具体条件/阈值/产物，技术锚点在线下证据区）。

详见 `usefulness-floor.md`「白话且决策级双标准」。

---

## 8. 与 OKF log.md / gbrain timeline 的区分（防 R3 漂移）

- `log.md` = **OKF 文档变更史**（这本书哪天改了什么，ISO 日期倒序、append-only）。
- 各文档「证据与可信度」里的**证据时间线** = 该结论的**取证轨迹**（在代码里何处看到什么）。
- **二者不同**：不要把证据轨迹倒进 `log.md`，也不要把书的变更史塞进文档证据区。
