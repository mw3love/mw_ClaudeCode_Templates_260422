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
