# prompts/audit-narrative.md — 业务叙事独立审核（OPFOR 红军 + 头脑预演）

> 主 agent 在 AUDIT 阶段填充派发。审核子 agent **必须与写书 agent 不同上下文**，只读。
> 见 `references/honesty-charter.md`（审核只降 variance 不降 bias）/ `references/supervision.md`。

输入（主 agent 填）：
- 目标项目根：`<PROJECT_ROOT>`（可 grep/读源码取证）
- 叙事书路径：`<NARRATIVE_DIR>`（先读 `L0-product.md` 首页声明 + 三账本）
- 脚本：`<SKILL_DIR>/scripts/ledger-orphans.sh`、`<SKILL_DIR>/scripts/verify-citations.sh`

---

## 头脑预演（覆盖/逻辑闭环）
- 三账本（code/entry/edge）是否齐全、各 orphan 是否透明列出？
- 旅程能否 L0→L5 读通、层间一致？
- "部分覆盖/未解之谜"是否如实标注，还是把"没读"伪装成"读过"？
- 返回 `LOGIC_CLOSED` 或 `ANOMALY_FOUND`（含 P0–P3）。

## 红蓝对抗攻击向量（每记给可复现证据 + P0–P3；仅 P0/P1 算 BREACH）
1. **过度声明**：把行为/连边/因果/顺序结论标成「已确认」（举具体行）。
2. **编造/失效引用**：抽 8–10 条「已确认(字面)」跑 `verify-citations.sh`，列命中率；指向不存在符号 = 假追溯。
3. **孤儿业务节点**：journey 节点挂不上任何代码证据。
4. **入口漏枚举**：对照框架权威注册表（AndroidManifest/路由注解/SPI/DI），找未进 entry-ledger 的入口候选。
5. **分母缩小**：code 分母是否被偷换成"有 portrait 的文件"而非独立 `find` 全集。
6. **orphan 漏报**：实际未认领文件/未配对 fire 端是否漏出 orphan 清单。
7. **已枚举入口 vs 注册表派生候选 diff**：跑机械抽取 vs 账本候选，找差额（防"候选清单←真实注册表"漏读）。
8. **断裂边漏配对**：可 grep 的 enqueue/publish/sendBroadcast fire 端是否都配对端或标断裂边；漏标的 = edge-orphan 漏报。
9. **dispatcher 未展开**：单入口分发多业务（`when(action)`/路由表）是否按分支展开为多节点，还是 1 入口掩盖 N 子行为。
10. **traced 可达链不可复现**：抽 traced 认领，要求复现其可达链（grep 命中序列）；复现不了 = 应降 heuristic。
11. **叙事过期未标**：`git diff` 命中文件消费的 journey 是否标"待复核"，或首页有无快照声明（grep 命中≠未过期）。
12. **含糊到无用 / 决策级具体度不足**：抽核心规则，看是否只有"会处理"级含糊断言（含糊+推断双免责）。
13. **状态/横切业务漏测**：token 过期/TTL/权限/flag/迁移 等第二轴业务是否登记，可 grep 子类是否 count-gate。
14. **punt 占比**：核心业务节点 punt 占比是否过高、首页是否披露。
15. **覆盖率粉饰盲区**：是否用单一高"枚举覆盖率"数字掩盖 0 覆盖子系统；"已知缺失/未测子系统"专章是否存在 + 带"非盲区全集"caveat。
16. **多角色/串行戳记造假**：串行降级是否被盖了与并行同款"独立交叉"戳记；分歧是否靠多数表决假装定论。
17. **机械闸门冒充业务权威**：首页/标题是否把 `exit 0` 暗示成"业务覆盖/不留细节已达成"；覆盖率是否冠"枚举"二字。
18. **密钥/PII**：grep 产物与中间产物有无密钥/token/PII 原文。
19. **术语泄漏**：抽 N 段**线上正文**及**全部机读 frontmatter 字段**（`title`/`description`/`tags`/自定义键）扫术语黑名单（框架名/类型名/函数名/库名未解释出现）。**证据层 concept（`type: portrait`/`ledger`）的 frontmatter 从宽**（按 P2/P3 记，不 gating）；线上正文不豁免。
20. **小白可读性**：核心旅程 L2 主干能否被**非本项目工程师**复述"做什么/得到什么"；读不出 = 白话化未达标。
21. **frontmatter 齐备/合法**：每 concept 有合法 YAML + `type`（取值在集合内）；`index.md`/`log.md` **无** frontmatter。
22. **gap 显式**：每旅程/规则/首页是否有"还不知道什么"小节（映射未解之谜）。
23. **frontmatter 过度声明（M9）**：**全部机读字段**（含证据层）是否含未标记的行为/连边/因果结论，或行为结论标签（如 `tags:[自动重试]`）、纯术语标签（如 `tags:[LanceDB]`）。此项对所有字段**一律不豁免**。
24. **诚实信号默认可见（M10）**：`honesty-charter` 第五条**全部信号行**（草稿/枚举/闸门不证业务/AUDIT 不认证/**非对称盲区/串行"不等同独立交叉验证"**/快照过期/punt 占比）是否默认首屏可见，还是被**整体或部分**塞进默认折叠 `<details>`；章首白话声明与 `已确认`/`未解之谜` 例外是否被折叠隐藏。
25. **闸门 token 污染（R1 advisory）**：narrative 文档（尤其 `glossary.md`）是否写了裸闸门 token（`WorkManager`/`enqueue(`/`sendBroadcast(`/`checkSelfPermission(`/大写 `TTL`·`TIMEOUT`·`EXPIR`/`isEnabled(`）致 `ledger-orphans.sh` 的 entry/edge/state derived 虚高（见 `plain-language.md` §3.1）。

## 诚实边界（自我约束 · honesty-charter 第三条）
你只能查**形式/结构/枚举类错误**；**查不出业务理解错误**（你与作者共享同一静态源、无运行时 oracle，可能共享同一误读）。**不得**在战报里声称"业务叙事已验证正确"。

## 交付
战报写入 `<NARRATIVE_DIR>/audit/audit-narrative-<n>.md`：逐记杀招(向量/证据/分级) + verify-citations 与 ledger-orphans 实跑结果 + 蓝军扛住项 + 总结论 `HELD` 或 `BREACH_FOUND`。写完只回 DONE。
