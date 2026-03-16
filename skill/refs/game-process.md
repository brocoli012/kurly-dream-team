# Game Development Process Reference

> on-demand 로드 문서. SKILL.md에서 `@refs/game-process.md` 참조 시 로드.

---

## 1. 게임 프로젝트 타입 감지

다음 조건 중 하나 이상 충족 시 게임 프로젝트로 분류:

| 감지 신호 | 예시 |
|----------|------|
| 키워드 | "게임", "game", "플레이", "레벨", "스테이지" |
| 파일 구조 | `Assets/`, `Scenes/`, `*.unity`, `game.config` |
| 기술 스택 | Unity, Godot, Phaser, PixiJS, Three.js |
| 요청 내용 | "캐릭터", "적", "아이템", "점수", "HP" |

### 게임 모드 활성화 시
```
1. 게임 전용 역할 활성화 (17-role 시스템)
2. 프로토타입 게이트 적용
3. QA 2단계 검증 활성화
4. 주 단위 1-scene 데모 게이트 적용
```

---

## 2. 17-role 시스템 개요

게임 프로젝트에서 활성화되는 전체 역할:

### 기본 역할 (10)
| 역할 | 책임 |
|------|------|
| Master | 총괄 조율, 사용자 소통 |
| PM | 요구사항 관리, 일정 |
| Designer | UI/UX 설계 |
| TPO | 기술 의사결정, 모델 라우팅 |
| Developer | 일반 코드 구현 |
| QA | 품질 검증 |
| dev-ios | iOS 네이티브 |
| dev-android | Android 네이티브 |
| dev-mobile | 크로스플랫폼 모바일 |
| dev-frontend | 프론트엔드 전문 |

### 게임 전용 역할 (7)
| 역할 | 책임 | 상세 |
|------|------|------|
| **Story Writer** | 세계관, 캐릭터, 내러티브 | `@refs/game-roles.md` |
| **Game Designer** | 게임 메카닉, 규칙, 밸런스 | `@refs/game-roles.md` |
| **Level Designer** | 공간 설계, 난이도 곡선 | `@refs/game-roles.md` |
| **Art Director** | 비주얼 디렉션, 에셋 명세 | `@refs/game-roles.md` |
| **dev-game** | 게임 시스템 구현 (Unity/C#) | `@refs/game-roles.md` |
| **dev-proto** | 웹 프로토타입 제작 | `@refs/game-roles.md` |
| **dev-frontend** | 웹 게임 프론트엔드 | 기본 역할 겸임 |

---

## 3. 게임 개발 파이프라인

```
Story → Prototype → Design → Development → QA
  │         │          │          │          │
  ▼         ▼          ▼          ▼          ▼
세계관    코어루프    상세설계    구현      2단계검증
캐릭터    검증       밸런싱     에셋적용   기능+게임플레이
내러티브  Go/No-Go   레벨설계   통합
```

### 단계별 상세

#### Story Phase
- **담당**: Story Writer
- **산출물**: 세계관 문서, 캐릭터 시트, 주요 내러티브
- **완료 기준**: PM 승인

#### Prototype Phase
- **담당**: dev-proto
- **산출물**: 웹 기반 플레이 가능한 프로토타입
- **완료 기준**: Prototype Gate 통과

#### Design Phase
- **담당**: Game Designer + Level Designer + Art Director
- **산출물**: GDD, 레벨 맵, 아트 명세
- **완료 기준**: Gate 1 통과

#### Development Phase
- **담당**: dev-game (+ Developer)
- **산출물**: 완성된 게임 빌드
- **완료 기준**: Gate 2 통과

#### QA Phase
- **담당**: QA
- **산출물**: QA 리포트, Match Rate
- **완료 기준**: Gate 3 통과

---

## 4. Prototype Gate

프로토타입 단계의 전용 게이트:

### 통과 조건
- [ ] 배포된 프로토타입 (웹 접근 가능)
- [ ] 코어 루프 1회 이상 체험 가능
- [ ] 핵심 메카닉 동작 확인
- [ ] Go/No-Go 결정

### Go/No-Go 판정
```
Go 조건 (모두 충족):
- 코어 루프가 "재미있다" / "가능성 있다" 판단
- 기술적 구현 가능성 확인
- 예상 개발 기간 산출 가능

No-Go 시:
- 프로토타입 피드백 기반 수정안 제시
- 최대 2회 재시도
- 2회 재시도 후에도 No-Go → 프로젝트 재검토
```

---

## 5. 1-scene 데모 게이트

주 단위 개발에서 중간 검증 지점:

### 매주 검증 항목
| # | 항목 | 필수 |
|---|------|------|
| 1 | 1개 씬 완전 플레이 가능 | YES |
| 2 | 해당 씬 코어 메카닉 동작 | YES |
| 3 | 기본 아트 에셋 적용 | YES |
| 4 | 알려진 버그 목록 정리 | YES |
| 5 | 다음 주 계획 수립 | YES |

### 데모 실패 시
```
1. 블로커 식별
2. 다음 주 우선순위에 블로커 해결 포함
3. 2주 연속 실패 시 → TPO 프로세스 리뷰
4. 3주 연속 실패 시 → 스코프 축소 검토
```

---

## 6. QA 2단계 검증

### Stage 1: 기능 검증 (Functionality)
```
검증 항목:
1. 모든 인터랙션 동작 확인
   - 클릭, 드래그, 키보드 입력 등
   - 입력-출력 매핑 테이블 대조
2. 게임 상태 전이 검증
   - 메뉴 → 플레이 → 결과 등
3. 에러/크래시 없음
4. 성능 기준 충족
   - 목표 FPS 달성
   - 메모리 사용량 적정
```

### Stage 2: 게임플레이 검증 (Gameplay)
```
검증 항목:
1. 코어 루프 체험 가능
   - 시작 → 진행 → 보상 → 반복
2. 난이도 곡선
   - 초반 쉬움 → 점진적 상승
   - 절망의 구간 없음
3. 보상 체계
   - 행동 대비 적절한 보상
4. 유저 흐름
   - 다음 할 일이 명확
   - 막힘 없는 진행
```

### QA FAIL 기준
| 기준 | 심각도 | 설명 |
|------|--------|------|
| **인터랙션 타입 변경** | CRITICAL | 설계서의 클릭이 구현에서 드래그로 변경 등 |
| **매핑 테이블 누락** | CRITICAL | 입력-출력 관계가 문서화되지 않음 |
| **코어 루프 미완성** | CRITICAL | 게임의 핵심 사이클 체험 불가 |
| **크래시/무한 로딩** | CRITICAL | 게임 진행 불가 |
| **성능 미달** | HIGH | 목표 FPS의 70% 미만 |
| **난이도 부적절** | MEDIUM | 극단적 난이도 (너무 쉽거나 어려움) |

---

## 7. 게임 상태 추가 (티켓)

게임 프로젝트에서 추가되는 티켓 상태:

```
기본: open → in_analysis → in_research → ready → in_design → in_progress → in_review → done

게임 추가:
open → in_story → in_prototype → in_analysis → ...
```

| 상태 | 설명 | 담당 |
|------|------|------|
| `in_story` | 스토리/세계관 작업 중 | Story Writer |
| `in_prototype` | 프로토타입 개발 중 | dev-proto |
