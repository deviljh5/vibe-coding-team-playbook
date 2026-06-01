# 任务生命周期 SOP

标准作业流：从需求到合并的 5 步闭环。

## 流程总览

```
┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│ 1.定义   │ → │ 2.分析   │ → │ 3.编码   │ → │ 4.自审   │ → │ 5.审查   │
│ 验收标准 │   │ +计划    │   │ +验证    │   │ +PR      │   │ +合并    │
└──────────┘   └──────────┘   └──────────┘   └──────────┘   └──────────┘
  Feature Owner   Agent+Human    Agent          Agent         Human Reviewer
```

## Step 1：定义验收标准（Feature Owner）

**输入**：需求 / Issue / Bug Report
**输出**：填好的 Prompt 模板

1. 选择合适的 Prompt 模板（`templates/prompts/`）
2. 填写：背景、验收标准、范围约束、回归范围、禁止事项
3. 评估任务大小：预计 diff < 400 行，否则拆分

**检查点**：
- [ ] 验收标准可测试（不是模糊描述）
- [ ] 允许/禁止修改范围明确
- [ ] 任务可在一个 PR 内完成

## Step 2：影响面分析 + 实现计划（Agent → Human 确认）

**输入**：Prompt 模板
**输出**：影响面分析文档

1. Agent 使用 `templates/prompts/impact-analysis.md` 输出分析
2. **不写代码**，等待人类确认
3. Feature Owner 审查：
   - 影响范围是否合理？
   - 风险缓解是否充分？
   - 是否需要拆分？

**检查点**：
- [ ] 涉及模块已列出
- [ ] 风险点已识别
- [ ] 测试策略已定义
- [ ] 人类已确认计划

## Step 3：编码 + 验证（Agent）

**输入**：确认后的实现计划
**输出**：代码改动 + 测试

1. 按计划分步编码
2. 每步完成后运行相关测试
3. 全部完成后运行 `./scripts/validate.sh`
4. 测试证据写入 PR 描述

**检查点**：
- [ ] `./scripts/validate.sh` 通过
- [ ] 新功能/Bug 修复有测试
- [ ] diff 在范围内

## Step 4：Agent 自审 + 提交 PR（Agent）

**输入**：代码改动
**输出**：PR

1. 使用 `templates/prompts/self-review.md` 完成自审
2. 创建 PR，使用 `.github/pull_request_template.md`
3. 填写：变更摘要、测试证据、影响范围、自审结果
4. 标注需要的 reviewer（关键目录改动）

**检查点**：
- [ ] PR 模板全部填写
- [ ] 自审清单完成
- [ ] CI 自动检查触发

## Step 5：审查 + 合并（Human Reviewer）

**输入**：PR + CI 结果 + AI 评审
**输出**：合并或反馈

1. 查看 CI 结果（structure-check, doc-freshness）
2. 查看 AI 代码评审评论
3. 重点审查：
   - 架构边界是否遵守
   - 安全风险
   - 测试覆盖
   - 回归风险
4. Approve 或 Request Changes
5. 合并（squash merge 推荐）

**检查点**：
- [ ] CI 全绿
- [ ] 至少 1 人 approve（关键目录 2 人）
- [ ] 无未解决的 review comment

## 并行任务策略

独立子任务使用 git worktree 并行：

```bash
# 创建独立 worktree
git worktree add ../project-feat-auth -b feat/auth
git worktree add ../project-feat-api -b feat/api

# 各 worktree 中独立运行 Agent
# 合并前在 main worktree 跑全量验证
./scripts/validate.sh
```

## 异常处理

| 情况 | 动作 |
|------|------|
| Agent 改动了范围外文件 | Revert 越界改动，重新约束 Prompt |
| CI 失败 | Agent 读错误信息修复，错误信息应包含修复指引 |
| 测试 flake | 重跑 1 次，仍失败则创建 fix-flake issue |
| 需要架构决策 | PR 标注 `needs-human-decision`，暂停等人类 |
| diff > 400 行 | 拆分为多个 PR |
