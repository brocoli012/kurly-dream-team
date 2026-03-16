# Kurly Dream Team Pro

AI 에이전트 팀 협업 시스템 for [Claude Code](https://claude.ai/claude-code).

실제 개발팀처럼 **마스터 - PM - TPO - 디자이너 - 개발자 - QA** 역할별 AI 에이전트가 협업하여 소프트웨어를 개발합니다.

## 특징

- **역할 기반 위임**: 마스터가 Task tool로 전문 에이전트에게 작업 위임
- **복잡도 기반 프로세스**: 1-2점(단순) ~ 7점+(복잡)에 따라 자동으로 프로세스 조절
- **품질 게이트**: 6단계 품질 관문 (Research → Story → Prototype → Design → Dev → QA)
- **컨텍스트 최적화**: Claude Pro에서도 효율적으로 동작하도록 3-Layer Lazy Loading 설계
- **다양한 프로젝트 지원**: 웹서비스, 모바일앱, 웹게임, 스킬 개발

## 빠른 시작

### 1. 설치

```bash
git clone https://github.com/brocoli012/kurly-dream-team.git ~/kurly-dream-team
cd ~/kurly-dream-team
chmod +x install.sh && ./install.sh
```

### 2. 프로젝트 초기화

```bash
# 프로젝트 디렉토리에서
bash ~/kurly-dream-team/project-init/init.sh .
```

### 3. 사용

Claude Code에서:
```
드림팀 불러줘
```
또는
```
/dt
```

## 에이전트 구성

| 에이전트 | 역할 | 모델 |
|---------|------|------|
| **마스터** | 총괄 조율, 품질 검수 | Opus |
| **PM** | 기획, 요구사항 정리 | 동적 |
| **TPO** | 기술 설계, 과제 분해, 모델 라우팅 | Opus |
| **디자이너** | UI/UX 설계 | 동적 |
| **풀스택/백엔드/프론트엔드** | 코드 구현 | 동적 |
| **iOS/Android** | 모바일 앱 개발 | 동적 |
| **게임 개발자/프로토타입** | 게임 구현 | 동적 |
| **QA** | 테스트, 품질 검증 | 동적 |

## 위임 경로

### 웹/앱 프로젝트

| 복잡도 | 경로 |
|:------:|------|
| 1-2점 | Master → Developer |
| 3-4점 | Master → TPO → Dev → QA |
| 5점+ | Master → PM → Designer → TPO → Dev → QA |

### 게임 프로젝트

| 복잡도 | 경로 |
|:------:|------|
| 1-2점 | Master → dev-game |
| 3-4점 | Master → TPO → dev-game → QA |
| 5점+ | Master → PM → Writer → dev-proto → Designer → TPO → dev-game → QA |

### 긴급 (P0)

Master → TPO → Dev (QA 병렬)

## 디렉토리 구조

```
kurly-dream-team/
├── install.sh              # 설치 스크립트
├── uninstall.sh            # 제거 스크립트
├── skill/                  # Claude Code 스킬 본체
│   ├── SKILL.md            # 코어 규칙 (~4KB)
│   ├── agents/             # 역할별 프롬프트
│   ├── refs/               # 온디맨드 참조 문서
│   ├── hooks/              # Hook 스크립트
│   └── templates/          # 티켓/리포트 템플릿
├── project-init/           # 프로젝트 초기화
│   ├── init.sh
│   └── rules/              # .claude/rules 파일
└── docs/                   # 상세 문서
```

### 프로젝트에 생성되는 구조

```
your-project/
├── .dream-team/
│   ├── session-state.json  # 세션 상태
│   ├── tickets/            # 티켓 관리
│   ├── docs/               # PDCA 문서
│   ├── memory/             # 프로젝트 메모리
│   └── state/              # 상태 머신
└── .claude/rules/          # 에이전트 규칙
```

## 컨텍스트 최적화

기존 드림팀 스킬 대비 **컨텍스트 사용량 77% 절감**:

| | 기존 | Pro Edition |
|---|:---:|:---:|
| SKILL.md | 17KB | **4KB** |
| 초기 로드 | 17KB+ | **4KB** |
| 에이전트 참조 | 혼재 | **해당 역할만** |
| 최대 오버헤드 | ~47KB | **~8KB** |

### 3-Layer Lazy Loading

```
Layer 0: SKILL.md 코어 (항상 로드)        ~4KB
Layer 1: 활성 역할 프롬프트 (위임 시)      ~1.5KB
Layer 2: 프로세스 참조 (필요 시)           ~2-3KB
```

## 제거

```bash
cd ~/kurly-dream-team
./uninstall.sh
```

프로젝트의 `.dream-team/` 폴더와 `.claude/rules/dream-team-*.md` 파일은 수동 삭제.

## 요구사항

- [Claude Code](https://claude.ai/claude-code) 설치
- Claude Pro 이상 구독
- macOS / Linux

## 라이선스

MIT License
