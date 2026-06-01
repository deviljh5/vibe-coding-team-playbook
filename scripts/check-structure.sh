#!/usr/bin/env bash
# 结构约束检查 — 失败信息包含修复指引
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ERRORS=0

error() {
  echo "❌ $1"
  echo "   修复：$2"
  ERRORS=$((ERRORS + 1))
}

warn() {
  echo "⚠️  $1"
}

pass() {
  echo "✅ $1"
}

echo "=== 结构约束检查 ==="
echo ""

# 1. 必需文件存在
REQUIRED_FILES=(
  "AGENTS.md"
  "README.md"
  ".cursor/rules/00-core.mdc"
  ".cursor/rules/01-architecture.mdc"
  ".cursor/rules/02-pr-workflow.mdc"
  "docs/architecture/system-overview.md"
  "docs/architecture/module-boundaries.md"
  "docs/sop/task-lifecycle.md"
  "docs/sop/pr-guidelines.md"
  "docs/quality/gates.md"
  "docs/security/policy.md"
)

for f in "${REQUIRED_FILES[@]}"; do
  if [[ ! -f "$ROOT/$f" ]]; then
    error "缺少必需文件: $f" "创建该文件或从 playbook 模板复制"
  fi
done

# 2. AGENTS.md 行数限制（Agent 导航地图应简洁）
if [[ -f "$ROOT/AGENTS.md" ]]; then
  lines=$(wc -l < "$ROOT/AGENTS.md" | tr -d ' ')
  if [[ "$lines" -gt 150 ]]; then
    error "AGENTS.md 超过 150 行 ($lines 行)" "精简内容，深层文档移到 docs/ 并在 AGENTS.md 中链接"
  else
    pass "AGENTS.md 行数 OK ($lines 行)"
  fi
fi

# 3. Prompt 模板完整性
PROMPT_TEMPLATES=(
  "templates/prompts/feature-task.md"
  "templates/prompts/bugfix-task.md"
  "templates/prompts/refactor-task.md"
  "templates/prompts/impact-analysis.md"
  "templates/prompts/self-review.md"
)

for f in "${PROMPT_TEMPLATES[@]}"; do
  if [[ ! -f "$ROOT/$f" ]]; then
    error "缺少 Prompt 模板: $f" "从 playbook templates/prompts/ 复制"
  fi
done

# 4. 脚本可执行权限
for script in "$ROOT"/scripts/*.sh; do
  if [[ -f "$script" ]] && [[ ! -x "$script" ]]; then
    error "$(basename "$script") 缺少可执行权限" "运行 chmod +x $script"
  fi
done

# 5. 禁止 docs/ 中嵌入可执行脚本块（除示例外）
if grep -rn '^```bash' "$ROOT/docs/" 2>/dev/null | grep -v 'validate.sh\|check-structure\|check-doc-freshness\|nightly-audit\|metrics-collect' | head -1 | grep -q .; then
  warn "docs/ 中发现 bash 代码块，确保仅为示例命令而非可执行逻辑"
fi

# 6. .cursorignore 存在
if [[ ! -f "$ROOT/.cursorignore" ]]; then
  error "缺少 .cursorignore" "创建 .cursorignore 排除 node_modules/、dist/ 等，参考 playbook 模板"
else
  pass ".cursorignore 存在"
fi

echo ""
if [[ "$ERRORS" -gt 0 ]]; then
  echo "=== 失败：$ERRORS 个错误 ==="
  exit 1
else
  echo "=== 全部通过 ==="
  exit 0
fi
