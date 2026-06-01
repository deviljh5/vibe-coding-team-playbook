# 4 周落地实施指南

将 playbook 从模板变为团队实际工作方式的逐步指南。

## 第 1 周：规则与模板统一

**目标**：全团队使用统一的 Agent 规则和 Prompt 模板

### 周一-周二

- [ ] AI Tech Lead 复制 playbook 到你的业务仓库
- [ ] 适配 `.cursor/rules/` 到你的技术栈
- [ ] 适配 `AGENTS.md` 到你的项目结构
- [ ] 团队全员阅读 `docs/onboarding/day-one-checklist.md`

### 周三-周四

- [ ] 选 1 条业务线作为试点
- [ ] 试点成员用 Prompt 模板完成 2-3 个真实任务
- [ ] 收集反馈：哪些规则太严/太松？

### 周五

- [ ] 根据反馈更新规则
- [ ] 运行 `./scripts/metrics-collect.sh` 建立基线
- [ ] 首次 weekly retrospective（简短版）

**验收标准**：
- 100% 试点成员能独立使用 Prompt 模板
- `.cursor/rules/` 已适配并提交

---

## 第 2 周：CI 门禁与小 PR

**目标**：自动质量检查上线，强制小 PR

### 周一-周二

- [ ] 启用 `.github/workflows/quality-gate.yml`
- [ ] 确认 structure-check 和 doc-freshness 在 PR 中运行
- [ ] 配置 PR 模板（`.github/pull_request_template.md`）

### 周三-周四

- [ ] 全部署 AI 代码评审（Cursor Bugbot 或 Codex webhook）
- [ ] 试点成员所有 PR 必须使用 PR 模板
- [ ] 监控 PR 大小分布

### 周五

- [ ] 统计：PR 平均大小、CI 通过率
- [ ] 调整 PR 大小阈值（如需要）
- [ ] weekly retrospective

**验收标准**：
- CI 门禁在所有 PR 中运行
- PR 平均大小 < 400 行

---

## 第 3 周：并行任务与夜间巡检

**目标**：并行 Agent 开发 + 自动化巡检

### 周一-周二

- [ ] 团队培训：git worktree 并行策略
- [ ] 启用 `.github/workflows/nightly-audit.yml`
- [ ] 配置 Codex 安全策略（`templates/codex/config.toml.example`）

### 周三-周四

- [ ] 至少 2 个并行 Agent 任务成功合并
- [ ] 验证夜间巡检 issue 自动创建
- [ ] Security Owner 完成首次审计日志审查

### 周五

- [ ] 统计：并行任务成功率、巡检发现的问题数
- [ ] 更新 `docs/metrics/quality-grades.md`
- [ ] weekly retrospective

**验收标准**：
- 至少 1 次成功的并行 Agent 任务合并
- 夜间巡检运行并生成报告

---

## 第 4 周：收敛与固化

**目标**：按指标收敛流程，输出团队开发手册

### 周一-周二

- [ ] 对比 4 周指标与基线
- [ ] 识别最高 ROI 的 Agent 任务类型
- [ ] 识别必须人工主导的任务类型

### 周三-周四

- [ ] 更新规则/模板（基于 4 周数据）
- [ ] 编写团队专属开发手册（从 playbook 定制）
- [ ] 非试点成员开始使用统一流程

### 周五

- [ ] 最终 weekly retrospective
- [ ] 确定下月改进重点
- [ ] 庆祝 🎉

**验收标准**：
- 全团队使用统一流程
- 指标有可衡量的改善趋势
- 团队开发手册已输出
