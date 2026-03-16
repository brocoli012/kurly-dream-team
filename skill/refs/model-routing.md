# TPO Dynamic Model Routing Reference

> on-demand 로드 문서. SKILL.md에서 `@refs/model-routing.md` 참조 시 로드.

---

## 1. 개요

TPO는 작업의 난이도를 점수화하여 최적의 모델을 동적으로 배정합니다.
이를 통해 비용 효율성과 품질을 동시에 달성합니다.

---

## 2. 채점 기준 테이블

4개 차원에서 각 1-10점으로 평가:

| 차원 | 1-3점 (낮음) | 4-6점 (중간) | 7-10점 (높음) |
|------|-------------|-------------|--------------|
| **Impact Scope** | 단일 파일 수정 | 3-5개 파일 영향 | 6개+ 파일, 모듈 간 영향 |
| **Technical Complexity** | 단순 CRUD, 텍스트 변경 | 비즈니스 로직, API 연동 | 아키텍처 변경, 동시성, 보안 |
| **Risk** | 롤백 쉬움, 사이드이펙트 없음 | 일부 사이드이펙트 가능 | 데이터 손실 가능, 보안 영향 |
| **Decision** | 정해진 패턴 따름 | 2-3개 대안 중 선택 | 신규 설계 결정, 트레이드오프 |

### 총점 산출
```
총점 = (Impact + Complexity + Risk + Decision) / 4
소수점 반올림
```

---

## 3. 점수 → 난이도 → 모델 매핑

| 총점 | 난이도 | 모델 | 비용 | 적합한 작업 |
|------|--------|------|------|------------|
| **1-3** | Easy | **Haiku** | 최저 | 오타 수정, 텍스트 변경, 단순 CRUD, 포맷팅 |
| **4-6** | Medium | **Sonnet** | 중간 | 기능 구현, 리팩토링, API 연동, 테스트 작성 |
| **7-10** | Hard | **Opus** | 최고 | 아키텍처 설계, 보안 구현, 복잡한 알고리즘, 대규모 리팩토링 |

### 경계값 처리
```
3.5 → 반올림 4 → Sonnet
6.5 → 반올림 7 → Opus

단, Risk 차원이 단독 8점 이상이면 한 단계 상향:
- Haiku → Sonnet
- Sonnet → Opus
```

---

## 4. 역할별 모델 권장

| 역할 | 기본 모델 | 상향 조건 |
|------|----------|----------|
| **PM** | Sonnet | 대규모 요구사항 분석 → Opus |
| **Designer** | Sonnet | 복잡한 디자인 시스템 → Opus |
| **TPO** | Opus | 항상 Opus (의사결정 역할) |
| **Developer** | 동적 배정 | 위 점수표 기반 |
| **QA** | Sonnet | 보안 검증 집중 시 → Opus |
| **Story Writer** | Sonnet | 장편 세계관 구축 → Opus |
| **Game Designer** | Sonnet | 복잡한 밸런싱 → Opus |
| **Level Designer** | Sonnet | - |
| **Art Director** | Haiku | 명세 작성 위주 |
| **dev-proto** | Haiku | 빠른 프로토타입 |
| **dev-game** | 동적 배정 | Developer와 동일 기준 |

---

## 5. 오버라이드 규칙

### 사용자 강제 지정
```
사용자가 모델을 명시적으로 지정하면 무조건 따름:
- "Opus로 해줘" → Opus
- "Haiku로 충분해" → Haiku
- "빠르게 해줘" → Haiku (속도 우선 해석)
- "꼼꼼하게 해줘" → Opus (품질 우선 해석)
```

### TPO 판단 오버라이드
```
TPO가 점수와 다른 모델을 선택할 수 있는 경우:
1. 이전 동일 작업에서 낮은 모델 실패 경험 → 상향
2. 프로젝트 마감 임박으로 속도 우선 → 하향 (Risk 낮을 때만)
3. lessons-learned.md에 관련 교훈 있을 때 → 교훈 따름
```

### 오버라이드 기록
```json
{
  "routing": {
    "ticket": "TASK-005",
    "scores": { "impact": 3, "complexity": 5, "risk": 2, "decision": 4 },
    "total": 4,
    "suggested_model": "Sonnet",
    "actual_model": "Opus",
    "override_reason": "사용자 요청: 꼼꼼하게"
  }
}
```

---

## 6. 라우팅 프로세스 요약

```
1. TPO가 작업 수신
2. 4차원 채점 (Impact, Complexity, Risk, Decision)
3. 총점 산출 및 모델 결정
4. 오버라이드 조건 확인 (사용자 지정, Risk 단독 고점)
5. 최종 모델로 서브에이전트 위임
6. 라우팅 결정을 session-state.json에 기록
```

---

## 7. 비용 효율성 가이드

### 비용 절감 팁
- 린트/포맷 수정은 항상 Haiku
- 테스트 실행/확인은 Haiku로 충분
- 코드 리뷰는 Sonnet 이상
- 아키텍처 결정은 반드시 Opus

### 분할 전략
```
복잡한 작업을 분할하여 모델 혼합 사용:
1. 분석/설계: Opus (고비용, 1회)
2. 구현: Sonnet (중비용, 다회)
3. 린트/포맷: Haiku (저비용, 다회)

예) 총 비용 = Opus x 1 + Sonnet x 3 + Haiku x 2
    vs 전부 Opus = Opus x 6 → 약 60% 절감
```
