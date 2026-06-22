# Changelog

All notable changes to Living Codex are documented here.
Format based on [Keep a Changelog](https://keepachangelog.com/); this project aims for [SemVer](https://semver.org/).

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
