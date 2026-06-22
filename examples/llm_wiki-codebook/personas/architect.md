# 人设视角 · 架构师 (architect)

> **Confidence 图例**：`已确认` = 仅字面存在性、已 grep 核验，非语义/运行验证；`推断` = 未运行验证的判断；`未解之谜` = 需运行或未读到。

## 先读什么（入口路线）
[[00-architecture]] 架构总览 → [[10-modules/rust-backend]] + [[10-modules/llm-providers]] 模块边界 → [[20-dataflow]] 数据流（标推断）。

## 你会关心的
- **分层是否清晰**：三层（Rust 宿主 / React 前端 / 配套 MCP·扩展）。前端承载了几乎全部业务逻辑（`src/lib` ~190 文件），Rust 偏"能力提供者"（fs/向量/检索/子进程/HTTP）。`confidence: 推断`
- **模块耦合点**：`ingest.ts` 是上帝模块倾向（118KB 单文件），跨多 subsystem。`confidence: 推断` — 引用：`src/lib/ingest.ts`
- **跨边界依赖**：前端 → Rust 仅经 IPC（`invoke`）与本地 HTTP 两条窄通道；可扩展点在 provider 抽象（`llm-providers.ts`）与检索融合（`search-rrf.ts`）。`confidence: 推断`

## 你最怕的（架构师风险清单）
- **上帝模块**：`ingest.ts` 体量过大，单点复杂度高、难测难改。`confidence: 推断`
- **逻辑全在前端**：核心业务在 TS 侧，Rust 仅薄封装 → 业务可移植性/可测性依赖前端。`confidence: 推断`
- **跨层穿透**：前端直接拼 provider endpoint 并经 Rust fetch 出站，信任边界下沉到用户配置。`confidence: 推断`
- **双检索/双存储一致性**：磁盘 Markdown 真相 vs LanceDB 向量索引的同步漂移。`confidence: 推断`

## 你（架构师）基本不看
单测细节、具体配置默认值 → 见 [[50-testing]] / [[80-config]]。
