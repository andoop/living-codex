# 命令参考 · Commands

> 在 Cursor / Claude Code / Kiro 用 `/codex …` 斜杠命令（或把命令当普通消息发给 AI）；Codex 用 `$cartographer`。命令是薄入口，加载 `skill/` 方法论。

## `codex map [path]`
测绘建书 / 增量整合。
| 参数 | 说明 | 默认 |
|---|---|---|
| `--depth L1\|L2\|L3\|L4` | 测绘深度（L1 架构→L4 逐函数） | L1 + 关键模块 L2 |
| `--personas a,b,...` | 人设视角 | architect,newgrad,security,sre |
| `--max-agents N` | 并发上限（自适应、可降级） | 宿主上限 |
| `--lang zh\|en\|...` | 产物语言 | 跟随对话 |
| `--backend auto\|codegraph\|repomix\|none` | 可选解析器后端 | auto（缺失降 none） |
| `--resume` | 从 survey-state 续跑 | — |

## `codex ask "<question>"`
只读问答，答案带 confidence 引用（`已确认/推断/未解之谜`）。

## `codex review`
二次自审：确定性核查（被引符号/文件存在、失效 wikilink、孤儿）+ 对「已确认」强制 grep 回查。**绝不打"已验证"标签**；矛盾仅 advisory。

## `codex lint [--since <git-ref>]`
增量保鲜（advisory，不阻断）：被引文件变更 / 失效 wikilink / 孤儿提示。无哈希能力时按 git diff 文件名重测相关章节。

## `codex onboard [--persona p] [--horizon day1|week1]`
按依赖序产出"该读哪些章节与文件"的有序上手路线。

> 没有 `codex check`（PR 硬门禁）——刻意不做：LLM 判定不可复现，不应阻断合并。见 [honesty.md](honesty.md)。
