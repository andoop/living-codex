# 人设视角 · 安全 (security)

> **Confidence 图例**：`已确认` = 仅字面存在性、已 grep 核验，非语义/运行验证；`推断` = 未运行验证的判断；`未解之谜` = 需运行或未读到。
> **校验/鉴权/注入等均为行为性 → 最高推断；"是否真被利用"= 未解之谜。**

## 先读什么（入口路线）
[[60-interfaces]] 接口面 → [[80-config]] 配置与密钥 → [[95-risks]] 风险 → [[70-data-model]] 数据模型。

## 信任边界
- **前端 ↔ Rust**：Tauri IPC + 本地 HTTP（19828）。`confidence: 已确认（仅字面存在性）` — 引用：`api_server.rs :: PORT`
- **应用 ↔ 外部**：经 Rust fetch 出站到用户配置的 LLM/检索 endpoint；http 能力宽松（`http://**`/`https://**`）。`confidence: 已确认（仅字面存在性）` — 引用：`capabilities/default.json`
- **应用 ↔ 子进程**：spawn `claude`/`codex` CLI。`confidence: 推断` — 引用：`commands/claude_cli.rs`

## 输入校验点（行为性 → 推断）
- 摄取路径：`src/lib/ingest.ts :: isSafeIngestPath`（防路径穿越，有效性未验证）。
- 文件命令：`src-tauri/src/commands/fs.rs`（read/write/atomic/delete，路径来自前端）。
- API body 上限：`api_server.rs :: MAX_BODY_BYTES`、`MAX_FILE_CONTENT_BYTES`。`confidence: 已确认（仅字面存在性）`

## 密钥 / 凭证处理（只记键名/位置，不记原文）
- `LlmConfig.apiKey`（位置：`src/stores/wiki-store.ts`，持久化：`project-store.ts` → `app-state.json`）。**是否加密落盘 = 未解之谜**。
- 搜索 provider key（`SearchProviderOverride.apiKey`）。
- ✅ 本测绘**未发现硬编码密钥原文**（尽力而非保证）。

## 你最怕的（安全风险清单）
- **本地 API 无鉴权面**：19828 端口本机可达，鉴权机制 = 未解之谜（需精读路由）。`confidence: 未解之谜`
- **出站请求面过宽（SSRF/数据外发）**：`http://**` 能力 + 用户自定义 endpoint。`confidence: 推断`
- **密钥明文落盘风险**：持久化是否加密未确认。`confidence: 未解之谜`
- **子进程参数注入面**：CLI spawn 的参数/PATH 解析（`cli_resolver.rs`）。`confidence: 推断`
- **第三方解析库（PDF/Office）攻击面**：恶意文档触发 panic/RCE 面，靠 `run_guarded` 兜（覆盖范围 = 推断）。`confidence: 推断`

## 你（安全）不关心
构建优化、代码风格。
