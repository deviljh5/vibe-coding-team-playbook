#!/usr/bin/env bash
# 指标采集 — 从 git 历史生成指标快照
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUTPUT="$ROOT/docs/metrics/dashboard-data.json"

echo "=== 指标采集 ==="
echo ""

# 时间范围：最近 7 天
END_DATE=$(date -u '+%Y-%m-%d')
START_DATE=$(date -u -v-7d '+%Y-%m-%d' 2>/dev/null || date -u -d '7 days ago' '+%Y-%m-%d' 2>/dev/null || echo "unknown")

# PR 吞吐量（基于 merge commits）
if git -C "$ROOT" rev-parse HEAD >/dev/null 2>&1; then
  MERGE_COUNT=$(git -C "$ROOT" log --oneline --merges --since="$START_DATE" 2>/dev/null | wc -l | tr -d ' ')
  COMMIT_COUNT=$(git -C "$ROOT" log --oneline --since="$START_DATE" 2>/dev/null | wc -l | tr -d ' ')
else
  MERGE_COUNT=0
  COMMIT_COUNT=0
fi

# 文件变更统计
FILES_CHANGED="N/A"
if [[ "$COMMIT_COUNT" -gt 0 ]]; then
  FILES_CHANGED=$(git -C "$ROOT" diff --stat "HEAD~${COMMIT_COUNT}" 2>/dev/null | tail -1 || echo "N/A")
fi

echo "周期: $START_DATE ~ $END_DATE"
echo "Commits: $COMMIT_COUNT"
echo "Merge commits: $MERGE_COUNT"
echo "文件变更: $FILES_CHANGED"
echo ""

# 生成 JSON
GENERATED_AT=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

cat > "$OUTPUT" << EOF
{
  "generated_at": "$GENERATED_AT",
  "period": {
    "start": "$START_DATE",
    "end": "$END_DATE"
  },
  "delivery": {
    "pr_cycle_median_hours": null,
    "throughput_prs_per_week": $MERGE_COUNT,
    "rework_rate_percent": null,
    "agent_task_completion_rate_percent": null
  },
  "quality": {
    "defect_escape_rate_percent": null,
    "rollback_rate_percent": null,
    "test_flake_rate_percent": null,
    "ci_first_pass_rate_percent": null
  },
  "agent": {
    "one_shot_pass_rate_percent": null,
    "ai_review_hit_rate_percent": null,
    "validate_first_pass_rate_percent": null
  },
  "raw": {
    "commits_in_period": $COMMIT_COUNT,
    "merge_commits_in_period": $MERGE_COUNT,
    "files_changed_summary": "$(echo "$FILES_CHANGED" | tr -d '"')"
  },
  "notes": "Connect GitHub API for full metrics. See docs/metrics/framework.md"
}
EOF

echo "✅ 指标已写入 $OUTPUT"
echo ""
echo "下一步："
echo "  1. 打开 docs/metrics/weekly-retrospective.md 进行复盘"
echo "  2. 连接 GitHub API 获取 PR 周期、返工率等完整指标"
