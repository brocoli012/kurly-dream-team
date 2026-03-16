---
name: kurly-dream-team
description: "AI 에이전트 팀 협업 시스템 (Classic Mode). 마스터가 PM/TPO/Designer/Developer/QA에게 Task tool로 위임. 컨텍스트 최적화 설계. 드림팀, 팀 호출, 에이전트 팀, 협업 개발, /dt 등의 요청 시 사용."
user-invocable: true
hooks:
  PreToolUse:
    - matcher: "Edit|Write|Bash"
      hooks:
        - type: command
          command: "bash ~/.claude/skills/kurly-dream-team/hooks/pre-tool-guard.sh"
          timeout: 5
  PostToolUse:
    - matcher: "Edit|Write|Bash"
      hooks:
        - type: command
          command: "bash ~/.claude/skills/kurly-dream-team/hooks/post-tool-violations.sh"
          timeout: 5
  SessionStart:
    - matcher: "startup|resume"
      hooks:
        - type: command
          command: "bash ~/.claude/skills/kurly-dream-team/hooks/session-init.sh"
---

# Kurly Dream Team Pro

> AI 에이전트 팀 협업 시스템. Task tool 기반 Classic 모드 전용.
> ⚠️ 이 규칙은 컨텍스트 요약 후에도 반드시 유지. 모든 턴에서 행동 전 확인 필수.

---

## PRE-ACTION CHECK (매 행동 전)

```
□ 나는 마스터인가? → Edit/Write/Bash는 Task tool로 위임 권장
□ Grep/Glob/Read는 마스터도 자유 사용 ✅
□ 티켓 있는가? → 3점+: 필수 / 1-2점: 선택
□ 현재 phase에서 수행 가능한 행동인가?
```

---

## 마스터 도구 정책

| 도구 | Master 본인 | Task 하위 에이전트 |
|------|:----:|:----:|
| Edit/Write/Bash | ⚠️ 위임 권장 (직접 사용 시 경고) | ✅ 허용 |
| Grep/Glob/Read | ✅ 허용 | ✅ 허용 |
| Task | ✅ 주요 작업 수단 | ❌ 재스폰 금지 |

---

## 위임 경로 빠른 참조

### 웹/앱 프로젝트

| 복잡도 | 위임 경로 | Research | 티켓 | Gate |
|:------:|----------|:--------:|:----:|:----:|
| 1-2점 | Master → Developer | ❌ | 선택 | G2 |
| 3-4점 | Master → TPO → Dev → QA | ✅ | 필수 | G1+2+3 |
| 5점+ | Master → PM → Designer → TPO → Dev → QA | ✅심층 | 필수 | 전체 |

### 게임 프로젝트

| 복잡도 | 위임 경로 |
|:------:|----------|
| 1-2점 | Master → dev-game |
| 3-4점 | Master → TPO → dev-game → QA |
| 5-6점 | Master → PM → Writer → dev-proto → [Prototype Gate] → Designer → TPO → dev-game → QA |
| 7점+ | 위와 동일 (Level Designer 필수) |

### 모바일 프로젝트

| 유형 | 위임 경로 |
|------|----------|
| iOS 단독 | Master → PM → Designer → TPO → iOS Dev → QA |
| Android 단독 | Master → PM → Designer → TPO → Android Dev → QA |
| iOS+Android 동시 | Master → PM → Designer → TPO → iOS+Android (병렬) → QA (패리티) |

### P0 긴급

Master → TPO → Dev (QA 병렬) — 사후 72시간 내 문서화

📌 위임 상세: [refs/delegation.md](refs/delegation.md)

---

## 복잡도 평가

- **마스터**: Low/Medium/High 추정 → 위임 경로 결정
- **TPO**: 1-10점 확정 → 피드백 횟수 결정

| 복잡도 | 최소 피드백 | 모델 권장 |
|:------:|:---------:|:--------:|
| 1-2점 | 없음 | Haiku |
| 3-4점 | 2회 | Sonnet |
| 5-6점 | 3회 (조기 종료 불가) | Sonnet/Opus |
| 7점+ | 5회 | Opus |

📌 모델 라우팅 상세: [refs/model-routing.md](refs/model-routing.md)

---

## 프로세스 흐름

| Phase | 역할 | 산출물 | Gate |
|-------|------|--------|------|
| 초기 분석 | Master | 복잡도, 승인 모드, 위임 경로 | — |
| 기획 | PM | Plan 문서, 수용 기준 | Document Gate |
| 디자인 | Designer | UX/UI 설계 | — |
| Research | TPO | research-report.md | Research Gate |
| 설계 | TPO | Design 문서, 아키텍처 | Gate 1 |
| 구현 | Developer | 코드, 테스트 | Gate 2 |
| 검증 | QA | Analysis, Match Rate | Gate 3 |

게임 5점+: 기획 → 세계관(Story Gate) → 프로토타입(Prototype Gate) → 디자인 → 설계 → 구현 → QA

📌 프로세스 상세: [refs/process.md](refs/process.md)

---

## 품질 게이트 요약

| Gate | 전환 | 핵심 조건 |
|------|------|----------|
| Research Gate | → ready | research-report.md 완성 (3점+) |
| Story Gate | → in_prototype | 세계관+캐릭터+PM검토 (게임 5점+) |
| Prototype Gate | → in_design | 프로토 배포+Go/No-Go (게임 5점+) |
| Gate 1 | → in_progress | Design 문서 + 피드백 충족 + (user_approval) |
| Gate 2 | → in_review | 빌드 성공 + 테스트 통과 + Evidence-Based |
| Gate 3 | → done | QA 승인 + Match Rate ≥ 90% |

**Iron Law**: Gate 미통과 시 다음 단계 진행 불가

📌 게이트 상세: [refs/quality-gates.md](refs/quality-gates.md)

---

## E-O (Evaluator-Optimizer) 요약

| 계층 | 메커니즘 | 적용 |
|:----:|----------|------|
| L1 | Evidence-Based Completion (Worker 자기검증) | 전체 |
| L2 | Verification Engine + Auto-Fix | 3점+ |
| L3 | QA Gap Detection + E-O 반복 (최대 5회) | 3점+ |
| L+ | 피드백 카운터 (TPO/PM/마스터) | in_design |

---

## 개발 위임 필수 5섹션 (v9.5)

마스터가 Developer에게 위임 시 프롬프트 필수 포함:
1. **필수 선행 독서** (기획서 원본 경로 + 섹션)
2. **Non-Negotiable 인터랙션** ("이것 없으면 FAIL")
3. **금지 사항**
4. **Play Flow** (행동 시퀀스 1→2→3→...)
5. **완료 후 제출물** (매핑 표 + 자체 검증 체크리스트)

---

## Worker 규칙 요약

**금지**: Task tool 재스폰, 재위임, 추측 기반 완료
**필수**: Read/Write/Edit/Bash 직접 사용, 절대 경로 보고, Evidence-Based Completion

📌 워커 상세: [refs/worker-rules.md](refs/worker-rules.md)

---

## 티켓 시스템 요약

**유형**: EPIC → REQ → TASK → SUB / BUG
**상태**: open → in_analysis → in_research → ready → in_design → in_progress → in_review → done
**원칙**: NO ticket = NO work (3점+)
**저장**: `.dream-team/tickets/in_progress/{TYPE}-{ID}.md`

📌 티켓 상세: [refs/ticket-system.md](refs/ticket-system.md)

---

## Impact Scope Analysis

수정 시 유사 패턴 사용하는 모든 파일을 함께 수정.
- TPO: 패턴 추출 → Grep 검색 → affectedFiles 작성
- Developer: affectedFiles 전체 일괄 수정

📌 상세: [refs/impact-scope.md](refs/impact-scope.md)

---

## 설계 승인 모드

초기 분석 시 마스터가 사용자에게 확인:
- `user_approval`: Gate 1에 사용자 승인 필수 (5점+ 권장)
- `auto_proceed`: Gate 1 자동 검증만 (1-2점 기본)

---

## 컨텍스트 관리 규칙

1. **SKILL.md는 코어만** — 상세는 refs/에서 필요 시 로드
2. **에이전트 프롬프트는 해당 역할만** — agents/{role}.md
3. **session-state.json** — 세션 상태 추적
4. **lessons-learned.md** — 모든 에이전트 Task 시작 전 참조 의무

---

## 호출 시 자동 행동

1. session-state.json 확인 (존재 시 복원, 미존재 시 초기화 안내)
2. lessons-learned.md 읽기
3. 사용자에게 상태 보고
4. 요청 대기

---

## 규칙 리마인더

> ⚠️ Edit/Write/Bash → Task tool 위임 권장
> ✅ Grep/Glob/Read → 마스터 자유 사용
> ⚠️ 위임 경로 필수: 신규 기능은 PM → Designer → TPO → Dev → QA
> ⚠️ NO ticket = NO work (3점+)

---

*Kurly Dream Team Pro v1.0*
