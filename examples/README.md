# 示例产物 · Examples

## `llm_wiki-codebook/` — 在真实项目上实跑生成的代码厚书

这是 Living Codex 对真实开源项目 [nashsu/llm_wiki](https://github.com/nashsu/llm_wiki)（Tauri + React + Rust，~378 文件）实跑生成的 codebook，**未经人工美化**，原样收录，用来展示真实手感与诚实分档。

- 档位：`backend=none`（纯模式）· 串行单 agent（宿主无并行 → 自动降级）· L1 全局 + 4 个关键 territory 做 L2。
- 21 章：`README`(TOC+档位+图例) · `00-architecture`(Mermaid) · `20-dataflow`(Mermaid) · `10-modules/`×5 · 依赖/构建/测试/接口/数据模型/配置/历史/风险 · `99-未解之谜` · `personas/`×4。

### 这本书诚实在哪（实测数据）
- confidence 分布：**已确认 97 / 推断 207 / 未解之谜 50** —— 重度偏「推断」，这是「诚实税」：宁可少盖章，不假装懂。
- **0 处**"已验证 / 运行时成立"措辞。
- 每条「已确认」都只担保**字面存在性**，把行为部分显式切出标「推断」。例：
  > **统一流式入口 `streamChat`，按 provider 运行期分派** `已确认（仅字面存在性）` — 引用：`src/lib/llm-client.ts :: streamChat`（脚本回查命中；"按 provider 分派" = 行为性 → **推断**）
- 抽样 5 条「已确认」用 `verify-citations.sh` 对真实源码回查 **5/5 命中**，无幻觉。
- 巨型文件 `ingest.ts`（118KB）显著标 **⚠️ 部分测绘**，正文未读部分入「未解之谜」（成本护栏）。

用 [Obsidian](https://obsidian.md) 打开本目录即得图谱视图与反向链接。
