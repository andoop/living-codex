# 命令参考 · Commands

> **怎么触发**：这些 `codex …` 是 **agent 内的命令**（不是 shell 命令）。装好 skill、重启 agent 后：
> - **Cursor / Claude Code / Kiro**：发 `/codex map …`（或直接把 `codex map …` 当普通消息发给 AI）。
> - **Codex CLI**：用 `$cartographer`，再用自然语言说"map 当前项目 …"。
> - 安装：`curl -fsSL https://raw.githubusercontent.com/andoop/living-codex/main/install.sh | bash`

---

## 深度分层 `--depth L1|L2|L3|L4`（最常调的参数，务必理解）

深度决定"读多细"。**越深越准、越贵、越慢**。可对不同 territory 用不同深度（默认全局 L1 + 关键模块 L2）。

| 层 | 读什么 | 产出粒度 | 成本 | 适用 |
|----|--------|----------|------|------|
| **L1 · 全局架构** | 只读：目录结构、入口文件、构建配置、README、依赖清单、各模块**导出符号清单**（不读实现） | 一张架构图 + 模块地图 + 各模块一段"它是干嘛的" | 最低 | 第一眼看懂"这项目由哪些块组成、怎么搭起来的" |
| **L2 · 模块** | 在 L1 基础上，读关键模块的**公开接口 + 关键函数签名 + 主流程骨架**（精读入口与导出，不逐行读全部实现） | 每个关键 territory 一章：职责、关键文件、对外接口、与邻居的边 | 中 | **默认推荐**。够你上手、改得动一般功能 |
| **L3 · 关键路径深挖** | 顺着一条重要链路（如"一次下单/一次鉴权"）**逐函数追**调用链、数据流、状态变化 | 关键流程的端到端剖析 + 时序/数据流图 | 高 | 要改/排查某条核心流程时，对**少数**关键路径开 |
| **L4 · 逐文件逐函数** | 几乎逐行读指定 territory | 接近"逐函数注释级"的详尽章节 | 最高（大库不现实） | 只对**很小且极关键**的模块（如核心算法/安全边界）开 |

**用法举例**
```text
codex map .                                  # 默认：全局 L1 + 自动挑关键模块做 L2
codex map . --depth L1                        # 只要全局架构鸟瞰（最快最便宜）
codex map . --depth L2                        # 全部 territory 做到模块级
codex map src/payment --depth L3              # 只对 payment 子树深挖关键路径
codex map src/crypto --depth L4               # 对小而关键的 crypto 模块逐函数
```
> **成本护栏**：默认浅档 + 深挖 opt-in；每 territory 有 token 预算，超了就降级"摘要级"并在该章显著标 **⚠️ 部分测绘**、把没读的塞进 `99-未解之谜`——**绝不假装读全了**。

---

## 人设视角 `--personas a,b,...`

为不同角色生成**针对性解读章节**（落在 `docs/codebook/personas/`）。同一份代码，不同人关心的入口和风险不同。默认 4 个：

| persona | 它先带你看什么 | 关注的风险 | 推荐入口章节 |
|---------|----------------|------------|--------------|
| **architect** 架构师 | 整体分层、模块边界、关键依赖与耦合、技术选型 | 循环依赖、跨层泄漏、单点、扩展性 | 架构总览 / 模块地图 / 依赖 |
| **newgrad** 新人 | "从哪跑起来"、最小心智模型、按依赖序的上手路线 | 环境搭建坑、隐藏约定、看不懂的黑话 | 总览 / 构建运行 / onboarding 路线 |
| **security** 安全 | 输入入口、鉴权/授权、密钥与配置、外部调用面 | 注入面、鉴权遗漏、密钥处理、越权 | 接口/API / 配置 / 风险 |
| **sre** 运维 | 启动/部署、配置、外部依赖、失败模式、可观测性 | 启动依赖、超时/重试、资源、降级路径 | 构建运行 / 配置 / 数据流 |

**用法举例**
```text
codex map . --personas architect,newgrad             # 只要这两个视角
codex map . --personas security                       # 安全审计视角单独出
codex map . --personas architect,newgrad,security,sre # 默认全套
```
> 自定义人设：直接写名字（如 `--personas frontend,dba,ml`），skill 会按"该角色最先看什么 + 关注什么风险"自适应生成。人设之间**内容必须不同质**（不是换标题），这是设计要求。

---

## 命令清单

### `codex map [path]` — 测绘建书 / 增量整合
| 参数 | 说明 | 默认 |
|---|---|---|
| `[path]` | 测绘范围（可指子目录） | 当前项目根 |
| `--depth L1\|L2\|L3\|L4` | 见上「深度分层」 | L1 + 关键模块 L2 |
| `--personas a,b,...` | 见上「人设视角」 | architect,newgrad,security,sre |
| `--max-agents N` | 并发只读子 agent 上限（自适应、可降级到串行） | 宿主上限（通常 ≈4–5） |
| `--lang zh\|en\|...` | 产物语言 | 跟随当前对话 |
| `--backend auto\|codegraph\|repomix\|none` | 可选解析器后端（见下） | auto（缺失自动降 none） |
| `--resume` | 从 `survey-state.md` 断点续跑 | — |

### `codex ask "<question>"` — 只读问答
基于已建的 codebook 回答，**带可信度引用**（`已确认/推断/未解之谜` + `文件::符号`）。例：`codex ask "鉴权在哪做的？"`

### `codex review` — 二次自审
确定性核查：被引符号/文件是否存在、失效 `[[wikilink]]`、孤儿页；对每条「已确认」**强制跑 grep 回查**。**绝不打"已验证"标签**；发现章节间矛盾只标 advisory、不擅自改写。

### `codex lint [--since <git-ref>]` — 增量保鲜（advisory）
被引文件变更 / 失效 wikilink / 孤儿提示，**不阻断任何流程**。无哈希能力时按 `git diff` 文件名重测相关章节。例：`codex lint --since HEAD~20`

### `codex onboard [--persona p] [--horizon day1|week1]` — 上手路线
按依赖拓扑给"第 1 天 / 第 1 周该读哪些章节与文件"的有序清单。

> **刻意没有 `codex check`（PR 硬门禁）**：LLM 判定不可复现，放到"必须可复现"的合并关卡上是范畴错配，会误报阻断正常合并。见 [honesty.md](honesty.md)。

---

## 后端 `--backend`（可选增强，不是必需）

| 值 | 作用 | 对可信度的影响 |
|----|------|----------------|
| `none`（纯模式，默认可降级到此） | 纯 AI 读文件 | 跨边/运行期结论**一律「推断」**；书首页标"最佳努力草稿" |
| `codegraph` | 借 [CodeGraph](https://github.com/colbymchenry/codegraph) 的静态符号图 | **静态结构**结论可升「已确认(解析器)」；运行期仍「推断」 |
| `repomix` | 借 [repomix](https://repomix.com) 预打包上下文 | 加速/省 token，可信度档不变 |
| `auto` | 探测到就用，没有就降 `none` | 自适应 |

**核心永远零运行时、可移植**；后端缺失自动降级，结构不缺、承诺同步降级。

---

## 可信度三档（产物里随处可见）
- **已确认** = 被引符号在该文件**字面存在**（已 grep 核验）。**不**代表语义/行为为真。
- **推断** = 未经运行验证的判断（一切"调用/顺序/触发/运行期"行为结论封顶到这）。
- **未解之谜** = 需运行 / 需更多上下文 / 没读到。

完整规则见 [honesty.md](honesty.md)。
