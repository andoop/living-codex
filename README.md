<div align="center">

# 📖 Living Codex · 活典

**最诚实的业务叙事 skill —— 把任意代码库读成一本可追溯的「业务导览书」。**

*按业务旅程一层层往里讲；不假装验证、不编造引用、不懂就写进「未解之谜」。*

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

> 你接手了一个十几万行、没人讲得清的项目。你真正想搞懂的，不是"有哪些类"，而是 **"用户做一件事，系统到底发生了什么"**。
>
> Living Codex 就是干这个的。装进项目后，它从**业务入口**出发，派多个只读子 agent 分头追踪代码，最后把整个库**按业务旅程**讲成一本书——由外到里、由浅到深分成六层：
>
> **L0 这是什么产品 → L1 有哪几块能力 → L2 一条旅程怎么走 → L3 有哪些分支和规则 → L4 底层怎么实现 → L5 对应哪段代码。**
>
> 读起来像**产品文档**，而不是类清单。

### 它和别的「AI 读代码」工具，差在哪？

差在**诚实**。每条结论都标了可信度：

- `已确认` 只代表一件事——**这个符号确实在文件里出现过**（用 grep 核对过），不代表它的行为为真。
- 凡是"A 触发 B""失败重试 3 次""这条旅程跨异步连到那段"这类**得跑起来才知道**的结论，最高只标 `推断`。
- 实在搞不清的，老实写进 `未解之谜`，并说明该去读哪个文件。

**它永远不会给你盖一个其实没核实过的「已验证」绿章。**

## ✨ 特性

| | |
|---|---|
| 📖 **按业务旅程讲** | 六层洋葱 L0→L5，从"这是什么产品"一路讲到"对应哪段代码"，由浅入深 |
| 🧭 **入口驱动，尽量不漏** | 从框架的路由、注解、配置等"权威清单"里独立列出所有入口，再补一轮状态触发（登录过期、缓存失效、权限…），双管齐下少漏业务 |
| 🎭 **多角色交叉追踪** | 同一条旅程派三个视角（正常流程 / 数据与状态 / 失败与边界）各自独立追，**结论打架的地方就是疑点**，由专门的"调和者"核对 |
| 🔬 **三档可信度** | `已确认` / `推断` / `未解之谜`，一眼看清哪些能信、哪些只是猜 |
| 🛂 **独立审核才算完** | 写完后另派一个独立 agent 挑刺（红蓝对抗 18 项），再过机械校验脚本，脚本通过才算 DONE。**不是 AI 自己说做完就完** |
| 🕳️ **盲区摆在明面上** | 不用一个漂亮的覆盖率数字糊弄你；扫到了但这轮没追的子系统，单独列一章告诉你 |
| ♻️ **可移植 · 零运行时** | 就是一份 Markdown，装进任何 agent（Claude / Cursor / Codex / Kiro）即用，不装 Node、不编译 |
| 📚 **Obsidian 兼容** | 纯 Markdown + Mermaid 图 + `[[wikilink]]`，白捡图谱、反链、搜索 |
| 🔌 **可选增强** | 装了 `codegraph` / `repomix` 就自动用上，没有就降级，结论照样出 |

## 🧠 诚实，是它的护城河

别的工具拼功能多、图好看、跑得快。Living Codex 拼的是 **你敢不敢信它写的每一句话**。

它给自己定了几条死规矩：

1. **「已确认」只担保字面存在**。grep 到一个名字，只证明这个名字出现过，不证明围绕它写的那句话是对的。
2. **行为类结论封顶到「推断」**。调用、顺序、触发、重试、并发…这些得跑代码才知道的，再有把握也只标"推断"。
3. **机械校验只证三件事**：脚本通过 = 文件、入口、异步连边这三类**清单列全了**，**不等于**"业务没遗漏 / 已验证正确"。
4. **盲区不藏着**。哪些地方没法机械兜底、哪些子系统没追，首页直接挑明。

完整规则见 [docs/honesty.md](docs/honesty.md)。这套纪律源自 [Sandtable](https://github.com/andoop/sandtable) 的「实事求是」底线。

## 📦 安装

Living Codex 就是一份 `SKILL.md`，复制进你的 agent 即可。

```bash
# 一键安装（自动探测 Claude Code / Cursor / Codex / Kiro）
curl -fsSL https://raw.githubusercontent.com/andoop/living-codex/main/install.sh | bash

# 或指定平台
curl -fsSL .../install.sh | bash -s kiro
```

```powershell
# Windows
irm https://raw.githubusercontent.com/andoop/living-codex/main/install.ps1 | iex
```

手动安装：把整个 `skill/` 目录复制到项目的 skill 目录（Kiro 放 `.kiro/skills/narrator/`），重启 agent 即可。无运行时依赖；可选脚本缺失时自动降级。

> **Kiro 用户**：Kiro 启动时会自动发现 `.kiro/skills/` 下的 skill，用到时再加载全文。装好重启后直接发 `narrate …` 就行。

## 🚀 快速上手

> 下面是发给 **AI** 的命令（Cursor/Claude/Kiro 直接当普通消息发；Codex CLI 用 `$narrator`），**不是 shell 命令**。详见 [docs/commands.md](docs/commands.md)。

```text
# 1. 先剥一条旅程跑通（首次强烈推荐——任务小、几分钟就看到产物）
narrate --journey 工程下载

# 2. 满意了再铺全项目（梳理所有业务旅程，会跑比较久）
narrate .

# 3. 代码改了之后做增量保鲜：标记可能过期的旅程，不阻断
narrate --lint --since HEAD~20

# 4. 单独再跑一轮独立审核
narrate --audit

# 5. 中断了接着跑
narrate --resume
```

产物都落在项目的 `docs/codebook/narrative/`：首页 `L0-product.md`（诚实声明 + 旅程目录 + 能力域图 + 上手顺序），加上 `journeys/`（各条旅程）、`rules/`（业务规则）、`portraits/`（代码证据）、各账本和盲区专章。用 Obsidian 打开就有图谱视图。

> **为什么首次先用 `--journey`？** `narrate .` 是个重活：要派一堆子 agent、列入口、多角色追踪、配连边、独立审核，前几十秒甚至几分钟没产物是正常的。先用 `--journey` 锁一条旅程，几分钟看到成品长啥样，再决定要不要铺全量。

## ⚙️ 原理

一条业务旅程，Living Codex 是这样一步步攒出来的：

| 步骤 | 在干嘛 |
|---|---|
| **① 定范围** | 划清哪些文件算、哪些不算，建一份文件清单当"覆盖底数" |
| **② 列入口** | 从框架的路由/注解/配置里独立列出所有业务入口，再补一轮状态触发器 |
| **③ 多角色追踪** | 同一旅程派三个视角各自追，互不通气 |
| **④ 配连边** | 把跨异步/消息边界断开的旅程片段，重新接上；接不上的标"断裂" |
| **⑤ 调和** | 三个视角打架的地方，由调和者核实，定不下来就降级成"未解之谜" |
| **⑥ 成书** | 归并成 L0–L5 六层，写成产物 |
| **⑦ 审 + 验收** | 另派独立 agent 挑刺，再跑机械校验脚本；脚本通过才算完成 |

几个关键设计：

- **入口从框架"权威清单"独立列，不从追踪结果倒推**——这样才不会"追到哪算哪"，把整条没被追到的业务线漏掉。
- **三个视角不共享中间结论**——结论一致更可信，打架的地方正是误读或含糊的信号。
- **旅程 = 节点 + 边**——跨异步的旅程会被切成几段，连边单独记账；接不上就老实标"断裂边"，绝不假装连通。
- **完成由脚本说了算，不由 AI 自称**——机械校验脚本自己数一遍、和账本对账，对不上就不让收工。
- **只有主 agent 写账本**，子 agent 是只读的、不再往下派，避免互相打架。并发跟着宿主能力自动调，不行就退回串行。

吸收自 [CodeWiki](https://arxiv.org/abs/2510.24428)、[superpowers](https://github.com/obra/superpowers)、[llm_wiki / Karpathy 模式](https://github.com/nashsu/llm_wiki) 与 [Sandtable](https://github.com/andoop/sandtable)。详见 [docs/methodology.md](docs/methodology.md)。

## 🆚 与同类的对比

| | **Living Codex** | CodeGraph | Understand-Anything | llm_wiki |
|---|---|---|---|---|
| 形态 | 可移植 Markdown skill | 编译 CLI/MCP | Node 插件 + Dashboard | Tauri 桌面应用 |
| 组织线 | **业务旅程（L0–L5）** | 符号图 | 代码图 | 文档 |
| 读起来像 | **产品文档** | 给 agent 查的图 | 图 + Dashboard | 互链 wiki |
| 用 LLM 建图 | 是（可加解析器） | 否（纯静态） | 是（混合） | 是 |
| **诚实分档** | **三档 + grep 回查 + 行为封顶推断 + 机械校验** | provenance | reviewer | sources[] |
| 运行时 | **零（可选增强）** | 重 | 重 | 最重 |
| 许可 | MIT | MIT | MIT | GPL-3.0 |

Living Codex 不跟它们拼运行时能力，拼的是**可移植 + 可信 + 贴业务**。它们的能力可以当 Living Codex 的可选后端。

## 📚 示例产物

`examples/` 收录了在真实项目（[nashsu/llm_wiki](https://github.com/nashsu/llm_wiki)）上实跑出的样例，能直观看到 `已确认/推断/未解之谜` 三档分档、Mermaid 图、grep 回查命中长什么样。见 [examples/README.md](examples/README.md)。

## 🤝 贡献 & 📜 许可

欢迎贡献——见 [CONTRIBUTING.md](CONTRIBUTING.md) 与 [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)。安全问题见 [SECURITY.md](SECURITY.md)。

**MIT License** © 2026 Living Codex contributors —— 见 [LICENSE](LICENSE)。

<div align="center"><sub>诚实地把任何代码库讲成业务。Narrate any codebase — honestly.</sub></div>
