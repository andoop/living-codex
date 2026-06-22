<div align="center">

# 🗺️ Living Codex · 活典

**最诚实的代码理解 skill —— 给任意项目读出一本可追溯的「代码厚书」。**

*它绝不假装验证、绝不编造引用、不懂就写进「未解之谜」。*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Skill: SKILL.md](https://img.shields.io/badge/format-SKILL.md-blueviolet.svg)](skill/SKILL.md)
[![Zero runtime](https://img.shields.io/badge/runtime-zero%20·%20pure%20methodology-brightgreen.svg)](#原理)
[![Honesty-first](https://img.shields.io/badge/honesty-first-ff69b4.svg)](docs/honesty.md)

[![Claude Code](https://img.shields.io/badge/Claude_Code-supported-blueviolet.svg)](#安装)
[![Cursor](https://img.shields.io/badge/Cursor-supported-blueviolet.svg)](#安装)
[![Codex](https://img.shields.io/badge/Codex-supported-blueviolet.svg)](#安装)
[![Kiro](https://img.shields.io/badge/Kiro-supported-blueviolet.svg)](#安装)

[安装](#安装) · [快速上手](#快速上手) · [原理](#原理) · [诚实模型](docs/honesty.md) · [对比](#与同类的对比) · [示例产物](examples/)

</div>

---

> **你刚接手一个 18 万行、没人讲得清的项目。从哪看起？**
>
> Living Codex 是一个**可移植的 Sandtable 式方法论 skill**：装进任意项目后，它用多个只读子 agent 分治测绘整个代码库，自底向上综合成一本**可读、可追溯、分章节的「代码厚书」**（Obsidian 兼容），并按「架构师 / 新人 / 安全 / SRE」等人设给出多视角解读。
>
> **它和其它「AI 读代码」工具最大的不同：它把诚实当作地基。** 每条结论都标可信度——`已确认` 只担保「这个符号在文件里字面存在（已 grep 核验）」，凡是「A 在 B 之前执行」「失败不重试」这类**要跑代码才知道**的行为结论，一律最高只标 `推断`；搞不清的，老老实实进 `未解之谜`。**它永远不会给你盖一个其实没核实过的「已验证」绿章。**

## ✨ 特性

| | |
|---|---|
| 🗺️ **全方位测绘** | 架构 / 模块 / 数据流 / 依赖 / 构建运行 / 测试 / 接口 / 数据模型 / 配置 / 历史 / 风险，11 个维度成章 |
| 📖 **一本能读的厚书** | TOC + 分章 + 章节摘要 + Mermaid 架构/数据流图，纯 Markdown，**Obsidian 兼容**（白捡图谱/反链/搜索） |
| 🎭 **多人设视角** | 架构师 / 新人 onboarding / 安全 / SRE 各成一章，绑定不同入口与风险清单 |
| 🔬 **三档可信度** | `已确认`（仅字面存在性，已 grep 核验）/ `推断` / `未解之谜`——一眼看清哪些能信、哪些待查 |
| 🧭 **依赖序 onboarding 路线** | 「第 1 天 / 第 1 周该读哪些章节与文件」的有序清单 |
| ♻️ **可移植 · 零运行时** | 一份 Markdown skill，装进任何 agent（Claude / Cursor / Codex / Kiro）即用，无需 Node / 编译 |
| 🛡️ **诚实红线内建** | 不假装验证 · 不编造行号 · 行为结论最高只标推断 · 不写密钥原文 · 只读不改你的源码 |
| 🔌 **可选后端增强** | 在场时可叠加 `codegraph` / `repomix` 解析器，把静态结构结论升级为「已确认(解析器)」（可降级） |

## 🧠 诚实，是它的护城河

别的工具拼"功能多、图好看、跑得快"。Living Codex 拼的是 **你敢不敢信它写的每一句话**。

- **「已确认」严格收窄**：只表示被引符号字面存在（机械 grep 核验），**不表示语义为真**。
- **行为 / 关系 / 顺序 / 因果 / 运行期结论**：任何档位**最高只能「推断」**——因为纯静态阅读验不了它们。
- **无 grep 回查能力时**：「已确认」档**直接禁用**、全部降级「推断」。MUST 不挂在可选项上。
- **不挑边改造虚假一致**：发现章节间矛盾只标 advisory，绝不擅自改一边制造"看起来一致"。

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

手动安装：把 `skill/` 整个目录复制到你项目的 skill 目录（Kiro: `.kiro/skills/cartographer/`；Claude/Cursor 见各自插件约定），重启 agent 即可。零运行时依赖；可选脚本（grep 回查 / repomix 预打包）缺失时自动降级。

## 🚀 快速上手

```text
# 1. 测绘建书（默认 L1 架构 + 关键模块 L2；可选 --depth/--personas/--backend）
codex map . --depth L2 --personas architect,newgrad,security,sre --lang zh

# 2. 带引用问答（只读，标可信度）
codex ask "支付重试会不会重复扣款？"

# 3. 二次自审（确定性回查 + 标出未解之谜，绝不盖"已验证"章）
codex review

# 4. 增量保鲜（advisory，不阻断任何流程）
codex lint --since HEAD~20

# 5. 新人依赖序路线
codex onboard --persona newgrad --horizon week1
```

产物落在目标项目的 `docs/codebook/`：`README.md`(TOC+档位+图例) + 分章 + `99-未解之谜.md` + `personas/` + Mermaid 图。用 Obsidian 打开即得图谱视图。

## ⚙️ 原理

```
SCOPE  →  PARTITION  →  SURVEY  →  SYNTHESIZE  →  PRESENT
摸边界    切 territory   只读子agent   多级归并        分档厚书
          (写 survey-     并行测绘      territory→       +人设
           state)        (主agent单      subsystem        +图
                         层扇出)         →global
```

- **编排集中化**：扇出只在顶层主 agent；子 agent 是**只读叶子、不再扇出、只写自己的 report**；状态/日志仅主 agent 单写（杜绝竞态）。
- **并发自适应**：并发 = `min(宿主上限, 待测数)`，串行分批覆盖全量，宿主受限自动降级（不承诺虚标的"100 并行"）。
- **多级综合**：territory → subsystem → global 逐级归并，纯模式下跨边/分组**一律标推断**，避免脑补连线当事实。
- **双档承诺**：`backend=none` = 最佳努力 onboarding 草稿；解析器后端在场 = 静态结构可标「已确认(解析器)」（运行期永远推断）。

吸收自 [CodeWiki](https://arxiv.org/abs/2510.24428)（分治多 agent + 自底向上综合）、[superpowers](https://github.com/obra/superpowers)（subagent 编排）、[llm_wiki / Karpathy 模式](https://github.com/nashsu/llm_wiki)（持久 wiki：Ingest/Query/Lint）与 [Sandtable](https://github.com/andoop/sandtable)（真实性纪律 + 状态记忆）。详见 [docs/methodology.md](docs/methodology.md)。

## 🆚 与同类的对比

| | **Living Codex** | CodeGraph | Understand-Anything | llm_wiki |
|---|---|---|---|---|
| 形态 | 可移植 Markdown skill | 编译 CLI/MCP | Node 插件 + Dashboard | Tauri 桌面应用 |
| 对象 | 代码 | 代码 | 代码 | 文档 |
| 产物 | 可读厚书(Markdown/Obsidian) | SQLite 图(给 agent 查) | 图+Dashboard | 互链 wiki |
| 建图用 LLM | 是(+可选解析器) | 否(纯静态) | 是(混合) | 是 |
| **诚实分档** | **三档+grep回查+行为结论封顶推断** | provenance | reviewer | sources[] |
| 运行时 | **零(可选增强)** | 重 | 重 | 最重 |
| 许可 | MIT | MIT | MIT | GPL-3.0 |

Living Codex 不与它们拼运行时能力，拼的是**可移植 + 可信 + 贴开发闭环**。三者的能力可作为它的**可选后端**。

## 📚 示例产物

`examples/` 收录了 Living Codex 在真实项目（[nashsu/llm_wiki](https://github.com/nashsu/llm_wiki)）上实跑生成的 21 章 codebook（含 `已确认/推断/未解之谜` 真实分档、Mermaid 图、4 人设、抽样 grep 回查 5/5 命中）。见 [examples/README.md](examples/README.md)。

## 🤝 贡献 & 📜 许可

欢迎贡献——见 [CONTRIBUTING.md](CONTRIBUTING.md) 与 [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)。安全问题见 [SECURITY.md](SECURITY.md)。

**MIT License** © 2026 Living Codex contributors —— 见 [LICENSE](LICENSE)。

<div align="center"><sub>诚实地理解任何代码库。Read any codebase — honestly.</sub></div>
