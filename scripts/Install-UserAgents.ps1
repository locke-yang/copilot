param(
    [switch]$Force
)

# 定義路徑
$sourceAgentsPath = Join-Path $PSScriptRoot "..\\.github\\agents"
$userAgentsPath = Join-Path $env:APPDATA "Code\User\.github\agents"

# 檢查來源路徑是否存在
if (-not (Test-Path $sourceAgentsPath)) {
    Write-Error "找不到來源 Agent 路徑: $sourceAgentsPath"
    exit 1
}

# 建立使用者 Agent 目錄
Write-Host "建立使用者 Agent 目錄: $userAgentsPath" -ForegroundColor Cyan
New-Item -ItemType Directory -Path $userAgentsPath -Force | Out-Null

# 複製 Agent 檔案
$agentFiles = Get-ChildItem -Path $sourceAgentsPath -Filter "*.agent.md" -ErrorAction SilentlyContinue

if ($agentFiles.Count -eq 0) {
    Write-Warning "找不到任何 .agent.md 檔案"
    exit 1
}

Write-Host "找到 $($agentFiles.Count) 個 Agent 檔案" -ForegroundColor Green

foreach ($file in $agentFiles) {
    $targetPath = Join-Path $userAgentsPath $file.Name
    
    if ((Test-Path $targetPath) -and -not $Force) {
        Write-Host "跳過 $($file.Name) (已存在，使用 -Force 覆蓋)" -ForegroundColor Yellow
    } else {
        Copy-Item -Path $file.FullName -Destination $targetPath -Force
        Write-Host "已複製: $($file.Name)" -ForegroundColor Green
    }
}

Write-Host "`n✓ Agent 安裝完成！" -ForegroundColor Green
Write-Host "所有工作區現在都可以使用這些 Agent。`n" -ForegroundColor Cyan
