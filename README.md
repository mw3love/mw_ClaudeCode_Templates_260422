# mw_ClaudeCode_Templates

Claude Code 전역 환경 설정 템플릿 모음.

## 포함 항목

| 항목 | 종류 | 설명 | 템플릿 포함 |
|------|------|------|:-----------:|
| `draft` | skill | KBS 기안문/보고서 작성 (어느 프로젝트에서든 사용) | ✅ |
| toast 알림 | hook | 응답 완료 시 Windows 토스트 알림 | ✅ |
| post-commit 훅 | hook | 커밋 시 README 변경 이력 자동 기록 | ✅ |
| bypass 래퍼 | shell | `claude` 입력 시 자동 bypass permissions 모드 | ✅ |

---

## 신규 PC 설치

### 1. 저장소 클론

```bash
git clone https://github.com/mw3love/mw_ClaudeCode_Templates_260422.git
```

### 2. 설치 스크립트 실행 (PowerShell)

```powershell
cd mw_ClaudeCode_Templates_260422
powershell -ExecutionPolicy Bypass -File setup.ps1
```

한 번 실행으로 아래 항목이 자동 설정됩니다.

| 항목 | 내용 |
|------|------|
| CMD | `claude` 입력 시 자동 bypass permissions 모드 |
| PowerShell | `claude` 입력 시 자동 bypass permissions 모드 |
| Git Bash | `claude` 입력 시 자동 bypass permissions 모드 |
| 완료 알림 | 응답 완료 시 Windows 토스트 알림 |
| settings.json | `skipDangerousModePermissionPrompt` 및 Stop hook 자동 구성 |
| skills/ | `draft` 복사 → `~/.claude/skills/` |
| git hook | post-commit (README 변경 이력 자동 기록) |

> **참고:** Claude Code(`claude.exe`)가 먼저 설치되어 있어야 합니다.

## 업데이트

설정 파일이 변경된 경우 pull 후 설치 스크립트를 재실행합니다.

```powershell
cd mw_ClaudeCode_Templates_260422
git pull
powershell -ExecutionPolicy Bypass -File setup.ps1
```

## 변경 이력

| 날짜 | PC | 커밋 메시지 |
|------|----|------------|
| 2026-05-02 | Home-Desktop | fix: toast 알림 PowerShell 옵션 수정 (-NonInteractive → -Sta) |
| 2026-04-28 | Home-N100 | fix: pre-push 훅을 post-commit으로 교체 (push 충돌 제거) |
| 2026-04-28 | Home-N100 | fix: pre-push 훅 push 에러 메시지 억제 |
| 2026-04-28 | Home-N100 | fix: pre-push 훅에서 README 커밋 즉시 push 추가 |
| 2026-04-28 | Home-N100 | docs: 포함항목 표에서 미포함 스킬 3개 제거 |
| 2026-04-28 | Home-N100 | docs: README에서 eval-plan 항목 제거 |
| 2026-04-28 | Home-N100 | remove: eval-plan 에이전트 제거 |
| 2026-04-28 | Home-N100 | fix: setup.ps1에 install.ps1 통합 호출, README 설치 안내 단일화 |
| 2026-04-28 | Home-N100 | docs: README 전면 개편 (포함항목 표, 변경이력 정렬) |
| 2026-04-28 | Home-N100 | fix: setup.ps1에 git hooks 설치 단계 추가 |
| 2026-04-28 | Home-N100 | feat: KBS 기안문 전역 draft 스킬 추가 |
| 2026-04-25 | Home-Desktop | feat: push 시 README 변경 이력 자동 기록 (pre-push 훅) |
