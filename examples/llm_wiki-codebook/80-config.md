# 80 · 配置（D9）

> **Confidence 图例**：`已确认` = 仅字面存在性、已 grep 核验，非语义/运行验证；`推断` = 未运行验证的判断；`未解之谜` = 需运行或未读到。
> **密钥/PII 红线**：本章只记键名/位置/用途，**不记原文**。

## 摘要
配置分两类：**应用配置**（用户在 Settings 里设的 LLM/embedding/搜索/代理/多模态/网络等，经 `tauri-plugin-store` 持久化到 `app-state.json`）与**构建/平台配置**（`tauri.conf.json` + 各平台覆盖、`vite.config.ts`、`tsconfig*.json`、`components.json`）。代理通过环境变量 `HTTP_PROXY`/`HTTPS_PROXY`/`NO_PROXY` 应用（`proxy.rs`）。

## 关键文件
| 文件 | 角色 | confidence |
|---|---|---|
| `src/lib/project-store.ts` :: `loadLlmConfig` | 应用配置读写（plugin-store） | 推断 |
| `src/components/settings/settings-types.ts` | 设置项类型 | 推断 |
| `src-tauri/src/proxy.rs` :: `apply_proxy_env` | 代理 env 应用 | 推断 |
| `src-tauri/tauri.conf.json` / `tauri.{macos,linux,windows}.conf.json` | 平台配置 | 已确认 |
| `src/lib/source-watch-defaults.json` | 源监听默认值 | 推断 |

## 关键结论
- **应用状态持久化文件名为 `app-state.json`（app_data_dir）** `confidence: 已确认（仅字面存在性）` — 引用：`src-tauri/src/lib.rs :: "app-state.json"`（字符串存在；实际读写时机 → 推断）
- **代理经环境变量在首个 HTTP 请求前应用** `confidence: 推断` — 引用：`src-tauri/src/proxy.rs :: apply_proxy_env`、`src-tauri/src/lib.rs :: set_proxy_env`（顺序/生效为运行期 → 推断）
- **存在按平台拆分的 Tauri 配置覆盖** `confidence: 已确认（仅字面存在性）` — 引用：`src-tauri/tauri.macos.conf.json` 等文件存在

## 敏感项（只记键名/位置/用途，禁原文）
- `apiKey`（位置：`src/stores/wiki-store.ts :: LlmConfig.apiKey`，经 `project-store.ts` 持久化；用途：LLM 供应商鉴权）`confidence: 已确认（仅字面存在性，键名）`
- 各搜索 provider `apiKey`（位置：`SearchProviderOverride`，`web-search.ts` / settings；用途：web 检索鉴权）
- 代理凭证（位置：`proxy.rs` ProxyConfig；用途：出站代理）
- ⚠️ **本测绘未发现仓库内硬编码密钥原文**（仅见键名/类型字段）；零运行时下此为尽力而非保证。

## 本章未解之谜
- `app-state.json` 完整字段与默认值（需运行/读用户态文件，且不应读真实用户文件）。
- 密钥在持久化时是否加密（需运行 / 见 [[95-risks]]）。
