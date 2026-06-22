# Changelog

All notable changes to Living Codex are documented here.
Format based on [Keep a Changelog](https://keepachangelog.com/); this project aims for [SemVer](https://semver.org/).

## [0.6.0] - 2026-06-22
manifest 审阅与返工 + 默认排隐藏目录 + 可"只要原始代码"。源于反馈"看到 manifest 后还想再删，比如编译产出/`.`开头目录/只看原始代码"。

### Added/Changed
- `.codebookignore` 默认追加 **所有 `.` 开头隐藏目录** 与 vendored 缓存（`ephemeral/.plugin_symlinks/.pub-cache`）。
- 支持**按扩展名/文件性质收窄**：一键"只要原始代码"（排 `*.xml/*.json/*.properties/*.gradle/*.pro` 等资源配置）。
- SCOPE 流程加 **manifest 审阅与返工循环**：建草案 manifest→开发者审阅→可按文件夹/扩展名/路径收窄→重算→循环；**硬门禁从"审 ignore"上移到"审最终 manifest"**，未批准这份清单禁止开绘。

## [0.5.0] - 2026-06-22
范围契约门禁：`.codebookignore` 先草拟→推演→红蓝对抗→**人最终审批**，批准后才开绘。源于反馈"ignore 也该推演对抗，由 AI 据客观事实定、人最终审核，没问题再完整绘制"。

### Added
- `references/scoping.md` 升级为带门禁的小闭环：① 据客观事实草拟 `.codebookignore`（含图片/视频/二进制等非代码资源默认排除）② 单一职责文件夹侦察子 agent（只报事实+建议、不带情绪、ESCALATE 交人、决策归主 agent）③ 对 ignore 本身做推演+红蓝对抗（审"该进的没误排、垃圾没混入、没缩分母假全覆盖"）④ **人最终审批硬门禁——未批准禁止建 manifest/禁止开绘**。

## [0.4.0] - 2026-06-22
SCOPE 范围界定：`.codebookignore`（gitignore 语法）+ 单一职责文件夹侦察子 agent。修复 v0.3 教训——默认忽略加入本 skill 自身安装副本 `.agents/.claude/.cursor/.kiro`（曾被误纳入测绘，分母虚高）。

## [0.3.0] - 2026-06-22
全覆盖逐文件画像模式：一次性做完、不留下一轮。源于反馈"不想分轮，定好目标做 TODO，逐文件做画像，全覆盖"。

### Added
- **`--coverage full` 模式**（`references/file-portraits.md` + `templates/file-portrait.md`）：
  - **MANIFEST**：枚举全部 in-scope 文件 → `docs/codebook/manifest.md`（每文件一行 TODO，排除构建产物且显式列排除规则）。
  - **PORTRAIT**：逐文件做"画像卡"（一句话职责 / 关键符号 / 入出依赖 / 关键结论 / 风险 / 未解之谜 / confidence），聚合进 `portraits/<module>.md`。
  - **DONE 闸门**：完成 = manifest TODO 100% 勾完（非"深度达档"）；未勾完**自动接着 grind**，续跑自动接力——**无需用户做"下一轮"决策**。
  - AUDIT 加查覆盖率=100%；"未勾却宣布完成"= P0。
- 诚实不变：全覆盖=每文件都有画像卡，≠ 每文件都运行验证；行为结论照样「推断」；排除清单显式列出，不许缩小分母假装全覆盖。

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
