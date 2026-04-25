# mw_ClaudeCode_Templates

Claude Code 전역 환경 설정 템플릿 모음.

## 신규 PC 설치

### 1. 저장소 클론

```bash
git clone https://github.com/mw3love/mw_ClaudeCode_Templates_260422.git
```

### 2. 설치 스크립트 실행 (PowerShell)

```powershell
cd mw_ClaudeCode_Templates_260422\setup
powershell -ExecutionPolicy Bypass -File install.ps1
```

한 번 실행으로 아래 항목이 자동 설정됩니다.

| 항목 | 내용 |
|------|------|
| CMD | `claude` 입력 시 자동 bypass permissions 모드 |
| PowerShell | `claude` 입력 시 자동 bypass permissions 모드 |
| Git Bash | `claude` 입력 시 자동 bypass permissions 모드 |
| 완료 알림 | 응답 완료 시 Windows 토스트 알림 |
| settings.json | `skipDangerousModePermissionPrompt` 및 Stop hook 자동 구성 |

> **참고:** Claude Code(`claude.exe`)가 먼저 설치되어 있어야 합니다.

## setup/ 구성

| 파일 | 설명 |
|------|------|
| `install.ps1` | 마스터 설치 스크립트 |
| `claude.cmd` | CMD용 bypass 래퍼 |
| `profile.ps1` | PowerShell 프로필 함수 |
| `bashrc_snippet.sh` | Git Bash `.bashrc` 추가 함수 |
| `toast.ps1` | 응답 완료 Windows 알림 스크립트 |

## 업데이트

설정 파일이 변경된 경우 pull 후 설치 스크립트를 재실행합니다.

```powershell
git pull
cd setup
powershell -ExecutionPolicy Bypass -File install.ps1
```

## 변경 이력

| 날짜 | PC | 커밋 메시지 |
|------|----|------------|
