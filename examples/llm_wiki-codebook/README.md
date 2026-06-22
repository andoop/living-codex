# LLM Wiki · 代码厚书（活典 Living Codex）

> 自动生成的 onboarding 草稿。**非运行验证的真相**。请配合源码阅读。
> 生成方法：活典 cartographer skill，串行单 agent 测绘（宿主无并行子 agent → 按 skill §3 降级阶梯退化为串行逐 territory）。

## 当前档位
- **backend**：`none`（纯模式）
- **标称**：**最佳努力 onboarding 草稿**
- **深度**：`L1 全局架构` + 对 4 个关键 territory 做 `L2`（Rust 后端 / Ingest 管线 / LLM Provider 层 / Wiki·图谱·检索）；其余 territory 为 **部分测绘**（见各章与 [[99-未解之谜]]）

## 全局免责（重要）
- 本书是 **onboarding 草稿**，不是经过运行验证的真相。
- 「**已确认**」**只**表示被引符号/字符串在所标文件里**字面存在**（已用 `scripts/verify-citations.sh` 做机械 grep 核验），**不**表示其语义/行为/调用关系为真。
- 任何**行为 / 关系 / 顺序 / 因果 / 运行期 / 动态**结论，**在本书任何位置最高只标「推断」**。
- 需运行才能定的，进 [[99-未解之谜]]。
- 跨 territory 边、subsystem 分组、运行期数据流，纯模式下**一律「推断」**（无解析器后端）。

## 降级声明
- **无解析器后端（codegraph）** → `backend=none`：跨边/运行期/调用关系一律「推断」，不画成确定关系。
- **有 `verify-citations.sh`** → 「已确认」档**可用**，但仅担保「字面存在性」。本书「已确认」条目采用该脚本机械 grep 回查；T9 验收**抽样核验 5/5 命中**（明细见 `docs/sandtable/features/2026-06-18-codebase-onboarding-skill/rehearsals/t9-live.md`），**全量 `--batch` 回查列为后续完善项**。
- **未用 repomix（pack-context.sh）** → 按文件清单手动读取，不影响结构完整性。
- **部分测绘**：前端 `src/components/**`、`mcp-server/**`、`extension/**`、大量 `*.test.ts` 仅做清单级扫描，未逐文件精读 → 列入 [[99-未解之谜]]，其结论 confidence 不得标已确认。
- **密钥/PII**：本书只记键名/位置/用途，不记原文；零运行时下这是尽力而非保证。

## 目录 TOC
- [[00-architecture]] 架构总览（含 Mermaid 架构图）
- [[20-dataflow]] 数据流（跨边标推断）
- [[30-dependencies]] 依赖
- [[40-build-run]] 构建与运行
- [[50-testing]] 测试
- [[60-interfaces]] 接口/API
- [[70-data-model]] 数据模型
- [[80-config]] 配置
- [[90-history]] 历史/演进
- [[95-risks]] 风险
- 模块章节（`10-modules/`）：
  - [[10-modules/rust-backend]] Rust/Tauri 后端
  - [[10-modules/ingest-pipeline]] Ingest 摄取管线
  - [[10-modules/llm-providers]] LLM Provider / 流式传输层
  - [[10-modules/wiki-graph-search]] Wiki·知识图谱·检索
  - [[10-modules/frontend-stores]] 前端状态（Zustand stores）
- 人设视角：[[personas/architect]] · [[personas/newgrad]] · [[personas/security]] · [[personas/sre]]
- [[99-未解之谜]]

## 一句话产品定位
LLM Wiki 是一个 **Tauri 2 + React 19 + Rust** 桌面应用：把原始资料（PDF/Office/网页剪藏）经 LLM 摄取（ingest）增量编译成一份 **Obsidian 兼容的 Markdown 知识库**，并提供 AI 对话、知识图谱、向量检索、深度研究、lint 健康检查等能力。
- confidence: 推断 — 综合自 `llm-wiki.md`、`README.md`、`src/lib/ingest.ts :: autoIngest`、`src-tauri/src/lib.rs`（产品意图为关系性归纳，最高推断）
