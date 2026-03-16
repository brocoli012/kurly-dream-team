#!/bin/bash
# Kurly Dream Team Pro - 프로젝트 초기화
set -euo pipefail

PROJECT_DIR="${1:-.}"
DT_DIR="$PROJECT_DIR/.dream-team"
SKILL_DIR="$HOME/.claude/skills/kurly-dream-team"

if [ -d "$DT_DIR" ]; then
    echo "⚠️  .dream-team/ 이미 존재합니다. 덮어쓰시겠습니까? [y/N]"
    read -r answer
    [[ "$answer" != "y" && "$answer" != "Y" ]] && echo "취소됨." && exit 0
fi

echo "🎯 Kurly Dream Team 프로젝트 초기화..."

# Create directory structure
mkdir -p "$DT_DIR"/{tickets/{backlog,in_progress,done},docs/{00-research,01-plan,02-design,03-analysis,04-report},memory,state}

# Copy session state template
if [ -f "$SKILL_DIR/templates/session-state.json" ]; then
    cp "$SKILL_DIR/templates/session-state.json" "$DT_DIR/session-state.json"
    # Set session ID
    SESSION_ID="session-$(date +%Y%m%d)"
    python3 -c "
import json
with open('$DT_DIR/session-state.json', 'r') as f:
    s = json.load(f)
s['session']['id'] = '$SESSION_ID'
s['session']['status'] = 'active'
with open('$DT_DIR/session-state.json', 'w') as f:
    json.dump(s, f, indent=2, ensure_ascii=False)
" 2>/dev/null
else
    echo '{"$schema":"kurly-dream-team-v1","version":"1.0","mode":"classic","session":{"id":"'$(date +%Y%m%d)'","status":"active"},"activeRoles":["master"],"complexity":{"estimated":null,"confirmed":null},"research":{"reportPath":null,"existingCodeSearched":false,"reuseDecision":null,"libraryReviewed":false,"conflictAnalysis":{"done":false,"risks":[]}},"loops":{"feedback":{"current":0,"max":3,"history":[]},"qaGate":{"current":0,"max":3,"history":[]}},"violations":[]}' | python3 -m json.tool > "$DT_DIR/session-state.json"
fi

# Create tickets INDEX
cat > "$DT_DIR/tickets/INDEX.md" << 'TICKETS_EOF'
# 티켓 인덱스

## 현재 상태 요약

| 상태 | 개수 |
|------|------|
| backlog | 0 |
| in_progress | 0 |
| done | 0 |

## 최근 티켓

| ID | 유형 | 제목 | 상태 | 담당 | 복잡도 |
|----|------|------|------|------|:------:|

TICKETS_EOF

# Create lessons-learned.md
cat > "$DT_DIR/docs/lessons-learned.md" << 'LESSONS_EOF'
# Lessons Learned

> 모든 에이전트는 Task 시작 전 이 문서를 참조합니다.

## 위임/전달
<!-- 마스터, dev 에이전트가 참조 -->

## QA
<!-- QA 에이전트가 참조 -->

## 기획서 품질
<!-- PM이 참조 -->

LESSONS_EOF

# Copy rules if project has .claude directory
RULES_SRC="$(dirname "$0")/rules"
if [ -d "$RULES_SRC" ]; then
    mkdir -p "$PROJECT_DIR/.claude/rules"
    cp "$RULES_SRC"/*.md "$PROJECT_DIR/.claude/rules/" 2>/dev/null || true
    echo "✅ .claude/rules/ 복사 완료"
fi

echo ""
echo "✅ 프로젝트 초기화 완료!"
echo ""
echo "📁 생성된 구조:"
echo "  $DT_DIR/"
echo "  ├── tickets/          # 티켓 관리"
echo "  ├── docs/             # PDCA 문서"
echo "  ├── memory/           # 프로젝트 메모리"
echo "  └── session-state.json"
echo ""
echo "💡 Claude Code에서 '드림팀' 또는 '/dt' 입력하여 시작"
