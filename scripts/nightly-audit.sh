#!/usr/bin/env bash
# 夜间巡检 — 文档过期、结构约束、约束偏离
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ISSUES=0

echo "=== 夜间巡检 $(date -u '+%Y-%m-%d %H:%M UTC') ==="
echo ""

# 1. 结构约束
echo "--- 结构约束 ---"
if bash "$ROOT/scripts/check-structure.sh"; then
  echo ""
else
  ISSUES=$((ISSUES + 1))
  echo ""
fi

# 2. 文档新鲜度
echo "--- 文档新鲜度 ---"
if bash "$ROOT/scripts/check-doc-freshness.sh"; then
  echo ""
else
  ISSUES=$((ISSUES + 1))
  echo ""
fi

# 3. 约束偏离：检查 AGENTS.md 中引用的 Prompt 模板是否都有 {{占位符}}
echo "--- 模板完整性 ---"
for template in "$ROOT"/templates/prompts/*.md; do
  name=$(basename "$template")
  if ! grep -q '{{' "$template" 2>/dev/null; then
    echo "⚠️  $name 缺少 {{占位符}}，模板可能不完整"
    ISSUES=$((ISSUES + 1))
  else
    echo "✅ $name 模板 OK"
  fi
done
echo ""

# 4. 安全基线检查
echo "--- 安全基线 ---"
if [[ -f "$ROOT/templates/codex/config.toml.example" ]]; then
  if grep -q 'danger-full-access' "$ROOT/templates/codex/config.toml.example" 2>/dev/null; then
    echo "❌ Codex 配置示例包含 danger-full-access"
    ISSUES=$((ISSUES + 1))
  else
    echo "✅ Codex sandbox 配置 OK"
  fi
fi

if grep -rq '\.env' "$ROOT/.gitignore" 2>/dev/null || [[ -f "$ROOT/.gitignore" ]]; then
  if [[ -f "$ROOT/.gitignore" ]] && grep -q '\.env' "$ROOT/.gitignore"; then
    echo "✅ .gitignore 排除 .env"
  else
    echo "⚠️  .gitignore 未排除 .env"
    ISSUES=$((ISSUES + 1))
  fi
else
  echo "⚠️  缺少 .gitignore"
  ISSUES=$((ISSUES + 1))
fi
echo ""

# 5. 汇总
echo "=== 巡检完成：$ISSUES 个问题 ==="
if [[ "$ISSUES" -gt 0 ]]; then
  exit 1
fi
exit 0
