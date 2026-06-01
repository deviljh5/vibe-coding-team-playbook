# 新成员 Day 1 上手清单

目标：新成员在 1 天内能独立使用 Cursor/Codex 完成一个标准任务并提交 PR。

## 上午：环境与规则（2-3 小时）

### 1. 工具安装

- [ ] 安装 Cursor IDE（团队版账号）
- [ ] 安装 Git、Node.js（或项目所需运行时）
- [ ] Clone 业务仓库 + 本 playbook 仓库

### 2. 阅读核心文档（按顺序）

- [ ] [AGENTS.md](../../AGENTS.md) — 15 分钟
- [ ] [docs/architecture/system-overview.md](../architecture/system-overview.md) — 15 分钟
- [ ] [docs/sop/task-lifecycle.md](../sop/task-lifecycle.md) — 15 分钟
- [ ] [docs/sop/pr-guidelines.md](../sop/pr-guidelines.md) — 10 分钟
- [ ] `.cursor/rules/` 全部规则 — 10 分钟

### 3. 配置 Cursor

- [ ] 确认项目规则已从 `.cursor/rules/` 加载（Settings → Rules）
- [ ] 确认 `.cursorignore` 已生效
- [ ] **不要**用个人 global rules 覆盖项目规则
- [ ] 配置 MCP servers（如团队使用 GitHub/Jira MCP）

## 下午：实战练习（3-4 小时）

### 4. 示例任务

由 mentor 分配一个 `< 100 行 diff` 的入门任务，例如：

- 给某个文档补充一节说明
- 修复一个带测试的 trivial bug
- 添加一个脚本的小功能

### 5. 按标准流程执行

- [ ] 使用 `templates/prompts/feature-task.md` 或 `bugfix-task.md` 描述任务
- [ ] 让 Agent 先做影响面分析（`impact-analysis.md`）
- [ ] mentor 确认计划
- [ ] Agent 编码 + 运行 `./scripts/validate.sh`
- [ ] Agent 自审（`self-review.md`）
- [ ] 提交 PR，使用 PR 模板

### 6. Review 与合并

- [ ] mentor review PR，给出反馈
- [ ] 新成员根据反馈修改
- [ ] 合并

## 验收

- [ ] 能独立使用 Prompt 模板发起 Agent 任务
- [ ] 能运行本地验证脚本
- [ ] 能按 PR 模板提交合规 PR
- [ ] 知道遇到阻塞时查哪些文档、找谁

## 常见问题

**Q: Agent 生成的代码风格不一致？**
A: 检查是否正确加载了 `.cursor/rules/`，清理 personal global rules 冲突。

**Q: Agent 改动了不该改的文件？**
A: 在 Prompt 中明确"允许修改"和"禁止修改"范围，参考模板。

**Q: 大仓库 Agent 响应慢或不准确？**
A: 检查 `.cursorignore`，会话聚焦到具体子目录，用 `@filename` 而非 `@codebase`。
