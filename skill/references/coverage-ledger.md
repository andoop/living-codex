# references/coverage-ledger.md — 业务覆盖账本（三账本）

> 落实 PRD FR4/§0.5。验证 TC5/TC9/TC11/TC16/TC18。
> 核心：**"不留任何细节"现实化为"orphan 清单透明 + 趋零"，而非声称零遗漏。**
> 诚实口径总则见 `honesty-charter.md`（机械闸门 vs AUDIT 能/不能对照表）。

落 `docs/codebook/narrative/coverage-ledger.md`（模板见 `templates/coverage-ledger.md`）。

---

## 三账本结构

| 账本 | 映射 | orphan 定义 | 分母来源 | 机械闸门 |
|---|---|---|---|---|
| **(a) code 覆盖** | 代码符号/分支 → 所属业务节点 | 未被认领的 in-scope 代码 = `code-orphan` | `.codebookignore` 后**全部 in-scope 文件**（独立 `find`） | `ledger-orphans.sh` clause (i) |
| **(b) entry 覆盖** | 框架注册表候选 → 是否枚举为旅程 | 未枚举的候选 = `entry-orphan` | FR1 框架权威注册表**独立派生** | clause (ii) |
| **(c) edge 覆盖** | 异步/派发 fire 端 → 对端 | 漏配对端 = `edge-orphan` | 可 grep 的跨进程/异步边界 | clause (iii) |

详见各自：`entry-ledger.md`、`edge-ledger.md`。

---

## 挂接方式 provenance（A5 + B1 机械化）

账本每条认领记录挂**挂接方式**列：

- **`traced`**：必须带**可机械回查的最短可达证据链**（入口符号 → … → 目标符号的 grep 命中序列）。
  - **回查不过 → 自动降 `heuristic`**。
  - AUDIT 对 traced 抽样**强制要求复现可达链**。
- **`heuristic`**：可见隔离、**不抵扣 orphan、不计入覆盖率分子**。

**「枚举覆盖率」分子只计 `traced`。**

### 可达链的诚实口径（mental-5 N2 · 防根因细粒度复发）

`backend=none` 下"可达链回查"至多证**相邻 hop 符号/引用的字面存在**，**不证运行时可达**。
→ **`traced` 在纯模式下仍属「推断」级连接**；命名（可达链 / traced / 计入覆盖率分子）**不得让读者误读为"已验证可达"**。§0.5 与首页须明写此口径。

---

## 分母全集（必须独立于追踪结果）

- **code 分母** = `.codebookignore` 后全部 in-scope 文件（文件级底线）。
- **承接 focused codebook 时，长尾未画像文件一律先记 orphan 候选，不得剔出分母**。
- **绝不**以"有 portrait 的文件/符号"当分母（那是缩小分母假装全覆盖）。

## 强制自推导机械闸门（A4 · 镜像 coverage-check.sh）

`scripts/ledger-orphans.sh` **必备且自推导**：
- 独立 `find` 套 `.codebookignore` 算 in-scope 全集；
- **账本分母 ≠ 独立 find 计数 → `exit≠0`**；
- **DONE 由脚本 exit 0 决定，非 AI 自称**；
- **脚本/grep 能力缺失 → "趋零/全覆盖"声明不可用，降级"分母未机械确认"**（镜像"无 grep 回查→已确认不可用"）。

## 机械核对粒度（诚实降级）

- 默认**文件级**。
- **符号/分支级 orphan 仅在解析器后端（codegraph）时升级为机械全量**；否则标"分支级 orphan = 人工抽样、非机械全量"。

---

## 诚实口径（§0.5 · 写入首页与覆盖率标题）

机械闸门**只证三件事，且不证其它**：
1. 文件枚举完整（每个 in-scope 文件被认领或显式 code-orphan）；
2. 入口根枚举完整（可 grep 注册表候选被枚举或显式排除）；
3. 连边登记完整（可 grep 异步/派发边配对端或标断裂边）。

机械闸门**绝不证、也绝不暗示**：业务细节已穷尽 / 因果链已验证 / L3 分支已覆盖 / traced 关系为真。

- **`exit 0` = "枚举与连边登记完整"，绝不 = "不留任何细节已达成"。**
- 产物首页与覆盖率标题必须写**"枚举覆盖率"**而非"业务覆盖率"。
- **术语并列释义（redteam-5 R1）**：「枚举覆盖率(分子只计 traced)」衡量 traced 连接质量，**与** `entry-orphan`(是否枚举完整) 是两个不同维度——"枚举覆盖率 70%" ≠ "30% 入口缺失"（被枚举但仅 heuristic 连接的入口不是 entry-orphan、却不计入分子）。**首页须并列两数并释义**，防误读。

## 趋零口径澄清（mental-2 N3）

"趋零"仅指**入口可达的业务代码**；非入口代码（纯算法/数据/工具）为**预期 orphan**，如实列出不算失败。**硬承诺是"透明"而非"清零"**——避免制造降 orphan 的反向压力（诱导把无可达链连边标 traced）。
