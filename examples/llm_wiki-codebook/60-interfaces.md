# 60 · 接口 / API（D7）

> **Confidence 图例**：`已确认` = 仅字面存在性、已 grep 核验，非语义/运行验证；`推断` = 未运行验证的判断；`未解之谜` = 需运行或未读到。

## 摘要
三类对外/对内接口：
1. **Tauri IPC 命令**：`lib.rs :: invoke_handler` 中字面列出的 `#[tauri::command]`（fs、project、search、vectorstore、claude_cli、codex_cli、extract_images、file_sync、proxy、close behavior 等）。前端用 `@tauri-apps/api/core :: invoke` 调用。
2. **本地 HTTP API**：`api_server.rs`，`tiny_http`，端口 `19828`，前缀 `/api/v1`。
3. **MCP server**：`mcp-server/src/index.ts`（Node），经上面的 HTTP API 访问 project，作为 MCP 工具暴露给外部 agent。

## 关键文件
| 文件 | 角色 | confidence |
|---|---|---|
| `src-tauri/src/lib.rs` :: `invoke_handler` | IPC 命令注册清单 | 已确认 |
| `src/commands/fs.ts` | 前端 IPC 封装（read/write/list…） | 推断 |
| `src-tauri/src/api_server.rs` :: `API_PREFIX` | HTTP API 前缀/端口/限流常量 | 已确认 |
| `mcp-server/src/index.ts` | MCP 工具入口 | 推断 |
| `mcp-server/src/api-client.ts` | MCP → 本地 HTTP API 客户端 | 推断 |
| `src-tauri/capabilities/default.json` | Tauri 权限能力清单 | 已确认 |

## 关键结论
- **IPC 命令集中在 `invoke_handler` 宏中字面列出** `confidence: 已确认（仅字面存在性）` — 引用：`src-tauri/src/lib.rs :: invoke_handler`（命令名如 `commands::fs::read_file`、`commands::vectorstore::vector_search` 字面存在；其运行期可达性 → 推断）
- **本地 HTTP API 前缀 `/api/v1`、端口 19828** `confidence: 已确认（仅字面存在性）` — 引用：`src-tauri/src/api_server.rs :: API_PREFIX`、`:: PORT`
- **MCP server 经 HTTP API 间接读 project** `confidence: 推断` — 引用：`mcp-server/src/api-client.ts`、`mcp-server/src/index.ts`（调用关系为行为性 → 推断）
- **Tauri 能力允许 http 访问任意 http/https（宽松）** `confidence: 已确认（仅字面存在性）` — 引用：`src-tauri/capabilities/default.json`（`{ "url": "http://**" }` 等字面存在；安全影响见 [[personas/security]] / [[95-risks]]）

## 本章未解之谜
- HTTP API 完整端点表、方法、鉴权（未精读 `api_server.rs` 路由分发；需运行）。
- MCP 工具的完整 schema 与权限边界（需精读 `index.ts` / 运行）。
