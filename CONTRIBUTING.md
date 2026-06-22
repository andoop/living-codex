# Contributing to Living Codex

谢谢你愿意让 Living Codex 更好。它是一个**方法论 skill**，贡献多半是改 `skill/` 下的 Markdown 规范与可选 shell 脚本。

## 最高原则：诚实 > 功能

任何 PR 不得削弱 [docs/honesty.md](docs/honesty.md) 的五条铁律。尤其：
- 不得引入任何"假装已验证"的措辞或机制。
- 不得让「已确认」覆盖行为/运行期结论。
- 新增"强能力"若依赖运行时，必须标为**可选后端**且缺失可降级，不得破坏"零运行时可移植"红线。

## 开发流程

1. Fork & 建分支：`git checkout -b feat/my-change`
2. 改动落在 `skill/`（方法论/模板/prompt/脚本）或 `docs/`。
3. 脚本用纯 POSIX sh/bash + coreutils，不引入 jq/python/node 依赖。
4. 跑本地检查：`shellcheck skill/scripts/*.sh`（若装了），并自测脚本退出码。
5. 若改了产物规范，更新 `examples/` 或在 PR 描述里说明对样例的影响。
6. 提 PR，描述：改了什么、为什么、是否触及诚实红线（必答）。

## 报告问题
用 `.github/ISSUE_TEMPLATE/` 的模板。涉及"它盖了不该盖的已确认章 / 编了行号 / 假装验证"——**优先级最高**，请附可复现的章节与源码位置。

## 行为准则
参与即同意 [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)。
