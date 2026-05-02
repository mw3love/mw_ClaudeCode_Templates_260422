# Claude Code 전역 환경 설치 스크립트
# GitHub clone 후 한 번만 실행:
#   powershell.exe -ExecutionPolicy Bypass -File setup.ps1

$claudeDir  = "$env:USERPROFILE\.claude"
$configRepo = "https://github.com/mw3love/claude-global-config_260502.git"
$repoDir    = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "Claude Code 전역 환경 설치" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# 1. ~/.claude 를 git으로 동기화 (clone 또는 pull)
if (-not (Test-Path "$claudeDir\.git")) {
    if (Test-Path $claudeDir) {
        # 디렉토리는 있지만 git이 아닌 경우: 기존 파일 유지하며 init + pull
        Write-Host "기존 ~/.claude 발견 → git 초기화 후 병합..." -ForegroundColor Yellow
        git -C $claudeDir init
        git -C $claudeDir remote add origin $configRepo
        git -C $claudeDir fetch origin main
        git -C $claudeDir checkout -b main --track origin/main 2>$null
    } else {
        Write-Host "~/.claude 없음 → clone 중..." -ForegroundColor Yellow
        git clone $configRepo $claudeDir
    }
    Write-Host "[OK] ~/.claude 동기화 완료" -ForegroundColor Green
} else {
    Write-Host "기존 git 저장소 발견 → pull 중..." -ForegroundColor Yellow
    git -C $claudeDir pull origin main
    Write-Host "[OK] ~/.claude 최신화 완료" -ForegroundColor Green
}

# 2. git hooks 설치 (post-commit: README 변경 이력 자동 기록)
$srcHooks = Join-Path $repoDir "setup\hooks"
$dstHooks = Join-Path $repoDir ".git\hooks"
if (Test-Path $srcHooks) {
    $oldHook = Join-Path $dstHooks "pre-push"
    if (Test-Path $oldHook) { Remove-Item $oldHook -Force }

    Get-ChildItem $srcHooks | ForEach-Object {
        $dst = Join-Path $dstHooks $_.Name
        Copy-Item $_.FullName $dst -Force
        & git -C $repoDir update-index --chmod=+x "setup/hooks/$($_.Name)" 2>$null
    }
    Write-Host "[OK] git hooks 설치 완료" -ForegroundColor Green
}

# 3. 쉘 bypass 별명 설치 (CMD / PowerShell / Git Bash + 레지스트리)
Write-Host ""
Write-Host "쉘 bypass 설치 중..." -ForegroundColor Cyan
& powershell.exe -ExecutionPolicy Bypass -File "$repoDir\setup\install.ps1"

# 4. 알림 테스트
Write-Host ""
Write-Host "토스트 알림 테스트 중..." -ForegroundColor Cyan
powershell.exe -NoProfile -Sta -ExecutionPolicy Bypass -File "$claudeDir\toast.ps1"

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "설치 완료!" -ForegroundColor Cyan
Write-Host "  - ~/.claude : git으로 관리 ($configRepo)" -ForegroundColor White
Write-Host "  - skills/   : draft (KBS 기안문)" -ForegroundColor White
Write-Host "  - hooks     : Stop (토스트 알림)" -ForegroundColor White
Write-Host ""
