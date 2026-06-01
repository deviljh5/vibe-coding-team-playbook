#!/usr/bin/env bash
# 完整本地验证 — lint + 结构 + 文档
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "========================================"
echo "  Vibe Coding 本地验证"
echo "========================================"
echo ""

FAILED=0

run_check() {
  local name="$1"
  local script="$2"
  echo "--- $name ---"
  if bash "$script"; then
    echo ""
  else
    FAILED=$((FAILED + 1))
    echo ""
  fi
}

run_check "结构约束" "$ROOT/scripts/check-structure.sh"
run_check "文档新鲜度" "$ROOT/scripts/check-doc-freshness.sh"

echo "========================================"
if [[ "$FAILED" -gt 0 ]]; then
  echo "验证失败：$FAILED 项未通过"
  exit 1
else
  echo "全部验证通过 ✓"
  exit 0
fi
