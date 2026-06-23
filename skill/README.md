# 活典 · Living Codex (narrator) — 安装与使用

> 最诚实的业务叙事 skill。可移植装进任意项目，把代码库按业务旅程读成一本分档可信的「业务导览书」。
> 完整方法论见 `SKILL.md`，细则见 `references/`。

---

## 安装（可移植，即装即用）

最省事：把下面这段发给你自己的 AI，它会自动装好——
```text
帮我安装 Living Codex 业务叙事 skill：优先执行
curl -fsSL https://raw.githubusercontent.com/andoop/living-codex/main/install.sh | bash
不能跑 shell 就 git 克隆 https://github.com/andoop/living-codex ，把 skill/ 整个目录
复制到本项目的 skill 目录（Kiro: .kiro/skills/narrator/，Claude/Cursor/Codex 类推），结构不变。
装完提醒我重启 agent，并告诉我可发 `narrate --journey <一条旅程>` 试跑。
```

或手动：把整个 `narrator/` 目录复制进目标项目（或宿主 skill 目录）即可：
```
narrator/
├── SKILL.md            # 主方法论（先读这个）
├── README.md
├── references/         # 细则（诚实宪章 / 洋葱模型 / 三账本 / 编排 / 产物规范…）
├── templates/          # L0 首页 / 旅程 / 规则 / 三账本 / 画像 模板
├── prompts/            # 多角色追踪 / 调和 / 独立审核 / 范围侦察 agent prompt
└── scripts/            # 可选 shell 增强（机械闸门 / grep 回查 / 脱敏…）
```
不绑死语言栈/runtime。脚本为纯 shell（grep/sed/find），可选。

## 触发命令面
| 命令 | 作用 |
|---|---|
| `narrate [path]` | 入口驱动梳理全项目业务旅程，产出 L0–L5 业务导览书 |
| `narrate --journey <名>` | 只剥一条指定业务旅程（首次推荐，把大任务切小） |
| `narrate --resume` | 从 `manifest.md` / 三账本断点续跑 |
| `narrate --audit` | 单独再跑一轮独立子 agent 审核 |
| `narrate --lint [--since <ref>]` | advisory 保鲜（git diff 命中 → 标 journey 待复核，不阻断） |

示例：
```
narrate --journey 工程下载            # 首次推荐：先剥一条跑通
narrate .                            # 再铺全项目
narrate --lint --since HEAD~20
narrate --audit
```

## 能力随后端升降（双档承诺）
| 档位 | 标称 | 静态结构 | 行为/运行期/连边 |
|---|---|---|---|
| `backend=none`（纯模式） | 最佳努力业务导览草稿 | 「已确认」=字面存在性（需 grep 回查） | 一律「推断」 |
| `backend=codegraph`（解析器后端） | 解析器后端 | 可「已确认(解析器)」 | 仍一律「推断」 |

## 依赖与降级
| 可选依赖 | 缺失时 |
|---|---|
| `scripts/verify-citations.sh` 或等价 grep | **「已确认」档停用，全部降「推断」** |
| `scripts/ledger-orphans.sh` / grep | "枚举完整"声明不可用，降"分母未机械确认" |
| codegraph 解析器后端 | `backend=none`，连边/运行期标「推断」 |
| repomix（`pack-context.sh`） | 主 agent 按文件清单逐个读取 |
| git | `--lint` 无 file→journey 反向触发，降首页快照声明 |

降级一律在产物里**显式说明**，不静默。

## 诚实红线（一句话）
- 「已确认」**只**担保字面存在性，**不**担保行为/连边为真；
- 行为/流程/连边/顺序/运行期结论**最高「推断」**；
- 机械闸门 exit 0 只证三类枚举完整，**不**等于业务零遗漏/已验证正确；
- 独立 AUDIT **绝不**说「已验证业务正确」；
- 不写密钥/PII 原文（零运行时下尽力而非保证，提供 `scrub-secrets.sh`）；
- 只读不改目标源码（除产物目录 `docs/codebook/narrative/`）。

## 脚本自测
```
bash scripts/verify-citations.sh README.md "Living Codex"   # 应 HIT, exit 0
bash scripts/verify-citations.sh README.md "不存在的符号xyz"  # 应 MISS, exit 1
```
