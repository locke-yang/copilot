param(
    [switch]$Force
)

# 定義路徑
$sourceVSCodePath = Join-Path $PSScriptRoot "..\\.vscode"
$userVSCodePath = Join-Path $env:APPDATA "Code\User\.vscode"

# 檢查來源路徑是否存在
if (-not (Test-Path $sourceVSCodePath)) {
    Write-Error "找不到來源 .vscode 路徑: $sourceVSCodePath"
    exit 1
}

# 建立使用者 .vscode 目錄
Write-Host "建立使用者 .vscode 目錄: $userVSCodePath" -ForegroundColor Cyan
New-Item -ItemType Directory -Path $userVSCodePath -Force | Out-Null

# 複製所有 .vscode 檔案
$vscodeFiles = Get-ChildItem -Path $sourceVSCodePath -Recurse -File -ErrorAction SilentlyContinue

if ($vscodeFiles.Count -eq 0) {
    Write-Warning "找不到任何 .vscode 檔案"
    exit 1
}

Write-Host "找到 $($vscodeFiles.Count) 個檔案" -ForegroundColor Green

foreach ($file in $vscodeFiles) {
    $relativePath = $file.FullName.Substring($sourceVSCodePath.Length + 1).Replace($PSScriptRoot, "").TrimStart("\")
    $targetPath = Join-Path $userVSCodePath (Split-Path $file.FullName -Leaf)
    
    if ((Test-Path $targetPath) -and -not $Force) {
        Write-Host "跳過 $(Split-Path $file.FullName -Leaf) (已存在，使用 -Force 覆蓋)" -ForegroundColor Yellow
    } else {
        Copy-Item -Path $file.FullName -Destination $targetPath -Force
        Write-Host "已複製: $(Split-Path $file.FullName -Leaf)" -ForegroundColor Green
    }
}

Write-Host "`n✓ .vscode 設定複製完成！" -ForegroundColor Green
Write-Host "所有工作區現在都可以使用這些設定。`n" -ForegroundColor Cyan
