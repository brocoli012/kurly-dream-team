#!/bin/bash
# Kurly Dream Team Pro - 제거
set -euo pipefail

SKILL_NAME="kurly-dream-team"
SKILL_DIR="$HOME/.claude/skills/$SKILL_NAME"

echo ""
echo "  Kurly Dream Team Pro Uninstaller"
echo "  ================================="
echo ""

if [ ! -d "$SKILL_DIR" ]; then
    echo "  설치된 스킬을 찾을 수 없습니다."
    exit 0
fi

echo "  다음 디렉토리를 삭제합니다:"
echo "    $SKILL_DIR"
echo ""
echo "  계속하시겠습니까? [y/N]"
read -r answer
if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "  취소됨."
    exit 0
fi

rm -rf "$SKILL_DIR"
echo "  [OK] 스킬 제거 완료"
echo ""
echo "  참고: 프로젝트의 .dream-team/ 폴더는 수동으로 삭제해주세요."
echo "  참고: .claude/rules/ 의 dream-team-*.md 파일도 수동으로 삭제해주세요."
echo ""
