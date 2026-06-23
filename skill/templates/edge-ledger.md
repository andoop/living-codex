# 连边账本 · {{项目}}（FR10）

> 见 `references/edge-ledger.md`。业务旅程 = 节点 + **边**。
> 边的**因果方向/时序一律「推断」**（连通性靠 grep 字面成对，语义靠推断）。
> count-gate **只覆盖跨进程/异步解耦边界**；进程内同步导航（普通 `startActivity`）走普通 traced 连边、不进此账本 count-gate。

---

## 异步/派发边配对

| edge-id | fire/源端 | 对端/receive | 连接的旅程节点 | 配对状态 | confidence |
|---|---|---|---|---|---|
| E1 | `enqueue(UploadWork)` @ {{文件}} | `UploadWorker.doWork` @ {{文件}} | N3 ↔ N4（同一上传旅程） | 已配对 | 推断（方向/时序） |
| E2 | `publish(SyncEvent)` @ {{文件}} | `@Subscribe onSyncEvent` @ {{文件}} | N7 ↔ N8 | 已配对 | 推断 |
| E3 | `sendBroadcast(ACTION_X)` @ {{文件}} | ? | N9 ↔ ? | **断裂边 / 对端未找到 = 已知静态盲区** | — |

## edge-orphan（fire 端漏配对端，机械抽取 count-gate 揪）
- `{{fire 端}}`〔edge-orphan：对端未找到〕

## 机械核对（count-gate · 限跨进程/异步）
- enqueue/publish/sendBroadcast/跨进程 Intent/DI 注入 fire 端机械抽取数：{{n}} vs 账本配对+断裂数：{{m}} → {{一致 / exit≠0}}

## 盲区非对称声明（不可删）
edge 分母无机械底线——不可 grep 的异步派发（通用 helper / DI / 反射 / 协程 Channel / 自定义线程池 / 未知框架）= 承认盲区：其两段各为合法入口/有画像（非 code/entry-orphan）、fire 端不进机械分母（非 edge-orphan）→ 旅程可能被静默劈开而 `exit 0` 照过。靠 AUDIT"断裂边漏配对"兜底，绝不假装异步连边已穷尽。
