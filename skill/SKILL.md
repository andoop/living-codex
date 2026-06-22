---
name: cartographer
description: 活典 Living Codex — 最诚实的代码理解 skill。可移植装进任意项目，用集中编排的多子 agent 分治测绘，产出分档可信（已确认/推断/未解之谜）的 Markdown 代码厚书 + onboarding 视角。核心纪律：不假装验证、不编造引用、把不确定集中暴露。
---

# 活典 · Living Codex — cartographer

> 把一个陌生代码库做成一本**可读、可追溯、诚实标注可信度**的厚书。
> 差异化不是「功能最多」，是 **Sandtable 真实性纪律**：不假装验证、不编造引用、把不确定集中暴露、不会的就明说。

---

## 0. 一句话契约（读之前先记住）

本 skill 产出的是 **onboarding 草稿**，不是经过运行验证的真相。
- 「**已确认**」**只**担保一件事：被引用的符号/字符串在它标注的文件里**字面存在**（机械 grep 核验过）。它**不**担保任何语义、行为、关系为真。
- 任何「**行为性 / 关系性 / 顺序 / 因果 / 运行期 / 动态**」结论，**在任何档位最高只能标「推断」**。
- 不知道、需要运行才能定的，进「**未解之谜**」。
- **完成 = 过审，不是 AI 自称**：未经独立子 agent 的 AUDIT、未对照 `objectives.md` 验收覆盖，**不得宣布完成**（见 §2.5）。

---

## 1. 何时用

- 接手陌生项目，要快速、安全地建立心智模型；
- 需要把一个代码库的架构/模块/数据流讲清楚给不同角色（架构师/新人/安全/SRE）；
- 想要一本可提交 git、Obsidian 兼容、可被后续 AI 检索的代码文档。

不适用：需要确定性可验证 provenance / 真证伪 / 可信增量索引时——那些需要确定性运行时（tree-sitter/SQLite/SHA256），本 skill 明确不假装能做（详见 `references/provenance.md`）。

---

## 2. 七阶段流程（含监督闭环）

> **核心升级**：OBJECTIVES 先定目标、AUDIT 由**独立子 agent** 做头脑预演 + 红蓝对抗审核、SIGN-OFF 对照目标验收。**严禁"AI 说做完就做完"——未过 AUDIT 不算 DONE。**

```
OBJECTIVES → SCOPE → PARTITION → SURVEY → SYNTHESIZE → PRESENT → AUDIT ⇄ (按发现再做一轮) → SIGN-OFF
```

| 阶段 | 做什么 | 谁来做 | 详见 |
|---|---|---|---|
| **OBJECTIVES** | 先定**测绘目标与验收**：这本书帮谁回答什么；**覆盖目标**（哪些子系统必须深读、到什么深度）；**完成定义**（可验收标准）。写入 `docs/codebook/objectives.md`。**大项目必须显式设覆盖目标矩阵与每区深度**，并与开发者确认。 | 主 agent（与开发者确认） | `references/objectives.md` |
| **SCOPE** | 定档位(backend)、深度(L1–L4)、人设、语言、token 预算；**界定范围：生成/确认 `.codebookignore`（排除构建产物/二进制/非代码资源/本 skill 安装副本）** | 主 agent | §3, `references/provenance.md`, `references/scoping.md` |
| **PARTITION** | 切 territory，写 `survey-state.md`（todo/doing/done + 边界 + 文件清单） | 主 agent **单线程写** | `references/orchestration.md` |
| **SURVEY** | 分批扇出**只读叶子** agent，各写自己的 `territory-report-<id>.md` | 主 agent 扇出 / 叶子只读 | `references/orchestration.md`, `prompts/subagent-survey.md` |
| **SYNTHESIZE** | **多级归并** territory→subsystem→global，保留显式跨边清单 | 主 agent | `references/orchestration.md` |
| **PRESENT** | 生成厚书 + 人设视角 + onboarding 路线，逐章首放 confidence 图例 | 主 agent | `references/book-spec.md`, `references/presentations.md` |
| **AUDIT** | 派**独立**子 agent 做**头脑预演（覆盖/逻辑闭环）+ 红蓝对抗（揪过度声明/编造引用/漏测关键子系统/未达覆盖目标）**。产 `ANOMALY/BREACH` + 分级。 | 主 agent 扇出独立审核子 agent（**非**写书的那个） | `references/supervision.md`, `prompts/audit-mental.md`, `prompts/audit-redteam.md` |
| **SIGN-OFF** | 对照 `objectives.md` 验收：审核 **P0/P1 清零** 且 **覆盖达目标**（或开发者明确接受残余）才算 DONE；否则回相应阶段**再做一轮**。 | 主 agent（与开发者） | `references/supervision.md` |

落地后可选：`review`（轻量二次自审，`references/self-review.md`）、`lint`（advisory 保鲜，`references/lint-and-resume.md`）。**注意：`review`≠`AUDIT`——`review` 是同一上下文的轻量确定性自查，`AUDIT` 是独立子 agent 的对抗式审核，二者不可互相替代。**

---

## 2.5 监督与签收闭环（AUDIT / SIGN-OFF · 不可违背）

> 这是本 skill 最重要的纪律：**理解的产物必须被独立审核，不能由写书的 AI 自己宣布完成。**

**OBJECTIVES（先定目标）**——`map` 一开始就要产出 `docs/codebook/objectives.md`：
- 北极星：这本书要帮**谁**、回答**哪些问题**才算有用；
- **覆盖目标矩阵**：列出项目的主要子系统，标注每个**必须达到的深度**（L1/L2/L3/L4）与"是否本轮必覆盖"；大项目可分轮，但要写明本轮目标与后续轮；
- 完成定义：可验收的二元标准（如"核心上传链路 L3、其余模块至少 L1 清单 + 职责推断"）。
- 大项目/不确定时**与开发者确认 objectives 再开测**。

**AUDIT（产出后，派独立子 agent 审核）**——PRESENT 完成后**必须**做，至少两路独立子 agent（与写书 agent 不同上下文）：
- **头脑预演子 agent**：逐章推演逻辑/覆盖闭环——是否覆盖 objectives 的覆盖目标？章节间是否一致？"部分测绘"是否如实标注？
- **红蓝对抗子 agent**：攻击这本书——揪 ①把行为结论标了「已确认」②编造/失效引用 ③objectives 要求覆盖却漏测/浅测的关键子系统 ④在覆盖远未达目标时却口吻像"已完成" ⑤密钥原文泄漏。
- 每条发现按 **P0–P3** 分级（同 Sandtable 口径）。审核报告写入 `docs/codebook/audit/audit-<n>.md`。
- 若宿主并行子 agent 不可用：**仍须用独立上下文**跑审核（如串行依次起独立审核 agent / 子进程），**不得**用写书的同一上下文自审顶替。

**SIGN-OFF（对照目标验收，决定是否 DONE）**：
- **P0/P1 清零** 且 **覆盖达 objectives 目标**（或开发者明确接受残余）→ 才可标 DONE。
- 否则 → 回 SURVEY/SYNTHESIZE/PRESENT **再做一轮**（深化漏测区、修正过度声明），再 AUDIT。循环到达标。
- DONE 时在书首页写明：对照 objectives 的**覆盖达成度**、剩余残余、审核轮数。

**红旗（出现即违规）**：扇出失败就浅扫宣布完成 · 用 `review` 顶替 `AUDIT` · 覆盖 10% 却不标目标缺口 · 审核 agent 与写书 agent 同上下文。

详见 `references/objectives.md`、`references/supervision.md`。

---

## 2.6 覆盖模式（`--coverage focused|full`）

| 模式 | 覆盖契约 | 完成定义 | 适用 |
|---|---|---|---|
| `focused`（默认） | objectives 覆盖矩阵：核心 L3 + 长尾 L1，长尾可留后续轮 | 必覆盖子系统达目标深度 | 快速 onboarding |
| **`full`** | **manifest：枚举全部 in-scope 文件，逐一画像** | **manifest TODO 100% 勾完** | **一次性全覆盖、不留下一轮 / 审计 / 完整知识库** |

**`full` 模式要点**（详见 `references/file-portraits.md`）：
1. **MANIFEST**：**先界定干净范围**（见 `references/scoping.md`）——① 生成 `.codebookignore`（种子=项目 `.gitignore` + Living Codex 默认：构建产物/二进制/非代码资源(图片视频音频)/**本 skill 自身安装副本 `.agents/.claude/.cursor/.kiro`**/codebook 产物），② 文件夹分批派**单一职责侦察子 agent**（只报客观事实+建议、ESCALATE 交人）③ 主 agent 决策 ④ **对 `.codebookignore` 做推演+红蓝对抗**（审"该进的没误排、垃圾没混入、没靠扩大忽略缩分母假全覆盖"）⑤ **人最终审批范围（硬门禁）**。**未获人批准，禁止建 manifest、禁止开绘。** 批准后才应用 ignore 用 `find` 列 in-scope 文件 → `docs/codebook/manifest.md`。**这个人审过的干净总数 = 分母。**
2. **PORTRAIT**：按 manifest **逐文件**用 `templates/file-portrait.md` 产画像（聚合进 `portraits/<module>.md`），完成一个勾一个 `[x]`；超大/生成码画不动标 `[~]`+写明原因入未解之谜（仍计已处理，不许跳过不记）。
3. **DONE 闸门（核心）**：manifest 还有 `- [ ]` → **未完成、自动接着 grind**（resume 从第一个未勾处继续，**这是自动续跑、不是要用户决策的"下一轮"**）；**TODO 未清零禁止进 SYNTHESIZE 或宣布完成**。全勾完才 SYNTHESIZE→PRESENT→AUDIT→SIGN-OFF。
4. 诚实不变：全覆盖=每个文件都有画像卡，**不等于**每个文件都运行验证；行为结论照样「推断」。排除清单须在 manifest 显式列出，不许缩小分母假装全覆盖。
5. AUDIT 加查 manifest 覆盖率=100%；"未勾却宣布完成"= **P0**。

---

## 3. 编排集中化铁律（不可违背）

> 来源：宿主约束——子 agent 不能再生成子 agent、并行 agent 之间不可通信、并发有硬上限。

1. **扇出只在顶层主 agent 发生**。子 agent 是**只读叶子**：**不再生成下级子 agent**。
2. **状态只有主 agent 写**。`survey-state.md` / `log.md` **仅主 agent 单线程回填**；叶子 agent **只写自己的** `territory-report-<id>.md`，不碰共享状态。
3. **并发 = `min(宿主上限(通常≈4–5), 待测 territory 数)`**，靠**串行分批**覆盖全量。
   - **绝不宣称「100 并行」** 或任何宿主做不到的标称。
   - 降级阶梯：并发受限 → 减小批大小 → 退化为**串行**逐个。串行下仍覆盖全部 territory，不丢章节。
4. **续跑**：中断后主 agent 读 `survey-state.md`，从未完成处继续，不重复已 done、不漏 todo。
5. **扇出失败不得静默判完成**：若并行叶子 agent 扇出**返回空/不可用**（很多宿主如此），主 agent **必须**：①在 `survey-state.md` 与书首页**显著记录"扇出降级为串行"**；②**重新评估覆盖目标**——串行单 agent 啃不动大项目全量，要么按 `objectives.md` 的覆盖目标**分多轮**串行覆盖，要么向开发者说明"本轮只覆盖 X，其余进未解之谜"。**绝不允许**扇出失败 → 单 agent 浅扫 7 个模块 → 直接宣布 done。覆盖缺口由 **AUDIT 阶段**对照 objectives 强制揪出。

---

## 4. 诚实红线声明（核心，贯穿全程）

- **confidence 三档**：`已确认`（仅字面存在性，已 grep 核验） / `推断` / `未解之谜`。
- **「已确认」语义严格收紧**：仅 = 被引符号/字符串字面存在性被机械 grep 核验。**不等于语义为真**。
- **行为/关系/顺序/因果/运行期/动态结论**（包括但不限于「调用 / 在…之前 / 触发 / 回滚 / 不重试 / 并发 / 校验 / 持久化 / 加锁 / 去重」；判定准则：**凡需运行、或需读多处控制流才成立的谓语 = 行为性**）→ **任何档位最高只能「推断」**，**禁止**标「已确认」或「已确认(解析器)」。
- **解析器后端档**只允许把**静态结构结论**（import / 定义 / 调用点语法存在 / 静态调用边）升级为「已确认(解析器)」；对调用**只担保「调用点语法存在」**，被调具体实现/多态/接口/DI/反射**一律「推断」**。**运行期/动态行为永远「推断」**。
- **「已确认」的机械回查是必需而非可选**：宿主无 `scripts/verify-citations.sh` 或等价 grep 回查能力时，**「已确认」档不可用，自动降级为「推断」**。
- **不编造 file:line**；**不强行标不可信行号**充当「已确认」（LLM 行号不可信，引用用「文件 + 可 grep 符号名/字符串」）。
- **不假装验证**：自审产物**绝不**出现「已验证 / 已确认运行行为」等措辞（详见 §6）。
- **不写密钥/PII 原文**（含中间产物 `territory-report`/`log`）；零运行时下这是**尽力而非保证**，须向开发者明示。

---

## 5. 双档承诺（随后端升降，PRESENT 落实）

| 档位 | 书首页标称 | 静态结构结论 | 行为/运行期/跨边结论 |
|---|---|---|---|
| **纯模式 `backend=none`** | 「最佳努力 onboarding 草稿」 | 最高「已确认」=字面存在性（需 grep 回查能力，否则降「推断」） | 一律「推断」 |
| **解析器后端 `backend=codegraph`** | 「解析器后端」 | 可标「已确认(解析器)」（import/定义/调用点/静态边） | 仍一律「推断」 |

承诺随档位同步升降。**confidence 图例必须逐章首显著放出**（含「已确认=仅字面存在性、非语义/运行验证」的释义），免责不止书首页一处。

---

## 6. 二次自审（`review`，诚实化的原"自我红蓝对抗"）

- **确定性项硬查**：被引符号/文件不存在、`[[wikilink]]` 失效、孤儿页；对每条「已确认」**强制跑 grep 回查**。
- **「文本内部自相矛盾」仅 advisory**：只提示，**不参与「通过」判定**，**不擅自改写消解**（无运行时真值不挑一边改）。
- **硬声明**：自审结果 = 「**未被二次复读证伪**」≠「运行时已验证」。**绝不打「已验证」标签、绝不给安全感保证**。需运行才能定的结论一律进「未解之谜」。

详见 `references/self-review.md`、`prompts/self-review.md`。

---

## 7. 降级总则

| 缺失能力 | 降级行为 |
|---|---|
| 无 grep 回查 (`verify-citations.sh`/等价) | 「已确认」档**不可用**，全部降「推断」 |
| 无解析器后端 (codegraph) | `backend=none`，跨边/运行期标「推断」，首页标「草稿」 |
| 无 repomix (`pack-context.sh`) | 用方法论手动按文件清单读取，不影响结构完整性 |
| 无哈希脚本 | lint 增量降级为「按 git diff 文件名重测相关章节」 |
| token 预算超限 | 该 territory 降级为摘要级 → 章节显著标「部分测绘」、未读文件入该章「未解之谜」、confidence 不得标已确认 |

降级必须在产物里**显式说明**，不静默。

---

## 8. 命令面（方案 A）

`map`（测绘建书；**默认含 OBJECTIVES 先定目标 + AUDIT 独立审核 + SIGN-OFF 验收**；`--coverage focused|full`，`full`=枚举全部文件逐一画像、grind 到 manifest 100% 才算完、续跑自动接力，见 §2.6） / `ask`（只读问答带引用） / `audit`（独立子 agent 审核） / `review`（轻量自审） / `lint`（advisory 保鲜） / `onboard`（依赖序路线）。

**本期无 `check`（PR 硬门禁已删）**，无 `ask --save`（避免无界增长与一致性问题）。

详见 `README.md`。

---

## 9. 多宿主触发

本 skill 是纯方法论 + 可选 shell 脚本，不绑死语言栈/runtime。在支持 skill/子 agent 的宿主（Claude Code / Cursor / Codex / Gemini / Kiro 等）中加载本 SKILL.md 即可；扇出能力随宿主自适应（见 §3 降级阶梯）。可选脚本为纯 shell（grep/sed），缺失即降级。
