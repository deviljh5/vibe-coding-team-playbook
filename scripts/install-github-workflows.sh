#!/usr/bin/env bash
# 将 CI 工作流模板安装到 .github/workflows/
# 需要 gh token 具备 workflow scope：gh auth refresh -h github.com -s workflow
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/templates/ci/workflows"
DEST="$ROOT/.github/workflows"

if ! gh auth status 2>&1 | grep -q workflow; then
  echo "❌ 当前 gh token 缺少 workflow scope。"
  echo "   修复：gh auth refresh -h github.com -s workflow"
  echo "   然后在浏览器完成授权后重新运行本脚本。"
  exit 1
fi

mkdir -p "$DEST"
cp "$SRC"/*.yml "$DEST/"
echo "✅ 已复制工作流到 $DEST"

cd "$ROOT"
git add .github/workflows/
if git diff --cached --quiet; then
  echo "工作流文件无变更，跳过提交。"
else
  git commit -m "$(cat <<'EOF'
Add GitHub Actions workflows for quality gate and nightly audit.

Enable automated structure checks, doc freshness validation, PR size limits, and scheduled repository audits.
EOF
)"
  git push origin HEAD
  echo "✅ 已推送到 GitHub，Actions 即将生效。"
fi
