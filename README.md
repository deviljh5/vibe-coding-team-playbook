# Vibe Coding Team Playbook

大型项目团队在 Cursor / Codex 等 AI 编码工具上的协作实施手册与可复用模板。

## 快速开始

1. 阅读 [AGENTS.md](./AGENTS.md) — Agent 行为边界与导航入口
2. 复制 `.cursor/rules/` 到你的业务仓库并适配
3. 按 [docs/onboarding/day-one-checklist.md](./docs/onboarding/day-one-checklist.md) 完成新成员上手
4. 使用 [templates/prompts/](./templates/prompts/) 中的标准 Prompt 模板发起任务
5. 按 [docs/sop/task-lifecycle.md](./docs/sop/task-lifecycle.md) 执行标准作业流

## 目录结构

```
.
├── AGENTS.md                    # Agent 导航地图（约 100 行，指向深层文档）
├── .cursor/
│   └── rules/                   # 团队级 Cursor 规则（提交到版本控制）
├── .cursorignore                # 大仓库索引排除配置
├── docs/
│   ├── architecture/            # 架构导航（Agent 友好）
│   ├── onboarding/              # 新成员 1 天上手
│   ├── sop/                     # 标准作业流与 PR 规范
│   ├── quality/                 # 质量门禁与自动评审
│   ├── security/                # 安全审批与审计
│   └── metrics/                 # 指标看板与每周复盘
├── templates/
│   ├── prompts/                 # 统一 Prompt 模板
│   ├── pr/                      # PR / Issue 模板
│   └── codex/                   # Codex 配置示例
├── scripts/                     # 可执行约束与巡检脚本
└── .github/
    └── workflows/               # CI 质量门禁示例
```

## 五阶段落地节奏

| 周次 | 目标 | 对应文档 |
|------|------|----------|
| 第 1 周 | 规则与模板统一、选 1 条业务线试点 | `.cursor/rules/`, `templates/prompts/` |
| 第 2 周 | 接入自动评审和基础门禁，强制小 PR | `docs/sop/`, `.github/workflows/` |
| 第 3 周 | 并行任务与夜间巡检上线 | `scripts/nightly-audit.sh`, `docs/quality/` |
| 第 4 周 | 按指标收敛流程，固化为团队手册 | [docs/implementation/4-week-rollout.md](./docs/implementation/4-week-rollout.md), `docs/metrics/` |

## 角色分工

| 角色 | 职责 |
|------|------|
| AI Tech Lead | 维护规则与 Prompt 模板，定义架构边界 |
| Feature Owner | 拆需求、定验收、控范围 |
| Quality Owner | 维护 CI 质量门禁与自动评审 |
| Security Owner | 审批高风险动作与审计日志 |

## 许可

MIT — 按需复制到你的业务仓库并适配。
