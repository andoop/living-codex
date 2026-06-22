# Changelog

All notable changes to Living Codex are documented here.
Format based on [Keep a Changelog](https://keepachangelog.com/); this project aims for [SemVer](https://semver.org/).

## [0.2.0] - 2026-06-22
监督闭环：根治"AI 说做完就做完"。源于真实验收反馈——在 13 万文件的大型 Android 仓上，并行扇出失败→单 agent 串行只深读 7/70 模块却走到"完成"。

### Added
- **OBJECTIVES 先定目标**（`references/objectives.md`）：`map` 第一步产出 `docs/codebook/objectives.md`——北极星 + **覆盖目标矩阵**（全部子系统 × 目标深度 × 本轮是否必覆盖）+ 可验收完成定义；大项目须与开发者确认。
- **AUDIT 独立监督审核**（`references/supervision.md` + `prompts/audit-mental.md` / `prompts/audit-redteam.md`）：PRESENT 后派**独立子 agent**（非写书上下文）做头脑预演（覆盖/逻辑闭环）+ 红蓝对抗（过度声明/编造引用/覆盖缺口/完成度造假/密钥泄漏）。
- **SIGN-OFF 对照目标验收**：P0/P1 清零 + 覆盖达 objectives 才算 DONE，否则**再做一轮**。
- 新命令 `codex audit`；状态机由五阶段升级为**七阶段**（OBJECTIVES→…→AUDIT⇄→SIGN-OFF）。

### Changed
- 编排铁律新增：**扇出失败不得静默判完成**——降级串行须显著记录、重估覆盖目标、分轮覆盖，覆盖缺口由 AUDIT 强制揪出。
- 明确 `review`（同上下文自查）≠ `audit`（独立监督），不可互相替代。

## [0.1.0] - 2026-06-22
首个公开版本。一个可移植、诚实优先的代码理解 skill。

### Added
- `skill/` — cartographer 方法论：`SKILL.md` + 8 references + 4 templates + 2 prompts + 3 scripts。
- 五阶段测绘 `SCOPE→PARTITION→SURVEY→SYNTHESIZE→PRESENT`，编排集中化（主 agent 单层扇出、子 agent 只读叶子）。
- 三档可信度（`已确认/推断/未解之谜`）+ 双档承诺；行为/运行期结论封顶「推断」；「已确认」需 grep 回查，无回查能力则该档禁用。
- 命令面 `map / ask / review / lint / onboard`（无 PR 硬门禁，刻意）。
- 可选后端 `codegraph / repomix`（缺失自动降级）；可选脚本 `verify-citations.sh / scrub-secrets.sh / pack-context.sh`。
- 多平台 `install.sh` / `install.ps1`（Claude / Cursor / Codex / Kiro / generic）。
- `examples/llm_wiki-codebook/` — 在真实项目实跑的 21 章样例产物。
- 文档：`docs/honesty.md`、`docs/methodology.md`、`docs/commands.md`。

### Notes
- 经 3 轮红蓝对抗 + 头脑预演加固：P0/P1 清零；T9 真实项目实跑通过、诚实红线端到端守住、抽样 grep 回查 5/5 命中。
- 已知残余（路线图）：全量 `--batch` 回查、全局 token 上限护栏、编排集中化的机制级强制（当前为提示词约束）。
