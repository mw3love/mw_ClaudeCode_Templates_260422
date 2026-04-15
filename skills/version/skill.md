---
name: version
description: KBS Peacock 프로젝트의 버전 번호를 일괄 변경하고 커밋+푸시하는 스킬. 사용자가 "/version X.X.X" 또는 "버전 X.X.X로 올려", "버전 변경", "버전 업데이트" 등을 말할 때 반드시 사용. 버전 번호가 적힌 3곳(main.py, main_window.py, settings_dialog.py)을 모두 변경하고, About 날짜를 오늘 날짜로 갱신하고, README.md 버전 이력 테이블에 새 항목을 추가한 뒤 git 커밋 및 푸시까지 자동으로 수행한다.
---

# KBS Peacock 버전 관리 스킬

## 개요

이 스킬은 KBS Peacock 모니터링 프로그램의 버전 번호를 한 번에 관리한다.
사용자가 `/version 1.5.6` 또는 `/version` (인자 없음)으로 호출한다.
커밋 후 `git push`까지 자동으로 수행한다.

## 변경해야 할 위치 (총 5곳)

| 파일 | 위치 | 변경 내용 |
|------|------|----------|
| `kbs_monitor/main.py` | `app.setApplicationName(...)` | 버전 번호 |
| `kbs_monitor/ui/main_window.py` | `self.setWindowTitle(...)` | 버전 번호 |
| `kbs_monitor/ui/settings_dialog.py` | `lbl_version = QLabel(...)` | 버전 번호 |
| `kbs_monitor/ui/settings_dialog.py` | `lbl_date = QLabel(...)` | 오늘 날짜 (YYYY-MM-DD) |
| `README.md` | 버전 이력 테이블 | 새 버전 행 맨 위에 추가 |

## 실행 순서

### 1단계: 버전 번호 확인

- 인자가 있으면 그 버전을 사용 (예: `/version 1.5.6` → `1.5.6`)
- **인자가 없으면** `kbs_monitor/main.py`에서 현재 버전을 읽은 뒤 **패치 버전(세 번째 숫자)을 자동으로 +1**하여 사용한다.
  - 예: 현재 `v1.6.7` → 자동으로 `1.6.8` 적용 (사용자에게 묻지 않음)
  - 자동 결정된 버전을 사용자에게 한 줄로 알리고 즉시 진행한다.
- `v` 접두사는 제거하고 순수 숫자 형식으로 사용 (`1.5.6`, `v` 없이)

### 2단계: 오늘 날짜 확인

```bash
date +%Y-%m-%d
```

### 3단계: 4개 파일 수정

각 파일의 정확한 패턴을 grep으로 먼저 확인한 뒤, Edit 도구로 수정한다.

**main.py**
```
app.setApplicationName("KBS Peacock v{이전버전}")
→
app.setApplicationName("KBS Peacock v{새버전}")
```

**main_window.py**
```
self.setWindowTitle("KBS Peacock v{이전버전}")
→
self.setWindowTitle("KBS Peacock v{새버전}")
```

**settings_dialog.py** (2곳)
```
lbl_version = QLabel("KBS Peacock v{이전버전}")
→
lbl_version = QLabel("KBS Peacock v{새버전}")

lbl_date = QLabel("{이전날짜}")
→
lbl_date = QLabel("{오늘날짜}")
```

**README.md** — 버전 이력 테이블 맨 위에 새 행 삽입

변경사항 요약은 이전 버전 이후의 git log를 참고해 한 줄로 자동 생성한다:
```bash
git log v{이전버전태그}..HEAD --oneline 2>/dev/null || git log --oneline -10
```
(태그가 없으면 최근 커밋 10개를 참고해 판단)

```markdown
| **v{새버전}** | {주요 변경사항 한 줄 요약} |
```

기존 테이블의 `| **v{이전최신버전}**` 행 바로 위에 삽입한다.

### 4단계: 변경 확인

수정 후 grep으로 3곳 모두 새 버전으로 바뀌었는지 확인한다.

```bash
grep -rn "KBS Peacock v" kbs_monitor/ --include="*.py"
```

### 5단계: git 커밋 및 푸시

`kbs_config.json`은 커밋에서 반드시 제외한다.

```bash
git add kbs_monitor/main.py kbs_monitor/ui/main_window.py kbs_monitor/ui/settings_dialog.py README.md
git commit -m "v{새버전}: 버전 번호 업데이트

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
git push
```

## 결과 보고

커밋 및 푸시 완료 후 변경된 5곳(버전 3곳 + 날짜 1곳 + README 1곳)을 간단히 요약해 알려준다.
