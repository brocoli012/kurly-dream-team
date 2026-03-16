#!/bin/bash
# Kurly Dream Team Pro - 원커맨드 설치
set -euo pipefail

SKILL_NAME="kurly-dream-team"
SKILL_DIR="$HOME/.claude/skills/$SKILL_NAME"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "  Kurly Dream Team Pro Installer"
echo "  ================================"
echo ""

# 1. Check prerequisites
if [ ! -d "$HOME/.claude" ]; then
    echo "ERROR: ~/.claude 디렉토리가 없습니다."
    echo "Claude Code가 설치되어 있는지 확인해주세요."
    exit 1
fi

# 2. Check for existing installation
if [ -d "$SKILL_DIR" ]; then
    echo "  기존 설치를 발견했습니다. 업데이트합니다..."
    rm -rf "$SKILL_DIR"
fi

# 3. Create skills directory if needed
mkdir -p "$HOME/.claude/skills"

# 4. Copy skill files
cp -r "$REPO_DIR/skill" "$SKILL_DIR"
echo "  [OK] 스킬 설치 완료: $SKILL_DIR"

# 5. Set executable permissions for hooks
chmod +x "$SKILL_DIR/hooks/"*.sh 2>/dev/null || true
echo "  [OK] Hook 실행 권한 설정"

# 6. Verify installation
if [ -f "$SKILL_DIR/SKILL.md" ]; then
    echo ""
    echo "  설치 완료!"
    echo ""
    echo "  사용법:"
    echo "  -------"
    echo "  1. 프로젝트 초기화:"
    echo "     bash $REPO_DIR/project-init/init.sh /path/to/your/project"
    echo ""
    echo "  2. Claude Code에서 드림팀 호출:"
    echo "     '드림팀' 또는 '/dt' 입력"
    echo ""
    echo "  제거:"
    echo "  ------"
    echo "     bash $REPO_DIR/uninstall.sh"
    echo ""
else
    echo ""
    echo "  ERROR: 설치 검증 실패. SKILL.md를 찾을 수 없습니다."
    exit 1
fi
