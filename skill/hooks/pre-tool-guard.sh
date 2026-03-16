#!/bin/bash
set -euo pipefail
trap 'exit 0' ERR

STATE_FILE=".dream-team/session-state.json"
[ ! -f "$STATE_FILE" ] && exit 0

INPUT=$(cat 2>/dev/null || echo '{}')
TOOL=$(echo "$INPUT" | grep -o '"tool_name":"[^"]*"' | head -1 | cut -d'"' -f4 2>/dev/null || echo "")

# Only warn for Edit/Write/Bash
case "$TOOL" in
  Edit|Write|Bash) ;;
  *) exit 0 ;;
esac

echo "⚠️ 마스터가 ${TOOL}을 직접 사용합니다. Task tool 위임을 권장합니다."
exit 0
