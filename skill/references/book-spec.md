# references/book-spec.md — 代码厚书规范（Obsidian vault）

> 落实 FR2/FR5。对应 TC1/TC9。产出落 `docs/codebook/`。

---

## Vault 布局

```
docs/codebook/
├── README.md                 # 书首页：TOC + 当前档位 + 全局免责（用 `templates/codebook-README.md` 生成）
├── 00-architecture.md        # D1 架构总览
├── 10-modules/               # D2 各模块一章
│   └── <module>.md
├── 20-dataflow.md            # D3 数据流（跨边标推断）
├── 30-dependencies.md        # D4
├── 40-build-run.md           # D5
├── 50-testing.md             # D6
├── 60-interfaces.md          # D7
├── 70-data-model.md          # D8
├── 80-config.md              # D9
├── 90-history.md             # D10
├── 95-risks.md               # D11
├── entities/                 # 关键实体页（[[wikilink]] 目标）
├── concepts/                 # 术语表
├── personas/                 # 4 人设视角章节
│   ├── architect.md
│   ├── newgrad.md
│   ├── security.md
│   └── sre.md
├── diagrams/                 # Mermaid 图（分层出图）
└── 99-未解之谜.md            # 集中暴露所有不确定/需运行确认
```

## 书首页 README.md（首页必含）
- **当前档位**：`纯模式（最佳努力 onboarding 草稿）` 或 `解析器后端`。
- **全局免责**：本书是 onboarding 草稿，非运行验证真相；「已确认」仅 = 字面存在性。
- **TOC**：链接到各章 + personas + 99-未解之谜。
- 降级声明（缺哪些可选能力、影响什么）。

## 章节结构（三段式，见 `templates/chapter.md`）
1. **章首 confidence 图例**（逐章必放，FR8）。
2. **摘要**。
3. **关键文件**（文件 + 角色，引用用「文件 + 符号」）。
4. **关键结论**（每条带 `confidence: 已确认|推断|未解之谜` + 引用）。

## Mermaid 分层出图
- 不画一张「全宇宙」大图（会失真）。按 subsystem 分层各出一张，global 图只画 subsystem 间关系。
- 纯模式下跨边连线**注明「最佳努力近似（推断）」**，不画成确定关系。

## 密钥 / PII 红线（含中间产物，TC9）
- 书、`territory-report-*.md`、`log.md` 中**只记键名 / 位置 / 用途**，例：`DB_PASSWORD（位置：.env，用途：数据库连接）`。
- **绝不出现密钥值 / token / PII 原文**。
- 零运行时下这是**尽力而非保证**——须在 README/SKILL 明示，并提供可选 `scripts/scrub-secrets.sh`。

## Obsidian 兼容
- 实体/概念用 `[[wikilink]]` 互链；wikilink 目标必须真实存在（self-review 硬查失效 wikilink/孤儿页）。


## README 验证声明诚实守则（T9 教训）
- README/章节**禁止预先断言**"本书**所有**「已确认」条目均已回查"——除非 REVIEW 阶段确已对**全部**条目跑过 `verify-citations.sh`。
- 只能写**实际回查范围**：如"已确认条目经 verify-citations 回查；本次抽样核验 N/N 命中，全量 `--batch` 回查为后续项"。
- 任何"已回查/已核验"措辞必须对应**真实跑过的**回查；写不出真实范围就不写该声明（呼应 self-review：不假装已核实）。
