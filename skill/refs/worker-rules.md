# Worker / Sub-agent Rules Reference

> on-demand 로드 문서. SKILL.md에서 `@refs/worker-rules.md` 참조 시 로드.

---

## 1. 금지 사항 (Prohibitions)

서브에이전트(Worker)는 다음 행위를 **절대 금지**:

| # | 금지 행위 | 사유 |
|---|----------|------|
| 1 | **Task tool 사용** | 추가 서브에이전트 생성 불가 (체인 깊이 제한) |
| 2 | **다른 에이전트에게 재위임** | 작업은 받은 에이전트가 직접 수행 |
| 3 | **추측 기반 완료 선언** | 모든 완료는 증거 기반 (Evidence-Based) |
| 4 | **티켓 없는 작업 수행** | NO ticket = NO work |
| 5 | **범위 밖 작업** | TASK에 명시되지 않은 작업 금지 |
| 6 | **MUST NOT 항목 위반** | 위임 시 명시된 금지사항 준수 |

### 위반 시 처리
```
위반 감지 → session-state.json violations 기록
→ 해당 작업 결과 무효 처리 가능
→ TPO 리뷰 시 위반 누적 확인
```

---

## 2. 필수 사항 (Requirements)

### 도구 직접 사용
```
Worker는 반드시 직접 도구를 사용:
- Read: 파일 읽기
- Edit: 파일 수정 (기존 파일)
- Write: 파일 생성 (신규 파일)
- Bash: 명령 실행 (빌드, 테스트, 린트)
- Grep: 코드 검색
- Glob: 파일 검색
```

### 절대 경로 사용
```
모든 파일 참조는 절대 경로:
- GOOD: /Users/user/project/src/main.ts
- BAD:  ./src/main.ts
- BAD:  src/main.ts
```

### 증거 기반 작업
```
모든 행동에 증거를 남김:
- 파일 수정 → Edit tool 호출 기록
- 빌드 확인 → Bash 실행 결과
- 테스트 → 테스트 실행 출력
- 검색 → Grep/Glob 결과
```

---

## 3. 완료 보고 형식 (Completion Report)

작업 완료 시 반드시 다음 형식으로 보고:

```markdown
## 완료 보고

### 변경 파일 목록
- /absolute/path/to/file1.ts (수정)
- /absolute/path/to/file2.ts (신규)
- /absolute/path/to/file3.ts (삭제)

### 변경 요약 (3줄 이내)
- feature: 사용자 인증 미들웨어 추가
- fix: JWT 토큰 만료 처리 로직 수정
- refactor: 인증 관련 유틸 함수 분리

### 커밋 해시
abc1234 (커밋한 경우)

### 티켓 상태 업데이트
TASK-005: in_progress → in_review
```

### 보고 필수 항목 체크리스트
- [ ] 변경 파일 목록 (절대 경로)
- [ ] 변경 요약 (diff 기반, 3줄 이내)
- [ ] 커밋 해시 (커밋한 경우, 안 했으면 "미커밋" 명시)
- [ ] 티켓 상태 업데이트

---

## 4. Auto-Fix 의무

Worker가 린트/포맷/임포트 에러를 발생시킨 경우 **자동 수정 의무**:

### Auto-Fix 대상
| 유형 | 예시 | 행동 |
|------|------|------|
| 린트 에러 | ESLint, Clippy 경고/에러 | 자동 수정 후 재실행 |
| 포맷 에러 | Prettier, rustfmt 불일치 | 포맷터 실행 |
| 임포트 에러 | 미사용 import, 누락 import | 수동 수정 |
| 타입 에러 | TypeScript, mypy 에러 | 수동 수정 |

### Auto-Fix 프로세스
```
1. 코드 수정 완료
2. 린트/빌드 실행
3. 에러 발견 시:
   a. 자동 수정 가능 → 즉시 수정 + 재실행
   b. 수동 수정 필요 → 직접 수정 + 재실행
4. 클린 상태 확인 후 완료 보고
```

> Worker가 발생시킨 에러를 미수정 상태로 보고하면 **Gate 2 자동 실패**

---

## 5. Impact Scope 준수

### Worker의 Impact Scope 의무

TPO가 위임 시 제공한 `IMPACT_SCOPE`를 반드시 준수:

```
1. affectedFiles 전수 확인
   - 위임 시 전달받은 파일 목록 모두 열람
   - 누락된 파일이 없는지 확인

2. 일괄 수정 (Batch Modify)
   - 동일 패턴 변경은 모든 대상 파일에 적용
   - 부분 적용 금지 (일부만 수정하고 나머지 누락 금지)

3. 재검색 (Re-search)
   - 수정 완료 후 Grep으로 누락 확인
   - 패턴 변경 시: 이전 패턴 잔존 여부 검색
   - 새 패턴 적용 시: 미적용 파일 검색
```

### Impact Scope 위반 예시
```
BAD: 함수명을 3개 파일에서만 변경 (실제 5개 파일에서 사용)
BAD: 타입 변경 후 관련 테스트 파일 미수정
BAD: import 경로 변경 후 일부 파일 누락

GOOD: Grep으로 전수 검색 → 모든 파일 수정 → 재검색으로 확인
```

---

## 6. lessons-learned.md 참조 의무

### 작업 시작 시
```
1. .dream-team/lessons-learned.md 읽기
2. 현재 작업과 관련된 교훈 확인
3. 동일 실수 반복 방지
```

### 작업 완료 시 (새 교훈 발견 시)
```
1. 새로운 교훈을 lessons-learned.md에 추가
2. 형식:
   ## [날짜] [카테고리]
   - 상황: [무엇이 발생했는지]
   - 교훈: [배운 점]
   - 방지책: [재발 방지 방법]
```

---

## 7. 역할별 추가 규칙

### Developer 추가 규칙
- 새 파일 생성 시 프로젝트 컨벤션 준수
- 테스트 파일은 구현 파일과 동시에 작성
- TODO/FIXME 코멘트 금지 (즉시 해결)

### Designer 추가 규칙
- UI 명세는 구체적 수치로 (color, spacing, font)
- 상태별 디자인 명시 (default, hover, active, disabled, error)
- 반응형 브레이크포인트 명시

### QA 추가 규칙
- 테스트 시나리오 사전 작성 후 실행
- FAIL 시 재현 단계 명확히 기술
- Match Rate 산출 근거 명시
