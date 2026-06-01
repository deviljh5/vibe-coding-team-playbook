#!/usr/bin/env bash
# 文档新鲜度检查 — 检测过期或缺失的文档
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ERRORS=0
WARNINGS=0
MAX_AGE_DAYS=90

error() {
  echo "❌ $1"
  echo "   修复：$2"
  ERRORS=$((ERRORS + 1))
}

warn() {
  echo "⚠️  $1"
  WARNINGS=$((WARNINGS + 1))
}

pass() {
  echo "✅ $1"
}

echo "=== 文档新鲜度检查 ==="
echo ""

# 1. 关键文档必须有"最后更新"标记或近期 git 变更
KEY_DOCS=(
  "docs/architecture/system-overview.md"
  "docs/architecture/module-boundaries.md"
  "docs/sop/task-lifecycle.md"
  "docs/security/policy.md"
)

for doc in "${KEY_DOCS[@]}"; do
  filepath="$ROOT/$doc"
  if [[ ! -f "$filepath" ]]; then
    error "$doc 不存在" "创建该文档"
    continue
  fi

  # 检查 git 最后修改时间
  if git -C "$ROOT" log -1 --format="%ci" -- "$doc" 2>/dev/null | grep -q .; then
    last_date=$(git -C "$ROOT" log -1 --format="%ci" -- "$doc" | cut -d' ' -f1)
    last_epoch=$(date -j -f "%Y-%m-%d" "$last_date" "+%s" 2>/dev/null || date -d "$last_date" "+%s" 2>/dev/null || echo 0)
    now_epoch=$(date "+%s")
    age_days=$(( (now_epoch - last_epoch) / 86400 ))

    if [[ "$age_days" -gt "$MAX_AGE_DAYS" ]]; then
      warn "$doc 已 $age_days 天未更新（阈值 ${MAX_AGE_DAYS} 天）"
    else
      pass "$doc 新鲜度 OK (${age_days}d)"
    fi
  else
    warn "$doc 无 git 历史，无法判断新鲜度"
  fi
done

# 2. AGENTS.md 链接有效性（检查相对链接目标存在）
if [[ -f "$ROOT/AGENTS.md" ]]; then
  broken=0
  while IFS= read -r link; do
    target=$(echo "$link" | sed 's/.*(\.\/\([^)]*\)).*/\1/' | sed 's/#.*//')
    if [[ -n "$target" ]] && [[ ! -f "$ROOT/$target" ]]; then
      error "AGENTS.md 链接失效: $target" "创建目标文件或修正链接"
      broken=$((broken + 1))
    fi
  done < <(grep -o '\(\./[^)]*\)' "$ROOT/AGENTS.md" 2>/dev/null || true)

  if [[ "$broken" -eq 0 ]]; then
    pass "AGENTS.md 链接全部有效"
  fi
fi

# 3. module-boundaries.md 中的路径是否实际存在
if [[ -f "$ROOT/docs/architecture/module-boundaries.md" ]]; then
  while IFS= read -r path; do
    clean=$(echo "$path" | tr -d '`' | sed 's/\/$//')
    if [[ "$clean" == *"*"* ]] || [[ "$clean" == "." ]]; then
      continue
    fi
    if [[ ! -e "$ROOT/$clean" ]]; then
      warn "module-boundaries.md 引用的路径不存在: $clean"
    fi
  done < <(grep -o '`[^`]*`' "$ROOT/docs/architecture/module-boundaries.md" | grep -v 'http' | head -20 || true)
fi

echo ""
echo "=== 结果：$ERRORS 错误, $WARNINGS 警告 ==="
if [[ "$ERRORS" -gt 0 ]]; then
  exit 1
fi
exit 0
