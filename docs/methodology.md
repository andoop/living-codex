# 方法论 · How It Works

Living Codex 是一个 `SKILL.md` 方法论：宿主 AI 加载后按下面五阶段执行。完整规范见 [`skill/SKILL.md`](../skill/SKILL.md) 与 `skill/references/`。

## 五阶段状态机

```
SCOPE  →  PARTITION  →  SURVEY  →  SYNTHESIZE  →  PRESENT
```

1. **SCOPE — 摸边界**：识别语言/入口/构建系统；排除 `node_modules/dist/build/.venv/...` 与超大文件；gitignore 感知。
2. **PARTITION — 切 territory**：自顶向下把项目按目录/子系统切成 N 个 territory，主 agent 写 `survey-state.md`（边界 + 文件清单 + 状态）。
3. **SURVEY — 并行测绘**：主 agent **单层扇出**只读子 agent，每个测一个 territory、只写自己的 `territory-report-<id>.md`。子 agent 是**只读叶子，不再扇出**；状态/日志仅主 agent 单写。并发 = `min(宿主上限, 待测数)`，串行分批，受限自动降级。
4. **SYNTHESIZE — 多级归并**：territory → subsystem → global 逐级 reduce，每级只综合上级摘要 + 显式跨边清单。纯模式下跨边/分组**一律标推断**。
5. **PRESENT — 分档厚书**：产出 `docs/codebook/`（README/TOC + 分章 + 99-未解之谜 + personas + Mermaid 图），每条结论带 confidence（见 [honesty.md](honesty.md)）。

## 三大操作（借鉴 Karpathy LLM Wiki 模式）

- **map**（Ingest）：测绘建书 / 增量整合新代码。
- **ask**（Query）：只读问答，带可信度引用。
- **review + lint**（Lint）：二次自审（确定性核查、禁"已验证"）+ advisory 保鲜（被引文件变更 / 失效 wikilink / 孤儿）。

## 站在巨人肩上

| 来源 | 借鉴点 |
|---|---|
| [CodeWiki (arXiv 2510.24428)](https://arxiv.org/abs/2510.24428) | 自顶向下分解 + 分治多 agent + 自底向上综合 |
| [superpowers](https://github.com/obra/superpowers) | subagent 编排、composable SKILL.md、design gate |
| [CodeGraph](https://github.com/colbymchenry/codegraph) | provenance 标记、content_hash 增量、单强工具 prompt 学 |
| [Understand-Anything](https://github.com/Egonex-AI/Understand-Anything) | 多 agent 流水线、neighborMap、人设、依赖序导览、graph-reviewer |
| [llm_wiki / Karpathy](https://github.com/nashsu/llm_wiki) | 持久 wiki（Ingest/Query/Lint）、index/log、sources[] 可追溯、Obsidian 兼容 |
| [Sandtable](https://github.com/andoop/sandtable) | 实事求是纪律、状态记忆、异常驱动修正 |

## 与可选后端的关系

`--backend codegraph|repomix|none`。后端是**可选增强**：在场时把静态结构结论升级为「已确认(解析器)」、加速上下文预打包；缺失时纯方法论路径降级运行，结构不缺、承诺同步降级。**核心永远零运行时、可移植。**
