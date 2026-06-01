#!/usr/bin/env bash
# 将 CI 工作流模板安装到 .github/workflows/
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/templates/ci/workflows"
DEST="$ROOT/.github/workflows"

COPY_ONLY=false
DO_COMMIT=false
DO_PUSH=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --copy-only) COPY_ONLY=true; shift ;;
    --commit) DO_COMMIT=true; shift ;;
    --push) DO_COMMIT=true; DO_PUSH=true; shift ;;
    -h|--help)
      echo "用法: install-github-workflows.sh [--copy-only | --commit | --push]"
      exit 0
      ;;
    *) echo "未知选项: $1"; exit 1 ;;
  esac
done

# 默认：有 workflow 权限则 commit+push，否则仅复制
if [[ "$COPY_ONLY" != true ]] && [[ "$DO_COMMIT" != true ]]; then
  if gh auth status 2>&1 | grep -q workflow; then
    DO_COMMIT=true
    DO_PUSH=true
  else
    COPY_ONLY=true
  fi
fi

mkdir -p "$DEST"
cp "$SRC"/*.yml "$DEST/"
echo "✅ 已复制工作流到 $DEST"

if [[ "$COPY_ONLY" == true ]]; then
  if ! gh auth status 2>&1 | grep -q workflow; then
    echo "ℹ️  未推送：gh 缺少 workflow scope。授权后运行: $0 --push"
  fi
  exit 0
fi

if ! gh auth status 2>&1 | grep -q workflow; then
  echo "❌ 需要 workflow scope: gh auth refresh -h github.com -s workflow"
  exit 1
fi

cd "$ROOT"
git add .github/workflows/ 2>/dev/null || true
if git diff --cached --quiet 2>/dev/null; then
  echo "ℹ️  工作流无变更，跳过提交"
  exit 0
fi

git commit -m "$(cat <<'EOF'
Add GitHub Actions workflows for quality gate and nightly audit.

Enable automated structure checks, doc freshness validation, PR size limits, and scheduled repository audits.
EOF
)"

if [[ "$DO_PUSH" == true ]]; then
  git push origin HEAD
  echo "✅ 已推送到 GitHub，Actions 即将生效"
else
  echo "✅ 已本地提交，请手动 git push"
fi
