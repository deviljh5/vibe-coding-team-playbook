# Vibe Coding Team Playbook

大型项目团队在 Cursor / Codex 上的协作规范与模板。**一条命令安装到你的项目，无需手抄文件。**

## 一键安装（推荐）

在你的**业务项目根目录**执行：

```bash
# 本地 playbook 路径安装（把路径换成你的 clone 位置）
~/Projects/vibe-coding-team-playbook/install.sh . --with-ci --push
```

或从 GitHub 拉取安装：

```bash
curl -fsSL https://raw.githubusercontent.com/deviljh5/vibe-coding-team-playbook/master/install.sh | bash -s -- . --with-ci --push
```

| 选项 | 作用 |
|------|------|
| `.` | 安装到当前目录 |
| `--with-ci` | 附带 GitHub Actions 质量门禁 |
| `--push` | 自动 git 提交并推送 |
| `--force` | 覆盖已有 `AGENTS.md` |

**Makefile 等价命令：**

```bash
make setup TARGET=~/Projects/your-app   # 安装 + CI + 推送
```

安装后会自动带上：

- `.cursor/rules/` — Cursor 团队规则
- `AGENTS.md` — Agent 导航入口
- `docs/` — SOP、架构、安全、指标文档
- `templates/prompts/` — 标准 Prompt 模板
- `scripts/validate.sh` — 本地一键验证
- `.github/` — PR 模板与 CI（加 `--with-ci` 时）

## 日常只用这三件事

1. **开任务** — 复制 `templates/prompts/feature-task.md` 到 Cursor 对话
2. **提交前** — 运行 `./scripts/validate.sh`
3. **提 PR** — 用自动加载的 PR 模板，贴测试证据

## 新成员上手

运行安装命令后，读 [docs/onboarding/day-one-checklist.md](./docs/onboarding/day-one-checklist.md)（约半天）。

## 4 周落地节奏

详见 [docs/implementation/4-week-rollout.md](./docs/implementation/4-week-rollout.md)。

## 仓库结构

```
.cursor/rules/     # 团队规则（版本化）
AGENTS.md          # Agent 入口地图
docs/              # SOP / 架构 / 安全 / 指标
templates/         # Prompt / PR / CI 模板
scripts/           # validate、bootstrap、巡检
.github/           # PR 模板 + Actions
install.sh         # 一键安装入口
```

## 许可

MIT
