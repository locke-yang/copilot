param(
    [switch]$Force
)

# 定義路徑
$sourceCopilotPath = Join-Path $PSScriptRoot "..\\.github"
$userCopilotPath = Join-Path $env:APPDATA "Code\User\.github"

# 檢查來源路徑是否存在
if (-not (Test-Path $sourceCopilotPath)) {
    Write-Error "找不到來源 .github 路徑: $sourceCopilotPath"
    exit 1
}

# 建立使用者 .github 目錄
Write-Host "建立使用者 .github 目錄: $userCopilotPath" -ForegroundColor Cyan
New-Item -ItemType Directory -Path $userCopilotPath -Force | Out-Null

# 定義要複製的檔案
$filesToCopy = @(
    "copilot-instructions.md",
    "copilot-chat-instructions.md"
)

Write-Host "找到 $($filesToCopy.Count) 個檔案" -ForegroundColor Green

foreach ($fileName in $filesToCopy) {
    $sourcePath = Join-Path $sourceCopilotPath $fileName
    $targetPath = Join-Path $userCopilotPath $fileName
    
    if (-not (Test-Path $sourcePath)) {
        Write-Host "略過 $fileName (來源檔案不存在)" -ForegroundColor Yellow
        continue
    }
    
    if ((Test-Path $targetPath) -and -not $Force) {
        Write-Host "跳過 $fileName (已存在，使用 -Force 覆蓋)" -ForegroundColor Yellow
    } else {
        Copy-Item -Path $sourcePath -Destination $targetPath -Force
        Write-Host "已複製: $fileName" -ForegroundColor Green
    }
}

Write-Host "`n✓ Copilot 指令複製完成！" -ForegroundColor Green
Write-Host "所有工作區現在都可以使用這些指令。`n" -ForegroundColor Cyan
