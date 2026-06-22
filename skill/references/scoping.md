# SCOPE 范围界定 · .codebookignore + 文件夹侦察（先定干净范围，再建 manifest）

> 教训：直接 `find` 全树会把构建产物、第三方 vendored、甚至本 skill 自己的安装副本（`.agents/.claude/.cursor/.kiro`）都算进来，分母虚高、画像噪声。**先界定干净范围，再 manifest。**

## 第 1 步：`.codebookignore`（像 .gitignore）
项目根放一个 `.codebookignore`，gitignore 语法，决定哪些文件/目录**不纳入**测绘。
- **种子**：把项目 `.gitignore` 内容**同步**进来打底（构建产物、IDE、依赖多半已在里面）。
- **Living Codex 默认追加**（始终忽略）：
  ```
  # build / deps / vcs
  build/  .gradle/  .git/  .idea/  node_modules/  .cxx/  captures/  dist/  out/
  # binaries
  *.class *.jar *.aar *.so *.flat *.png *.jpg *.jpeg *.webp *.gif *.ttf *.otf *.keystore *.kapt_metadata
  # Living Codex 自身安装副本与产物（绝不自我测绘）
  .agents/ .claude/ .cursor/ .kiro/ docs/codebook/ docs/codebook-*/
  ```
- **让开发者确认**：把生成的 `.codebookignore` 给开发者过目/增删一次（这是范围契约，值得确认）。

## 第 2 步：文件夹逐批侦察（单一职责子 agent）
对**顶层 + 次级目录**分批，派**文件夹侦察子 agent** 客观分类（用 `prompts/scoping-folder.md`）。

**侦察子 agent 铁律（按开发者要求）：**
- **职责单一**：只对"这个文件夹是什么、该不该纳入"给**客观事实 + 建议**。不写画像、不改文件、不做别的。
- **不带情绪/担忧**：不说"建议谨慎""可能重要"这类主观修饰；只陈述可取证事实（语言构成、是否含 `build.gradle`/`package.json`、是否 vendored/第三方、是否生成码、文件数）。
- **拿不准就升级**：证据不足以判定 → 返回 `ESCALATE`（连同事实），**交主 agent/开发者定**，子 agent 不替决策。
- 每个文件夹返回一条：`path | 事实(1-2句,带证据) | 分类(first-party-source/third-party-vendored/generated/tooling/tests/resources/unknown) | 建议(in|out|ESCALATE)`。

## 第 3 步：主 agent 决策（指挥官拍板）
- 子 agent 报 `in`/`out` 且证据清楚 → 主 agent 采纳，把 `out` 的写进 `.codebookignore`。
- 子 agent 报 `ESCALATE` 或主 agent 存疑 → **写进 `questions`/直接问开发者**，人定。子 agent 只报事实，**决策永远在主 agent/人**。
- 决策留痕：在 `docs/codebook/scope-decisions.md` 记每个文件夹的事实 + 裁决 + 依据。

## 第 4 步：建 manifest
范围敲定后，`find` 时应用 `.codebookignore`，只把 in-scope 文件写进 `manifest.md`。**这个干净分母才是"全做完"的基准。**

## 诚实红线
- `.codebookignore` 顶部必须**显式列出所有忽略规则**（不许偷偷扩大忽略来缩小分母假装全覆盖）。
- 被忽略的"第三方/生成码"在书里 `99-未解之谜` 或 `scope-decisions.md` 留一句"已知存在、按范围排除、未测绘"，不假装不存在。
