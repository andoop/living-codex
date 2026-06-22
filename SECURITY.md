# Security Policy

## 报告漏洞
请**不要**公开提交安全问题。通过私有渠道（GitHub Security Advisory 或维护者邮箱）报告，我们会尽快响应。

## Living Codex 的安全边界（务必知悉）
Living Codex 是只读测绘 skill，但它运行在你的 AI agent 里、能读你的源码：

- **密钥/PII**：skill 规定只记键名/位置、不写原文（含中间产物与日志）。但**零运行时下这是「尽力而非保证」**——LLM 行为是概率性的。处理含密钥的仓库时，建议启用可选 `scrub-secrets.sh` 并人工复核产物 `docs/codebook/` 后再提交/共享。
- **只读**：skill 不修改你的源码；若发现任何写入目标源码的行为，请按漏洞上报。
- **产物外泄**：`docs/codebook/` 是普通 Markdown，可能含敏感架构信息——提交/共享前自行评估。

## 支持版本
最新发布版接受安全修复。
