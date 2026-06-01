#!/usr/bin/env bash
# 一键将 playbook 安装到目标项目
# 用法: ./scripts/bootstrap-project.sh [目标目录] [--with-ci] [--push]
set -euo pipefail

PLAYBOOK="$(cd "$(dirname "$0")/.." && pwd)"
TARGET=""
WITH_CI=false
DO_PUSH=false
FORCE=false

usage() {
  cat <<'EOF'
用法: bootstrap-project.sh [目标目录] [选项]

选项:
  --with-ci    安装 GitHub Actions 工作流
  --push       安装后自动 git add / commit / push（需在 git 仓库内）
  --force      覆盖已存在的 AGENTS.md
  -h, --help   显示帮助

示例:
  ./scripts/bootstrap-project.sh ~/Projects/my-app
  ./scripts/bootstrap-project.sh . --with-ci --push
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --with-ci) WITH_CI=true; shift ;;
    --push) DO_PUSH=true; shift ;;
    --force) FORCE=true; shift ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "未知选项: $1"; usage; exit 1 ;;
    *)
      if [[ -z "$TARGET" ]]; then
        TARGET="$1"
      else
        echo "多余参数: $1"; usage; exit 1
      fi
      shift
      ;;
  esac
done

TARGET="${TARGET:-.}"
TARGET="$(cd "$TARGET" && pwd)"

if [[ "$TARGET" == "$PLAYBOOK" ]]; then
  echo "ℹ️  目标为 playbook 自身，仅执行校验与 CI 检查。"
  bash "$PLAYBOOK/scripts/validate.sh"
  if [[ "$WITH_CI" == true ]] && [[ ! -f "$TARGET/.github/workflows/quality-gate.yml" ]]; then
    bash "$PLAYBOOK/scripts/install-github-workflows.sh" --copy-only
    [[ "$DO_PUSH" == true ]] && bash "$PLAYBOOK/scripts/install-github-workflows.sh" --commit --push
  fi
  exit 0
fi

echo "=========================================="
echo "  Vibe Coding Playbook 一键安装"
echo "=========================================="
echo "来源: $PLAYBOOK"
echo "目标: $TARGET"
echo ""

copy_dir() {
  local src="$1" dest="$2"
  if [[ ! -d "$src" ]]; then
    return
  fi
  mkdir -p "$dest"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a "$src/" "$dest/"
  else
    cp -R "$src/." "$dest/"
  fi
  echo "✅ 已复制 $(basename "$src")/ → $dest"
}

# 1. Cursor 规则
copy_dir "$PLAYBOOK/.cursor/rules" "$TARGET/.cursor/rules"

# 2. 文档与模板
copy_dir "$PLAYBOOK/docs" "$TARGET/docs"
copy_dir "$PLAYBOOK/templates" "$TARGET/templates"

# 3. 脚本（若已有 scripts/ 则装到 scripts/vibe/，避免覆盖项目脚本）
SCRIPTS_DEST="$TARGET/scripts"
if [[ -d "$TARGET/scripts" ]] && [[ -n "$(find "$TARGET/scripts" -maxdepth 1 -type f 2>/dev/null | head -1)" ]]; then
  SCRIPTS_DEST="$TARGET/scripts/vibe"
  echo "ℹ️  检测到已有 scripts/，playbook 脚本安装到 scripts/vibe/"
fi
copy_dir "$PLAYBOOK/scripts" "$SCRIPTS_DEST"
chmod +x "$SCRIPTS_DEST"/*.sh 2>/dev/null || true
VALIDATE_CMD="./scripts/validate.sh"
[[ "$SCRIPTS_DEST" == *"/vibe" ]] && VALIDATE_CMD="./scripts/vibe/validate.sh"

# 4. AGENTS.md
if [[ -f "$TARGET/AGENTS.md" ]] && [[ "$FORCE" != true ]]; then
  echo "⚠️  已存在 AGENTS.md，跳过（使用 --force 覆盖）"
else
  cp "$PLAYBOOK/AGENTS.md" "$TARGET/AGENTS.md"
  echo "✅ 已安装 AGENTS.md"
fi

# 5. .cursorignore（合并，不覆盖已有行）
if [[ -f "$PLAYBOOK/.cursorignore" ]]; then
  touch "$TARGET/.cursorignore"
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    if ! grep -qxF "$line" "$TARGET/.cursorignore" 2>/dev/null; then
      echo "$line" >> "$TARGET/.cursorignore"
    fi
  done < "$PLAYBOOK/.cursorignore"
  echo "✅ 已合并 .cursorignore"
fi

# 6. GitHub 模板
mkdir -p "$TARGET/.github/ISSUE_TEMPLATE"
[[ -f "$PLAYBOOK/.github/pull_request_template.md" ]] && \
  cp "$PLAYBOOK/.github/pull_request_template.md" "$TARGET/.github/pull_request_template.md"
[[ -f "$PLAYBOOK/.github/ISSUE_TEMPLATE/agent-task.md" ]] && \
  cp "$PLAYBOOK/.github/ISSUE_TEMPLATE/agent-task.md" "$TARGET/.github/ISSUE_TEMPLATE/agent-task.md"
echo "✅ 已安装 GitHub PR / Issue 模板"

# 7. CI 工作流
if [[ "$WITH_CI" == true ]]; then
  mkdir -p "$TARGET/.github/workflows"
  cp "$PLAYBOOK/templates/ci/workflows/"*.yml "$TARGET/.github/workflows/"
  echo "✅ 已安装 GitHub Actions 工作流"
fi

# 8. 本地验证
if [[ -x "$TARGET/$VALIDATE_CMD" ]] || [[ -x "$TARGET/scripts/validate.sh" ]] || [[ -x "$TARGET/scripts/vibe/validate.sh" ]]; then
  echo ""
  echo "--- 运行本地验证 ---"
  (cd "$TARGET" && bash "${VALIDATE_CMD#./}") || echo "⚠️  验证有警告，可稍后修复"
fi

# 9. 可选 git 提交推送
if [[ "$DO_PUSH" == true ]] && git -C "$TARGET" rev-parse --git-dir >/dev/null 2>&1; then
  echo ""
  echo "--- Git 提交与推送 ---"
  git -C "$TARGET" add .cursor .cursorignore AGENTS.md docs templates scripts .github 2>/dev/null || true
  if ! git -C "$TARGET" diff --cached --quiet; then
    git -C "$TARGET" commit -m "$(cat <<'EOF'
chore: bootstrap vibe coding team playbook

Add Cursor rules, AGENTS.md, SOP docs, prompt templates, validation scripts, and optional CI workflows.
EOF
)"
    git -C "$TARGET" push 2>/dev/null || git -C "$TARGET" push -u origin HEAD
    echo "✅ 已提交并推送到远程"
  else
    echo "ℹ️  无变更需要提交"
  fi
fi

echo ""
echo "=========================================="
echo "  安装完成"
echo "=========================================="
echo "下一步（可选）:"
echo "  • 在 Cursor 打开项目，确认 Rules 已加载"
echo "  • 编辑 AGENTS.md 适配你的项目结构"
echo "  • 发起任务时用 templates/prompts/feature-task.md"
if [[ "$WITH_CI" != true ]]; then
  echo "  • 启用 CI: cd \"$TARGET\" && ./scripts/install-github-workflows.sh --commit --push"
fi
