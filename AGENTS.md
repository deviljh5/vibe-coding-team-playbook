# Agent 导航地图

> 本文件是 Agent 的入口地图（约 100 行）。深层规则与文档见下方链接。
> **Agent 无法访问的上下文 = 不存在。** 执行任务前先读相关文档。

## 黄金原则

1. **小步快跑**：单次任务只改一个意图，PR 尽量 < 400 行
2. **先计划后编码**：影响面分析 → 实现计划 → 编码 → 验证 → 自审
3. **测试即约束**：没有测试证据的改动不得合并
4. **不猜架构**：不确定时读 `docs/architecture/`，不要凭空发明模式
5. **最小 diff**：只改任务范围内的文件，不做无关重构

## 目录职责

| 路径 | 职责 | Agent 权限 |
|------|------|------------|
| `docs/` | 团队文档与 SOP | 可读，修改需 PR |
| `.cursor/rules/` | Cursor 团队规则 | 只读，修改需 AI Tech Lead 审批 |
| `templates/` | Prompt / PR 模板 | 可读，按需复制 |
| `scripts/` | 可执行约束脚本 | 可运行，修改需 PR |
| `.github/workflows/` | CI 门禁 | 修改需 Quality Owner 审批 |

## 任务执行流程

```
人类写验收标准 → Agent 影响面分析 → AgentSendPlan → 编码 → 跑验证 → Agent 自审 → 人类审关键风险 → 合并
```

详见 [docs/sop/task-lifecycle.md](./docs/sop/task-lifecycle.md)

## 必读文档索引

- 架构总览：[docs/architecture/system-overview.md](./docs/architecture/system-overview.md)
- 数据流：[docs/architecture/data-flow.md](./docs/architecture/data-flow.md)
- 模块边界：[docs/architecture/module-boundaries.md](./docs/architecture/module-boundaries.md)
- 任务 SOP：[docs/sop/task-lifecycle.md](./docs/sop/task-lifecycle.md)
- PR 规范：[docs/sop/pr-guidelines.md](./docs/sop/pr-guidelines.md)
- 质量门禁：[docs/quality/gates.md](./docs/quality/gates.md)
- 安全策略：[docs/security/policy.md](./docs/security/policy.md)
- 指标复盘：[docs/metrics/weekly-retrospective.md](./docs/metrics/weekly-retrospective.md)

## Prompt 模板

执行任务时使用标准模板，不要即兴发挥：

- 新功能：[templates/prompts/feature-task.md](./templates/prompts/feature-task.md)
- Bug 修复：[templates/prompts/bugfix-task.md](./templates/prompts/bugfix-task.md)
- 重构：[templates/prompts/refactor-task.md](./templates/prompts/refactor-task.md)
- 影响面分析：[templates/prompts/impact-analysis.md](./templates/prompts/impact-analysis.md)
- Agent 自审：[templates/prompts/self-review.md](./templates/prompts/self-review.md)

## 验证命令

```bash
# 结构约束检查
./scripts/check-structure.sh

# 文档新鲜度检查
./scripts/check-doc-freshness.sh

# 完整本地验证（lint + 结构 + 文档）
./scripts/validate.sh
```

## 禁止事项

- 不要提交密钥、token、`.env` 文件
- 不要跳过验证直接请求合并
- 不要在一个 PR 中混合多个不相关意图
- 不要修改 `.cursor/rules/` 除非任务明确要求
- 不要执行 `git push --force` 到 main/master
- 不要安装未审批的外部依赖

## 遇到阻塞时

1. 先查 `docs/architecture/` 和 `docs/sop/`
2. 仍不确定 → 在 PR 中标注 `needs-human-decision` 并说明选项
3. 不要"试 harder"——诊断缺失的能力（工具、文档、约束），补进仓库
