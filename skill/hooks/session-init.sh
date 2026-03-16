#!/bin/bash
set -euo pipefail
trap 'exit 0' ERR

STATE_FILE=".dream-team/session-state.json"
DT_DIR=".dream-team"

# Check if dream team is initialized
if [ ! -d "$DT_DIR" ]; then
    echo "=== Dream Team Session State ==="
    echo "Status: not initialized"
    echo "Run project-init to set up .dream-team/"
    echo "================================"
    exit 0
fi

if [ ! -f "$STATE_FILE" ]; then
    echo "=== Dream Team Session State ==="
    echo "Status: no session"
    echo "================================"
    exit 0
fi

# Read state with python3
python3 -c "
import json
try:
    with open('$STATE_FILE') as f:
        s = json.load(f)
    status = s.get('session', {}).get('status', 'unknown')
    violations = len(s.get('violations', []))

    # Count active tickets
    import os
    tickets_dir = '$DT_DIR/tickets/in_progress'
    active = len([f for f in os.listdir(tickets_dir) if f.endswith('.md')]) if os.path.isdir(tickets_dir) else 0

    print('=== Dream Team Session State ===')
    print(f'Mode: classic')
    print(f'Status: {status}')
    print(f'Active Tickets: {active}건')
    if violations > 0:
        print(f'Violations: {violations}건')
    print('================================')
except Exception as e:
    print('=== Dream Team Session State ===')
    print(f'Status: error ({e})')
    print('================================')
" 2>/dev/null
exit 0
