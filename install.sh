#!/usr/bin/env bash
# 一键安装入口（可在任意项目根目录执行）
# 用法:
#   /path/to/vibe-coding-team-playbook/install.sh .
#   /path/to/vibe-coding-team-playbook/install.sh ~/Projects/my-app --with-ci --push
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
exec bash "$DIR/scripts/bootstrap-project.sh" "$@"
