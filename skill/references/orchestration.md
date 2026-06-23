# references/orchestration.md — 集中编排 + 多级归并（业务叙事轴）

> 落实 SKILL.md「编排集中化铁律」。对应 FR3/FR9。
> 核心铁律（来自宿主约束）：**扇出只在顶层主 agent；子 agent 是只读叶子、不再扇出；账本/状态仅主 agent 单线程写。**

---

## 单写者纪律（最高铁律）

- **仅主 agent 写**共享状态：`entry-ledger.md` / `edge-ledger.md` / `coverage-ledger.md` / 状态轴账本 / `manifest.md` / `log.md`。
- **叶子 agent 只写自己的**追踪草稿（各角色一份），**不碰共享账本**，叶子之间不通信。
- 叶子全程**只读**目标源码。

---

## BOOTSTRAP — 文件级 manifest（覆盖账本真分母 · A6）

TRACE 之前，主 agent 先界定干净范围并建**至少文件级**的 FULL manifest，作为 `coverage-ledger` 的 code 分母真分母：

1. 先定 `.codebookignore`（见 `references/scoping.md`）→ `find` 出 in-scope 全集。
2. 写 `docs/codebook/narrative/manifest.md`：每文件一行 `- [ ]`（仅主 agent 写）。
3. 若证据层只做 focused 画像：长尾未画像文件**一律先记 orphan 候选，不得剔出分母**；并显式警告"证据层 focused，长尾入未解之谜是因证据未建、非不存在"。

> 逐文件画像规范见 `references/file-portraits.md`；画像是 L5 证据叶子，被 journey 的 L5 锚点互链。

---

## TRACE — 多角色只读叶子扇出（主 agent 扇出）

同一条业务旅程派**不同质角色**叶子独立追踪（见 `references/multi-role.md`）：

```
对每条待追踪 journey：
    batch = 取 min(宿主上限≈4–5, 角色数×待追踪 journey 数) 个叶子
    主 agent 并行扇出叶子：
        - 正常流程追踪者   (prompts/narrative-trace-role-normal.md)
        - 数据·状态追踪者   (prompts/narrative-trace-role-state.md)
        - 失败·边界追踪者   (prompts/narrative-trace-role-failure.md)
    每个叶子：只读、从自己的入口/状态种子追踪，只写自己的草稿
              （节点序列 + 证据锚点 + fire 端 + orphan 候选 + 可达链）
    叶子返回后，主 agent 把 fire 端/候选回填账本（单线程写）
```

铁律复述：
- **叶子不再扇出下级**；叶子之间不共享中间结论（**分歧即信号**，留给 RECONCILE）。
- **账本只有主 agent 写**；叶子只写自己的角色草稿。

---

## 并发自适应 + 降级阶梯

```
实际并发 = min(宿主上限, 角色数 × 待追踪 journey 数)
宿主上限未知/扇出失败 → 减小批大小 → 退化为串行逐角色
```

- **不出现「100 并行」宣称**，承诺「宿主自适应 + 可降级串行」。
- **扇出失败不得静默判完成**：主 agent 必须 ①在 `log.md` 与首页**显著记录"扇出降级为串行"**；②重评覆盖目标——按入口分多轮串行覆盖，或明示"本轮只覆盖 X，其余进未解之谜"。缺口由 AUDIT 对照三账本强制揪出。
- **多角色并行不可用 → 降级串行多角色**（同一主 agent 切显式角色 + 独立上下文轮次），SIGN-OFF/首页须标 `⚠️ 串行、不等同独立交叉验证`（见 `references/multi-role.md`）。

---

## 续跑（resume）

中断后主 agent 从磁盘台账恢复，不靠记忆：
- `manifest.md`：`[x]` 跳过、`[ ]` 从第一个未勾处继续画像。
- 三账本：已登记的入口/边/认领记录跳过；`doing`（中断残留）重追。
- 因**只有主 agent 写**账本，状态无交错损坏。
- `narrate --resume` 即据此从断点接力，不重复、不漏。

---

## EDGE-LINK + RECONCILE + SYNTHESIZE — 多级归并

> 不一次性把所有叶子草稿塞进上下文（会失真）。分级归并：

```
Level 0: 各角色追踪草稿              （叶子产出，每角色一份）
Level 1: EDGE-LINK + RECONCILE       （主 agent 配对 fire/receive 端、调和多角色分歧）
Level 2: L0–L4 洋葱 + 三账本回填      （主 agent 综合成业务导览书）
```

- **EDGE-LINK**：机械抽取 fire 端全集 + 各叶子报告 → 配对 publish/subscribe、enqueue/dequeue；配不上标"断裂边"（见 `references/edge-ledger.md`）。
- **RECONCILE**：reconciler（**非任一追踪者**）交叉调和分歧；无法调和的**降「未解之谜」标分歧，不靠多数表决**（见 `prompts/reconcile.md`）。
- **SYNTHESIZE**：归并成 L0–L5 洋葱（见 `references/narrative-model.md`）+ 回填 code/entry/edge 三账本 + provenance（traced 须带可达链）。

### 跨边/连接可信度（纯模式）
- `backend=none`：所有连边、顺序、因果、跨进程关系 → **一律「推断」**；`traced` 在纯模式下至多证相邻 hop 字面存在，**不证运行时可达**（见 `references/coverage-ledger.md`）。
- `backend=codegraph`：静态结构边（import/静态调用点）可标「已确认(解析器)」；**运行期/动态行为仍「推断」**。

---

## 成本护栏
- 用 `--journey <名>` 把任务切小：只追一条旅程，避免一次性铺全项目导致超长任务。
- 每条 journey/角色设 token 预算；超预算 → 该追踪降级摘要级 → 在该 journey 显著标「部分追踪」、未读入「未解之谜」、confidence 不得标已确认。
