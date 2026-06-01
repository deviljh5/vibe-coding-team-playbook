# 指标框架

团队 Vibe Coding 协作的核心度量指标。

## 指标分类

### 1. 交付速度

| 指标 | 定义 | 目标 | 采集方式 |
|------|------|------|----------|
| PR 周期 | PR 创建 → 合并的时间 | < 24h (S/M PR) | GitHub API |
| 吞吐量 | 每周合并 PR 数 | 团队基线 +10%/月 | GitHub API |
| 返工率 | Request Changes 次数 / 总 PR | < 30% | GitHub API |
| Agent 任务完成率 | Agent 独立完成 / 总任务 | > 60% | Issue 标签 |

### 2. 质量结果

| 指标 | 定义 | 目标 | 采集方式 |
|------|------|------|----------|
| 缺陷逃逸率 | 合并后 7 天内发现的 bug / 总 PR | < 10% | Issue 标签 |
| 回滚率 | revert PR / 总 PR | < 5% | GitHub API |
| 测试稳定性 | flake 测试次数 / 总运行 | < 2% | CI 日志 |
| CI 通过率 | 首次 CI 通过 / 总 PR | > 80% | GitHub Actions |

### 3. Agent 质量

| 指标 | 定义 | 目标 | 采集方式 |
|------|------|------|----------|
| 建议采纳率 | 合并代码中 Agent 生成 / 总代码 | 跟踪趋势 | git blame 分析 |
| 一次通过率 | 无 Request Changes 的 PR / 总 PR | > 50% | GitHub API |
| AI 评审命中率 | 有效 AI 评论 / 总 AI 评论 | > 80% | Review 分析 |
| 验证脚本通过率 | validate.sh 首次通过 / 总运行 | > 90% | 本地/CI 日志 |

## 数据采集

```bash
# 采集当前指标快照
./scripts/metrics-collect.sh

# 输出到 docs/metrics/dashboard-data.json
```

## 看板使用

1. 每周一运行 `metrics-collect.sh`
2. 打开 `docs/metrics/dashboard-data.json` 查看看板数据
3. 在每周复盘中使用（见 `weekly-retrospective.md`）

## 基线建立

第 1-2 周不做目标考核，只采集数据建立基线。
第 3 周起设定目标，第 4 周收敛流程。

## 指标不应导致的扭曲

- 不以 PR 数量作为个人 KPI（鼓励小 PR 而非刷量）
- 不以 Agent 生成比例为唯一效率指标（质量优先）
- 不惩罚 Request Changes（审查是质量投资）
