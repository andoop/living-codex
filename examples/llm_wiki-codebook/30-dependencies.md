# 30 · 依赖（D4）

> **Confidence 图例**：`已确认` = 仅字面存在性、已 grep 核验，非语义/运行验证；`推断` = 未运行验证的判断；`未解之谜` = 需运行或未读到。
> 依赖**字面存在**（manifest 内）可标已确认；其"如何被使用/版本运行期行为"→ 推断。

## 摘要
前端（`package.json`）：React 19、Zustand 5、i18next、Milkdown（编辑器）、Sigma + graphology（图）、Mermaid、KaTeX、react-markdown/remark/rehype、Tauri JS 插件（http/store/dialog/opener/autostart）。后端（`Cargo.toml`）：Tauri 2、reqwest（rustls）、tiny_http、lancedb + arrow、pdfium-render、calamine/docx-rs/office_oxide（Office 解析）、tokio、notify、walkdir、sha2/md-5、uuid。

## 关键文件
| 文件 | 角色 | confidence |
|---|---|---|
| `package.json` | 前端依赖与脚本 | 已确认 |
| `src-tauri/Cargo.toml` | Rust 依赖与 release profile | 已确认 |
| `mcp-server/package.json` | MCP server 依赖 | 推断 |

## 关键结论
- **前端图谱栈 = graphology + sigma + @react-sigma/core** `confidence: 已确认（仅字面存在性）` — 引用：`package.json`（`"sigma"`、`"graphology"`、`"graphology-communities-louvain"` 字面存在；运行期用法 → 推断）
- **后端向量库 = lancedb + arrow-array/arrow-schema** `confidence: 已确认（仅字面存在性）` — 引用：`src-tauri/Cargo.toml`（`lancedb = "0.27.2"`、`arrow-array = "57"` 字面存在）
- **PDF/Office 解析 = pdfium-render + calamine + docx-rs + office_oxide** `confidence: 已确认（仅字面存在性）` — 引用：`src-tauri/Cargo.toml`（依赖字面存在；解析行为 → 推断）
- **release profile 用 `lto`、`panic = "unwind"`、`strip`** `confidence: 已确认（仅字面存在性）` — 引用：`src-tauri/Cargo.toml :: [profile.release]`
- **React 19 + Zustand 5 + i18next 国际化** `confidence: 已确认（仅字面存在性）` — 引用：`package.json`（`"react": "^19.0.0"`、`"zustand"`、`"i18next"`）

## 本章未解之谜
- 各依赖的实际调用面与是否有未用依赖（需运行/构建分析）。
- `package-lock.json` / `Cargo.lock` 锁定版本与 manifest range 的差异（未逐一核对）。
