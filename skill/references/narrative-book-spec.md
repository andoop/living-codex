# references/narrative-book-spec.md — 业务导览书产物规范（Obsidian vault）

> 落实 SKILL.md PRESENT 阶段。定义 `docs/codebook/narrative/` 的目录布局、互链约定、首页索引、onboarding 顺序与 Obsidian 兼容。
> 一切呈现都不改变诚实纪律：行为/连边/因果结论最高「推断」（见 `honesty-charter.md`）。

---

## 目录布局

```
docs/codebook/narrative/
├── index.md                 # OKF 机读渐进披露目录（OKF §6 · 无 frontmatter · 模板 index.md）
├── log.md                   # OKF 文档变更史（OKF §7 · ISO 日期倒序 append-only · 无 frontmatter · 模板 log.md）
├── L0-product.md            # 人读首页：诚实声明 + 旅程 TOC + 能力域图 + onboarding（type: product · 模板 narrative-L0-product.md）
├── L1-domains.md            # 能力域地图（type: domain-map · 无独立模板，本 spec 强制 frontmatter）
├── glossary.md              # 术语白话表（type: glossary · 模板 glossary.md）
├── journeys/
│   └── <journey-id>.md      # 每条业务旅程：L2 主干 + L3/L4 折叠（type: journey · 模板 narrative-journey.md）
├── rules/
│   └── <rule-id>.md         # 可复用业务规则（type: rule · 模板 narrative-rule.md）
├── portraits/
│   └── <module>.md          # L5 证据画像，逐文件聚合（type: portrait · 模板 file-portrait.md）
├── entry-ledger.md          # 入口账本（type: ledger · 含 ENTRY_CAND_CLAIMED: 锚点行）
├── edge-ledger.md           # 连边账本（type: ledger · 含 EDGE_FIRE_CLAIMED: 锚点行）
├── coverage-ledger.md       # 三账本汇总（type: ledger · 含 CODE_DENOM_CLAIMED: 锚点行）
├── state-ledger.md          # 状态/横切账本（type: ledger · 含 STATE_SIG_CLAIMED: 锚点行 · 无独立模板，本 spec 强制 frontmatter）
├── manifest.md              # 文件级 FULL manifest（type: ledger · 无独立模板，本 spec 强制 frontmatter）
├── blind-spots.md           # 已知缺失/未测子系统专章（type: blind-spots · 无独立模板，本 spec 强制 frontmatter）
└── audit/
    └── audit-narrative-<n>.md   # 独立审核战报（type: audit · 无独立模板，本 spec 强制 frontmatter）
```

> 目标项目根放 `.codebookignore`（范围契约，见 `scoping.md`）。

---

## 每 concept 文档结构（线上白话 / 线下证据 · 见 `plain-language.md`）

除保留文件 `index.md`/`log.md` 外，每个 concept `.md` 自上而下：

1. **OKF frontmatter**（`type` 必填 + `title`/`description`/`tags`/`timestamp` 荐；内容纪律见 `plain-language.md` §4/§5）。
2. **章首白话可信度声明**（默认可见，承载"推断"基线 · M10）。
3. **线上白话正文**：面向小白、零未解释术语、产品/交互视角；**关键结论编号 ①②③**。
4. **`## 还不知道什么`（gap）**：白话、线上可见；装"未解之谜"（M6/M8）。
5. **`## 证据与可信度`（线下 · 可折叠 `<details>`）**：confidence 三档 + `文件 :: 符号` 锚点，**按线上同号 ①②③ 列**，逐条可绑定（M2）；完整三档释义图例下沉于此（配合 `provenance.md` §K）。

> **frontmatter 强制（无独立模板的产物）**：`L1-domains.md`(`type: domain-map`)、`blind-spots.md`(`type: blind-spots`)、`audit/*.md`(`type: audit`)、`state-ledger.md`(`type: ledger`)、`manifest.md`(`type: ledger`) 由主 agent 按本 spec 生成时**必须**带合规 frontmatter；ledger 类 frontmatter 置于 `*_CLAIMED:` 锚点行之上，不破坏 `ledger-orphans.sh` 行首锚定 grep（实测通过）。
> **glossary / 正文避裸闸门 token**（R1 实测约束）：见 `plain-language.md` §3.1——narrative 文档里写代码名不得用 `WorkManager`/`enqueue(`/`sendBroadcast(`/`checkSelfPermission(`/大写 `TTL`·`TIMEOUT`·`EXPIR`/`isEnabled(` 等裸形，否则污染 `ledger-orphans.sh` 的 entry/edge/state 分母致 `GATE_MISMATCH` 误报；PRESENT 写完须重跑闸门排查。**不改脚本**（守 N5）。

---

## 互链约定（Obsidian 兼容）

- **`[[wikilink]]` 是唯一发射形式**：旅程间、旅程→规则、旅程→画像（L5 锚点）、首页→各账本、首页↔`index.md` 全部用 `[[wikilink]]`。一致性自检 / `verify-citations` 以它为锚。
  - OKF 标准 markdown link（`[文字](路径)`）仅作"可被 OKF 消费端兼容读取"的说明，**生成端不主动发射**（避免标准 link 死链逃过 wikilink 自检）。
- L5 锚点优先 `[[portraits/<module>#<符号>]]`；**长尾无 portrait 的文件**直链 `文件:符号` 并标「证据层未建画像」（纳入 wikilink 有效性检查，不产生死链）。
- 纯 Markdown + 标准 Mermaid，无需插件即可在 Obsidian 打开得图谱/反链/搜索。
- Mermaid 图**必须**带 caption：`本图为静态推断重建，非验证协议……`（防被读成确定的执行顺序/因果）。

---

## L0 首页索引（人读导航中枢）vs index.md（机读目录）— 导航分工（M5）

二者分工明确、**均纳入死链/孤儿自检、互不替代**：
- **`L0-product.md`** = 人读首页（含**诚实声明** + 旅程 TOC + 能力域图 + onboarding 顺序）。
- **`index.md`** = OKF 机读渐进披露目录（按层/主题快速定位，模板 `index.md`，无 frontmatter）。

首页 `L0-product.md` **必须**包含（模板 `templates/narrative-L0-product.md`）：

1. **诚实声明清单**（`honesty-charter.md` 第五条）——**第五条全部诚实信号行本身线上默认可见**（含串行"不等同独立交叉验证"戳记、入口/连边/状态非对称盲区声明）；**仅每条信号的详细释义/账本指针/数字明细**可移入折叠「证据与边界」，**不可整体折叠、也不可只折叠部分信号行**（条目与语义均不可删，M10）。
2. **默认可见的一行白话 honesty banner**（"基于读代码的推断草稿、非已验证事实；覆盖率仅指枚举、机械闸门与审核都不认证业务正确——详见证据与边界"）。
3. **这是什么产品**（≤3 句，白话，禁营销词）。
4. **能干哪几件大事 → 旅程 TOC**（每件大事链到一条 journey）。
5. **能力域图**（链到 `L1-domains`）。
6. **全局 gap 入口**（`## 还不知道什么`，链 `blind-spots`，白话）。
7. **枚举覆盖率总览表**（分子系统，禁单一数字粉饰；冠"枚举"二字；可置于折叠「证据与边界」内的数字明细，但"覆盖率冠枚举二字"这条信号行本身默认可见）。
8. **onboarding 顺序**（见下）。
9. **导航区**：`index`、三账本、盲区专章、manifest、glossary、log、audit。

---

## onboarding 顺序（按业务旅程，替代逐文件路线）

首页给一段**有序的"先读哪条旅程"**清单，让新人按业务依赖、由主干到边缘上手：

```
## 上手顺序（建议按此读）
1. [[journeys/<核心主旅程>]]      — 最高频/最能代表产品的那条；先建主干心智模型
2. [[journeys/<其依赖的旅程>]]    — 主旅程依赖或紧邻的能力域
3. [[journeys/<横切/状态旅程>]]   — 鉴权/权限/同步等横切业务（见状态轴）
4. [[blind-spots]]                — 最后读盲区专章，知道"还有哪些没覆盖"
```

排序原则（均属**推断**，按证据排）：
- 主干优先：从 entry-ledger 里**最高频/最核心入口**对应的旅程起。
- 依赖在先：被多条旅程复用的能力域/规则前置。
- 横切殿后：状态/权限/迁移等第二轴业务，建立主干后再看。
- 盲区收尾：用 `blind-spots.md` 收口，明确未覆盖边界。

> onboarding 顺序是**导航建议**，不是覆盖承诺；它不改变任何 confidence 标注。

---

## 一致性自检（PRESENT 末尾）

- 每条 journey 的 L5 锚点都能解析（`[[portraits/...]]` 存在，或直链文件标了"未建画像"）。
- 首页旅程 TOC 与 `journeys/` 实际文件一一对应，无孤儿、无死链。
- `index.md` 与实际产物一一对应（机读目录无死链）；`L0-product.md` 与 `index.md` 均存在、互不替代。
- 三账本锚点行齐全（`*_CLAIMED:`），`scripts/ledger-orphans.sh` 可读（frontmatter 不破坏行首锚定，实测通过）。
- 覆盖率表每个子系统都冠"枚举"二字、并列两维释义。
- **每 concept 有合法 OKF frontmatter（含 `type`）**；`index.md`/`log.md` **无** frontmatter。
- **每条 journey/rule 与 L0 有 `## 还不知道什么` gap 小节**；线上关键结论编号 ①②③ 与线下证据区同号**无悬空绑定**。
- **闸门 token 体检**：写完 glossary/正文后重跑 `ledger-orphans.sh`；若 entry/edge/state derived 异常偏高，排查 narrative 文档裸 token 污染（`plain-language.md` §3.1），改写后复跑。
