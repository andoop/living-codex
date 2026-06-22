# 10 · 模块 · LLM Provider / 流式传输层（L2）

> **Confidence 图例**：`已确认` = 仅字面存在性、已 grep 核验，非语义/运行验证；`推断` = 未运行验证的判断；`未解之谜` = 需运行或未读到。

## 摘要
该 territory 把多家 LLM 供应商抽象成统一的流式接口。`llm-client.ts` 暴露 `streamChat`，按 `config.provider` 分派到不同传输：HTTP（经 `tauri-fetch.ts` 的 Rust 后端 fetch）或子进程 CLI（`claude-cli-transport.ts` / `codex-cli-transport.ts`）。`llm-providers.ts`（约 38KB）持有各 provider 的协议适配（OpenAI chat、Anthropic messages、Azure、Ollama、MiniMax、custom 等）。配套：`endpoint-normalizer.ts`、`azure-openai.ts`、`reasoning-detector.ts`、`api-token.ts`、`has-usable-llm.ts`、`connection-tests.ts`。

## 关键文件
| 文件 | 角色 | confidence |
|---|---|---|
| `src/lib/llm-client.ts` :: `streamChat` | 统一流式聊天入口 + provider 分派 | 已确认 |
| `src/lib/llm-providers.ts` :: `getProviderConfig` | 各 provider 协议/请求构造 | 推断 |
| `src/lib/tauri-fetch.ts` :: `getHttpFetch` | 经 Rust 的 HTTP fetch（绕过 webview CORS） | 推断 |
| `src/lib/claude-cli-transport.ts` :: `streamClaudeCodeCli` | Claude Code CLI 子进程流 | 推断 |
| `src/lib/codex-cli-transport.ts` :: `streamCodexCli` | Codex CLI 子进程流 | 推断 |
| `src/stores/wiki-store.ts` :: `CustomApiMode` / `LlmConfig` | provider/模型/密钥等配置类型 | 已确认 |
| `src/lib/reasoning-detector.ts` | 推理 token 检测/抽取 | 推断 |

## 关键结论
- **统一流式入口 `streamChat`，按 provider 运行期分派** `confidence: 已确认（仅字面存在性）` — 引用：`src/lib/llm-client.ts :: export async function streamChat`（脚本回查命中；"按 provider 分派/调用哪个 transport" = 行为性 → 推断）
- **支持的 provider 取值在 `LlmConfig.provider` 联合类型中字面列出** `confidence: 已确认（仅字面存在性）` — 引用：`src/stores/wiki-store.ts :: CustomApiMode`（同文件 `LlmConfig` provider 联合含 openai/anthropic/google/azure/ollama/custom/minimax/claude-code/codex-cli；其运行期可用性 → 推断）
- **HTTP 请求走 Rust 后端 fetch 而非 webview（规避第三方 CORS）** `confidence: 推断` — 引用：`src/lib/tauri-fetch.ts :: getHttpFetch`、`src-tauri/src/lib.rs`（注释提及；实际出站路径为运行期 → 推断）
- **CLI provider 通过动态 import 懒加载子进程 transport** `confidence: 推断` — 引用：`src/lib/llm-client.ts :: streamViaClaudeCodeCli` / `streamViaCodexCli`（`await import(...)` 字面存在；懒加载触发为运行期 → 推断）

## 本章未解之谜
- 各 provider 的流式解析差异（SSE vs 行协议）与错误重试策略（需运行）。
- `reasoning` 模式（off/low/.../max/custom）在不同 provider 的真实映射（需运行）。
- 取消（AbortSignal）在 HTTP 与子进程两条路径的真实语义（需运行）。
