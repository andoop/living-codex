# references/presentations.md — 可选展现形态

> 落实 FR2。对应 TC13。PRESENT 阶段的可选附加产物。

---

## onboarding 依赖序路线（`/codex onboard --persona <p> --horizon <h>`）

按**依赖序**（先被依赖的、先要跑起来的在前）给出「读什么」的有序清单。

### newgrad / week1 示例结构
```
## 第 1 天（跑起来 + 主干）
1. [[40-build-run]] — 怎么 build/run（引用：Makefile :: "run", Dockerfile）
2. [[00-architecture]] — 系统大图（先看 subsystem 划分）
3. 入口模块：src/main.py :: def main

## 第 1 周（核心模块依赖序）
4. [[10-modules/config]] — 配置加载（被多数模块依赖）
5. [[10-modules/db]] — 数据访问层
6. [[10-modules/api]] — 对外接口
7. [[50-testing]] — 怎么验证你的改动
```

- 每条**关联源码带可定位引用**（文件 + 符号）。
- 依赖序基于 import/定义的静态结构（可「已确认」字面存在）+ 主 agent 对「谁该先读」的**推断**（标推断）。
- 「实际运行时初始化顺序」= 行为性 → 若给出，标「推断」或入未解之谜。

## 其它可选展现
- **per-persona 一页纸**：把该人设入口章节 + 风险清单浓缩成单页。
- **subsystem 导览图**：链接到 `diagrams/` 分层 Mermaid。

> 所有展现形态复用同一批底层结论与 confidence 标注，不新增未经回查的「已确认」。
