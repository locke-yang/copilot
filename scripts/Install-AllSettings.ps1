param(
    [switch]$Force,
    [switch]$SkipAgents,
    [switch]$SkipVSCode
)

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Copilot 全域設定安裝程式" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$allSuccess = $true

# 安裝 Agents
if (-not $SkipAgents) {
    Write-Host "`n[1/3] 安裝 Agents..." -ForegroundColor Yellow
    try {
        $agentsScript = Join-Path $scriptPath "Install-UserAgents.ps1"
        if (Test-Path $agentsScript) {
            if ($Force) {
                & $agentsScript -Force
            } else {
                & $agentsScript
            }
            Write-Host "✓ Agents 安裝完成`n" -ForegroundColor Green
        } else {
            Write-Host "✗ 找不到 Install-UserAgents.ps1`n" -ForegroundColor Red
            $allSuccess = $false
        }
    } catch {
        Write-Host "✗ Agents 安裝失敗: $_`n" -ForegroundColor Red
        $allSuccess = $false
    }
}

# 複製 VS Code 設定
if (-not $SkipVSCode) {
    Write-Host "[2/2] 複製 VS Code 設定..." -ForegroundColor Yellow
    try {
        $vscodeScript = Join-Path $scriptPath "Copy-VSCodeSettings.ps1"
        if (Test-Path $vscodeScript) {
            if ($Force) {
                & $vscodeScript -Force
            } else {
                & $vscodeScript
            }
            Write-Host "✓ VS Code 設定複製完成`n" -ForegroundColor Green
        } else {
            Write-Host "✗ 找不到 Copy-VSCodeSettings.ps1`n" -ForegroundColor Red
            $allSuccess = $false
        }
    } catch {
        Write-Host "✗ VS Code 設定複製失敗: $_`n" -ForegroundColor Red
        $allSuccess = $false
    }
}

# 最終結果
Write-Host "========================================" -ForegroundColor Cyan
if ($allSuccess) {
    Write-Host "✓ 所有設定安裝完成！" -ForegroundColor Green
    Write-Host "所有工作區現在都可以使用這些設定。`n" -ForegroundColor Green
    exit 0
} else {
    Write-Host "✗ 部分安裝失敗，請檢查上述錯誤訊息。`n" -ForegroundColor Red
    exit 1
}
