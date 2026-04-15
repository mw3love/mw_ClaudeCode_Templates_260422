# mw_ClaudeCode_Templates

Claude Code 전역 설정 및 커스텀 스킬 모음.

## 스킬 (skills/)

Claude Code에서 `/스킬명` 으로 호출하는 사용자 정의 명령어.

| 스킬 | 호출 | 설명 |
|------|------|------|
| fix-plan | `/fix-plan <문제 설명>` | 버그/이슈 수정계획 문서 자동 생성 |
| task-plan | `/task-plan` | PRD 분석 후 구현 작업계획 대화식 수립 |

### 설치 (신규 PC)

```powershell
# ~/.claude 폴더가 없는 경우
git clone https://github.com/mw3love/mw_ClaudeCode_Templates_260422.git "$env:USERPROFILE\.claude"

# 이미 ~/.claude가 있는 경우 — remote 연결 후 병합
cd ~/.claude
git init
git remote add origin https://github.com/mw3love/mw_ClaudeCode_Templates_260422.git
git fetch origin
git merge origin/main --allow-unrelated-histories
```

Claude Code를 재시작하면 스킬이 자동 인식됩니다.

## 업데이트

```bash
cd ~/.claude
git pull
```

## 변경 이력

| 날짜 | 내용 | PC |
|------|------|-----|
| 2025-04-15 | setup.ps1 Edit/Write 권한에 Windows 절대 경로 형식 추가 | MW-Lenovo |
| 2025-04-15 | setup.ps1에 Write/NotebookEdit/WebFetch/WebSearch 권한 추가 | MW-Lenovo |
| 2025-04-15 | 전역 CLAUDE.md 추가 (추측 대신 조사 우선 원칙) | MW-Lenovo |
| 2025-04-15 | Bash 허용 형식 수정 Bash → Bash(*) | MW-Lenovo |
| 2025-04-14 | commands/templates 제거, skills 구조로 통합 | MW-Lenovo |
| 2025-04-13 | setup.ps1 추가 및 fix-plan 단계 구조 개선 | MW-Lenovo |
| 2025-04-12 | 초기 생성 (commands/agents/templates) | MW-Lenovo |
