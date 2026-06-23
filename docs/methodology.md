# 方法论 · How It Works

Living Codex 是一个 `SKILL.md` 方法论：宿主 AI 加载后，按业务旅程把代码库读成一本「业务导览书」。完整规范见 [`skill/SKILL.md`](../skill/SKILL.md) 与 `skill/references/`。

## 业务叙事流程

```
BOOTSTRAP → ENTRY-LEDGER + STATE-SEED → 多角色 TRACE → EDGE-LINK → RECONCILE → SYNTHESIZE → PRESENT → AUDIT ⇄ → SIGN-OFF
```

1. **BOOTSTRAP — 摸边界 + 真分母**：生成 `.codebookignore`（排除 `node_modules/dist/build/.venv/...`、二进制、本 skill 安装副本），`find` 出 in-scope 全集，建至少文件级 `manifest.md` 作覆盖账本真分母。
2. **ENTRY-LEDGER + STATE-SEED — 枚举入口**：从框架权威注册表（AndroidManifest/路由注解/SPI/DI/事件总线）**独立派生**入口候选，每个"枚举为业务"或"显式排除"；追加状态/条件触发种子（token 过期/TTL/权限/flag/迁移）作第二轴。
3. **多角色 TRACE — 不同质追踪**：主 agent **单层扇出**只读叶子，同一旅程派「正常流程 / 数据·状态 / 失败·边界」三不同质角色独立追踪，各写草稿 + fire 端 + orphan 候选 + 可达链。叶子**只读、不再扇出**；账本仅主 agent 单写。
4. **EDGE-LINK — 连边配对**：机械抽取异步/派发 fire 端（enqueue/publish/sendBroadcast），配对端，配不上标"断裂边"。业务旅程 = 节点 + 边。
5. **RECONCILE — 调和分歧**：reconciler（非追踪者）交叉调和多角色分歧；无法调和的降「未解之谜」标分歧，不靠多数表决。
6. **SYNTHESIZE — 归并洋葱**：合成 L0–L5 分层洋葱 + 回填 code/entry/edge 三账本。
7. **PRESENT — 业务导览书**：产出 `docs/codebook/narrative/`（L0 首页 + 旅程 + 规则 + 画像 + 三账本 + 盲区专章 + Mermaid「非验证协议」图），每条结论带 confidence（见 [honesty.md](honesty.md)）。
8. **AUDIT ⇄ SIGN-OFF — 独立审核验收**：派**独立子 agent**（异于写书上下文）做头脑预演 + 红蓝对抗；`ledger-orphans.sh` exit 0 + P0/P1 清零 + punt 可接受 + 盲区具名才算 DONE，否则回相应阶段再做一轮。

## 分层洋葱 L0–L5

由外到里、由浅到深，每层自包含、渐进式展开：

| 层 | 答什么问题 |
|---|---|
| **L0 产品全景** | 这软件是干嘛的？给谁用？能干哪几件大事？ |
| **L1 能力域地图** | 它由哪几块能力组成、怎么协作？ |
| **L2 用户旅程** | 我做一件事，端到端发生了什么？ |
| **L3 场景与规则** | 这一步在什么条件下会怎样？阈值/边界/异常？ |
| **L4 机制实现** | 底层状态/数据/时序怎么实现的？ |
| **L5 代码锚点** | 证据在哪？（链到 `文件:符号` + 逐文件画像） |

## 命令

- **`narrate [path]`**：入口驱动梳理全项目业务旅程。
- **`narrate --journey <名>`**：只剥一条指定旅程（把大任务切小，推荐先用它跑通）。
- **`narrate --resume`**：从 manifest/三账本断点续跑。
- **`narrate --audit`**：单独再跑一轮独立审核。
- **`narrate --lint`**：advisory 保鲜（git diff 命中 → 标消费它的 journey 待复核）。

## 站在巨人肩上

| 来源 | 借鉴点 |
|---|---|
| [CodeWiki (arXiv 2510.24428)](https://arxiv.org/abs/2510.24428) | 自顶向下分解 + 分治多 agent + 自底向上综合 |
| [superpowers](https://github.com/obra/superpowers) | subagent 编排、composable SKILL.md |
| [llm_wiki / Karpathy](https://github.com/nashsu/llm_wiki) | 持久 wiki、可追溯 sources[]、Obsidian 兼容 |
| [Sandtable](https://github.com/andoop/sandtable) | 实事求是纪律、状态记忆、异常驱动修正 |

## 与可选后端的关系

`backend codegraph|repomix|none`。后端是**可选增强**：在场时把静态结构结论升级为「已确认(解析器)」、加速上下文预打包；缺失时纯方法论路径降级运行，结构不缺、承诺同步降级。**核心永远零运行时、可移植。**
