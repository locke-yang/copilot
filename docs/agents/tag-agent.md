# tag-agent 使用指南

tag-agent 協助自動化 Git 標籤和版本發佈流程，確保版本管理規範和一致性。

## 功能概述

該 Agent 提供以下功能：

- **版本管理** - 自動更新版本號和 CHANGELOG
- **標籤建立** - 建立語意化版本標籤
- **提交管理** - 生成符合規範的 commit 訊息
- **發佈流程** - 自動化推送到 GitLab 並建立 Release

## 快速開始

### 基本用法

1. 在 Copilot Chat 中選擇 **Tag** Agent（透過 dropdown）
2. 提供版本號或指令

Agent 會自動：
1. 分析 commit 歷史
2. 推薦下一個版本號
3. 提示更新 CHANGELOG
4. 建立版本標籤
5. 推送到 GitLab

### 帶參數的用法

```
- 版本號：1.2.0
- 類型：feature release
- 發佈說明：新增用戶認證功能和性能優化
```

## 語意化版本控制 (Semantic Versioning)

tag-agent 遵循 [語意化版本控制 2.0.0](https://semver.org/spec/v2.0.0.html) 規範。

### 版本格式

```
vX.Y.Z

X = 主版本 (Major)
Y = 次版本 (Minor)
Z = 修訂版本 (Patch)
```

### 版本遞增規則

#### 1. 主版本 (Major) 遞增 - X.0.0

**時機：** 進行了不向後相容的 API 變更

**範例：**
```
v1.0.0 → v2.0.0
```

**場景：**
- 刪除或重新命名 API 端點
- 改變現有函數簽名
- 更改數據格式
- 更新主要依賴

**CHANGELOG 示例：**
```markdown
## [2.0.0] - 2025-12-15

### 變更 (Breaking Changes)
- 移除已棄用的 `/api/v1/users` 端點
- 使用 OAuth2 替代 JWT 認證
- 重構認證模組 API

### 新增
- 新的 `/api/v2/auth` 端點
- 支援 Google OAuth 登入
```

#### 2. 次版本 (Minor) 遞增 - X.Y+1.0

**時機：** 新增了向後相容的功能

**範例：**
```
v1.0.0 → v1.1.0
```

**場景：**
- 新增 API 端點
- 添加可選參數
- 添加新功能
- 新增工具或命令

**CHANGELOG 示例：**
```markdown
## [1.1.0] - 2025-12-15

### 新增
- 新增雙因素認證 (2FA) 功能
- 支援 TOTP 驗證器應用
- 新增 `/api/users/{id}/2fa` 端點
- 用戶設置頁面新增 2FA 選項
```

#### 3. 修訂版本 (Patch) 遞增 - X.Y.Z+1

**時機：** 修正 Bug 或進行小型優化

**範例：**
```
v1.0.0 → v1.0.1
```

**場景：**
- 修正 Bug
- 性能優化
- 文檔更新
- 安全補丁

**CHANGELOG 示例：**
```markdown
## [1.0.1] - 2025-12-15

### 已修正
- 修正登入頁面在 Safari 瀏覽器的顯示問題
- 修正用戶列表查詢性能問題
- 修正密碼重置郵件送達失敗
```

### 版本號決策樹

```
檢查自上一版本以來的變更：

1. 有不向後相容的變更？
   └─ 是 → 遞增主版本 (Major)
   └─ 否 → 進行步驟 2

2. 有新增功能？
   └─ 是 → 遞增次版本 (Minor)
   └─ 否 → 進行步驟 3

3. 有 Bug 修正或優化？
   └─ 是 → 遞增修訂版本 (Patch)
   └─ 否 → 不發佈新版本
```

## CHANGELOG 管理

CHANGELOG 記錄項目的版本歷史和變更。

### CHANGELOG 格式

遵循 [Keep a Changelog](https://keepachangelog.com/zh-TW/) 規範：

```markdown
# 變更紀錄

所有值得注意的專案變更都應在本檔案中有所記錄。

格式基於 [Keep a Changelog](https://keepachangelog.com/zh-TW/)，
並遵循 [語意化版本控制](https://semver.org/spec/v2.0.0.html)。

## [未發佈]

### 新增
- 新增功能說明

### 變更
- 修改項說明

### 已移除
- 移除項說明

### 已修正
- 修正項說明

### 安全性
- 安全性改進說明

## [1.2.0] - 2025-12-15

### 新增
- 新增雙因素認證功能
- 支援 TOTP 驗證器

### 變更
- 改進用戶介面響應速度
- 優化資料庫查詢

### 已修正
- 修正登入頁面顯示問題
- 修正文件上傳超時

### 安全性
- 更新依賴以修補安全漏洞

## [1.1.0] - 2025-12-01

### 新增
- 新增用戶偏好設定功能
```

### 主要部分說明

#### 新增 (Added)

列出項目新增的功能或特性：

```markdown
### 新增
- 新增用戶認證系統
- 支援 Google OAuth 登入
- 新增 API 文檔
- 新增暗黑模式支援
```

#### 變更 (Changed)

列出對現有功能的變更或改進：

```markdown
### 變更
- 改進用戶介面設計
- 優化資料庫查詢性能
- 更新依賴版本
- 簡化配置流程
```

#### 已移除 (Removed)

列出刪除的功能或特性（通常在主版本發佈時）：

```markdown
### 已移除
- 移除舊的 API v1
- 刪除已棄用的函數
- 移除對 Node.js 12 的支援
```

#### 已修正 (Fixed)

列出修正的 Bug：

```markdown
### 已修正
- 修正登入頁面在 Safari 的顯示問題
- 修正用戶列表查詢性能問題
- 修正密碼重置郵件送達失敗
```

#### 安全性 (Security)

列出安全性相關的修正和改進：

```markdown
### 安全性
- 更新依賴以修補 XSS 漏洞
- 改進密碼加密算法
- 修複 CSRF 攻擊漏洞
```

### CHANGELOG 維護流程

#### 開發過程中

在 `未發佈` 部分記錄變更：

```markdown
## [未發佈]

### 新增
- 雙因素認證功能
- TOTP 驗證器支援

### 已修正
- Safari 相容性問題
```

#### 發佈新版本時

1. 重命名 `未發佈` 部分
2. 添加日期
3. 提交和標籤

在 Copilot Chat 中選擇 **Tag** Agent，提供：

```
- 版本號：1.2.0
```

Agent 會自動：
1. 將 `未發佈` 改為 `1.2.0`
2. 添加發佈日期
3. 提交更新
4. 建立標籤

#### 發佈後

重新建立 `未發佈` 部分以供下一個版本：

```markdown
## [未發佈]

### 新增

### 變更

### 已移除

### 已修正

### 安全性

## [1.2.0] - 2025-12-15
```

## Git 標籤管理

Git 標籤用於標記版本發佈點。

### 標籤命名規範

遵循語意化版本格式：

```
vX.Y.Z

範例：v1.0.0, v1.2.3, v2.0.0
```

### 建立標籤

#### 方式 1：輕量標籤（不推薦）

```bash
git tag v1.2.0
```

#### 方式 2：帶註解的標籤（推薦）

```bash
git tag -a v1.2.0 -m "Release v1.2.0"
```

#### 方式 3：tag-agent 自動建立

在 Copilot Chat 中選擇 **Tag** Agent，提供版本號和其他相關資訊

### 標籤訊息內容

帶註解標籤的訊息應包含：

**格式：**
```
Release vX.Y.Z

主要變更摘要

- 新增功能簡述
- 修改項簡述
- 修正項簡述
```

**完整範例：**
```
Release v1.2.0

實作雙因素認證和性能優化

- 新增雙因素認證 (2FA) 功能
- 優化用戶列表查詢性能 (提升 50%)
- 修正登入頁面在 Safari 的顯示問題
- 更新依賴以修補安全漏洞
```

### 標籤操作

#### 列出所有標籤

```bash
git tag
git tag -l "v1.*"  # 列出 v1.x 的所有標籤
```

#### 檢視標籤詳情

```bash
git show v1.2.0
```

#### 刪除標籤

```bash
# 刪除本地標籤
git tag -d v1.2.0

# 刪除遠程標籤
git push origin -d v1.2.0
```

#### 推送標籤

```bash
# 推送單個標籤
git push origin v1.2.0

# 推送所有標籤
git push origin --tags
```

## 工作流程範例

### 完整的版本發佈流程

#### 第 1 步：收集變更

在開發過程中維護 CHANGELOG 的 `未發佈` 部分：

```markdown
## [未發佈]

### 新增
- 雙因素認證功能
- TOTP 驗證器支援

### 變更
- 改進登入性能

### 已修正
- 修正 Safari 相容性問題
```

#### 第 2 步：確定版本號

基於變更分析決定版本號：

```
commit 歷史：
- feat: 新增 2FA 功能
- refactor: 優化登入流程
- fix: 修正 Safari 問題

決策：有新增功能 → 遞增次版本
最新版本：v1.1.0
下一版本：v1.2.0
```

#### 第 3 步：準備發佈

```bash
# 確認工作目錄乾淨
git status

# 確認在 main/develop 分支
git branch
```

#### 第 4 步：建立發佈提交

```bash
# 更新 CHANGELOG.md
# 將 [未發佈] 改為 [1.2.0] - 2025-12-15

git add CHANGELOG.md
git commit -m "chore(release): 發佈 v1.2.0"
```

或在 Copilot Chat 中選擇 **Tag** Agent，提供：

```
- 版本號：1.2.0
- 更新 CHANGELOG：true
```

#### 第 5 步：建立標籤

```bash
git tag -a v1.2.0 -m "Release v1.2.0

新增雙因素認證功能和性能優化

- 新增雙因素認證 (2FA) 功能
- 優化用戶列表查詢性能
- 修正登入頁面在 Safari 的顯示問題"
```

或使用 tag-agent：

```
@tag
- 版本號：1.2.0
- 建立標籤：true
```

#### 第 6 步：推送到 GitLab

```bash
git push origin main
git push origin v1.2.0
```

或：

```bash
git push origin --tags
```

### 快速修復發佈流程

用於快速發佈 Patch 版本：

```bash
# 建立修復分支（可選）
git checkout -b fix/security-patch

# 進行修復...
git add .
git commit -m "fix: 修正安全漏洞"

# 更新 CHANGELOG
# [未發佈] → [1.2.1] - 2025-12-15

# 提交和標籤
# 在 Copilot Chat 中選擇 tag-agent，提供版本號 1.2.1
```

### 預發佈版本

用於發佈 Alpha、Beta 或 RC 版本。在 Copilot Chat 中選擇 **Tag** Agent，提供：

```
- 版本號：1.2.0-beta.1
- 類型：預發佈
```

標籤示例：
```
v1.2.0-alpha.1
v1.2.0-beta.1
v1.2.0-rc.1
```

## 最佳實務

### 1. 保持 CHANGELOG 最新

在開發過程中即時更新 CHANGELOG：

✅ 好的做法：

```markdown
## [未發佈]

### 新增
- 實作 TOTP 雙因素認證
- 支援 Microsoft Authenticator

### 已修正
- 修正登入超時問題
```

❌ 不好的做法：

```markdown
## [未發佈]

### 新增
- 修改了一些代碼

### 已修正
- 修正了一些 Bug
```

### 2. 原子化的提交

確保發佈提交是原子化的：

```bash
# 只在發佈時提交版本相關檔案
git commit -m "chore(release): 發佈 v1.2.0"
```

不要在發佈提交中混合其他變更。

### 3. 使用帶註解的標籤

始終使用帶註解的標籤（-a）而非輕量標籤：

```bash
# 推薦
git tag -a v1.2.0 -m "Release v1.2.0"

# 不推薦
git tag v1.2.0
```

帶註解的標籤包含建立者、日期和訊息，更便於歷史追蹤。

### 4. 標籤訊息要詳細

標籤訊息應包含主要變更摘要，便於快速了解版本內容：

```bash
git tag -a v1.2.0 -m "Release v1.2.0

新增雙因素認證和性能優化

- 新增 2FA 功能
- 優化查詢性能 50%
- 修正 Safari 相容性"
```

### 5. 維護版本順序

確保版本號按時間遞增：

```
v1.0.0 (2025-11-01)
v1.1.0 (2025-11-15)
v1.2.0 (2025-12-01)
v2.0.0 (2025-12-15)
```

### 6. 向後相容性考量

在決定版本號時考慮向後相容性：

- **向後相容** → 使用 Minor 或 Patch
- **破壞相容** → 使用 Major

### 7. 及時發佈

定期發佈新版本，避免堆積太多變更：

- **Patch**: 每週（Bug 修正）
- **Minor**: 每月（新功能）
- **Major**: 每季度（重大改變）

## 故障排除

### 標籤已存在

**問題：**
```
fatal: tag 'v1.2.0' already exists
```

**解決方案：**

1. 刪除舊標籤並重新建立：
```bash
git tag -d v1.2.0
git push origin -d v1.2.0
git tag -a v1.2.0 -m "..."
git push origin v1.2.0
```

2. 或使用新的版本號

### 推送失敗

**問題：**
```
error: failed to push some refs to 'origin'
```

**解決方案：**

```bash
# 更新本地分支
git fetch origin
git rebase origin/main

# 再次推送
git push origin main
git push origin v1.2.0
```

### CHANGELOG 衝突

**問題：** 多人同時編輯 CHANGELOG

**解決方案：**

1. 手動合併衝突
2. 保留所有變更
3. 按時間順序排列版本

```bash
# 編輯 CHANGELOG，合併衝突後
git add CHANGELOG.md
git commit -m "merge: 合併 CHANGELOG 衝突"
```

## 配置和設定

### 在 settings.json 中啟用 Agent

```json
{
  "chat.agent.enabled": true
}
```

### MCP 整合設定

確認 `mcp.json` 中的 GitLab 配置：

```json
{
  "mcpServers": {
    "gitlab": {
      "command": "...",
      "env": {
        "GITLAB_TOKEN": "your-token",
        "READ_ONLY_MODE": "false"
      }
    }
  }
}
```

## 相關資源

- [tag-agent 原始檔案](tag.agent.md)
- [commit-agent 指南](commit-agent.md)
- [Create MR Agent 指南](create-mr-agent.md)
- [語意化版本控制 2.0.0](https://semver.org/spec/v2.0.0.html)
- [Keep a Changelog](https://keepachangelog.com/zh-TW/)
- [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
- [VS Code Agents 總覽](README.md)
- [CHANGELOG.md](../../CHANGELOG.md)

## 常見問題

**Q: 我應該多久發佈一次新版本？**

A: 取決於項目更新頻率：
- 活躍開發：每週發佈一次（通常是 Patch）
- 定期更新：每月發佈一次（Minor）
- 穩定項目：每季度或按需發佈

**Q: 如何處理多個並行版本線？**

A: 使用分支管理：

```
main (v2.x)
├── release/v1 (v1.x 維護線)
└── develop (下一版本 v3.x 開發)
```

**Q: 預發佈版本（Alpha、Beta）怎麼處理？**

A: 使用預發佈標籤：

```
v1.2.0-alpha.1
v1.2.0-beta.1
v1.2.0-rc.1
v1.2.0
```

**Q: 如何回退已發佈的版本？**

A: 建立新的 Patch 版本，不要刪除發佈的標籤：

```markdown
## [1.2.1] - 2025-12-16

### 已修正
- 回退 1.2.0 中的不穩定功能

## [1.2.0] - 2025-12-15 (已廢棄)

### 已知問題
- 此版本存在重大問題，請升級到 1.2.1
```

**Q: 版本號中如何處理零？**

A: 始終包含三個數字：

```
v1.0.0   (正確)
v1       (錯誤)
v1.0     (不完整)
```

## 支援和反饋

如遇問題或有改進建議，請提交 Issue 或 Merge Request。

---

最後更新：2025-12-12
