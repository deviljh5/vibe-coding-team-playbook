# 安全策略

Agent 权限分级、审批流程与审计要求。

## 权限分级

| 级别 | 名称 | Agent 能力 | 适用场景 |
|------|------|------------|----------|
| L0 | 只读 | 读文件、搜索、分析 | 影响面分析、代码理解 |
| L1 | 工作区写入 | 修改项目内文件 | 日常编码任务 |
| L2 | 命令执行 | 运行测试、lint、构建 | 验证阶段 |
| L3 | 网络访问 | 外网请求、包安装 | 需 Security Owner 审批 |
| L4 | 危险操作 | force push、删分支、改 CI | 禁止 Agent 执行 |

## Cursor 配置

Cursor Agent 默认 L1（工作区写入）。团队规则限制：

- 禁止修改 `.cursor/rules/`（除非 AI Tech Lead 任务）
- 禁止 force push
- 禁止提交 `.env` / credentials
- 安装新依赖需 Feature Owner 确认

## Codex 配置

参考 `templates/codex/config.toml.example`：

```toml
# 推荐生产配置
sandbox_mode = "workspace-write"
approval_policy = "untrusted"  # 不可信命令需人工审批

[network]
# 默认禁止，白名单模式
allow = ["registry.npmjs.org", "pypi.org"]
```

### 审批策略

| approval_policy | 行为 | 推荐场景 |
|-----------------|------|----------|
| on-request | 所有命令需审批 | 高安全环境 |
| untrusted | 不可信命令需审批 | **团队默认** |
| never | 不审批（不推荐） | 仅限只读分析 |
| granular | 按命令类型配置 | 高级定制 |

## 敏感操作审批流程

```
Agent 请求敏感操作
  → 暂停执行
  → 通知 Security Owner / Feature Owner
  → 人类审批或拒绝
  → 记录到审计日志
  → 继续或终止
```

### 需审批的操作

- 安装新 npm/pip/cargo 依赖
- 外网 HTTP 请求（非白名单域名）
- 修改 CI/CD 配置
- 修改安全策略文档
- 访问数据库连接
- 修改 `.cursor/rules/`

## 密钥管理

- **禁止**硬编码密钥、token、密码
- **禁止**提交 `.env`、`.env.*`、`credentials.json`、`*.pem`
- 使用环境变量或密钥管理服务
- `.cursorignore` 和 `.gitignore` 双重排除敏感文件

## 审计日志

### 必须记录的事件

| 事件 | 记录内容 |
|------|----------|
| Agent 提示 | 完整 prompt |
| 工具执行 | 命令、参数、结果 |
| 审批决策 | 批准/拒绝、审批人 |
| 网络请求 | URL、方法、响应码 |
| 文件修改 | 路径、diff 摘要 |

### Codex 遥测

Codex 支持 OpenTelemetry 导出：

```toml
[telemetry]
exporter = "otlp"
endpoint = "http://your-otel-collector:4317"
```

### 审计审查

- Security Owner 每周审查审计日志
- 异常模式（大量失败、越权尝试）自动告警
- 保留期：至少 90 天

## 事件响应

| 严重度 | 示例 | 响应 |
|--------|------|------|
| P0 | 密钥泄露 | 立即轮换密钥，撤销 commit |
| P1 | Agent 越权修改 CI | 回滚 PR，审查 Agent 规则 |
| P2 | 未审批的依赖安装 | revert 依赖，补充审批 |
| P3 | 文档安全策略过期 | 创建更新 task |

## 合规检查清单

- [ ] `.cursorignore` 排除敏感文件
- [ ] `.gitignore` 排除 `.env` 和 credentials
- [ ] Codex `sandbox_mode` 不是 `danger-full-access`
- [ ] Codex `approval_policy` 不是 `never`
- [ ] 审计日志已启用
- [ ] 团队成员了解审批流程
