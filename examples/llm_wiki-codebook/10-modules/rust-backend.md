# 10 · 模块 · Rust / Tauri 后端（L2）

> **Confidence 图例**：`已确认` = 仅字面存在性、已 grep 核验，非语义/运行验证；`推断` = 未运行验证的判断；`未解之谜` = 需运行或未读到。

## 摘要
Rust 侧（`src-tauri/src/`）是 Tauri 2 宿主：`lib.rs` 注册插件、命令、托盘与窗口关闭行为；`commands/` 下按领域拆分命令模块；`api_server.rs` 起一个本地 `tiny_http` HTTP 服务；`clip_server.rs`、`proxy.rs`、`panic_guard.rs`、`tray.rs` 为辅助。命令几乎都包裹在 `panic_guard::run_guarded`，把第三方解析库 panic 转成错误（`Cargo.toml` 注明 `panic = "unwind"`）。

## 关键文件
| 文件 | 角色 | confidence |
|---|---|---|
| `src-tauri/src/lib.rs` :: `pub fn run` | 入口：插件/命令/setup/窗口事件 | 已确认 |
| `src-tauri/src/commands/fs.rs` | 文件系统命令（读写/原子写/列目录/预处理/md5…） | 推断 |
| `src-tauri/src/commands/vectorstore.rs` :: `ChunkSearchResult` | LanceDB 向量库 upsert/search/optimize | 已确认 |
| `src-tauri/src/commands/search.rs` :: `tokenize_query` | 项目内全文检索（分词/片段/标题抽取） | 已确认 |
| `src-tauri/src/commands/claude_cli.rs` / `codex_cli.rs` | 把 `claude` / `codex` CLI 作为子进程，流式回传 | 推断 |
| `src-tauri/src/commands/file_sync.rs` | 项目文件监听（notify）+ 变更队列 | 推断 |
| `src-tauri/src/commands/extract_images.rs` | PDF/Office 图片抽取（pdfium-render） | 推断 |
| `src-tauri/src/api_server.rs` :: `API_PREFIX` | 本地 HTTP API（端口 19828，`/api/v1`） | 已确认 |
| `src-tauri/src/panic_guard.rs` :: `run_guarded` | 命令边界 panic 捕获 | 推断 |
| `src-tauri/src/proxy.rs` | HTTP 代理 env 应用 | 推断 |

## 关键结论
- **向量库后端是 LanceDB，按 page / chunk 两套结构（v1 legacy + v2 chunk）** `confidence: 已确认（仅字面存在性）` — 引用：`src-tauri/src/commands/vectorstore.rs :: ChunkSearchResult`、`:: VectorSearchResult`（结构体字面存在；其实际读写/迁移行为 → 推断）
- **向量库物理路径为 `<project>/.llm-wiki/lancedb`** `confidence: 推断` — 引用：`src-tauri/src/commands/vectorstore.rs :: db_path`（字符串模板存在，但「运行期实际写到该路径」需运行 → 推断）
- **本地 API server 设了速率限制/在途上限等常量** `confidence: 已确认（仅字面存在性）` — 引用：`src-tauri/src/api_server.rs`（`RATE_LIMIT_MAX_REQUESTS`、`MAX_IN_FLIGHT_REQUESTS` 字面存在；其运行期是否真正限流 = 行为性 → 推断）
- **命令通过 `run_guarded` 捕获 panic 转错误** `confidence: 推断` — 引用：`src-tauri/src/panic_guard.rs :: run_guarded`、`Cargo.toml :: panic = "unwind"`（包裹与捕获是行为性 → 推断）
- **CLI provider（claude/codex）以子进程方式桥接** `confidence: 推断` — 引用：`src-tauri/src/commands/claude_cli.rs`、`Cargo.toml :: tokio ... features ["process"]`（spawn/流式为运行期行为 → 推断）

## 本章未解之谜
- `api_server` 路由表与各端点鉴权/CORS 的运行期真实行为（需运行；见 [[95-risks]]）。
- 向量库 v1→v2 迁移、`optimize`/compaction 的实际触发时机（需运行）。
- 子进程 CLI 的取消/超时语义（`codexCliTimeoutMinutes`）实际生效路径（需运行）。
