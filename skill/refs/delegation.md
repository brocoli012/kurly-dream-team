# Delegation & Classification Reference

> on-demand 로드 문서. SKILL.md에서 `@refs/delegation.md` 참조 시 로드.

---

## 1. 마스터 분류 로직

사용자 요청을 의도(intent) 기반으로 분류:

| 의도 패턴 | 위임 대상 | 예시 |
|-----------|----------|------|
| **"무엇을 만들지"** (what to build) | PM | "사용자 인증 기능 추가해줘" |
| **"어떻게 보여줄지"** (how to show) | Designer | "로그인 화면 디자인해줘" |
| **"어떻게 만들지"** (how to build) | TPO | "Redis 캐시 적용해줘" |
| **"고쳐줘"** (fix) | Developer (단순) / TPO (복잡) | "버그 수정해줘" |
| **"확인해줘"** (verify) | QA | "테스트 돌려줘" |

---

## 2. 모호성 점수 게이트 (Ambiguity Score)

요청의 모호성을 0-1 스케일로 평가:

```
0.0 - 완전 명확: "LoginButton 컴포넌트의 color를 #333으로 변경"
0.3 - 약간 모호: "로그인 버튼 색상 변경"
0.5 - 경계값: 클래리피케이션 트리거
0.7 - 모호: "로그인 개선"
1.0 - 매우 모호: "UX 좋게 해줘"
```

| 점수 | 행동 |
|------|------|
| 0.0 - 0.4 | 즉시 위임 진행 |
| **0.5 이상** | **클래리피케이션 질문 필수** |
| 0.8 이상 | 2개 이상 구체화 질문 |

---

## 3. 의도 감지 키워드

| 분류 | 키워드 | 복잡도 | 위임 경로 |
|------|--------|--------|-----------|
| **simple fix** | "오타", "typo", "색상 변경", "텍스트 수정" | 1-2pt | Master → Developer |
| **tech work** | "리팩토링", "최적화", "마이그레이션", "캐시" | 3-5pt | Master → TPO → Developer |
| **new feature** | "새 기능", "추가", "구현", "만들어" | 3-7pt | Master → PM → Designer → TPO → Dev |
| **large change** | "전체 리뉴얼", "아키텍처 변경", "대규모" | 7pt+ | 풀체인 + user_approval |
| **P0** | "긴급", "장애", "P0", "핫픽스", "서버 다운" | 가변 | P0 긴급 프로세스 |

---

## 4. 9단계 위임 구조

서브에이전트 위임 시 필수 포함 항목:

```markdown
## TASK
[수행할 작업 명확히 기술]

## OUTCOME
[기대하는 결과물과 완료 기준]

## SKILLS
[필요한 기술 스택/도메인 지식]

## TOOLS
[사용할 도구 목록: Read, Edit, Write, Bash, Grep, Glob]

## MUST DO
[반드시 수행해야 하는 사항 체크리스트]

## MUST NOT
[절대 하면 안 되는 사항]

## CONTEXT
[관련 파일 경로, 이전 결정사항, 참고 정보]

## TEST_SCOPE
[검증해야 할 테스트 범위]

## IMPACT_SCOPE
[영향받는 파일/모듈 목록 - TPO가 사전 분석]
```

---

## 5. 위임 체인 검증

### 표준 위임 체인

| 유형 | 체인 |
|------|------|
| 신규 기능 | Master → PM → Designer → TPO → Developer → QA |
| 기술 작업 | Master → TPO → Developer → QA |
| 단순 수정 | Master → Developer |
| 디자인 작업 | Master → PM → Designer |
| 긴급 (P0) | Master → Developer (+ 72hr 사후 문서화) |

### 위반 유형

| 위반 | 설명 | 심각도 |
|------|------|--------|
| **skip** | 중간 역할 건너뜀 (예: PM 없이 Developer 직행) | HIGH |
| **reverse** | 역순 위임 (예: Developer → PM) | CRITICAL |
| **duplicate** | 동일 역할 중복 위임 | MEDIUM |

위반 감지 시 session-state.json의 `violations`에 기록.

---

## 6. P0 긴급 프로세스

```
트리거: "P0", "긴급", "장애", "서버 다운"

간소화 경로:
Master → Developer (직접 위임)

필수 사항:
1. 즉시 수정 착수
2. 최소 테스트로 검증
3. 72시간 이내 사후 문서화:
   - 원인 분석 (Root Cause)
   - 수정 내용
   - 재발 방지책
   - 누락된 Gate 항목 보완
```

---

## 7. 모바일 위임 경로

| 플랫폼 | 위임 경로 | 특이사항 |
|--------|----------|----------|
| **iOS** | Master → PM → Designer → TPO → dev-ios → QA | Swift/SwiftUI 전문 |
| **Android** | Master → PM → Designer → TPO → dev-android → QA | Kotlin/Compose 전문 |
| **Hybrid** | Master → PM → Designer → TPO → dev-mobile → QA | RN/Flutter 전문 |
| **병렬** | iOS + Android 동시 | TPO가 공통 설계 후 분기 |

---

## 8. 게임 위임 경로

| 복잡도 | 위임 경로 |
|--------|----------|
| 1-2pt | Master → dev-game |
| 3-4pt | Master → Game Designer → dev-game → QA |
| 5-6pt | Master → Story Writer → Game Designer → TPO → dev-game → QA |
| 7pt+ | Master → Story Writer → Game Designer → Level Designer → Art Director → TPO → dev-proto → dev-game → QA |

> 게임 역할 상세: `@refs/game-roles.md` 참조
