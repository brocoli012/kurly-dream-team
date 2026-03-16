# 프로세스 전체 그림

## 요청 접수부터 완료까지

```
[사용자 요청]
     │
     ▼
[마스터: 요청 분석]
  ├── 복잡도 추정 (Low/Medium/High)
  ├── 프로젝트 유형 판별 (웹/앱/게임)
  ├── 위임 경로 결정
  └── 승인 모드 확인 (user_approval / auto_proceed)
     │
     ├─── 1-2점: Master → Developer ─────────────────────┐
     │                                                     │
     ├─── 3-4점: Master → TPO → Dev → QA ────────────────┤
     │                                                     │
     └─── 5점+: Master → PM → Designer → TPO → Dev → QA ─┤
                                                           │
                                                    [마스터: 검수]
                                                           │
                                                    [완료 보고]
```

## 복잡도별 프로세스

### 1-2점 (단순)
```
요청 → Master 직접 판단 → Developer 구현 → Gate 2 → 완료
```
- 티켓: 선택
- Research: 생략
- 피드백: 없음
- Gate: G2만

### 3-4점 (보통)
```
요청 → Master 분석 → [티켓 생성]
  → TPO: Research + 설계 → [Research Gate] → [Gate 1]
  → Developer: 구현 → [Gate 2]
  → QA: 검증 → [Gate 3]
  → 완료
```
- 티켓: 필수
- Research: 필수
- 피드백: 최소 2회
- Gate: G1 + G2 + G3

### 5점+ (복잡)
```
요청 → Master 분석 → [티켓 생성] → 승인 모드 확인
  → PM: 기획서 작성 → [Document Gate]
  → Designer: UI/UX 설계
  → TPO: Research + 기술 설계 → [Research Gate] → [Gate 1]
    └── (user_approval 시: 사용자 설계 승인)
  → Developer: 구현 → [Gate 2]
  → QA: 검증 (Match Rate ≥ 90%) → [Gate 3]
  → 완료
```
- 티켓: 필수
- Research: 심층 (2-3회 반복)
- 피드백: 최소 3-5회
- Gate: 전체

## 게임 프로젝트 (5점+)

```
요청 → Master 분석 → [티켓 생성]
  → PM + Story Writer: 기획 + 세계관 → [Story Gate]
  → dev-proto: 웹 프로토타입 → [Prototype Gate: Go/No-Go]
  → Game Designer + Art Director: 게임 디자인
  → TPO: 기술 설계 → [Gate 1]
  → dev-game: Unity 구현 → [Gate 2]
  → QA: 2단계 검증 (기능 + 게임성) → [Gate 3]
  → 완료
```

## 품질 게이트 상세

### Research Gate (in_research → ready)
- research-report.md 존재
- 기존 코드 탐색 완료
- 재사용 판단 완료
- 라이브러리 검토 완료
- 충돌 분석 완료

### Gate 1 (in_design → in_progress)
- Design 문서 존재
- 피드백 횟수 충족
- 체크리스트 완료
- (user_approval 시) 사용자 승인

### Gate 2 (in_progress → in_review)
- 빌드 성공 (실행 결과 첨부)
- 테스트 통과 (결과 첨부)
- Evidence-Based 검증 ("아마 될 것" = FAIL)
- Verification Engine 통과 (3점+)

### Gate 3 (in_review → done)
- QA 승인
- Match Rate ≥ 90%
- 보안 기본 검증 (CWE Top 10)

## E-O (Evaluator-Optimizer) 파이프라인

```
L1: Worker 자기검증 (Evidence-Based)
     │
L2: Verification Engine (Fresh-context, 3점+)
     │
L3: QA Gap Detection
     │ Match Rate < 90%?
     ├── Yes → Developer 수정 → 재검증 (최대 5회)
     └── No → PASS → done
```

## 모델 라우팅

TPO가 복잡도에 따라 에이전트 모델을 결정:

| 복잡도 | 모델 | 에이전트 예시 |
|:------:|:----:|-------------|
| 1-3점 | Haiku | 단순 수정, 텍스트 변경 |
| 4-6점 | Sonnet | 일반 기능 개발 |
| 7-10점 | Opus | 아키텍처 설계, 보안 |
