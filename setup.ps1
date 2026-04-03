# Claude Code 전역 환경 설치 스크립트
# GitHub clone 후 한 번만 실행:
#   powershell.exe -ExecutionPolicy Bypass -File setup.ps1

$claudeDir = "$env:USERPROFILE\.claude"
$toastPath = "$claudeDir\toast.ps1"
$settingsPath = "$claudeDir\settings.json"
$utf8bom = New-Object System.Text.UTF8Encoding $true

Write-Host ""
Write-Host "Claude Code 전역 환경 설치" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# 1. toast.ps1 생성
$msg = -join ([char[]](0xC751,0xB2F5,0x20,0xC644,0xB8CC,0x20,0x2D,0x20,0xC785,0xB825,0x20,0xB300,0xAE30,0x20,0xC911))
$toastContent = @"
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
`$n = New-Object System.Windows.Forms.NotifyIcon
`$n.Icon = [System.Drawing.SystemIcons]::Information
`$n.Visible = `$true
`$n.ShowBalloonTip(4000, 'Claude Code', '$msg', [System.Windows.Forms.ToolTipIcon]::None)
Start-Sleep -Milliseconds 4500
`$n.Visible = `$false
`$n.Dispose()
"@
[System.IO.File]::WriteAllText($toastPath, $toastContent, $utf8bom)
Write-Host "[OK] toast.ps1 생성됨" -ForegroundColor Green

# 2. settings.json 생성
#    기존 파일이 있으면 읽고, 없으면 빈 객체로 시작
if (Test-Path $settingsPath) {
    $settings = Get-Content $settingsPath -Raw -Encoding UTF8 | ConvertFrom-Json
    Write-Host "[OK] 기존 settings.json 불러옴" -ForegroundColor Green
} else {
    $settings = [PSCustomObject]@{}
    Write-Host "[OK] settings.json 새로 생성" -ForegroundColor Green
}

# 3. Stop hook (응답 완료 토스트 알림)
$stopHook = @(
    [PSCustomObject]@{
        hooks = @(
            [PSCustomObject]@{
                type    = "command"
                command = "powershell.exe -NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$toastPath`""
                async   = $true
            }
        )
    }
)

# 4. PostToolUse hook (소스 파일 수정 시 문서 업데이트 상기)
$postToolUseHook = @(
    [PSCustomObject]@{
        matcher = "Write|Edit"
        hooks   = @(
            [PSCustomObject]@{
                type    = "command"
                command = "python -c `"`nimport sys, json`ndata = json.load(sys.stdin)`nfp = data.get('tool_input',{}).get('file_path','') or data.get('tool_response',{}).get('filePath','')`nexts = ('.py','.js','.ts','.jsx','.tsx','.go','.java','.cs','.cpp','.c','.rs')`nif fp.endswith(exts):`n    print(json.dumps({'hookSpecificOutput':{'hookEventName':'PostToolUse','additionalContext':'[Doc Update Reminder] Source file modified. Check and update if needed: CLAUDE.md, memory/'}}))`n`""
                timeout = 10
            }
        )
    }
)

# 5. hooks 객체에 등록
if ($settings.PSObject.Properties.Name -contains "hooks") {
    Add-Member -InputObject $settings.hooks -NotePropertyName "Stop"        -NotePropertyValue $stopHook        -Force
    Add-Member -InputObject $settings.hooks -NotePropertyName "PostToolUse" -NotePropertyValue $postToolUseHook -Force
} else {
    $settings | Add-Member -NotePropertyName "hooks" -NotePropertyValue (
        [PSCustomObject]@{
            Stop        = $stopHook
            PostToolUse = $postToolUseHook
        }
    )
}

$json = $settings | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($settingsPath, $json, $utf8bom)
Write-Host "[OK] settings.json hooks 등록 완료 (Stop + PostToolUse)" -ForegroundColor Green

# 6. 알림 테스트
Write-Host ""
Write-Host "토스트 알림 테스트 중..." -ForegroundColor Cyan
powershell.exe -NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File $toastPath

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "설치 완료!" -ForegroundColor Cyan
Write-Host "  - agents/  : eval-plan (review / evaluate 모드)" -ForegroundColor White
Write-Host "  - commands/ : fix-plan (수정계획 생성)" -ForegroundColor White
Write-Host "  - hooks     : Stop(토스트 알림) + PostToolUse(문서 업데이트 상기)" -ForegroundColor White
Write-Host ""
