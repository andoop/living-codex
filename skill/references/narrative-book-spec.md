# references/narrative-book-spec.md — 业务导览书产物规范（Obsidian vault）

> 落实 SKILL.md PRESENT 阶段。定义 `docs/codebook/narrative/` 的目录布局、互链约定、首页索引、onboarding 顺序与 Obsidian 兼容。
> 一切呈现都不改变诚实纪律：行为/连边/因果结论最高「推断」（见 `honesty-charter.md`）。

---

## 目录布局

```
docs/codebook/narrative/
├── L0-product.md            # 首页：诚实声明清单 + 旅程 TOC + 能力域图 + onboarding 顺序（模板 narrative-L0-product.md）
├── L1-domains.md            # 能力域地图（一张 Mermaid 关系图 + 各域短描述）
├── journeys/
│   └── <journey-id>.md      # 每条业务旅程：L2 主干 + L3/L4 折叠（模板 narrative-journey.md）
├── rules/
│   └── <rule-id>.md         # 可复用业务规则（模板 narrative-rule.md）
├── portraits/
│   └── <module>.md          # L5 证据画像，逐文件聚合（模板 file-portrait.md）
├── entry-ledger.md          # 入口账本（含 ENTRY_CAND_CLAIMED: 锚点行）
├── edge-ledger.md           # 连边账本（含 EDGE_FIRE_CLAIMED: 锚点行）
├── coverage-ledger.md       # 三账本汇总（含 CODE_DENOM_CLAIMED: 锚点行）
├── state-ledger.md          # 状态/横切账本（含 STATE_SIG_CLAIMED: 锚点行）
├── manifest.md              # 文件级 FULL manifest（覆盖真分母）
├── blind-spots.md           # 已知缺失/未测子系统专章
└── audit/
    └── audit-narrative-<n>.md   # 独立审核战报
```

> 目标项目根放 `.codebookignore`（范围契约，见 `scoping.md`）。

---

## 互链约定（Obsidian 兼容）

- **全部用 `[[wikilink]]`** 相对引用：旅程间、旅程→规则、旅程→画像（L5 锚点）、首页→各账本。
- L5 锚点优先 `[[portraits/<module>#<符号>]]`；**长尾无 portrait 的文件**直链 `文件:符号` 并标「证据层未建画像」（纳入 wikilink 有效性检查，不产生死链）。
- 纯 Markdown + 标准 Mermaid，无需插件即可在 Obsidian 打开得图谱/反链/搜索。
- Mermaid 图**必须**带 caption：`本图为静态推断重建，非验证协议……`（防被读成确定的执行顺序/因果）。

---

## L0 首页索引（导航中枢）

首页 = 进入导览书的唯一入口，**必须**包含（模板 `templates/narrative-L0-product.md`）：

1. **诚实声明清单**（`honesty-charter.md` 第五条，逐条勾选，不可删）。
2. **这是什么产品**（≤3 句，禁营销词）。
3. **能干哪几件大事 → 旅程 TOC**（每件大事链到一条 journey）。
4. **能力域图**（链到 `L1-domains`）。
5. **枚举覆盖率总览表**（分子系统，禁单一数字粉饰；冠"枚举"二字）。
6. **onboarding 顺序**（见下）。
7. **导航区**：三账本、盲区专章、manifest、audit。

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
- 三账本锚点行齐全（`*_CLAIMED:`），`scripts/ledger-orphans.sh` 可读。
- 覆盖率表每个子系统都冠"枚举"二字、并列两维释义。
