# 业务覆盖账本 · {{项目}}（三账本）

> 见 `references/coverage-ledger.md` / `references/honesty-charter.md`。
> 覆盖率冠**"枚举"**二字；分母经 `scripts/ledger-orphans.sh` 自推导机械核对（exit 0）或显式标"分母未机械确认"。
> **「枚举覆盖率」分子只计 `traced`**；`heuristic` 可见隔离、不抵扣 orphan、不计入分子。
> 诚实口径：`backend=none` 下 `traced` 仍属「推断」级连接（可达链只证相邻 hop 字面存在，不证运行时可达）。

机械核对粒度：**{{文件级（默认）| 符号/分支级（仅 codegraph）}}**。

---

## (a) code 覆盖账本
分母 = `.codebookignore` 后全部 in-scope 文件（独立 `find`，**长尾未画像文件先记 orphan 候选、不剔出分母**）。

| 代码符号/分支 | 所属业务节点 | 挂接方式 | 可达链（traced 必填） |
|---|---|---|---|
| `{{文件}} :: {{符号}}` | [[journeys/{{j}}]] | traced | `{{入口符号}}→{{hop}}→{{目标符号}}`（grep 命中序列） |
| `{{文件}} :: {{符号}}` | [[journeys/{{j}}]] | heuristic | — （不计入覆盖率分子） |

**code-orphan（未认领的 in-scope 文件，显式列出）**：
- `{{文件}}`〔预期 orphan：非入口纯算法/数据〕 / `{{文件}}`〔待认领〕

code 枚举覆盖率 = traced 认领文件数 / 独立 find 分母 = **{{%}}**

## (b) entry 覆盖账本
见 [[entry-ledger]]。entry 枚举(traced/派生候选) = **{{n/m}}**；`entry-orphan`：{{未枚举候选清单}}。

## (c) edge 覆盖账本
见 [[edge-ledger]]。fire 端配对率 = **{{n/m}}**；`edge-orphan`（断裂边）：{{清单}}。

---

## 盲区非对称声明（不可删）
- 入口分母 / 连边分母 / 状态轴**均无机械底线**——只覆盖可 grep 部分；不可 grep 的 DI/反射/自定义总线/未知框架 = 承认盲区，可能三账本同时失明。
- {{若脚本/grep 缺失}}：⚠️ **分母未机械确认**——"趋零/全覆盖"声明不可用。
