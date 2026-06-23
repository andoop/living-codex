# 命令参考 · Commands

> **怎么触发**：这些是 **agent 内的命令**（不是 shell 命令）。装好 skill、重启 agent 后：
> - **Cursor / Claude Code / Kiro**：发 `narrate …`（或直接把"给这个项目做业务叙事 / 剥一条 XX 旅程"当普通消息发给 AI）。
> - **Codex CLI**：用 `$narrator`，再用自然语言说"narrate 当前项目 …"。
> - 安装：`curl -fsSL https://raw.githubusercontent.com/andoop/living-codex/main/install.sh | bash`

---

## Living Codex 做什么

把陌生代码库**按业务旅程**剥洋葱，读成一本读起来像**产品/交互文档**的业务导览书：

```
L0 产品全景 → L1 能力域 → L2 用户旅程 → L3 场景规则 → L4 机制 → L5 代码锚点
（由外到里、由浅到深，渐进式展开）
```

产物落目标项目 `docs/codebook/narrative/`，纯 Markdown、Obsidian 兼容（图谱/反链/搜索白捡）。

> **诚实承诺边界（务必理解）**：机械闸门（`ledger-orphans.sh` 三/四类 count-gate）**只证"可 grep 范围内枚举完整"**（文件/入口/连边/状态触发），**绝不等于"业务逻辑零遗漏/已验证正确"**。AUDIT 与 SIGN-OFF 同样**不认证业务正确**（无运行时 oracle）。产物是**尽力而为的业务导览草稿**：加速你理解 + 把你带到该读的代码 + **前置具名它没覆盖什么**（盲区子系统成章、orphan 透明、覆盖率冠"枚举"二字）。业务正确性仍需你对着代码锚点自行核实。详见 `skill/references/honesty-charter.md`。

---

## 命令清单

### `narrate [path]` — 业务叙事建书
入口驱动梳理全项目业务旅程，产出 L0–L5 业务导览书。

| 参数 | 说明 | 默认 |
|---|---|---|
| `[path]` | 测绘范围（可指子目录） | 当前项目根 |
| `--journey <名>` | **只剥一条指定业务旅程**（推荐先用它跑通再铺全量） | — |
| `--resume` | 从 `manifest.md` / 三账本断点续跑 | — |
| `--backend auto\|codegraph\|repomix\|none` | 可选解析器后端（见下） | auto（缺失自动降 none） |
| `--lang zh\|en\|...` | 产物语言 | 跟随当前对话 |

```text
narrate .                       # 对全项目梳理业务旅程（入口驱动）
narrate --journey 工程下载       # 只剥一条指定业务旅程 L0→L5（首次推荐）
narrate . --backend codegraph   # 叠加静态符号图，静态结构结论可升「已确认(解析器)」
```

> **重任务提示**：`narrate .` 会扇出多个只读子 agent、跑较久（前几十秒看不到产物是正常的）。**首次强烈建议 `--journey` 锁定一条旅程**，把流程跑通、看产物形态后再铺全量。

### 阶段集（`narrate` 内部如何工作）
```
BOOTSTRAP（.codebookignore + 文件级 manifest 真分母）
→ ENTRY-LEDGER（枚举入口 + 框架权威注册表）+ STATE-SEED（状态/横切触发器）
→ 多角色 TRACE（正常/数据状态/失败 三不同质角色独立追踪）
→ EDGE-LINK（异步/派发连边配对、标断裂边）
→ RECONCILE（调和者核分歧）→ SYNTHESIZE → PRESENT
→ AUDIT（独立子 agent）→ SIGN-OFF（ledger-orphans.sh exit 0 才算完成）
```

### `narrate --audit` — 独立监督审核
对**已建好的**业务导览书派**独立子 agent**（与写书的不同上下文）做头脑预演（覆盖/逻辑闭环）+ 红蓝对抗（18 向量：过度声明/编造引用/断裂边漏配/dispatcher 未展开/可达链不可复现/叙事过期/状态漏测/punt 占比…）。战报落 `docs/codebook/narrative/audit/`。
> `narrate` 默认已内含 AUDIT → SIGN-OFF；`--audit` 是把审核单独再跑一轮。**完成 = 过审 + `ledger-orphans.sh` exit 0，不是 AI 自称。**

### `narrate --lint [--since <git-ref>]` — 增量保鲜（advisory）
构建反向 file→journey 索引；`git diff` 命中的文件 → 标消费它证据的所有 journey/rule「⚠️ 待复核(可能过期)」，**不阻断任何流程**。无 git → 降首页快照声明。
> 诚实边界：`grep 命中符号 ≠ 叙事未过期`（符号在、语义可能已变），故只能标"待复核"，不标"已确认未过期"。

---

## 后端 `--backend`（可选增强，不是必需）

| 值 | 作用 | 对可信度的影响 |
|----|------|----------------|
| `none`（纯模式，默认可降级到此） | 纯 AI 读文件 | 连边/运行期结论**一律「推断」**；首页标"草稿" |
| `codegraph` | 借静态符号图 | **静态结构**结论可升「已确认(解析器)」；运行期仍「推断」 |
| `repomix` | 借 [repomix](https://repomix.com) 预打包上下文 | 加速/省 token，可信度档不变 |
| `auto` | 探测到就用，没有就降 `none` | 自适应 |

**核心永远零运行时、可移植**；后端缺失自动降级，结构不缺、承诺同步降级。

---

## 可信度三档（产物里随处可见）
- **已确认** = 被引符号在该文件**字面存在**（已 grep 核验）。**不**代表语义/行为/连边为真。
- **推断** = 未经运行验证的判断（一切"流程/调用/顺序/连边/触发/运行期"行为结论封顶到这）。
- **未解之谜** = 需运行 / 需更多上下文 / 没读到（须说明为何没查清、该读哪个文件）。

完整规则见 [honesty.md](honesty.md)。
