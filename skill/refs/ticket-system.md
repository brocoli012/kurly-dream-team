# Ticket System Reference

> on-demand 로드 문서. SKILL.md에서 `@refs/ticket-system.md` 참조 시 로드.

---

## 1. 핵심 원칙

> **NO ticket = NO work**
>
> 티켓이 없으면 작업을 시작할 수 없습니다.
> 모든 작업은 반드시 티켓에서 시작하고, 티켓으로 추적합니다.

---

## 2. 타입 계층 구조

```
EPIC (대규모 기능/프로젝트)
├── REQ (요구사항/사용자 스토리)
│   ├── TASK (구현 단위 작업)
│   │   ├── SUB (하위 세부 작업)
│   │   └── SUB
│   └── TASK
│       └── SUB
└── REQ
    └── TASK
        └── BUG (결함)
```

| 타입 | 설명 | 생성자 | 예시 |
|------|------|--------|------|
| **EPIC** | 대규모 기능 묶음 | PM | "사용자 인증 시스템" |
| **REQ** | 요구사항/사용자 스토리 | PM | "이메일 로그인 구현" |
| **TASK** | 구현 단위 작업 | TPO/PM | "JWT 토큰 발급 API" |
| **SUB** | TASK의 하위 작업 | Developer/TPO | "토큰 갱신 로직" |
| **BUG** | 결함/이슈 | QA/누구나 | "로그인 시 500 에러" |

---

## 3. 상태 흐름 (State Flow)

### 기본 상태 흐름
```
open → in_analysis → in_research → ready → in_design → in_progress → in_review → done
```

| 상태 | 설명 | 진입 조건 | 퇴장 조건 |
|------|------|----------|----------|
| `open` | 생성됨 | 티켓 생성 시 | PM/TPO 분석 시작 |
| `in_analysis` | 분석 중 | PM이 요구사항 분석 | 분석 완료 |
| `in_research` | 리서치 중 | 3pt+ 리서치 필요 시 | Research Gate 통과 |
| `ready` | 준비 완료 | 분석/리서치 완료 | 설계 시작 |
| `in_design` | 설계 중 | Designer/TPO 작업 시작 | Gate 1 통과 |
| `in_progress` | 구현 중 | Developer 작업 시작 | Gate 2 통과 |
| `in_review` | 검증 중 | QA 검증 시작 | Gate 3 통과 |
| `done` | 완료 | 모든 Gate 통과 | - |

### 게임 프로젝트 추가 상태
```
open → in_story → in_prototype → in_analysis → ...
```

| 상태 | 설명 | 담당 |
|------|------|------|
| `in_story` | 스토리/세계관 작업 | Story Writer |
| `in_prototype` | 프로토타입 개발 | dev-proto |

### 특수 전이
```
어떤 상태에서든 → blocked (차단됨)
blocked → 이전 상태 (차단 해제 시)

in_review → in_progress (QA FAIL 시 재작업)
in_design → in_analysis (설계 중 요구사항 변경 발견)
```

---

## 4. 티켓 템플릿

### TASK 티켓 템플릿
```markdown
# [TASK-NNN] 제목

## 타입
TASK

## 상위 티켓
REQ-NNN (있으면)

## 복잡도
[1-10]pt

## 설명
[작업 내용 상세 기술]

## Acceptance Criteria
- [ ] 기준 1
- [ ] 기준 2
- [ ] 기준 3

## 기술 요구사항
- 언어/프레임워크:
- 영향 범위:

## 우선순위
[P0/P1/P2/P3]

## 담당자
[역할명]

## 상태
open

## 이력
| 날짜 | 상태 변경 | 변경자 | 비고 |
|------|----------|--------|------|
```

### BUG 티켓 템플릿
```markdown
# [BUG-NNN] 제목

## 타입
BUG

## 관련 티켓
TASK-NNN

## 심각도
[CRITICAL/HIGH/MEDIUM/LOW]

## 재현 단계
1.
2.
3.

## 기대 동작
[정상 동작 기술]

## 실제 동작
[현재 동작 기술]

## 환경
- OS:
- 브라우저/런타임:
- 버전:

## 상태
open
```

---

## 5. INDEX.md 관리

프로젝트의 티켓 현황을 한눈에 파악하는 인덱스 파일:

### 경로
```
.dream-team/INDEX.md
```

### 형식
```markdown
# Ticket Index

## 활성 티켓
| ID | 타입 | 제목 | 상태 | 담당 | 복잡도 |
|----|------|------|------|------|--------|
| TASK-001 | TASK | JWT 인증 구현 | in_progress | Developer | 5pt |
| BUG-001 | BUG | 로그인 500 에러 | open | - | 2pt |

## 완료 티켓
| ID | 타입 | 제목 | 완료일 |
|----|------|------|--------|
| TASK-000 | TASK | 프로젝트 초기화 | 2024-01-15 |
```

### 업데이트 규칙
- 티켓 생성/상태 변경 시 **즉시** INDEX.md 갱신
- 상태 변경은 티켓 파일 + INDEX.md **동시** 업데이트
- INDEX.md와 개별 티켓 파일 간 불일치 금지

---

## 6. 저장 경로

```
.dream-team/
├── INDEX.md                    # 티켓 인덱스
├── tickets/
│   ├── EPIC-001.md
│   ├── REQ-001.md
│   ├── TASK-001.md
│   ├── TASK-002.md
│   ├── SUB-001.md
│   ├── BUG-001.md
│   └── ...
├── docs/
│   ├── TASK-001/
│   │   ├── 01-plan.md
│   │   ├── 02-design.md
│   │   ├── 03-analysis.md
│   │   └── 04-report.md
│   └── ...
└── session-state.json
```

---

## 7. 티켓 번호 채번 규칙

```
형식: {TYPE}-{NNN}
- TYPE: EPIC, REQ, TASK, SUB, BUG
- NNN: 3자리 순번 (001부터)

채번 시:
1. INDEX.md에서 해당 타입의 최대 번호 확인
2. +1 증가
3. 중복 금지 (삭제된 번호 재사용 금지)
```

---

## 8. 우선순위 체계

| 등급 | 의미 | 대응 시간 | 예시 |
|------|------|----------|------|
| **P0** | 긴급/장애 | 즉시 | 서버 다운, 데이터 손실 |
| **P1** | 높음 | 당일 | 핵심 기능 버그 |
| **P2** | 보통 | 이번 스프린트 | 일반 기능 구현 |
| **P3** | 낮음 | 백로그 | 개선사항, 리팩토링 |
