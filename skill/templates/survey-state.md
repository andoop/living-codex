# survey-state.md — 测绘状态（**仅主 agent 单线程写**）

> 续跑依据。叶子 agent **不写本文件**。

## 全局
- backend: `{{none|codegraph}}`
- depth: `{{L1-L4}}`
- 宿主并发上限(估): `{{≈4-5}}`
- personas: `{{architect,newgrad,security,sre}}`

## Territory 表
| id | 边界(glob) | 文件清单 | 状态 | report | token 预算 | 备注 |
|---|---|---|---|---|---|---|
| t01 | `src/auth/**` | service.py, token.py | done | territory-report-t01.md | 8000 | |
| t02 | `src/api/**` | routes.py, ... | doing | - | 8000 | 中断残留→重置 todo |
| t03 | `src/db/**` | models.py, ... | todo | - | 8000 | |

状态取值：`todo` / `doing` / `done`。
续跑规则：`done` 跳过；`doing` 重置 `todo`；`todo` 继续。

## 批次日志（log.md 摘要，主 agent 写）
- batch1: t01,t02,t03,t04（并发4）→ t01 done, t02 中断
- ...
