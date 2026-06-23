<div align="center">

# 📖 Living Codex · 活典

**最诚实的业务叙事 skill —— 把任意代码库读成一本可追溯的「业务导览书」。**

*按业务旅程由外到里、由浅到深剥洋葱；它绝不假装验证、绝不编造引用、不懂就写进「未解之谜」。*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Skill: SKILL.md](https://img.shields.io/badge/format-SKILL.md-blueviolet.svg)](skill/SKILL.md)
[![Zero runtime](https://img.shields.io/badge/runtime-zero%20·%20pure%20methodology-brightgreen.svg)](#-原理)
[![Honesty-first](https://img.shields.io/badge/honesty-first-ff69b4.svg)](docs/honesty.md)

[![Claude Code](https://img.shields.io/badge/Claude_Code-supported-blueviolet.svg)](#-安装)
[![Cursor](https://img.shields.io/badge/Cursor-supported-blueviolet.svg)](#-安装)
[![Codex](https://img.shields.io/badge/Codex-supported-blueviolet.svg)](#-安装)
[![Kiro](https://img.shields.io/badge/Kiro-supported-blueviolet.svg)](#-安装)

[安装](#-安装) · [快速上手](#-快速上手) · [原理](#-原理) · [诚实模型](docs/honesty.md) · [对比](#-与同类的对比) · [命令](docs/commands.md)

</div>

---

> **你刚接手一个 18 万行、没人讲得清的项目。你想搞懂的其实不是"有哪些类"，而是"用户做一件事，系统到底发生了什么"。**
>
> Living Codex 是一个**可移植的业务叙事 skill**：装进任意项目后，它从**业务入口**出发，用多个只读子 agent 分治追踪，把代码库**按业务旅程**剥成一本可读、可追溯的「业务导览书」——L0 产品全景 → L1 能力域 → L2 用户旅程 → L3 场景规则 → L4 机制 → L5 代码锚点，读起来像**产品/交互文档**，而不是类清单。
>
> **它和其它「AI 读代码」工具最大的不同：它把诚实当作地基。** 每条结论都标可信度——`已确认` 只担保「这个符号在文件里字面存在（已 grep 核验）」，凡是「A 触发 B」「失败重试 3 次」「这条旅程跨异步连到那段」这类**要跑代码才知道**的行为/连边结论，一律最高只标 `推断`；搞不清的，老老实实进 `未解之谜`。**它永远不会给你盖一个其实没核实过的「已验证」绿章。**

## ✨ 特性

| | |
|---|---|
| 📖 **按业务旅程剥洋葱** | L0 产品全景→L1 能力域→L2 旅程→L3 场景规则→L4 机制→L5 代码锚点，由外到里、由浅到深，渐进式展开 |
| 🧭 **入口驱动 + 不漏** | 从框架权威注册表（路由/SPI/DI/事件总线/Manifest）独立枚举入口，配状态/横切第二轴，三账本机械兜底"枚举完整" |
| 🎭 **多角色交叉追踪** | 同一旅程派「正常流程 / 数据·状态 / 失败·边界」三不同质角色独立追踪，**分歧即信号**，由调和者核对 |
| 🔬 **三档可信度** | `已确认`（仅字面存在性，已 grep 核验）/ `推断`（一切行为/连边/因果封顶）/ `未解之谜`——一眼看清哪些能信 |
| 🛂 **独立监督审核** | 产出后派**独立子 agent** 做头脑预演 + 红蓝对抗（18 向量）→ `ledger-orphans.sh` 机械闸门 exit 0 才算完成。**完成 = 过审，不是 AI 自称** |
| 🕳️ **盲区前置具名** | 禁单一覆盖率数字粉饰；主动扫框架签名列"识别到存在但本轮未追踪"的子系统成专章 |
| ♻️ **可移植 · 零运行时** | 一份 Markdown skill，装进任何 agent（Claude / Cursor / Codex / Kiro）即用，无需 Node / 编译 |
| 📚 **Obsidian 兼容** | 纯 Markdown + Mermaid + `[[wikilink]]`，白捡图谱/反链/搜索 |
| 🔌 **可选后端增强** | 在场时可叠加 `codegraph` / `repomix`，把静态结构结论升级为「已确认(解析器)」（可降级） |

## 🧠 诚实，是它的护城河

别的工具拼"功能多、图好看、跑得快"。Living Codex 拼的是 **你敢不敢信它写的每一句话**。

- **「已确认」严格收窄**：只表示被引符号字面存在（机械 grep 核验），**不表示语义/行为/连边为真**。
- **行为 / 流程 / 连边 / 顺序 / 因果 / 运行期结论**：任何档位**最高只能「推断」**——因为纯静态阅读验不了它们。
- **机械闸门只证三件事**：`ledger-orphans.sh` exit 0 **只证**可 grep 范围内的文件/入口/异步连边枚举完整，**绝不**等于"业务零遗漏/已验证正确"。
- **盲区不沉默**：入口/连边/状态三处分母无机械底线 = 承认盲区，首页显式点破；识别到却没追的子系统单独成章。

完整规则见 [docs/honesty.md](docs/honesty.md)。这套纪律源自 [Sandtable](https://github.com/andoop/sandtable) 的「实事求是」底线。

## 📦 安装

Living Codex 是一个 `SKILL.md` 方法论 skill，复制进你的 agent 即可。

```bash
# 一键安装到你的 agent（自动探测 Claude Code / Cursor / Codex / Kiro）
curl -fsSL https://raw.githubusercontent.com/andoop/living-codex/main/install.sh | bash

# 或指定平台
curl -fsSL .../install.sh | bash -s kiro
```

```powershell
# Windows
irm https://raw.githubusercontent.com/andoop/living-codex/main/install.ps1 | iex
```

手动安装：把 `skill/` 整个目录复制到你项目的 skill 目录（Kiro: `.kiro/skills/narrator/`；Claude/Cursor 见各自插件约定），重启 agent 即可。零运行时依赖；可选脚本（grep 回查 / repomix 预打包）缺失时自动降级。

> **Kiro 提示**：Kiro 默认 agent 会在启动时自动发现 `.kiro/skills/` 下的 skill（读取 frontmatter 的 `name`/`description`），用到时再加载全文。装好重启后直接发 `narrate …` 即可。

## 🚀 快速上手

> 下面是**在你的 agent 里**发的命令（Cursor/Claude/Kiro 直接把消息发给 AI；Codex CLI 用 `$narrator`），**不是 shell 命令**。参数详解见 [docs/commands.md](docs/commands.md)。

```text
# 1. 先剥一条业务旅程跑通（首次强烈推荐——任务小、看得快）
narrate --journey 工程下载

# 2. 满意后再铺全项目（入口驱动梳理所有业务旅程；会跑较久）
narrate .

# 3. 增量保鲜（advisory，不阻断）：git diff 命中→标消费它的 journey "待复核"
narrate --lint --since HEAD~20

# 4. 单独再跑一轮独立审核
narrate --audit

# 5. 断点续跑（从 manifest / 三账本接力）
narrate --resume
```

产物落在目标项目的 `docs/codebook/narrative/`：`L0-product.md`（首页：诚实声明清单 + 旅程 TOC + 能力域图 + 上手顺序）+ `journeys/` + `rules/` + `portraits/`（L5 证据画像）+ 三账本 + `blind-spots.md` + Mermaid 图。用 Obsidian 打开即得图谱视图。

> **为什么首次先用 `--journey`？** `narrate .` 是个重任务：它要扇出多个子 agent、枚举入口、多角色追踪、配连边、独立审核，前几十秒甚至几分钟看不到产物是正常的。先用 `--journey` 锁定一条旅程，几分钟跑通看到形态，再决定要不要铺全量。

## ⚙️ 原理

```
BOOTSTRAP → ENTRY-LEDGER + STATE-SEED → 多角色 TRACE → EDGE-LINK → RECONCILE → SYNTHESIZE → PRESENT → AUDIT ⇄ → SIGN-OFF
摸边界+真分母   枚举入口+状态种子        三角色只读追踪   连边配对    调和分歧    归并洋葱     业务导览书  独立审核   机械闸门验收
```

- **入口驱动 + 双轴不漏**：从框架权威注册表**独立派生**入口候选（不从追踪结果倒推），每个"枚举为业务"或"显式排除"；再加状态/条件触发第二轴（token 过期/TTL/权限/flag/迁移），堵住"非入口驱动业务"的系统性漏读。
- **多角色交叉**：同一旅程三不同质角色独立追踪、不共享中间结论，**分歧即误读或含糊的强信号**，由独立调和者核对——降相关性偏差（但不假装消除系统性偏差）。
- **业务旅程 = 节点 + 边**：跨异步/派发边界的旅程被劈成多段，连边独立成账（`edge-ledger`），配不上的标"断裂边/已知盲区"，**不假装连通**。
- **完成 = 机械闸门 + 独立审核**：`ledger-orphans.sh` 自推导四类分母与账本声明比对，exit 0 才可签收；独立子 agent 红蓝对抗揪过度声明/漏配/粉饰。**AI 说做完不算数。**
- **编排集中化**：扇出只在顶层主 agent；子 agent 是只读叶子、不再扇出；账本仅主 agent 单写（杜绝竞态）。并发自适应、可降级串行。

吸收自 [CodeWiki](https://arxiv.org/abs/2510.24428)（分治多 agent + 自底向上综合）、[superpowers](https://github.com/obra/superpowers)（subagent 编排）、[llm_wiki / Karpathy 模式](https://github.com/nashsu/llm_wiki)（持久 wiki + 可追溯）与 [Sandtable](https://github.com/andoop/sandtable)（真实性纪律 + 状态记忆）。详见 [docs/methodology.md](docs/methodology.md)。

## 🆚 与同类的对比

| | **Living Codex** | CodeGraph | Understand-Anything | llm_wiki |
|---|---|---|---|---|
| 形态 | 可移植 Markdown skill | 编译 CLI/MCP | Node 插件 + Dashboard | Tauri 桌面应用 |
| 组织线 | **业务旅程（L0–L5 洋葱）** | 符号图 | 代码图 | 文档 |
| 读起来像 | **产品/交互文档** | SQLite 图(给 agent 查) | 图+Dashboard | 互链 wiki |
| 建图用 LLM | 是(+可选解析器) | 否(纯静态) | 是(混合) | 是 |
| **诚实分档** | **三档+grep回查+行为/连边封顶推断+机械闸门** | provenance | reviewer | sources[] |
| 运行时 | **零(可选增强)** | 重 | 重 | 最重 |
| 许可 | MIT | MIT | MIT | GPL-3.0 |

Living Codex 不与它们拼运行时能力，拼的是**可移植 + 可信 + 贴业务理解**。三者的能力可作为它的**可选后端**。

## 📚 示例产物

`examples/` 收录了在真实项目（[nashsu/llm_wiki](https://github.com/nashsu/llm_wiki)）上实跑生成的 codebook 样例，含 `已确认/推断/未解之谜` 真实分档、Mermaid 图、抽样 grep 回查命中，用于直观感受**诚实分档**在产物里长什么样。见 [examples/README.md](examples/README.md)。

## 🤝 贡献 & 📜 许可

欢迎贡献——见 [CONTRIBUTING.md](CONTRIBUTING.md) 与 [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)。安全问题见 [SECURITY.md](SECURITY.md)。

**MIT License** © 2026 Living Codex contributors —— 见 [LICENSE](LICENSE)。

<div align="center"><sub>诚实地把任何代码库讲成业务。Narrate any codebase — honestly.</sub></div>
