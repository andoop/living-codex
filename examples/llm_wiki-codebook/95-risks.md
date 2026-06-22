# 95 · 风险（D11）

> **Confidence 图例**：`已确认` = 仅字面存在性、已 grep 核验，非语义/运行验证；`推断` = 未运行验证的判断；`未解之谜` = 需运行或未读到。
> 风险均为**潜在面**，非"已发生漏洞"判定；任何"是否真被利用/真触发"= 推断或未解之谜。

## 摘要
本测绘未做安全审计，仅从静态结构标注**值得关注的面**：本地 HTTP API（端口 19828）、宽松的 Tauri http 能力、密钥本地持久化、子进程 CLI 桥接、第三方解析库（PDF/Office）panic 面。代码里**未见 TODO/FIXME/HACK**（`src/lib` + `src-tauri/src` 计数为 0），不代表无技术债，仅代表未用这些标记。

## 关键结论（风险面）
- **本地 HTTP API 默认监听 19828 + 限流常量** `confidence: 已确认（仅字面存在性）` — 引用：`src-tauri/src/api_server.rs :: PORT` / `RATE_LIMIT_MAX_REQUESTS`。**风险**：本机其它进程可访问该 API；是否有鉴权 = **未解之谜（需精读路由 / 运行）**。
- **Tauri http 能力允许任意 http/https URL** `confidence: 已确认（仅字面存在性）` — 引用：`src-tauri/capabilities/default.json :: "http://**"`。**风险（推断）**：出站请求面宽，配合用户配置 endpoint 存在 SSRF/数据外发面。
- **LLM/搜索 apiKey 本地持久化** `confidence: 推断` — 引用：`src/lib/project-store.ts`、`LlmConfig.apiKey`。**风险（推断）**：是否明文存储于 `app-state.json` 未确认 → [[99-未解之谜]]。
- **子进程 CLI 桥接（claude/codex）** `confidence: 推断` — 引用：`src-tauri/src/commands/claude_cli.rs`、`cli_resolver.rs`。**风险（推断）**：PATH 解析 / 参数注入面，需审 spawn 参数构造。
- **第三方解析库 panic 面，靠 `panic=unwind` + `run_guarded` 兜** `confidence: 推断` — 引用：`Cargo.toml :: panic = "unwind"`、`panic_guard.rs :: run_guarded`（兜底是否覆盖全部命令 = 行为性 → 推断）
- **路径安全校验存在但有效性未验证** `confidence: 推断` — 引用：`src/lib/ingest.ts :: isSafeIngestPath`、`src-tauri/src/commands/fs.rs`（路径穿越防护需运行验证）

## 本章未解之谜
- 本地 API / MCP 是否鉴权、绑定地址（127.0.0.1 vs 0.0.0.0）（需精读 `api_server.rs` 路由 / 运行）。
- 密钥是否加密落盘（需运行）。
- 文件命令的路径穿越防护是否完备（需运行 + 精读 `fs.rs`）。
