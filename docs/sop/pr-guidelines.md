# PR 规范

## 核心规则

1. **一个 PR 一个意图** — 不混合功能、修复、重构
2. **小 PR** — 建议 < 400 行 diff，超过需说明理由
3. **测试证据必填** — 命令 + 结果摘要
4. **影响说明必填** — 哪些模块受影响、回归风险

## PR 标题格式

```
<type>(<scope>): <description>

类型:
  feat     新功能
  fix      Bug 修复
  docs     文档
  refactor 重构（无行为变化）
  chore    工具/CI/依赖
  test     测试
```

示例：
- `feat(auth): add OAuth2 login flow`
- `fix(api): handle null response in user endpoint`
- `docs(sop): update task lifecycle step 3`

## PR 大小指南

| 大小 | 行数 | 审查时间 | 建议 |
|------|------|----------|------|
| XS | < 50 | < 15 min | 理想 |
| S | 50-200 | < 30 min | 推荐 |
| M | 200-400 | < 1 hour | 可接受 |
| L | 400-800 | 1-2 hours | 建议拆分 |
| XL | > 800 | > 2 hours | 必须拆分 |

## 审查策略

### 自动化审查（所有 PR）

- CI 结构检查
- CI 文档新鲜度
- AI 代码评审

### 人工审查

| 路径 | 审查要求 |
|------|----------|
| `.cursor/rules/` | AI Tech Lead |
| `.github/workflows/` | Quality Owner |
| `docs/security/` | Security Owner |
| `scripts/check-structure.sh` | Quality Owner |
| 一般代码/文档 | 任意团队成员 |

### 审查重点

Reviewer 不需要逐行看代码，聚焦：

1. **架构**：是否违反 module-boundaries？
2. **安全**：有无密钥泄露、不安全操作？
3. **测试**：覆盖是否充分？
4. **范围**：是否超出任务范围？

## 合并策略

- 默认 **squash merge**
- 需要 1 个 approve（关键目录 2 个）
- CI 必须全绿
- 不 force push 到 main/master

## 测试证据格式

PR 描述中必须包含：

```markdown
## 测试证据

### 自动化
- [ ] `./scripts/validate.sh` — 通过
- [ ] 单元测试 — X passed, 0 failed

### 手动（如适用）
- [ ] 场景 1：步骤 → 预期结果 ✓
- [ ] 场景 2：步骤 → 预期结果 ✓
```

## 并行 PR 合并顺序

多个并行 PR 合并时：

1. 先合并无依赖的基础 PR
2. 被依赖 PR 合并后，rebase 下游 PR
3. 每次合并后在 main 跑 `./scripts/validate.sh`
4. 冲突由下游 PR 作者解决
