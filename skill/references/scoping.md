# SCOPE 范围界定 · .codebookignore + 文件夹侦察（先定干净范围，再建 manifest）

> 教训：直接 `find` 全树会把构建产物、第三方 vendored、甚至本 skill 自己的安装副本（`.agents/.claude/.cursor/.kiro`）都算进来，分母虚高、画像噪声。**先界定干净范围，再 manifest。**

## 第 1 步：`.codebookignore`（像 .gitignore）
项目根放一个 `.codebookignore`，gitignore 语法，决定哪些文件/目录**不纳入**测绘。
- **种子**：把项目 `.gitignore` 内容**同步**进来打底（构建产物、IDE、依赖多半已在里面）。
- **Living Codex 默认追加**（始终忽略）：
  ```
  # build / deps / vcs / 所有隐藏目录（IDE/工具/缓存/VCS，默认全排）
  build/  .gradle/  .git/  .idea/  node_modules/  .cxx/  captures/  dist/  out/  .*/
  # vendored / 第三方 / 虚拟环境 / 生成（常见噪声，默认排除；如确需可显式取消）
  .venv/  venv/  3rd/  3rdparty/  third_party/  thirdparty/  vendor/  Pods/  .dart_tool/  site-packages/  ephemeral/  .plugin_symlinks/  .pub-cache/
  # binaries
  *.class *.jar *.aar *.so *.flat *.png *.jpg *.jpeg *.webp *.gif *.ttf *.otf *.keystore *.kapt_metadata
  # Living Codex 自身安装副本与产物（绝不自我测绘）
  .agents/ .claude/ .cursor/ .kiro/ docs/codebook/ docs/codebook-*/
  ```
- **可按"文件性质"收窄**（`.codebookignore` 支持扩展名规则）：开发者可选"**只要原始代码**"——排除资源/配置/数据类（`*.xml *.json *.properties *.yml *.yaml *.gradle *.pro` 等），只留代码语言文件（`.java/.kt/.dart/.cpp/.c/.h/.py/.sh/...`）。这是常见诉求，应在 manifest 审阅时支持一键收窄。
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
- 文件类型常识（据客观事实，非主观）：图片/视频/音频/字体/二进制/压缩包等**非代码资源**默认 `out`（除非是被分析的配置/数据）；纯生成码、vendored 第三方默认 `out`。

## 第 3.5 步：对 `.codebookignore` 做推演 + 红蓝对抗（范围契约也要审）
`.codebookignore` 是决定"全覆盖分母"的契约，**它本身必须被独立审核**，不能主 agent 一人说了算：
- **头脑预演子 agent（覆盖闭环）**：审"**该进的有没有被错误排除**"——逐条 ignore 规则核对，有没有把项目自有源码、关键配置误排掉；范围是否逻辑自洽。
- **红蓝对抗子 agent（攻击这份范围）**：攻 ①有没有把**真源码偷偷排掉**（漏测伪装成"忽略"）②有没有把**垃圾/第三方算进来**虚高分母 ③有没有靠**扩大忽略缩小分母**假装"全覆盖"④非代码资源排除是否有客观依据。每条给可复现证据 + P0–P3。
- 发现问题 → 主 agent 修 `.codebookignore` → 再审，直到 P0/P1 清零。审核报告落 `docs/codebook/audit/scope-audit-<n>.md`。

## 第 3.6 步：ignore 初审（范围草案）
- 经推演+对抗、P0/P1 清零后，得到 `.codebookignore` 草案 + 范围摘要。可继续建**草案 manifest**（第 4 步）让开发者看真实清单——**真正的硬门禁在第 4.6 步（审批 manifest）**，绘制前必须过。

## 第 4 步：建**草案** manifest
范围初定后，应用 `.codebookignore` 用 `find` 列 in-scope 文件 → 写 `docs/codebook/manifest.md`（**草案**，每文件一行 `- [ ]`）。同时输出**构成摘要**（总数、按语言/按顶层目录分布）给开发者看。

## 第 4.5 步：manifest 审阅与返工（可迭代，关键）
> 开发者**看到真实文件清单后**常会想再删（这正是本步存在的理由）。
- 把 manifest 的**总数 + 语言分布 + 目录分布 + 排除规则摘要**呈现给开发者。
- 开发者可提出收窄：按**文件夹**（如再去掉某目录）、按**扩展名/性质**（如"只要原始代码"→排 `*.xml/*.json/*.properties/*.gradle` 等资源配置）、按**路径模式**。
- 主 agent 据此**更新 `.codebookignore` → 重新生成 manifest → 再呈现**。**循环，直到开发者满意。**
- 每次返工在 `scope-decisions.md` 记一笔（改了什么、为什么、新总数）。

## 第 4.6 步：人最终审批 manifest（硬门禁，不可跳过）
<HARD-GATE>
**审批对象是最终 manifest（不是只审 ignore）。** 未获开发者对"这份文件清单"明确批准，**禁止开始任何画像绘制（grind）**。开发者说"批准/开绘"后，manifest 由草案转正式，方可进入逐文件画像。
</HARD-GATE>

## 第 5 步：grind（仅在 manifest 获批后）见 `references/file-portraits.md`。
范围敲定后，`find` 时应用 `.codebookignore`，只把 in-scope 文件写进 `manifest.md`。**这个干净分母才是"全做完"的基准。**

## 诚实红线
- `.codebookignore` 顶部必须**显式列出所有忽略规则**（不许偷偷扩大忽略来缩小分母假装全覆盖）。
- 被忽略的"第三方/生成码"在书里 `99-未解之谜` 或 `scope-decisions.md` 留一句"已知存在、按范围排除、未测绘"，不假装不存在。
