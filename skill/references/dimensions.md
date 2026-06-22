# references/dimensions.md — 11 测绘维度

> 每个维度给出：**要回答的问题** + **典型取证位置**（去哪 grep/读）。
> 测绘时每维至少产出一个章节或小节（见 `book-spec.md`）。覆盖不到的维度入「未解之谜」，不留白也不脑补。

| # | 维度 | 要回答的问题 | 典型取证位置 |
|---|---|---|---|
| D1 | **架构总览** | 系统由哪些大块组成？分层/边界在哪？ | 顶层目录结构、README、`docs/`、入口文件 |
| D2 | **模块/包** | 每个模块职责是什么？对外暴露什么？ | 包目录、`__init__`/`mod.rs`/`index.ts`、导出清单 |
| D3 | **数据流** | 数据如何在模块间流动？（**关系性→最高推断**） | 函数签名、参数传递、消息/事件名（grep 事件字符串） |
| D4 | **依赖** | 内部/外部依赖有哪些？版本？ | `package.json`/`requirements.txt`/`go.mod`/`Cargo.toml`/import 语句 |
| D5 | **构建与运行** | 怎么 build/run/部署？入口命令？ | `Makefile`/`Dockerfile`/CI 配置/`scripts`/`main` 入口 |
| D6 | **测试** | 测试怎么组织？覆盖了什么？ | `test/`/`__tests__/`/`*_test.go`/测试配置 |
| D7 | **接口/API** | 对外接口有哪些？路由/RPC/CLI？ | 路由定义、controller、`.proto`、OpenAPI、CLI parser |
| D8 | **数据模型** | 核心实体/表/schema 是什么？ | ORM model、migration、`schema.sql`、`*.proto` message |
| D9 | **配置** | 有哪些配置项？默认值/来源？ | `config/`、`.env.example`、settings 模块、环境变量读取处 |
| D10 | **历史/演进** | 近期怎么演进？热点文件？ | `git log`、`CHANGELOG`、高频改动目录（**结论标推断**） |
| D11 | **风险** | 已知坑/TODO/技术债/安全敏感点？ | `TODO`/`FIXME`/`HACK` grep、`SECURITY.md`、敏感配置位置 |

## 取证 → confidence 映射提示
- D2/D4/D8 中**符号/import/定义的字面存在** → 可标「已确认」（须 grep 回查；解析器档可「已确认(解析器)」）。
- D3/D5/D7/D10 中凡涉及「调用 / 触发 / 流向 / 顺序 / 行为」 → **最高「推断」**。
- 任何「需运行才能确定」（如实际运行路径、并发行为、配置在运行期的真实取值） → 「未解之谜」。
