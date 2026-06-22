# references/orchestration.md — 集中编排 + 多级 reduce

> 落实 SKILL.md §3 编排集中化铁律。对应 FR3/FR4，验证 TC4/TC5/TC6。

---

## PARTITION — 切 territory（主 agent 单线程）

1. 主 agent 按目录/模块边界把代码库切成 N 个 **territory**（一个 territory = 一组内聚、可被单个只读 agent 在 token 预算内读完的文件）。
2. 主 agent 写 `survey-state.md`（模板见 `templates/survey-state.md`）：
   - 每个 territory：`id` / `边界(路径 glob)` / `文件清单` / `状态(todo|doing|done)` / `report 路径` / `token 预算`。
   - 切分本身是**主 agent 的推断**（哪些文件算一组不是确定事实）→ 后续 subsystem 分组结论标「推断」。

## SURVEY — 分批扇出只读叶子（主 agent 扇出）

```
while 有 todo territory:
    batch = 取 min(宿主上限≈4–5, 剩余 todo 数) 个 territory
    主 agent 并行扇出 batch 个叶子 agent（prompts/subagent-survey.md）
    每个叶子：只读自己 territory 的文件清单，只写自己的 territory-report-<id>.md
    叶子返回后，主 agent 把对应 territory 状态 todo→done（单线程写 survey-state）
```

铁律复述：
- **叶子 agent 不再扇出下级**；叶子之间不通信。
- **叶子只写自己的 report**；`survey-state.md`/`log.md` **只有主 agent 写**。
- 叶子全程**只读**目标源码。

## 并发自适应 + 降级阶梯（TC5）

```
实际并发 = min(宿主上限, 待测 territory 数)
宿主上限未知/扇出失败 → 减小批大小 → 退化为串行逐个
```
- **不出现「100 并行」宣称**，承诺「宿主自适应 + 可降级串行」。
- 串行下仍**覆盖全部 territory**，不丢章节。

## 续跑（TC5）
- 中断后主 agent 读 `survey-state.md`：`done` 跳过、`doing`（中断残留）重置为 `todo` 重跑、`todo` 继续。
- 不重复已完成、不漏章节、状态无交错损坏（因只有主 agent 写）。

---

## SYNTHESIZE — 多级 reduce（TC6）

> 不一次性把所有 territory-report 塞进上下文（会导致全局架构失真）。分级归并：

```
Level 0: territory-report-<id>.md        （叶子产出，每 territory 一份）
Level 1: subsystem 摘要                    （主 agent 把相关 territory 摘要 + 跨边清单归并）
Level 2: global 架构章节                   （主 agent 只综合 subsystem 摘要 + 全局跨边清单）
```

每级**只综合上一级的摘要 + 显式「跨边清单」**（跨 territory/subsystem 的引用、数据流、调用点）。

### 跨边可信度与 backend 绑定（TC6/TC7）
- **`backend=none`（纯模式）**：所有跨 territory 边、subsystem 分组、运行期结论 → **一律「推断」**；架构图注明「无解析器后端下为最佳努力近似」。
- **`backend=codegraph`**：静态结构跨边（import/静态调用点）可标「已确认(解析器)」；**运行期/动态行为仍「推断」**。
- **不出现无依据的「已确认」跨模块连线**。

### subsystem 分组本身标推断
纯模式下「哪些 territory 属于同一 subsystem / 拓扑顺序」是主 agent 的**判断**，不是确定事实 → 这些分组/拓扑结论标「推断」。

---

## 成本护栏
- 默认深度 L1–L2；L3/L4 深挖 **opt-in**。
- 每 territory 设 token 预算；超预算 → 该 territory 降级摘要级 → 章节标「部分测绘」、未读文件/目录入该章「未解之谜」、**confidence 不得标已确认**。
