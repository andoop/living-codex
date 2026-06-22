# 人设视角 · SRE

> **Confidence 图例**：`已确认` = 仅字面存在性、已 grep 核验，非语义/运行验证；`推断` = 未运行验证的判断；`未解之谜` = 需运行或未读到。
> **重试/超时/降级/单点等均为行为性 → 最高推断。**

## 先读什么（入口路线）
[[40-build-run]] 构建/部署 → [[80-config]] 配置外部化 → [[90-history]] 演进热点 → [[95-risks]] 风险。

## 部署拓扑（推断）
单机桌面应用（Tauri），无服务端集群。"服务"实为应用内本地线程：API server、clip server 均在宿主进程内 `thread::spawn`。`confidence: 推断` — 引用：`api_server.rs :: start_api_server`（`thread::spawn`）、`clip_server.rs`

## 可观测性
- 日志：大量 `eprintln!("[proxy] ...")` / `[tray]` / `[clip]` 风格 stderr 打点。`confidence: 推断` — 引用：`src-tauri/src/lib.rs`（`eprintln!` 字面存在）
- 指标：未见结构化 metrics/埋点框架 → **未解之谜 / 缺失面**。

## 故障域与容错
- **API 端口冲突**：`api_server.rs` 有 `bind_server_with_retry` + `MAX_BIND_RETRIES` + 状态 `port_conflict`。`confidence: 已确认（仅字面存在性）` — 引用：`api_server.rs :: MAX_BIND_RETRIES`
- **panic 隔离**：命令边界 `run_guarded`，release `panic=unwind`，避免单文件损坏拖垮进程。`confidence: 推断`
- **限流**：`RATE_LIMIT_MAX_REQUESTS`、`MAX_IN_FLIGHT_REQUESTS` 常量存在；运行期是否真限流 = 推断。`confidence: 已确认（仅字面存在性）`

## 你最怕的（SRE 风险清单）
- **单进程单点**：所有"服务"在一个宿主进程内，崩溃即全停。`confidence: 推断`
- **外部 LLM/检索超时与重试**：流式请求的超时/重试/取消语义未验证（`codexCliTimeoutMinutes` 等）。`confidence: 未解之谜`
- **配置漂移**：用户态 `app-state.json` 与代码默认值漂移，跨机不可复现。`confidence: 推断`
- **缺监控埋点**：仅 stderr 文本日志，无指标聚合。`confidence: 推断`

## 你（SRE）不关心
API 设计美学、新人术语表。
