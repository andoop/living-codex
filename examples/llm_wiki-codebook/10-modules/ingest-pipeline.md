# 10 · 模块 · Ingest 摄取管线（L2）

> **Confidence 图例**：`已确认` = 仅字面存在性、已 grep 核验，非语义/运行验证；`推断` = 未运行验证的判断；`未解之谜` = 需运行或未读到。

## 摘要
`src/lib/ingest.ts`（约 118KB，单文件巨型模块）是产品核心：把一份原始 source 经 LLM 读取、分析、生成/合并 wiki 页、更新 index/log。围绕它有一组卫星模块：`ingest-queue.ts`（队列）、`ingest-cache.ts`（缓存）、`ingest-sanitize.ts`（清洗）、`text-chunker.ts`（语义分块）、`page-merge.ts`（页合并）、`enrich-wikilinks.ts`（补 wikilink）、`image-caption-pipeline.ts`（图像描述）、`mineru.ts`（PDF 解析）。该 territory 文件多、体量大，本章为 L2 但 `ingest.ts` 仅按导出符号 + 头部精读，正文大段未逐行读 → 标**部分测绘**。

> ⚠️ **部分测绘**：`ingest.ts` 体量过大超单次精读预算，仅读取导出符号清单与关键函数签名；正文实现细节入本章未解之谜。

## 关键文件
| 文件 | 角色 | confidence |
|---|---|---|
| `src/lib/ingest.ts` :: `autoIngest` | 摄取主流程编排 | 已确认 |
| `src/lib/ingest.ts` :: `startIngest` / `executeIngestWrites` | 摄取启动 / 落盘写入 | 推断 |
| `src/lib/ingest.ts` :: `parseFileBlocks` / `FILE_BLOCK_REGEX` | 解析 LLM 输出的 `---FILE:---` 块 | 推断 |
| `src/lib/ingest.ts` :: `buildAnalysisPrompt` / `buildGenerationPrompt` | 构造分析/生成提示词 | 推断 |
| `src/lib/text-chunker.ts` | 语义分块（供 embedding） | 推断 |
| `src/lib/page-merge.ts` | 已有页与新内容合并 | 推断 |
| `src/lib/ingest-queue.ts` | 摄取任务队列 | 推断 |
| `src/lib/dedup.ts` / `dedup-queue.ts` / `dedup-runner.ts` | 去重子系统 | 推断 |

## 关键结论
- **存在统一摄取入口 `autoIngest`** `confidence: 已确认（仅字面存在性）` — 引用：`src/lib/ingest.ts :: export async function autoIngest`（脚本回查命中；其内部调用链/执行顺序 = 行为性 → 推断）
- **LLM 生成的多文件输出用 `---FILE: ... ---END FILE---` 协议解析** `confidence: 推断` — 引用：`src/lib/ingest.ts :: FILE_BLOCK_REGEX`、`:: parseFileBlocks`（正则字面存在；其"解析→写盘"流程为行为性 → 推断）
- **摄取分"分析 → 生成 → 合并/写入"多阶段（推断的拓扑）** `confidence: 推断` — 引用：`buildAnalysisPrompt`、`buildGenerationPrompt`、`executeIngestWrites`（阶段顺序需读多处控制流 → 推断）
- **有独立去重子系统（含 embedding 去重）** `confidence: 推断` — 引用：`src/lib/dedup.ts`、`src/lib/dedup_embedding.ts`（文件存在；去重行为 → 推断）
- **路径安全校验存在（`isSafeIngestPath`）** `confidence: 推断` — 引用：`src/lib/ingest.ts :: isSafeIngestPath`（校验=行为性 → 推断；见 [[personas/security]]）

## 本章未解之谜
- `ingest.ts` 正文（数千行）未逐行精读：真实控制流、错误处理、各阶段衔接需精读/运行确认。
- 去重命中判定阈值、embedding 去重与文本去重的优先级（需运行）。
- 图像 caption 管线与 mineru PDF 解析的触发条件（需运行）。
