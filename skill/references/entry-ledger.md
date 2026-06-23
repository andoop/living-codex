# references/entry-ledger.md — 入口账本（Entry Ledger）

> 落实 PRD FR1/FR4(b)。对应 D2「入口驱动」。验证 TC2/TC14。
> 入口枚举是「不漏」的第一道防线：**漏枚举入口 = 整条业务线静默消失**。
> 入口**字面存在性**可标「已确认」（grep 核验）；**"哪些算业务入口"的归类标「推断」**。

落 `docs/codebook/narrative/entry-ledger.md`（模板见 `templates/entry-ledger.md`）。

---

## 入口类别（每个候选「枚举为业务」或「显式标排除 + 理由」二选一）

**常规类**：
- UI 屏 / Activity / Fragment / View Controller
- Intent / deeplink / URL scheme
- 推送（push / notification handler）
- 传感器 / 硬件回调
- 生命周期回调（`onCreate`/`onResume`/`Application.onCreate`…）
- 定时 / 后台任务（WorkManager / JobService / cron / scheduler）
- 对外 API / 路由（HTTP handler、gRPC service）
- CLI 命令 / 子命令

**A3 易漏类（系统性漏枚举高发区，必须主动扫）**：
- **事件总线订阅者**：EventBus `@Subscribe`、RxBus、`BroadcastReceiver`
- **DI/IoC 装配的 handler**：Dagger/Hilt/Spring 注入的 handler/strategy/listener
- **SPI / ServiceLoader**：`META-INF/services/*` 资源文件声明的实现
- **动态/反射注册**：`registerReceiver`、插件注册、运行时注册表
- **JNI / native 回调**
- **框架组件清单**：`AndroidManifest.xml` 的 component 声明

---

## 框架权威注册表强制纳入（A3 硬规则 · 不可违背）

下列是入口的**权威来源**，**无视任何"只要原始代码"的 code-only portrait 过滤，一律纳入入口枚举取证范围**——漏读这些 = 系统性漏枚举：

| 注册表 | 抽取什么 |
|---|---|
| `AndroidManifest.xml` | `<activity> <service> <receiver> <provider>` + `<intent-filter>` |
| 路由注解 | `@RequestMapping` / `@GetMapping` / `@Path` / `@Route` 等 token |
| DI 模块 | `@Module` / `@Provides` / `@Component` / Spring `@Configuration` |
| SPI 资源 | `META-INF/services/` 下的服务声明行 |
| 反射注册点 | `registerReceiver(` / 插件注册 API 调用点 |

> **理由**：这些注册表把"入口"声明在配置/注解里，而非纯逻辑代码中。若沿用 cartographer 的 code-only 过滤（"只要原始代码"排除 `*.xml`），会把整类入口排除出取证范围 → 漏读 = 整条业务线消失。故业务轴**覆写**该过滤，强制纳入。

---

## entry-orphan：入口覆盖账本（A2 头条修复 · 独立兜底）

- 入口候选**从框架权威注册表独立派生**（不从追踪结果派生）。
- 每个候选必须落到：**"已枚举为业务旅程"** 或 **"显式排除 + 理由"**。
- **未枚举的候选 = `entry-orphan`**，显式列出。
- **为什么 code-orphan 兜不住**：漏枚举入口时，其 handler 可能被别流程认领 → `code-orphan = 0` 却整条业务缺失。**code-orphan 对漏枚举入口定义性失明**，必须由 `entry-orphan` 独立兜住。

## 入口分母机械自推导（mental-3 P1 · 与 code 分母对称）

`scripts/ledger-orphans.sh` 对**可 grep 提取的**注册表候选做**机械抽取 + count-gate**：
- `AndroidManifest.xml` 的 `<activity|service|receiver|provider>` 数
- 路由注解 token（`@RequestMapping`/`@Path`…）数
- `META-INF/services` 行数
- `registerReceiver` / `@Subscribe` 调用点数

**账本入口候选数 ≠ 机械抽取数 → `exit≠0`**。

## 入口分母完整性上界（mental-4 N-entry-1 · 诚实声明）

入口分母**无 `find` 等价的"入口机制全集"机械底线**——可 grep 的注册表类型集合由 agent 依**已知框架**划定。
- **agent 未知的框架入口类型 = 承认的盲区**（其 handler 若被别流程认领则 code/entry 双分母同时失明）。
- 靠 AUDIT 红队 + 文件级 code-orphan 兜底，**不假装零遗漏**。
- **必须在产物首页显式点破此非对称**（与 `honesty-charter.md` 对照表一致）。

## dispatcher 分支展开（B2 · 单入口多业务）

单入口内分发多业务（`when(action){…}` / 路由表 / 命令分发器）时，**必须按 action/分支展开为多个业务节点**，不得以"1 个入口候选已枚举"掩盖 N 种子行为。机械闸门不证分支覆盖（粒度之下）→ 此项靠 AUDIT 抽查 + 透明（见 `coverage-ledger.md` §诚实口径）。
