# Dream Team Hooks 규칙

> 이 파일은 .claude/rules/에 위치하여 모든 에이전트에게 자동 주입됩니다.

## Hook 시스템

1. **PreToolUse Guard**: Master가 Edit/Write/Bash 사용 시 경고 출력 (warn-only, 차단 안 함)
2. **PostToolUse Violations**: Edit/Write/Bash 실행 후 violations 자동 기록 (최근 50건)
3. **SessionStart Init**: 세션 시작 시 드림팀 상태 자동 로드

## Hook 오류 시 대응

- 모든 Hook은 fail-open 정책 (오류 시 진행 허용)
- Grep/Glob은 Hook 대상 아님 (전원 허용)
