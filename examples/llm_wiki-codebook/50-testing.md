# 50 · 测试（D6）

> **Confidence 图例**：`已确认` = 仅字面存在性、已 grep 核验，非语义/运行验证；`推断` = 未运行验证的判断；`未解之谜` = 需运行或未读到。

## 摘要
测试框架是 **Vitest 4**，外加 **fast-check** 做属性测试。测试与源码同目录（`*.test.ts` / `*.property.test.ts` / `*.integration.test.ts` / `*.scenarios.test.ts` / `*.race.test.ts` / `*.real-llm.test.ts`）。`src/lib/` 内测试文件密度很高（数十个）。`real-llm` 套件需真实 LLM（`test:llm`，`--no-file-parallelism`），mocks 套件排除它（`test:mocks`）。`src/test-helpers/` 提供 fixtures、mock stream、临时 fs、测试环境加载。

## 关键文件
| 文件 | 角色 | confidence |
|---|---|---|
| `package.json` :: `test:mocks` / `test:llm` | 两套测试入口 | 已确认 |
| `src/test-helpers/mock-stream-chat.ts` | mock 流式聊天 | 推断 |
| `src/test-helpers/fs-temp.ts` / `load-test-env.ts` | 临时 fs / 环境加载 | 推断 |
| `src/lib/*.property.test.ts` | fast-check 属性测试 | 推断 |
| `src/i18n/i18n-parity.test.ts` | 多语言键一致性 | 推断 |
| `mcp-server/test/*.test.ts` | MCP server 测试 | 推断 |

## 关键结论
- **测试用 Vitest，real-llm 与 mock 套件分离** `confidence: 已确认（仅字面存在性）` — 引用：`package.json :: "test:mocks"`、`:: "test:llm"`、`devDependencies :: "vitest"`
- **存在属性测试（fast-check）** `confidence: 已确认（仅字面存在性）` — 引用：`package.json :: "fast-check"`、文件如 `src/lib/path-utils.property.test.ts`
- **有并发/竞态测试（如 sweep-reviews.race.test.ts）** `confidence: 推断` — 引用：`src/lib/sweep-reviews.race.test.ts`（文件存在；其覆盖的并发行为 → 推断）
- **i18n 键一致性有专门测试** `confidence: 已确认（仅字面存在性）` — 引用：`src/i18n/i18n-parity.test.ts`

## 本章未解之谜
- 实际测试覆盖率、通过率（需运行 `npm test`）。
- `real-llm` 套件依赖的真实凭证/网络（需运行；见 [[95-risks]]）。
- 本测绘**未运行任何测试**（只读 TARGET，且禁改/禁跑其源码行为验证）。
