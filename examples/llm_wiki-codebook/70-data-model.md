# 70 · 数据模型（D8）

> **Confidence 图例**：`已确认` = 仅字面存在性、已 grep 核验，非语义/运行验证；`推断` = 未运行验证的判断；`未解之谜` = 需运行或未读到。

## 摘要
没有传统 SQL schema；数据模型分三处：
1. **磁盘真相** = 项目目录里的 Markdown wiki 页（带 YAML frontmatter）+ `index.md` / `log.md`（见 `llm-wiki.md` 设计）。
2. **向量存储** = LanceDB（Arrow schema），结构体 `ChunkSearchResult` / `VectorSearchResult` / `ChunkUpsertInput`（`vectorstore.rs`）。
3. **前端 TS 类型** = `src/types/wiki.ts`（`WikiProject` / `FileNode`）、`chat-store.ts`（`DisplayMessage` / `Conversation` / `MessageReference`）、`wiki-store.ts`（`LlmConfig` 等）、`wiki-page-types.ts`、`wiki-schema.ts`、`frontmatter.ts`。

## 关键文件
| 文件 | 角色 | confidence |
|---|---|---|
| `src/types/wiki.ts` :: `WikiProject` | 项目/文件节点类型 | 推断 |
| `src/lib/wiki-schema.ts` / `wiki-page-types.ts` | wiki 页类型/schema | 推断 |
| `src/lib/frontmatter.ts` | YAML frontmatter 解析/生成 | 推断 |
| `src-tauri/src/commands/vectorstore.rs` :: `ChunkSearchResult` | 向量 chunk 结果结构 | 已确认 |
| `src-tauri/src/types/wiki.rs` | Rust 侧 wiki 类型 | 推断 |
| `src/stores/chat-store.ts` :: `DisplayMessage` | 消息模型 | 推断 |

## 关键结论
- **向量数据按 chunk 建模（chunk_id = `${page_id}#${chunk_index}`）** `confidence: 已确认（仅字面存在性）` — 引用：`src-tauri/src/commands/vectorstore.rs :: ChunkSearchResult`、`:: ChunkUpsertInput`（字段字面存在；id 派生为行为性 → 推断）
- **chat 消息含引用与图片（vision）** `confidence: 已确认（仅字面存在性）` — 引用：`src/stores/chat-store.ts :: MessageReference`、`:: MessageImage`
- **wiki 页用 YAML frontmatter 承载元数据** `confidence: 推断` — 引用：`src/lib/frontmatter.ts`、`src/lib/ingest.ts :: stampGeneratedFrontmatterDates`（生成/解析为行为性 → 推断）
- **核心真相是磁盘 Markdown，而非数据库** `confidence: 推断` — 引用：`llm-wiki.md`、`src/lib/persist.ts`（设计意图归纳 → 推断）

## 本章未解之谜
- LanceDB 表/列完整 schema（Arrow `Field` 定义未全部精读）。
- frontmatter 字段全集与校验规则（需精读 / 运行）。
