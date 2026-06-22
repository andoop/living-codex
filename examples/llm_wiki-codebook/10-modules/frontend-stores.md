# 10 · 模块 · 前端状态（Zustand stores）

> **Confidence 图例**：`已确认` = 仅字面存在性、已 grep 核验，非语义/运行验证；`推断` = 未运行验证的判断；`未解之谜` = 需运行或未读到。

## 摘要
前端全局状态用 **Zustand**（`create`）。`src/stores/` 下每个 store 负责一块：`wiki-store.ts`（当前 project、文件树、选中文件、活动视图、LLM 配置类型）、`chat-store.ts`（对话/消息/引用/图片）、`review-store.ts`、`lint-store.ts`、`research-store.ts`、`activity-store.ts`、`file-sync-store.ts`、`update-store.ts`、`zoom-store.ts`。`App.tsx` 在挂载时从持久化层（`project-store.ts` / `persist.ts`）加载配置与历史，注入这些 store。

## 关键文件
| 文件 | 角色 | confidence |
|---|---|---|
| `src/stores/wiki-store.ts` :: `LlmConfig` / `CustomApiMode` | 核心 project / LLM 配置状态 | 已确认 |
| `src/stores/chat-store.ts` :: `DisplayMessage` / `Conversation` | 对话与消息状态 | 推断 |
| `src/stores/review-store.ts` / `lint-store.ts` | review / lint 项状态 | 推断 |
| `src/stores/research-store.ts` | 深度研究状态 | 推断 |
| `src/stores/update-store.ts` | 更新检查/横幅状态 | 推断 |
| `src/App.tsx` | 挂载时编排各 store 初始化 | 推断 |
| `src/lib/project-store.ts` :: `loadLlmConfig` | tauri-plugin-store 持久化读写 | 推断 |

## 关键结论
- **状态层用 Zustand，每域一个 store** `confidence: 推断` — 引用：`src/stores/*.ts :: create`（`create` 来自 zustand 字面存在；"每域一个 store"为分组判断 → 推断）
- **LLM 配置类型集中在 `wiki-store.ts`** `confidence: 已确认（仅字面存在性）` — 引用：`src/stores/wiki-store.ts :: CustomApiMode`、`:: ReasoningConfig`（类型字面存在；其运行期取值 → 推断）
- **配置/历史经 `tauri-plugin-store` 持久化** `confidence: 推断` — 引用：`src/lib/project-store.ts :: getStore` / `loadLlmConfig`、`src/lib/persist.ts :: loadChatHistory`（读写为行为性 → 推断；apiKey 等敏感项见 [[personas/security]]）
- **`App.tsx` 在 mount 时拉起 auto-save 与 clip watcher** `confidence: 推断` — 引用：`src/App.tsx :: setupAutoSave` / `startClipWatcher`（`useEffect` 内调用为运行期行为 → 推断）

## 本章未解之谜
- 各 store 间的依赖与更新顺序（需运行）。
- 持久化的真实序列化/反序列化边界与迁移（需运行）。
- store 与 Rust IPC 的同步时机（需运行）。
