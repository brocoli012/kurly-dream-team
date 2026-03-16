# 커스터마이징 가이드

## 프로젝트별 설정

### .dream-team/config.md

프로젝트 루트에 설정 파일을 추가하여 동작을 커스터마이징할 수 있습니다:

```markdown
# Dream Team 프로젝트 설정

## 프로젝트 유형
- type: web  # web | app | game

## 기본 승인 모드
- approval: auto_proceed  # user_approval | auto_proceed

## 기술 스택
- frontend: React + TypeScript
- backend: Node.js + Express
- database: PostgreSQL
- deployment: Vercel

## 커스텀 위임 경로
(표준 경로를 사용하되, 필요 시 여기에 오버라이드)
```

### 커스텀 키워드

`.dream-team/knowledge/custom-keywords.md`에 프로젝트 특화 키워드를 추가:

```markdown
# 커스텀 키워드

| 키워드 | 위임 경로 | 비고 |
|--------|----------|------|
| "배송 로직" | TPO → Backend | 컬리 배송 시스템 |
| "상품 카드" | Designer → Frontend | UI 컴포넌트 |
```

## Hooks 커스터마이징

### Hook 비활성화

특정 Hook을 끄고 싶다면, 프로젝트의 `.claude/settings.json`에서 오버라이드:

```json
{
  "hooks": {
    "PreToolUse": []
  }
}
```

### 추가 Hook

프로젝트별 추가 Hook은 `.claude/settings.json`에 직접 추가:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "npx eslint --fix $FILE 2>/dev/null || true",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

## 에이전트 프롬프트 수정

`~/.claude/skills/kurly-dream-team/agents/` 의 파일을 직접 수정하여
에이전트 동작을 조정할 수 있습니다.

주의: `install.sh` 재실행 시 원본으로 덮어쓰므로, 커스텀 변경은
별도 백업하거나 fork 후 관리하세요.

## lessons-learned.md 활용

프로젝트에서 배운 교훈을 `.dream-team/docs/lessons-learned.md`에 기록하면
모든 에이전트가 Task 시작 전 참조합니다:

```markdown
## 위임/전달
- API 엔드포인트 변경 시 반드시 Swagger 문서도 함께 업데이트
- 결제 관련 코드는 반드시 TPO 검토 후 수정

## QA
- 모바일 웹은 Safari 호환성 반드시 체크
- 이미지 업로드는 5MB 이상 파일로도 테스트

## 기획서 품질
- 엣지 케이스를 반드시 기획서에 포함
```
