# 全覆盖逐文件画像模式 · file-portraits（`--coverage full`）

> 为「一次性做完、全覆盖、不留下一轮」设计。把覆盖从"深度档 + 长尾留后"换成**"枚举全部 in-scope 文件 → TODO 清单 → 逐文件画像 → grind 到 100%"**。**完成 = TODO 清零**，不是"深度达档"。

## 与 focused 模式的区别
| | `--coverage focused`（默认） | `--coverage full`（本规范） |
|---|---|---|
| 覆盖契约 | objectives 覆盖矩阵（核心 L3 + 长尾 L1，长尾留后续轮） | **manifest：全部 in-scope 文件逐一画像** |
| 完成定义 | 必覆盖子系统达目标深度 | **manifest TODO 100% 勾完** |
| 续跑语义 | 可能需新一轮判断 | **自动接着 grind，无需人做"下一轮"决策** |
| 适用 | 快速 onboarding / 只关心核心 | 要全仓不漏 / 审计 / 完整知识库 |

## 阶段（在七阶段里如何落地）

### MANIFEST（PARTITION 的全覆盖形态）
1. SCOPE 排除构建产物/依赖（`.class/.jar/.flat/.png/.kapt_metadata/node_modules/build/dist/.git` 等）后，`find` 全部 **in-scope 源文件**（按 dimensions 的文件类别：code/config/docs/infra/data/script/markup）。
2. 写 `docs/codebook/manifest.md`：**每文件一行** `- [ ] <相对路径> · <类别> · <所属 territory/module>`。这是**覆盖契约与 TODO 台账**（仅主 agent 写）。
3. 写明统计：in-scope 文件总数、各类别数、排除规则。**这个总数就是"全做完"的分母。**

### PORTRAIT（SURVEY 的逐文件形态）
按 manifest **逐文件**产出画像（用 `templates/file-portrait.md`），完成一个就把该行 `- [ ]`→`- [x]`。
- 画像写到对应 **module 画像文件** `portraits/<module>.md`（同 module 文件聚合成一章，避免文件爆炸），或大文件单独成页。
- **只读该文件 + 必要邻居**；关键导出符号标「已确认」前**必须 grep 回查**（`verify-citations.sh`）。
- 行为/调用/顺序/运行期一律「推断」；读不懂/需运行的入该文件画像的「未解之谜」。
- **批处理**：每批勾 N 个文件就回写 manifest（断点续跑依据）。串行宿主下顺序 grind；有并行则主 agent 分批扇出只读叶子，叶子各画各的、回写自己批次，**manifest 仍仅主 agent 勾**。

### DONE 闸门（核心）
- **manifest 仍有 `- [ ]` 未勾 → 未完成**，**自动继续 grind 下一批**（resume 读 manifest 从第一个未勾处继续）。**不得在 TODO 未清零时进 SYNTHESIZE 或宣布完成。**
- 全部 `- [x]` → 才进 SYNTHESIZE（从文件画像自底向上汇成模块章 + 架构）→ PRESENT → AUDIT → SIGN-OFF。
- 单文件实在画不动（超大/二进制误纳/生成代码）→ 标 `- [~]` + 在画像写明原因入「未解之谜」，**计入已处理**（不是假装勾完，是显式记"已看过、判定不深入及理由"）。

## 诚实红线（不变）
- 全覆盖 ≠ 全部「已确认」：画像里行为结论照样「推断」，没读懂照样「未解之谜」。**全覆盖指"每个文件都被看过且有画像卡"，不是"每个文件都被运行验证"。**
- manifest 的"100%"指 in-scope 文件，排除清单要在 manifest 里显式列出，不许用"缩小分母"假装全覆盖。

## AUDIT 对全覆盖模式的加查
- **覆盖率核对**：manifest 总数 vs 已勾(含 `[x]`/`[~]`)数 = 100%？抽查若干"已勾"文件的画像真实存在且非空、关键符号 grep 命中。
- 任何"未勾却已进 SYNTHESIZE / 宣布完成" = **P0**（完成度造假，违反 DONE 闸门）。
