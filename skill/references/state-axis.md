# references/state-axis.md — 状态/横切业务的第二遍历轴（FR13 · A-RT3-3）

> 落实 PRD FR13。验证 TC23。
> 核心：入口驱动会**系统性漏掉非入口根的状态/条件驱动业务**——须追加第二类遍历种子。

---

## 为什么需要第二轴

入口驱动（`entry-ledger.md`）从"用户/外部触发"出发，会漏掉**状态/条件驱动**的业务：
- token 过期重登
- 缓存 TTL 失效
- 权限传播 / 权限校验
- feature-flag 分支
- 启动迁移（schema migration）
- 定时同步

这类业务常与入口可达代码**共享文件** → **code-orphan 定义性失明**（与 A2 同构，新目标）。故须有**独立的"状态/横切规则"登记与 orphan 信号**，不能靠 code-orphan 兜底。

---

## 第二类遍历种子：状态/条件触发器

除入口外，追加种子：
- guard 判断
- 过期 / TTL 检查
- 权限校验点
- flag 读取点

可 grep 者作机械抽取，登记到独立的"状态·横切规则"账本。

## count-gate 只覆盖稳定签名子类（RT4-4 · 镜像 FR10 信号淹没排除）

| 子类 | 是否进 count-gate | 理由 |
|---|---|---|
| 权限校验 API（`checkPermission`/`ContextCompat.checkSelfPermission`…） | ✅ 进 | 稳定 API 签名，可稳定 grep |
| TTL / 过期常量（`*_TTL` / `EXPIR*`） | ✅ 进 | 稳定常量命名 |
| feature-flag 读取 API（`isEnabled` / flag client） | ✅ 进 | 稳定 API |
| **guard / 泛化条件分支（`if`）** | ❌ **移出 count-gate** | **无稳定签名，grep `if` 会洪泛** → 降人工 / AUDIT 抽样 + 承认盲区声明 |

→ **不假装"状态轴枚举机械完整"**。

## 诚实声明

- 不可 grep 的状态触发 = 承认盲区，**首页镜像声明**（与入口分母、连边分母非对称声明一致）。
- AUDIT 增 **"状态/横切业务漏测"** 攻击项。
