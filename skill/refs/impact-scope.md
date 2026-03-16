# Impact Scope Analysis Reference

> on-demand 로드 문서. SKILL.md에서 `@refs/impact-scope.md` 참조 시 로드.

---

## 1. 개요

Impact Scope는 코드 변경이 영향을 미치는 파일/모듈의 범위를 사전에 분석하여
누락 없는 수정과 일관성을 보장하는 프로세스입니다.

### 적용 조건
| 조건 | 적용 여부 |
|------|----------|
| 코드 수정 작업 | **필수** |
| 문서만 수정 | 불필요 |
| 설정 파일 변경 | 선택적 (영향 범위에 따라) |
| 리팩토링 | **필수** |
| 새 파일 추가만 | 불필요 (단, 기존 코드에 import 추가 시 필수) |

---

## 2. TPO 책임: 분석 단계

TPO는 Developer에게 위임하기 전에 Impact Scope를 분석합니다.

### 2.1 패턴 추출 (Pattern Extraction)

변경 대상에서 검색 가능한 패턴을 추출:

```
예시: 함수명 변경 getUserById → findUserById

추출 패턴:
- "getUserById" (직접 호출)
- "import.*getUserById" (import문)
- "getUserById.*test" (테스트 파일)
- "mock.*getUserById" (모킹)
```

### 2.2 Grep 검색 (Pattern Search)

추출된 패턴으로 코드베이스 전수 검색:

```bash
# 패턴별 검색
Grep: "getUserById" → 결과 목록
Grep: "import.*user-service" → 결과 목록
Glob: "**/*.test.ts" → 테스트 파일 목록
```

### 2.3 affectedFiles 목록 도출

검색 결과를 정리하여 명확한 파일 목록 생성:

```markdown
## Impact Scope: TASK-005

### affectedFiles
| # | 파일 경로 | 변경 유형 | 영향 패턴 |
|---|----------|----------|----------|
| 1 | /src/services/user-service.ts | 직접 수정 | 함수 정의 변경 |
| 2 | /src/controllers/user-controller.ts | 호출부 수정 | getUserById 호출 |
| 3 | /src/routes/user-routes.ts | import 수정 | import문 |
| 4 | /tests/user-service.test.ts | 테스트 수정 | 테스트 케이스 |
| 5 | /tests/user-controller.test.ts | 테스트 수정 | 모킹 변경 |

### 검색 커버리지
- 검색 패턴 수: 4
- 검색 결과 파일 수: 12
- affectedFiles 확정: 5
- 제외 사유: 7개 파일은 동명이인 (다른 getUserById)
```

---

## 3. Developer 책임: 실행 단계

Developer는 TPO가 제공한 affectedFiles를 기반으로 수정합니다.

### 3.1 전수 확인 (Check All Affected Files)

```
필수 행동:
1. affectedFiles의 모든 파일을 Read로 열람
2. 각 파일에서 변경 필요 지점 식별
3. 누락 파일 없는지 확인
4. affectedFiles에 없지만 영향받는 파일 발견 시 → TPO에 보고
```

### 3.2 일괄 수정 (Batch Modify)

```
필수 규칙:
- 동일 패턴 변경은 모든 대상 파일에 한 번에 적용
- 부분 적용 절대 금지
  BAD: 5개 파일 중 3개만 수정하고 "나머지는 나중에"
  GOOD: 5개 파일 모두 수정 후 완료 보고

수정 순서 권장:
1. 핵심 파일 (정의부) 먼저
2. 호출부/참조부
3. 테스트 파일
4. 설정/문서 파일
```

### 3.3 재검색 (Re-search)

```
수정 완료 후 반드시 재검색:

1. 이전 패턴 잔존 검색:
   Grep: "getUserById" → 0 결과 확인 (완전 제거 확인)

2. 새 패턴 적용 검색:
   Grep: "findUserById" → affectedFiles 수와 일치 확인

3. 불일치 시:
   - 누락 파일 발견 → 추가 수정
   - 예상외 파일 발견 → TPO에 보고
```

---

## 4. QA 일관성 검사

QA의 Gate 3에서 Impact Scope 관련 검사:

### 패턴 일관성 검사 (Match Rate의 10%)

```
Match Rate 산출 시 패턴 일관성 항목 포함:
- 전체 Match Rate의 10% 비중

검사 항목:
1. 이전 패턴 잔존 여부 (0이어야 함)
2. 새 패턴 적용 완전성 (affectedFiles 전부 적용)
3. import/export 정합성
4. 테스트 파일 동기화
```

### 일관성 검사 실패 시
```
패턴 잔존 발견 → Match Rate에서 감점
감점 기준:
- 잔존 1건: -2%
- 잔존 2-3건: -5%
- 잔존 4건+: 자동 FAIL
```

---

## 5. 예시 워크플로우

### 시나리오: API 엔드포인트 경로 변경

```
변경 내용: /api/users/:id → /api/v2/users/:id
```

#### Step 1: TPO 패턴 추출
```
패턴 목록:
- "/api/users"
- "api/users"
- "users/:id"
- "fetch.*users"
```

#### Step 2: TPO Grep 검색
```
Grep "/api/users" → 8개 파일
Grep "api/users" (설정파일) → 2개 파일
Grep "users/:id" (라우트) → 3개 파일
Grep "fetch.*users" (프론트) → 4개 파일
```

#### Step 3: TPO affectedFiles 정리
```markdown
| # | 파일 | 변경 유형 |
|---|------|----------|
| 1 | /src/routes/user-routes.ts | 라우트 정의 변경 |
| 2 | /src/middleware/auth.ts | 경로 화이트리스트 |
| 3 | /src/client/api/users.ts | fetch URL |
| 4 | /src/client/hooks/useUser.ts | API 호출 |
| 5 | /tests/api/users.test.ts | 테스트 URL |
| 6 | /tests/e2e/user-flow.test.ts | E2E 테스트 |
| 7 | /docs/api-spec.yaml | API 문서 |
| 8 | /nginx/proxy.conf | 리버스 프록시 |
```

#### Step 4: Developer 일괄 수정
```
1. user-routes.ts → 라우트 경로 변경
2. auth.ts → 화이트리스트 경로 변경
3. users.ts → API base URL 변경
4. useUser.ts → 호출 경로 변경
5. users.test.ts → 테스트 URL 변경
6. user-flow.test.ts → E2E URL 변경
7. api-spec.yaml → 문서 경로 변경
8. proxy.conf → 프록시 경로 변경
```

#### Step 5: Developer 재검색
```
Grep "/api/users" (v2 제외) → 0건 ✅
Grep "/api/v2/users" → 8건 (affectedFiles와 일치) ✅
```

#### Step 6: QA 일관성 검사
```
이전 패턴 "/api/users" 잔존: 0건 ✅
새 패턴 "/api/v2/users" 적용: 8/8 ✅
패턴 일관성: 100% ✅
```

---

## 6. Impact Scope 템플릿

TPO가 Developer에게 전달하는 표준 형식:

```markdown
## Impact Scope

### 변경 대상
[변경 내용 요약]

### 검색 패턴
| 패턴 | 용도 | 결과 수 |
|------|------|--------|

### affectedFiles
| # | 파일 경로 (절대) | 변경 유형 | 우선순위 |
|---|-----------------|----------|----------|

### 주의사항
- [특별히 주의할 파일/패턴]
- [사이드이펙트 가능성]

### 재검색 체크리스트
- [ ] 이전 패턴 잔존 0건 확인
- [ ] 새 패턴 적용 완전성 확인
- [ ] import/export 정합성 확인
```
