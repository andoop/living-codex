---
name: narrator
description: 活典 Living Codex — 把陌生代码库读成一本「业务导览书」的诚实 skill。按业务旅程由外到里、由浅到深剥洋葱（L0 产品全景→L1 能力域→L2 旅程→L3 场景规则→L4 机制→L5 代码锚点），产出读起来像产品/交互文档的 Markdown。何时用：想顺着「用户做 X、系统发生什么」彻底搞懂一条业务流程、给新人讲清楚业务、或为陌生项目建业务心智模型时。核心纪律：不假装验证、不编造引用、行为结论封顶「推断」、把不覆盖/不确定的前置具名。
---

# 活典 · Living Codex — narrator（业务叙事）

> 把一个陌生代码库读成一本**按业务组织、可追溯、诚实标注可信度**的「业务导览书」。
> 组织线不是模块/文件，而是**业务旅程**：由大到小、由外到里、由浅到深，读起来像**产品/交互文档**。
> 差异化不是「功能最多」，是 **Sandtable 真实性纪律**：不假装验证、不编造引用、把不确定集中暴露、不会的就明说。

---

## 0. 一句话契约（读之前先记住 · 不可违背）

本 skill 产出的是**尽力而为的业务"导览草稿"**，价值是 (a) 加速人建业务心智模型；(b) 把人精准带到该读的代码锚点自行核验；(c) 前置具名它不覆盖/不确定什么。**它不是业务真相权威，不替代你对代码的核验。**

- 「**已确认**」**只**担保一件事：被引符号/字符串在它标注的文件里**字面存在**（机械 grep 核验过）。**不**担保任何语义、行为、关系、连边为真。
- 任何「**行为 / 流程 / 连边 / 顺序 / 因果 / 运行期**」结论，**在任何档位最高只能标「推断」**。
- 不知道、需运行才能定的，进「**未解之谜**」（且须说明为何没查清、该读哪个文件）。
- **机械闸门（`scripts/ledger-orphans.sh` exit 0）只证三类「可 grep 范围内」枚举完整**（文件 / 入口根 / 异步连边），**绝不**等于"业务零遗漏/已验证正确"。
- **完成 = 过审，不是 AI 自称**：未经独立子 agent 的 AUDIT、`ledger-orphans.sh` 未 exit 0，**不得宣布完成**（见 §6）。

完整诚实口径见 `references/honesty-charter.md`（一份宪章统管三处免责 + 「机械闸门 vs AUDIT 能/不能」对照表）。

- **产物双层（线上白话 / 线下证据）**：正文（线上）是面向小白、零未解释术语的产品/交互白话；confidence 锚点/三档图例/技术库名（线下）下沉到每文档 `## 证据与可信度`，按线上编号绑定。**白话只作用于呈现与措辞层，诚实红线不因白话而松动**（见 `references/plain-language.md`）。

---

## 1. 何时用 / 不适用

**适用**：
- 想顺着一条业务旅程（"用户做 X → 系统做 Y → 得到 Z"）**由外到里、由浅到深彻底搞懂**；
- 接手陌生项目，要快速建立**业务**心智模型，而不只是模块清单；
- 要把某条业务流程/规则讲清楚给新人、产品、测试。

**不适用**：需要确定性可验证 provenance / 真证伪 / 可信增量索引时——那些需要确定性运行时（tree-sitter/SQLite/SHA256），本 skill 明确不假装能做（详见 `references/provenance.md`）。

---

## 2. 命令面

| 命令 | 作用 |
|---|---|
| `narrate [path]` | 入口驱动梳理全项目业务旅程，产出 L0–L5 业务导览书 |
| `narrate --journey <名>` | **只剥一条指定业务旅程**（推荐：把大任务切小，避免一次性铺全项目导致超长任务） |
| `narrate --resume` | 从 `manifest.md` / 三账本断点续跑（见 §10） |
| `narrate --audit` | 对已建好的导览书单独派独立子 agent 再跑一轮 AUDIT |
| `narrate --lint [--since <git-ref>]` | advisory 保鲜：git diff 命中的文件 → 标消费它的 journey「待复核(可能过期)」，不阻断 |

> **怎么触发**：装好 skill 重启 agent 后，发 `narrate …`（或直接自然语言"给这个项目做业务叙事/剥一条 XX 旅程"）。
> **重任务提示**：`narrate .` 会扇出多子 agent、跑较久；**首次建议用 `--journey` 锁定一条旅程**，跑通了再铺全量。

---

## 3. 业务叙事流程（阶段集 · 含监督闭环）

```
ENTRY-LEDGER + STATE-SEED → 多角色 TRACE → EDGE-LINK → RECONCILE → SYNTHESIZE → PRESENT → AUDIT ⇄ (再做一轮) → SIGN-OFF
```

| 阶段 | 做什么 | 谁来做 | 详见 |
|---|---|---|---|
| **BOOTSTRAP** | 先界定干净范围（`.codebookignore`）+ 建至少文件级 FULL manifest 作覆盖真分母 | 主 agent **单线程写** | `references/scoping.md` `references/file-portraits.md` `references/orchestration.md` |
| **ENTRY-LEDGER + STATE-SEED** | 枚举入口（含框架权威注册表强制纳入）→ `entry-ledger.md`；追加状态/条件触发种子（第二轴）→ 状态账本 | 主 agent **单线程写** | `references/entry-ledger.md` `references/state-axis.md` |
| **多角色 TRACE** | 同一旅程派**不同质角色**只读叶子（正常流程 / 数据·状态 / 失败·边界）独立追踪，各写草稿 + fire 端 + orphan 候选 + 可达链 | 主 agent 扇出 / 叶子只读、不共享中间结论 | `references/multi-role.md` `references/narrative-tracing.md` `prompts/narrative-trace-role-*.md` |
| **EDGE-LINK** | 机械抽取 fire 端 + 各叶子报告 → 配对 publish/subscribe、enqueue/dequeue，标断裂边 → `edge-ledger.md` | 主 agent | `references/edge-ledger.md` |
| **RECONCILE** | reconciler（**非追踪者**）交叉调和多角色分歧；无法调和降「未解之谜」标分歧，不靠多数表决 | 主 agent / 独立子 agent | `prompts/reconcile.md` |
| **SYNTHESIZE** | 归并成 L0–L5 洋葱 + 回填三账本（code/entry/edge）+ provenance（traced 须带可达链）；**按 `plain-language.md` 白话化发布 concept、线上/线下分层、关键结论编号** | 主 agent | `references/narrative-model.md` `references/coverage-ledger.md` `references/plain-language.md` |
| **PRESENT** | 产 `docs/codebook/narrative/`：L0 首页（**默认可见 honesty banner + 第五条全信号行 + 全局 gap**）+ `index.md`/`log.md`/`glossary.md` + journeys（白话正文 + L3/L4 折叠 + 线下证据区 + Mermaid「非验证协议」caption + `## 还不知道什么`）+ rules + 盲区专章；**每 concept 带 OKF frontmatter**；**白话化按 `plain-language.md`** | 主 agent | `references/narrative-book-spec.md` `references/plain-language.md` `templates/narrative-*.md` `references/blind-spots.md` |
| **AUDIT** | 派**独立**子 agent（异于写书 agent）跑头脑预演 + 红蓝对抗（18 向量含断裂边漏配/dispatcher 未展开/可达链不可复现/叙事过期/含糊到无用/状态漏测/punt 占比） | 主 agent 扇出独立审核子 agent | `references/supervision.md` `prompts/audit-narrative.md` |
| **SIGN-OFF** | `ledger-orphans.sh` exit 0 + P0/P1 清零 + punt 占比可接受 + 盲区具名 → DONE；否则回相应阶段再做一轮 | 主 agent（与开发者） | `references/supervision.md` `references/honesty-charter.md` |

---

## 4. 分层洋葱 L0–L5（产物的呈现形态）

向下读 = 越来越深；每层自包含可读，渐进式展开。详见 `references/narrative-model.md`。

> **线上 / 线下**（见 `references/plain-language.md`）：L0–L3 = 线上白话正文（**无未解释术语**、面向小白、产品/交互视角）；L5 + 每文档 `## 证据与可信度` = 线下证据层（保留技术术语/锚点）。

| 层 | 放什么（线上白话，无未解释术语） | confidence 上限 |
|---|---|---|
| **L0 产品全景** | 这是什么产品、给谁用、能干哪几件大事；≤1 页。禁营销/评价形容词 | 框架句须挂证据或标「编者摘要」 |
| **L1 能力域地图** | 几大能力域及彼此关系；一张图 + 短描述 | 同上 |
| **L2 用户旅程** | 端到端走一遍："用户做 X → 系统做 Y → 得到 Z"，主干顺序、分支收起 | 行为结论「推断」 |
| **L3 场景与规则** | 分支/条件/边界/异常/业务规则——**细节主体在此层**，须**决策级具体度** | 「推断」 |
| **L4 机制实现** | 状态机、数据模型、关键算法、时序 | 「推断」；Mermaid 带「非验证协议」caption |
| **L5 代码锚点（线下证据层）** | 链到 `文件:符号` + 逐文件画像（证据叶子）；保留术语正常 | 字面存在性「已确认」、调用关系「推断」 |

---

## 5. 诚实红线（核心，贯穿全程）

- **confidence 三档**：`已确认`（仅字面存在性，已 grep 核验） / `推断` / `未解之谜`。完整定义见 `references/provenance.md`。
- **「已确认」严格收窄**：仅 = 被引符号/字符串字面存在性被机械 grep 核验。**不等于语义/行为/连边为真**。
- **行为/流程/连边/顺序/因果/运行期结论**（调用 / 在…之前 / 触发 / 回滚 / 不重试 / 并发 / 校验 / 持久化 / 去重 / 路由到 / 异步回调…；判定准则：**凡需运行、或需读多处控制流才成立的谓语 = 行为性**）→ **任何档位最高只能「推断」**。
- **「已确认」的机械回查是必需而非可选**：宿主无 `scripts/verify-citations.sh` 或等价 grep 回查能力时，**「已确认」档不可用，自动降级「推断」**。
- **不编造 file:line**；引用用「文件 + 可 grep 符号名/字符串」。
- **有用性下限**（`references/usefulness-floor.md`）：禁「含糊 + 推断」双重免责——能静态查清的须给到决策级具体度（条件/阈值/分支/产物），查不清的诚实进「未解之谜」。
- **不写密钥/PII 原文**（含中间草稿）；零运行时下这是**尽力而非保证**，须向开发者明示（可选 `scripts/scrub-secrets.sh` 体检）。

---

## 6. 编排集中化 + 监督闭环（不可违背）

**编排集中化铁律**（来源：宿主约束——子 agent 不能再生成子 agent、并行 agent 间不可通信、并发有硬上限）：

1. **扇出只在顶层主 agent**；子 agent 是**只读叶子**，**不再生成下级**、叶子间不通信。
2. **账本/状态只有主 agent 单线程写**（`entry-ledger`/`edge-ledger`/`coverage-ledger`/状态账本/`manifest.md`/`log.md`）；叶子**只写自己的角色草稿**。
3. **并发 = `min(宿主上限≈4–5, 角色数×待追踪 journey 数)`**，靠串行分批覆盖全量；**绝不宣称「100 并行」**。
4. **扇出失败不得静默判完成**：必须显著记录"降级为串行"、重评覆盖目标、按入口分多轮串行或明示"本轮只覆盖 X"。缺口由 AUDIT 对照三账本强制揪出。
5. **多角色并行不可用 → 降级串行多角色**，SIGN-OFF/首页须标 `⚠️ 串行、不等同独立交叉验证`。

详见 `references/orchestration.md`。

**监督闭环**（`references/supervision.md`）：PRESENT 后**必须**派独立子 agent（异于写书上下文）做 AUDIT；SIGN-OFF 由 `ledger-orphans.sh` exit 0 + P0/P1 清零 + punt 可接受 + 盲区具名共同决定。**红旗**：扇出失败就浅追宣布完成 · 审核与写书同上下文 · 脚本未 exit 0 却称完成 · 单一覆盖率数字粉饰 0 覆盖子系统。

---

## 7. 三账本 + 状态轴 + 盲区（"不漏"的机械骨架）

- **三账本**（`references/coverage-ledger.md`）：(a) code 覆盖（文件→业务节点）(b) entry 覆盖（注册表候选→是否枚举）(c) edge 覆盖（异步 fire 端→对端）。每条认领挂 `traced`(带可达链)/`heuristic`；**枚举覆盖率分子只计 traced**。
- **状态轴**（`references/state-axis.md`）：入口驱动会漏掉状态/条件驱动业务（token 过期/TTL/权限/flag/迁移）——追加第二类遍历种子；只有稳定签名子类进 count-gate，guard/裸 if 承认盲区。
- **盲区专章**（`references/blind-spots.md`）：禁单一高覆盖率数字粉饰；主动扫框架签名列"识别到存在但本轮未追踪"的子系统，章首标"非盲区全集"caveat。
- **机械闸门**（`scripts/ledger-orphans.sh`）：自推导四类分母（code/entry/edge/state-sig）与账本声明比对，不一致即 `exit≠0`；**DONE 由脚本决定，非 AI 自称**。账本须落机械可读锚点行：`CODE_DENOM_CLAIMED:` / `ENTRY_CAND_CLAIMED:` / `EDGE_FIRE_CLAIMED:` / `STATE_SIG_CLAIMED:`。

---

## 8. 产物结构 + 首页声明清单

产物落目标项目 `docs/codebook/narrative/`，目录布局与 Obsidian 兼容规范见 `references/narrative-book-spec.md`：

```
docs/codebook/narrative/
├── index.md               # OKF 机读渐进披露目录（无 frontmatter）
├── log.md                 # OKF 文档变更史（ISO 倒序 append-only · 无 frontmatter）
├── L0-product.md          # 人读首页：honesty banner + 第五条全信号行 + 旅程 TOC + 全局 gap + onboarding
├── L1-domains.md          # 能力域地图（type: domain-map）
├── glossary.md            # 术语白话表（type: glossary）
├── journeys/<旅程>.md     # L2 白话正文 + L3/L4 折叠 + 还不知道什么 + 证据与可信度（type: journey）
├── rules/<规则>.md        # 业务规则（type: rule）
├── portraits/<module>.md  # L5 证据画像（逐文件 · type: portrait）
├── entry-ledger.md / edge-ledger.md / coverage-ledger.md / state-ledger.md / manifest.md  # type: ledger（frontmatter 置 *_CLAIMED: 之上）
├── blind-spots.md         # 已知缺失/未测子系统专章（type: blind-spots）
└── audit/                 # 独立审核战报（type: audit）
```

> **OKF frontmatter**：每发布 concept 顶部带 YAML（`type` 必填 + `title`/`description`/`tags`/`timestamp` 荐）；`index.md`/`log.md` 不带。frontmatter 内容纪律（不过度声明/不泄术语，`tags` 白名单）与"线上/线下"分层见 `references/plain-language.md`。glossary/正文避裸闸门 token（R1，§3.1）。

**L0 首页必写声明清单**（`references/honesty-charter.md` 第五条 · 模板 `templates/narrative-L0-product.md`）：导览草稿不替代核验 · 覆盖率冠"枚举"二字 + 两维并列释义 · 机械闸门只证三类枚举 · AUDIT/SIGN-OFF 不认证业务正确 · 入口/连边/状态三处分母无机械底线=承认盲区 · 多角色并行/串行戳记 · 快照时点+"grep 命中≠未过期" · 核心节点 punt 占比。**第五条每条信号行本身默认可见、不可整体或部分折叠**（M10），另加默认可见的一行白话 honesty banner。

---

## 9. 降级总则

| 缺失能力 | 降级行为 |
|---|---|
| 无 grep 回查 (`verify-citations.sh`/等价) | 「已确认」档**不可用**，全部降「推断」 |
| 无 `ledger-orphans.sh`/grep | "枚举完整/趋零"声明不可用，降"分母未机械确认" |
| 无解析器后端 (codegraph) | 连边/运行期标「推断」，首页标"草稿" |
| 无 repomix (`pack-context.sh`) | 主 agent 按文件清单逐个读取，不影响结构 |
| 无 git | `--lint` 无 file→journey 反向触发，降首页快照声明 |
| token 预算超限 | 该 journey/角色降摘要级 → 显著标「部分追踪」、未读入「未解之谜」、不得标已确认 |

降级必须在产物里**显式说明**，不静默。

---

## 10. 多宿主触发 + 续跑

- 本 skill 是纯方法论 + 可选 shell 脚本（grep/sed/find），不绑死语言栈/runtime。在支持 skill/子 agent 的宿主（Claude Code / Cursor / Codex / Gemini / Kiro 等）中加载本 SKILL.md 即可；扇出能力随宿主自适应（见 §6 降级阶梯）。
- **续跑**（`narrate --resume`）：主 agent 从磁盘台账恢复——`manifest.md` 从第一个未勾处继续、三账本已登记项跳过、`doing` 残留重追。因仅主 agent 写账本，状态无交错损坏。详见 `references/orchestration.md`「续跑」。
