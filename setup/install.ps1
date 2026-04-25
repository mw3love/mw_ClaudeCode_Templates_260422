$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "=== Claude Code 환경 설치 시작 ===" -ForegroundColor Cyan

# 1. claude.cmd -> %USERPROFILE%\.local\bin\
$binPath = "$env:USERPROFILE\.local\bin"
if (-not (Test-Path $binPath)) { New-Item -ItemType Directory -Path $binPath -Force | Out-Null }
Copy-Item "$scriptDir\claude.cmd" "$binPath\claude.cmd" -Force
Write-Host "[OK] CMD bypass 설정 완료" -ForegroundColor Green

# 2. PowerShell 프로필 설정
$psProfileDir = Split-Path $PROFILE
if (-not (Test-Path $psProfileDir)) { New-Item -ItemType Directory -Path $psProfileDir -Force | Out-Null }
Copy-Item "$scriptDir\profile.ps1" $PROFILE -Force
Write-Host "[OK] PowerShell bypass 설정 완료" -ForegroundColor Green

# 3. PowerShell 실행 정책
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
Write-Host "[OK] PowerShell 실행 정책 설정 완료" -ForegroundColor Green

# 4. CMD AutoRun 레지스트리
$cmdKey = "HKCU:\Software\Microsoft\Command Processor"
if (-not (Test-Path $cmdKey)) { New-Item -Path $cmdKey -Force | Out-Null }
Set-ItemProperty -Path $cmdKey -Name "AutoRun" -Value "doskey claude=`"$env:USERPROFILE\.local\bin\claude.exe`" --dangerously-skip-permissions `$*" -Type String
Write-Host "[OK] CMD AutoRun 설정 완료" -ForegroundColor Green

# 5. toast.ps1 -> %USERPROFILE%\.claude\
$claudeDir = "$env:USERPROFILE\.claude"
if (-not (Test-Path $claudeDir)) { New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null }
Copy-Item "$scriptDir\toast.ps1" "$claudeDir\toast.ps1" -Force
Write-Host "[OK] 완료 알림 스크립트 설정 완료" -ForegroundColor Green

# 6. Windows 알림 활성화
$pushKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications"
if (-not (Test-Path $pushKey)) { New-Item -Path $pushKey -Force | Out-Null }
Set-ItemProperty $pushKey -Name "ToastEnabled" -Value 1 -Type DWord
Write-Host "[OK] Windows 알림 활성화 완료" -ForegroundColor Green

# 7. Git Bash .bashrc 설정
$bashrc = "$env:USERPROFILE\.bashrc"
if (-not (Test-Path $bashrc)) { New-Item -ItemType File -Path $bashrc -Force | Out-Null }
$bashrcContent = Get-Content $bashrc -Raw -ErrorAction SilentlyContinue
if ($bashrcContent -notlike "*dangerously-skip-permissions*") {
    $snippet = Get-Content "$scriptDir\bashrc_snippet.sh" -Raw
    Add-Content $bashrc "`n$snippet"
    Write-Host "[OK] Git Bash bypass 설정 완료" -ForegroundColor Green
} else {
    Write-Host "[SKIP] Git Bash bypass 이미 설정됨" -ForegroundColor Yellow
}

# 8. settings.json Stop hook 및 skipDangerousModePermissionPrompt 설정
$settingsPath = "$env:USERPROFILE\.claude\settings.json"
if (-not (Test-Path $settingsPath)) {
    '{}' | Set-Content $settingsPath -Encoding UTF8
}

$settings = Get-Content $settingsPath -Raw | ConvertFrom-Json

# skipDangerousModePermissionPrompt
if (-not ($settings.PSObject.Properties.Name -contains 'skipDangerousModePermissionPrompt')) {
    $settings | Add-Member -MemberType NoteProperty -Name 'skipDangerousModePermissionPrompt' -Value $true
}

# hooks.Stop
$hookCommand = "powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File `"$env:USERPROFILE\.claude\toast.ps1`""
$hookEntry = [PSCustomObject]@{
    hooks = @(
        [PSCustomObject]@{
            type    = "command"
            command = $hookCommand
            async   = $true
        }
    )
}

if (-not ($settings.PSObject.Properties.Name -contains 'hooks')) {
    $settings | Add-Member -MemberType NoteProperty -Name 'hooks' -Value ([PSCustomObject]@{})
}
if (-not ($settings.hooks.PSObject.Properties.Name -contains 'Stop')) {
    $settings.hooks | Add-Member -MemberType NoteProperty -Name 'Stop' -Value @($hookEntry)
    Write-Host "[OK] settings.json Stop hook 설정 완료" -ForegroundColor Green
} else {
    Write-Host "[SKIP] Stop hook 이미 설정됨" -ForegroundColor Yellow
}

$settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8
Write-Host "[OK] settings.json 저장 완료" -ForegroundColor Green

# 9. pre-push 훅 설치 (저장소 루트의 .git/hooks/)
$repoRoot = Split-Path -Parent $scriptDir
$hooksDir = "$repoRoot\.git\hooks"
if (Test-Path $hooksDir) {
    Copy-Item "$scriptDir\hooks\pre-push" "$hooksDir\pre-push" -Force
    Write-Host "[OK] pre-push 훅 설치 완료" -ForegroundColor Green
} else {
    Write-Host "[SKIP] .git/hooks 없음 (git 저장소 아님)" -ForegroundColor Yellow
}

Write-Host "`n=== 설치 완료! 새 터미널을 열어주세요 ===" -ForegroundColor Cyan
