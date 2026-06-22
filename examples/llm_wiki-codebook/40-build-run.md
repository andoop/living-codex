# 40 · 构建与运行（D5）

> **Confidence 图例**：`已确认` = 仅字面存在性、已 grep 核验，非语义/运行验证；`推断` = 未运行验证的判断；`未解之谜` = 需运行或未读到。

## 摘要
前端构建用 Vite 8 + TypeScript（`npm run build` = `typecheck` + `vite build`）；桌面打包用 Tauri CLI（`npm run tauri`），`beforeBuildCommand = npm run build:desktop`（含 MCP server 构建）。CI 在 `.github/workflows/`（`ci.yml`、`build.yml`）。Rust 入口 `src-tauri/src/main.rs` → `lib.rs :: run`。

## 关键文件
| 文件 | 角色 | confidence |
|---|---|---|
| `package.json` :: `scripts` | dev/build/test/tauri 脚本 | 已确认 |
| `src-tauri/tauri.conf.json` | Tauri 构建/窗口/安全配置 | 已确认 |
| `vite.config.ts` | Vite 配置 | 推断 |
| `.github/workflows/ci.yml` / `build.yml` | CI / 发布构建 | 推断 |
| `src-tauri/build.rs` | Tauri build 脚本 | 推断 |

## 关键结论
- **dev 流程：`beforeDevCommand=npm run dev`，devUrl `http://localhost:1420`** `confidence: 已确认（仅字面存在性）` — 引用：`src-tauri/tauri.conf.json :: beforeDevCommand`、`:: "http://localhost:1420"`
- **构建脚本链：`build:desktop` → MCP 构建 + 前端 build** `confidence: 已确认（仅字面存在性）` — 引用：`package.json :: "build:desktop"`（脚本字符串存在；实际执行顺序 = 行为性 → 推断）
- **测试分 mocks 与 real-llm 两套** `confidence: 已确认（仅字面存在性）` — 引用：`package.json :: "test:mocks"`、`:: "test:llm"`（见 [[50-testing]]）
- **桌面前端产物输出到 `../dist`** `confidence: 已确认（仅字面存在性）` — 引用：`src-tauri/tauri.conf.json :: frontendDist`

## 本章未解之谜
- CI 实际矩阵/平台/签名流程（未精读 workflow 正文）。
- `build.rs`、pdfium 动态库的实际打包/定位（运行期；`lib.rs` 用 `resource_dir` 定位）。
