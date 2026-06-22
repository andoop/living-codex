# 10 · 模块 · Wiki · 知识图谱 · 检索（L2）

> **Confidence 图例**：`已确认` = 仅字面存在性、已 grep 核验，非语义/运行验证；`推断` = 未运行验证的判断；`未解之谜` = 需运行或未读到。

## 摘要
该 territory 覆盖知识库的"图与检索"侧：`wiki-graph.ts` 从 wiki 页构图（`buildWikiGraph`）；`graph-*.ts`（filters/insights/relevance/visibility/search）做图分析与可视化数据；前端用 graphology + sigma 渲染（见 `30-dependencies`）。检索分三路：Rust 全文检索（`commands/search.rs`）、前端向量检索（`embedding.ts :: searchByEmbedding`，底层 LanceDB）、RRF 融合（`search-rrf.ts`）。wiki 页本身由 `frontmatter.ts`、`wiki-filename.ts`、`wiki-page-resolver.ts`、`wikilink-transform.ts`、`persist.ts` 等支撑。

## 关键文件
| 文件 | 角色 | confidence |
|---|---|---|
| `src/lib/wiki-graph.ts` :: `buildWikiGraph` | 由 wiki 页集合构建链接图 | 已确认 |
| `src/lib/graph-relevance.ts` / `graph-insights.ts` | 图相关性/洞察计算 | 推断 |
| `src/lib/embedding.ts` :: `searchByEmbedding` | 向量检索（前端侧封装 LanceDB） | 已确认 |
| `src/lib/search.ts` / `search-rrf.ts` | 检索编排 / RRF 融合排序 | 推断 |
| `src-tauri/src/commands/search.rs` :: `tokenize_query` | Rust 全文检索分词/片段 | 已确认 |
| `src/lib/web-search.ts` :: `webSearch` | 外部 web 检索（tavily/serpapi/searxng…） | 已确认 |
| `src/lib/persist.ts` :: `loadChatHistory` | review/lint/chat 历史持久化 | 已确认 |
| `src/lib/wikilink-transform.ts` / `wiki-page-resolver.ts` | `[[wikilink]]` 解析/转换 | 推断 |

## 关键结论
- **存在从 wiki 页构图的入口 `buildWikiGraph`** `confidence: 已确认（仅字面存在性）` — 引用：`src/lib/wiki-graph.ts :: export async function buildWikiGraph`（脚本回查命中；构图算法/边生成 = 行为性 → 推断）
- **向量检索入口 `searchByEmbedding`，底层走 Rust LanceDB 命令** `confidence: 已确认（仅字面存在性）` — 引用：`src/lib/embedding.ts :: export async function searchByEmbedding`、`src-tauri/src/commands/vectorstore.rs :: vector_search_chunks`（跨边调用为行为性 → 推断）
- **全文检索在 Rust 侧分词 + 构建片段** `confidence: 已确认（仅字面存在性）` — 引用：`src-tauri/src/commands/search.rs :: tokenize_query`、`:: build_snippet`、`:: extract_title`（函数字面存在；其检索流程 = 行为性 → 推断）
- **多路召回用 RRF 融合（推断）** `confidence: 推断` — 引用：`src/lib/search-rrf.ts`、`src/lib/search.ts`（融合排序为行为性 → 推断）
- **外部 web 检索支持多 provider** `confidence: 已确认（仅字面存在性）` — 引用：`src/lib/web-search.ts :: export async function webSearch`、`:: hasConfiguredSearchProvider`（provider 选项字面存在；实际请求 = 行为性 → 推断）

## 本章未解之谜
- 图相关性/社区发现（graphology-communities-louvain）的真实计算路径与性能（需运行）。
- 向量检索 + 全文检索 + web 检索的实际融合权重与触发条件（需运行）。
- `[[wikilink]]` 解析对大小写/别名/路径碰撞的真实处理（需运行 / 见对应 *.test.ts）。
