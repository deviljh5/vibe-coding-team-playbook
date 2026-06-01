# 质量门禁

CI 与本地验证的质量检查项定义。

## 门禁层级

```
L1 本地验证 (开发者/Agent)     ./scripts/validate.sh
L2 PR 自动检查 (CI)            GitHub Actions
L3 AI 代码评审 (CI)            PR 创建时自动触发
L4 人工审查 (Reviewer)         关键风险点
```

## L1：本地验证

| 检查项 | 脚本 | 失败时 |
|--------|------|--------|
| 结构约束 | `check-structure.sh` | 错误信息含修复指引 |
| 文档新鲜度 | `check-doc-freshness.sh` | 警告 > 90 天未更新 |

```bash
./scripts/validate.sh
```

## L2：CI 自动检查

PR 创建/更新时自动运行（见 `.github/workflows/quality-gate.yml`）：

| Job | 检查内容 | 阻断合并 |
|-----|----------|----------|
| structure-check | 必需文件、AGENTS.md 行数、模板完整性 | 是 |
| doc-freshness | 关键文档新鲜度、链接有效性 | 是（错误）/ 否（警告） |

## L3：AI 代码评审

PR 从 draft → ready for review 时触发 AI 评审：

### 评审维度

1. **范围**：改动是否在 PR 描述范围内？
2. **架构**：是否违反 module-boundaries？
3. **安全**：硬编码密钥、不安全操作？
4. **测试**：新代码有无测试覆盖？
5. **文档**：公共 API 变更有无文档更新？

### 配置方式

**Cursor 团队**：启用 Cursor Bugbot 或在 PR 中 @cursor review

**Codex 团队**：通过 GitHub webhook 触发 Codex CLI 评审

```bash
# Codex CLI 评审示例
codex exec --prompt "$(cat templates/prompts/self-review.md)" \
  --sandbox workspace-write \
  --approval-policy untrusted
```

### 信号质量目标

- AI 评审命中率 > 80%（有效评论 / 总评论）
- 误报率 < 20%
- 人工 reviewer 因 AI 已覆盖而节省 > 30% 时间

## L4：人工审查

聚焦 AI 无法判断的风险：

| 检查项 | 谁审 |
|--------|------|
| 架构决策 | AI Tech Lead |
| 安全合规 | Security Owner |
| 业务逻辑正确性 | Feature Owner |
| 性能影响 | 相关模块 owner |

## 失败处理

| 失败类型 | 处理方式 |
|----------|----------|
| 结构检查失败 | Agent 读修复指引，自动修复 |
| 文档过期警告 | 创建 docs 更新 task |
| AI 评审误报 | Reviewer dismiss + 反馈给 AI Tech Lead |
| 测试 flake | 重跑 1 次 → 仍失败 → 创建 fix-flake issue |
| 合并冲突 | PR 作者 rebase 并重新验证 |

## 夜间巡检

每日 02:00 UTC 运行 `scripts/nightly-audit.sh`：

- 文档过期扫描
- 结构约束检查
- 约束偏离检测
- 有问题自动创建 GitHub Issue

## 质量等级

对代码库各区域评级（adapt 到你的业务仓库）：

| 等级 | 含义 | 要求 |
|------|------|------|
| A | 完全合规 | 测试覆盖 > 80%，文档完整，无约束偏离 |
| B | 基本合规 | 测试覆盖 > 60%，主要文档存在 |
| C | 需改进 | 测试覆盖 < 60% 或文档缺失 |
| D | 高风险 | 无测试或严重约束偏离 |

评级记录在 `docs/metrics/quality-grades.md`，每周更新。
