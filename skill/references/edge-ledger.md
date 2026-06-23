# references/edge-ledger.md — 跨流程连边账本（FR10 · 第三类一等概念）

> 落实 PRD FR10（B4 头条修复）。验证 TC19。
> 业务旅程 = **节点 + 边**。被劈开的 Worker 文件本身是入口、永不 code-orphan——**缺的是边，故边必须独立成账**（修复 N1 范畴错误）。
> 边的**因果方向/时序一律「推断」**（连通性靠 grep 字面成对，语义靠推断）。

落 `docs/codebook/narrative/edge-ledger.md`（模板见 `templates/edge-ledger.md`）。

---

## 登记哪些边（可 grep 的异步/派发边界）

| fire / 源端 | 对端 / receive |
|---|---|
| `enqueue`（队列 / WorkManager / JobService） | `dequeue` / Worker.doWork |
| `publish`（EventBus / RxBus） | `@Subscribe` / 订阅者 |
| intent-fire（`startActivity` / `sendBroadcast`） | `intent-filter` / `BroadcastReceiver` |
| DI 注入点 | 实现绑定 |
| 回调注册 | 触发点 |

---

## 配对规则（不假装连通，也不假装无关）

- 每条 fire/publish/enqueue 端**必须**：
  - **配上对端**，或
  - 显式标 **"断裂边 / 对端未找到 = 已知静态盲区"**。
- 一条旅程若跨异步边界被劈成多段 → **必须在 edge-ledger 标注该边把哪几个流程节点连成同一旅程**。
- 漏配对端 = `edge-orphan`，由 `ledger-orphans.sh` 机械抽取 fire 端 count-gate、由 AUDIT 揪。

## count-gate 口径收敛（mental-5 P2 · 防信号淹没）

fire 端 count-gate **只覆盖跨进程/异步解耦边界**：
- enqueue / publish / sendBroadcast / 跨进程 Intent / DI 注入。

**不含进程内同步导航**（如普通 `startActivity` 页面跳转，数以百计、会淹没信号）：
- 同步导航作**普通 traced 连边**处理，**不进 edge count-gate**。

## 连边分母完整性上界（mental-5 N1 · 镜像 FR4 入口分母诚实声明）

edge 分母**无机械底线**——只机械覆盖**可 grep 的**异步机制。

**不可 grep 的异步派发 = 承认的盲区**：
- 通用 helper / DI / 反射 / 协程 Channel / 自定义线程池 / 未知框架。
- 其 fire 端不进机械分母（非 `edge-orphan`），两段又各是合法入口/有画像（非 code/entry-orphan）
  → **三账本可能同时失明、旅程被静默劈开而 `exit 0` 照过**。

→ **必须在产物首页与本账本显式点破此非对称**，靠 AUDIT"断裂边漏配对"红队抽查兜底，**绝不假装异步连边已穷尽**。

---

## 旅程合成法（节点 + 边）

```
叶子追踪：各报告自己遇到的 fire 端（enqueue/publish/intent…）
主 agent EDGE-LINK：机械抽取 fire 端全集 + 各叶子报告 → 配对 publish/subscribe、enqueue/dequeue
                    配上 → 标注"此边连接 journey 节点 N_i 与 N_j 为同一旅程"
                    配不上 → 标"断裂边"，进 edge-orphan
覆盖率：fire 端配对数 / 机械抽取 fire 端数（冠"枚举"二字）
```
