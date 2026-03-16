#!/bin/bash
set -euo pipefail
trap 'exit 0' ERR

STATE_FILE=".dream-team/session-state.json"
[ ! -f "$STATE_FILE" ] && exit 0

INPUT=$(cat 2>/dev/null || echo '{}')
TOOL=$(echo "$INPUT" | grep -o '"tool_name":"[^"]*"' | head -1 | cut -d'"' -f4 2>/dev/null || echo "")

case "$TOOL" in
  Edit|Write|Bash) ;;
  *) exit 0 ;;
esac

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
# Use python3 for JSON manipulation (available on macOS)
python3 -c "
import json, sys
try:
    with open('$STATE_FILE', 'r') as f:
        state = json.load(f)
    v = state.get('violations', [])
    v.append({'tool': '$TOOL', 'timestamp': '$TIMESTAMP'})
    state['violations'] = v[-50:]  # keep last 50
    with open('$STATE_FILE', 'w') as f:
        json.dump(state, f, indent=2, ensure_ascii=False)
except:
    pass
" 2>/dev/null
exit 0
