# 시작 가이드

## 사전 준비

1. **Claude Code** 설치 확인
   ```bash
   claude --version
   ```

2. **Claude Pro** 이상 구독 확인

## 설치

```bash
# 1. 레포지토리 클론
git clone https://github.com/brocoli012/kurly-dream-team.git ~/kurly-dream-team

# 2. 설치 실행
cd ~/kurly-dream-team
chmod +x install.sh
./install.sh
```

설치 완료 시 `~/.claude/skills/kurly-dream-team/`에 스킬이 복사됩니다.

## 프로젝트 초기화

각 프로젝트에서 한 번만 실행:

```bash
cd /path/to/your/project
bash ~/kurly-dream-team/project-init/init.sh .
```

생성되는 구조:
```
.dream-team/
├── session-state.json    # 세션 상태 추적
├── tickets/              # 티켓 관리
│   ├── backlog/
│   ├── in_progress/
│   └── done/
├── docs/                 # PDCA 문서 체인
│   ├── 00-research/
│   ├── 01-plan/
│   ├── 02-design/
│   ├── 03-analysis/
│   └── 04-report/
├── memory/               # 프로젝트 메모리
└── state/                # 티켓별 상태 머신
```

## 드림팀 호출

Claude Code에서:

```
드림팀 불러줘
```

또는:

```
/dt
```

## 첫 번째 요청

```
사용자: 드림팀 불러줘
드림팀: (세션 상태 보고)

사용자: 로그인 페이지 만들어줘
드림팀:
  - 복잡도 추정: Medium (3-4점)
  - 승인 모드 질문
  - TPO에게 기술 설계 위임
  - Developer에게 구현 위임
  - QA에게 검증 위임
```

## 프로젝트 유형

드림팀은 자동으로 프로젝트 유형을 감지하거나, 명시적으로 지정할 수 있습니다:

- **웹 서비스**: React, Next.js, Vue 등
- **모바일 앱**: iOS (Swift), Android (Kotlin), 하이브리드
- **웹 게임**: Unity WebGL, Phaser, 순수 Canvas/WebGL
- **스킬 개발**: Claude Code 스킬

## 업데이트

```bash
cd ~/kurly-dream-team
git pull
./install.sh
```

## 제거

```bash
cd ~/kurly-dream-team
./uninstall.sh
```

프로젝트의 `.dream-team/` 폴더는 수동 삭제:
```bash
rm -rf /path/to/project/.dream-team
rm /path/to/project/.claude/rules/dream-team-*.md
```
