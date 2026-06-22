# references/lint-and-resume.md — advisory lint + 续跑

> 落实 FR7。对应 TC10/TC5/TC12。**lint 是 advisory，绝无 PR 硬门禁。**

---

## Lint（`/codex lint --since HEAD~N`）

### 确定性信号（可靠报出 + 触发增量重测）
- **被引文件变更**：`git diff --name-only <since>` 命中某章「关键文件」→ 标记该章「可能过时」并重测。
- **失效 wikilink**：`[[X]]` 目标页不存在。
- **孤儿页**：无入链页。

### Advisory（**只提示，不阻断**）
- 「解释是否过时」：被引文件变了不代表解释一定错，作 advisory 提示，由人决定是否重写。
- **不存在任何会阻断合并的硬门禁**（`/codex check` 本期已删）。

## 增量重测策略
- **有哈希脚本**（可选）：对被引文件算哈希，变更才重测。
- **无哈希脚本（降级，TC12）**：按 `git diff` **文件名**重测——文件名命中某章关键文件清单 → 重测该章。

## 续跑（resume，TC5）
- 读 `survey-state.md`：
  - `done` → 跳过；
  - `doing`（上次中断残留）→ 重置 `todo` 重跑；
  - `todo` → 继续。
- 因 `survey-state` **只有主 agent 单线程写**，续跑无交错损坏、不重复、不漏。

## 降级总表（与 SKILL §7 一致）
| 缺失 | lint 行为 |
|---|---|
| 无哈希脚本 | 按 git diff 文件名重测 |
| 无 git | lint 退化为「全书 wikilink/孤儿/已确认回查」体检，不做增量 |
| 无 verify-citations.sh | 跳过已确认回查项（但「已确认」档本就该停用，见 provenance） |
