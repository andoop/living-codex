# 人设视角 · 新人 (newgrad)

> **Confidence 图例**：`已确认` = 仅字面存在性、已 grep 核验，非语义/运行验证；`推断` = 未运行验证的判断；`未解之谜` = 需运行或未读到。

## 先读什么（入口路线 / onboarding 依赖序）
[[40-build-run]] 先把它跑起来 → [[10-modules/frontend-stores]] 看状态怎么流 → [[50-testing]] 学会怎么验证你的改动。

## 最小上手闭环
1. **跑起来**：`npm run dev`（Vite，devUrl `http://localhost:1420`），或 `npm run tauri dev` 起桌面壳。`confidence: 已确认（仅字面存在性）` — 引用：`package.json :: "dev"`、`tauri.conf.json :: beforeDevCommand`
2. **改一个小东西**：UI 文案在 `src/i18n/en.json` / `zh.json`（改完跑 `i18n-parity.test.ts` 确认键齐）。`confidence: 推断`
3. **验证**：`npm run test:mocks`（不需要真实 LLM）。`confidence: 已确认（仅字面存在性）` — 引用：`package.json :: "test:mocks"`

## 术语速记（concepts）
- **ingest（摄取）**：把一份原始资料经 LLM 编译进 wiki。
- **wiki 页**：带 frontmatter 的 Markdown，Obsidian 兼容。
- **provider**：一个 LLM 供应商（openai/anthropic/ollama/claude-code/codex-cli…）。
- **store**：Zustand 全局状态片。

## 你最怕的（新人风险清单）
- **环境坑**：桌面构建链 `build:desktop` 会先构建 MCP server（Node），少装一步就失败。`confidence: 推断` — 引用：`package.json :: "build:desktop"`
- **祖传巨石**：`ingest.ts` 太大，别想一次读完；从导出函数签名切入。`confidence: 推断`
- **两套测试**：`test:llm` 需要真实 LLM 凭证，本地一般只跑 `test:mocks`。`confidence: 已确认（仅字面存在性）`
- **隐式约定**：wiki 文件名/路径有规则（`wiki-filename.ts`），手改容易踩。`confidence: 推断`

## 你（新人）暂时不用看
全局架构权衡、SRE 容量规划 → 见 [[personas/architect]] / [[personas/sre]]。
