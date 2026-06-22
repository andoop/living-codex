# 90 · 历史 / 演进（D10）

> **Confidence 图例**：`已确认` = 仅字面存在性、已 grep 核验，非语义/运行验证；`推断` = 未运行验证的判断；`未解之谜` = 需运行或未读到。
> 本章结论涉及"演进/热点"→ **最高推断**。

## 摘要
TARGET 工作副本的 git 历史在本次测绘中**几乎不可用**：`git log --oneline` 只返回单条提交（`95175ae fix: prepare MCP resources before CI Rust builds`），疑似浅克隆/快照副本，无法据此判断热点目录或演进节奏。版本号 `0.4.25`（`package.json` / `Cargo.toml` / `tauri.conf.json` 三处一致）。代码内有 `changelog.ts`、`update-check.ts`、`about-section.tsx`，提示应用内置更新检查与变更日志机制。

## 关键文件
| 文件 | 角色 | confidence |
|---|---|---|
| `package.json` :: `"version": "0.4.25"` | 版本号 | 已确认 |
| `src/lib/changelog.ts` | 变更日志数据/渲染 | 推断 |
| `src/lib/update-check.ts` | 版本更新检查 | 推断 |
| `src/stores/update-store.ts` | 更新横幅状态 | 推断 |

## 关键结论
- **当前版本 0.4.25，三处 manifest 一致** `confidence: 已确认（仅字面存在性）` — 引用：`package.json`、`src-tauri/Cargo.toml`、`src-tauri/tauri.conf.json`（均含 `"version"`/`version`）
- **内置"检查更新 + changelog"能力** `confidence: 推断` — 引用：`src/lib/update-check.ts`、`src/lib/changelog.ts`（行为性 → 推断）
- **git 历史不足以做热点分析** `confidence: 已确认（事实：仅 1 条提交）** — 引用：`git log` 输出（命令事实，非源码语义）

## 本章未解之谜
- 真实演进史/热点文件：本副本 git 历史被截断，**无法测绘** → 需完整仓库历史。
- changelog 的版本节奏与重大重构点（需完整历史）。
