# 活典 · Living Codex (cartographer) — 安装与使用

> 最诚实的代码理解 skill。可移植装进任意项目，产出分档可信的代码厚书 + onboarding 视角。
> 完整方法论见 `SKILL.md`，细则见 `references/`。

---

## 安装（可移植，即装即用）
把整个 `cartographer/` 目录复制进目标项目（或宿主 skill 目录）即可：
```
cartographer/
├── SKILL.md            # 主方法论（先读这个）
├── README.md
├── references/         # 细则
├── templates/          # 厚书/状态/报告模板
├── prompts/            # 叶子 survey / 自审 agent prompt
└── scripts/            # 可选 shell 增强
```
不绑死语言栈/runtime。脚本为纯 shell（grep/sed），可选。

## 触发命令面（方案 A）
| 命令 | 作用 |
|---|---|
| `map` | 测绘建书（五阶段 SCOPE→PARTITION→SURVEY→SYNTHESIZE→PRESENT） |
| `ask` | 只读问答，回答带「文件+符号」引用 |
| `review` | 二次自审（确定性硬查 + 已确认 grep 回查） |
| `lint` | advisory 保鲜（**无 PR 硬门禁**） |
| `onboard` | 按依赖序的 onboarding 路线 |

> **本期无 `check`（PR 硬门禁已删）**，无 `ask --save`（避免无界增长）。

示例：
```
/codex map . --depth L2 --personas architect,newgrad,security,sre --lang zh
/codex review
/codex lint --since HEAD~20
/codex onboard --persona newgrad --horizon week1
```

## 能力随后端升降（双档承诺）
| 档位 | 标称 | 静态结构 | 行为/运行期/跨边 |
|---|---|---|---|
| `backend=none`（纯模式） | 最佳努力 onboarding 草稿 | 「已确认」=字面存在性（需 grep 回查） | 一律「推断」 |
| `backend=codegraph`（解析器后端） | 解析器后端 | 可「已确认(解析器)」 | 仍一律「推断」 |

## 依赖与降级
| 可选依赖 | 缺失时 |
|---|---|
| `scripts/verify-citations.sh` 或等价 grep | **「已确认」档停用，全部降「推断」** |
| codegraph 解析器后端 | `backend=none`，跨边/运行期标「推断」 |
| repomix（`pack-context.sh`） | 主 agent 按文件清单逐个读取 |
| 哈希脚本 | lint 增量降级为「按 git diff 文件名重测」 |

降级一律在产物里**显式说明**，不静默。

## 诚实红线（一句话）
- 「已确认」**只**担保字面存在性，**不**担保行为为真；
- 行为/关系/顺序/运行期结论**最高「推断」**；
- 自审**绝不**说「已验证」；
- 不写密钥/PII 原文（零运行时下尽力而非保证，提供 `scrub-secrets.sh`）；
- 只读不改目标源码。

## 脚本自测
```
bash scripts/verify-citations.sh README.md "Living Codex"   # 应 HIT, exit 0
bash scripts/verify-citations.sh README.md "不存在的符号xyz"  # 应 MISS, exit 1
```
