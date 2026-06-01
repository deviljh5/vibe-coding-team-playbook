# 系统总览

本 playbook 仓库为团队 Vibe Coding 协作的**模板与规范载体**，不包含业务代码。

## 系统定位

```
┌─────────────────────────────────────────────────┐
│              业务仓库 (your-app)                 │
│  ┌─────────┐  ┌─────────┐  ┌──────────────┐    │
│  │ 前端    │  │ 后端    │  │ 基础设施     │    │
│  └────┬────┘  └────┬────┘  └──────┬───────┘    │
│       └────────────┼───────────────┘            │
│                    │                            │
│         .cursor/rules/ + AGENTS.md              │
│         (从 playbook 复制并适配)                 │
└────────────────────┬────────────────────────────┘
                     │ 规范来源
┌────────────────────▼────────────────────────────┐
│         vibe-coding-team-playbook              │
│  规则 · 模板 · SOP · 质量门禁 · 指标框架        │
└─────────────────────────────────────────────────┘
```

## 核心组件

| 组件 | 路径 | 作用 |
|------|------|------|
| Agent 导航 | `AGENTS.md` | Agent 入口，指向所有深层文档 |
| Cursor 规则 | `.cursor/rules/` | 编码约束，提交到版本控制 |
| Prompt 模板 | `templates/prompts/` | 统一任务描述格式 |
| 架构文档 | `docs/architecture/` | 模块边界与数据流 |
| SOP | `docs/sop/` | 任务生命周期与 PR 规范 |
| 质量门禁 | `docs/quality/` + `.github/workflows/` | CI 自动检查 |
| 安全策略 | `docs/security/` | 权限分级与审计 |
| 指标框架 | `docs/metrics/` | 交付与质量度量 |
| 约束脚本 | `scripts/` | 可执行的架构/文档检查 |

## 采用方式

1. **Fork 或 copy** 本仓库的内容到你的业务仓库
2. 修改 `AGENTS.md` 和 `.cursor/rules/` 适配你的技术栈
3. 在 `docs/architecture/` 中替换为你的系统架构
4. 启用 `.github/workflows/` 中的 CI 门禁
5. 按 4 周节奏逐步落地（见 README.md）

## 技术栈（本 playbook 自身）

- Shell 脚本（bash）— 约束检查
- Markdown — 全部文档
- GitHub Actions — CI 示例
- Cursor Rules（.mdc）— Agent 行为约束
