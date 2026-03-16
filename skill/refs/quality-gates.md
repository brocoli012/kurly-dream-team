# Quality Gates & Verification Reference

> on-demand 로드 문서. SKILL.md에서 `@refs/quality-gates.md` 참조 시 로드.

---

## 개요: 게이트 체계

```
Research Gate → Document Gate → Gate 1 → Gate 2 → Gate 3
                                (설계)    (구현)    (검증)
```

---

## 1. Gate 1: 설계 게이트

**책임자**: TPO (검증), Designer/PM (작성)

### 통과 조건 체크리스트

- [ ] 설계 문서 (`02-design.md`) 작성 완료
- [ ] 피드백 라운드 최소 횟수 충족 (복잡도별)
- [ ] 모든 피드백 항목 addressed/deferred/rejected 처리
- [ ] Impact Scope 분석 완료 (affectedFiles 목록)
- [ ] 기술 선택 근거 문서화

### 선택적 사용자 승인
| 복잡도 | 승인 방식 |
|--------|-----------|
| 1-4pt | auto_proceed (자동 진행) |
| 5pt+ | **user_approval** (명시적 승인 필요) |

### Gate 1 실패 시
```
1. 미충족 항목 명시
2. 해당 역할에게 보완 요청
3. 보완 후 재검증
4. 최대 3회 반복 후에도 미통과 → 사용자 에스컬레이션
```

---

## 2. Gate 2: 구현 게이트

**책임자**: TPO (검증), Developer (작성)

### 통과 조건 체크리스트

- [ ] 빌드 성공 (컴파일 에러 없음)
- [ ] 모든 기존 테스트 통과
- [ ] 새 기능 테스트 작성 및 통과
- [ ] 린트/포맷 에러 없음
- [ ] Evidence-Based Completion 검증 (3pt+)
- [ ] Verification Engine 검증 (3pt+)

### Evidence-Based Completion (3pt+)

증거 기반 완료 검증 - 추측 금지:

| 항목 | 검증 방법 |
|------|----------|
| 빌드 | `npm run build` / `cargo build` 등 실행 결과 |
| 테스트 | `npm test` / `pytest` 등 실행 결과 |
| 린트 | `eslint` / `clippy` 등 실행 결과 |
| 동작 | 실제 실행 화면 또는 출력 로그 |

### Red Flags (즉시 반려)
```
다음 표현이 포함된 완료 보고는 자동 반려:
- "should work" / "아마 동작할 겁니다"
- "probably fine" / "괜찮을 거예요"
- "I think it's correct" / "맞을 것 같습니다"
- "didn't test but..." / "테스트는 안 했지만..."
- "looks good to me" (증거 없이)
```

### Verification Engine (3pt+)
```
1. 설계 문서의 요구사항 추출
2. 구현 코드와 1:1 매핑
3. 각 요구사항별 충족 여부 판정
4. 미충족 항목 → Developer에게 반환
```

---

## 3. Gate 3: 검증 게이트

**책임자**: QA

### 통과 조건 체크리스트

- [ ] 기능 테스트 전수 통과
- [ ] Match Rate ≥ 90%
- [ ] CWE Top 10 보안 검사
- [ ] 회귀 테스트 통과
- [ ] 엣지 케이스 검증

### Match Rate 기준

설계 문서 vs 구현 결과의 일치율:

| Match Rate | 판정 | 행동 |
|-----------|------|------|
| **95-100%** | PASS | 즉시 통과 |
| **90-94%** | CAUTION | 미일치 항목 목록화, TPO 판단 |
| **< 90%** | **FAIL** | Developer에게 반환, 재구현 |

### Match Rate 산출 방식
```
Match Rate = (일치 항목 수 / 전체 검증 항목 수) x 100

검증 항목 소스:
- 설계 문서 (02-design.md) 요구사항
- 티켓 acceptance criteria
- Impact Scope 내 파일별 변경사항
```

### CWE Top 10 보안 검사
- [ ] CWE-79: XSS (Cross-site Scripting)
- [ ] CWE-89: SQL Injection
- [ ] CWE-20: Improper Input Validation
- [ ] CWE-78: OS Command Injection
- [ ] CWE-22: Path Traversal
- [ ] CWE-352: CSRF
- [ ] CWE-434: Unrestricted File Upload
- [ ] CWE-862: Missing Authorization
- [ ] CWE-798: Hard-coded Credentials
- [ ] CWE-200: Information Exposure

---

## 4. E-O 파이프라인 (4계층)

품질 보증의 4계층 구조:

| 계층 | 이름 | 시점 | 내용 |
|------|------|------|------|
| **L1** | Evidence | 구현 중 | 빌드/테스트/린트 실행 증거 수집 |
| **L2** | Verification | Gate 2 | 설계-구현 매핑 검증 |
| **L3** | Observation | Gate 3 | QA 독립 검증, Match Rate 산출 |
| **L4** | Oversight | 전체 | TPO 프로세스 리뷰, 위반 감지 |

### 계층별 책임자
```
L1 Evidence     → Developer (자기 증명)
L2 Verification → TPO (교차 검증)
L3 Observation  → QA (독립 검증)
L4 Oversight    → TPO + Master (프로세스 감독)
```

---

## 5. QA 2단계 검증 (게임)

게임 프로젝트의 경우 QA는 2단계로 수행:

### Stage 1: 기능 검증
- [ ] 모든 인터랙션 동작 확인
- [ ] 입출력 매핑 테이블 vs 실제 동작 일치
- [ ] 에러/크래시 없음
- [ ] 성능 기준 충족 (FPS, 로딩 시간)

### Stage 2: 게임플레이 검증
- [ ] 코어 루프 체험 가능
- [ ] 난이도 곡선 적절성
- [ ] 보상 체계 동작
- [ ] 유저 경험 흐름 자연스러움

### QA FAIL 기준 (게임)
```
즉시 FAIL:
- 인터랙션 타입 변경 (클릭→드래그 등 설계와 불일치)
- 매핑 테이블 누락 (입력-출력 관계 미문서화)
- 코어 루프 미완성
- 크래시/무한 로딩
```

---

## 6. 1-scene 데모 게이트

주 단위 게임 개발에서의 중간 검증:

```
매주 금요일 (또는 스프린트 종료 시):
1. 1개 씬 완전 플레이 가능 상태
2. 해당 씬의 코어 메카닉 동작
3. 기본 아트 에셋 적용
4. 알려진 버그 목록 정리
5. 다음 주 계획 수립
```
