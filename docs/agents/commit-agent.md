# Commit Agent

## 功能說明

Commit Agent 協助您產生符合 Conventional Commits 規範的 Git Commit 訊息。

**主要功能：**
- 檢查暫存區的變更內容
- 分析程式碼變更的目的和影響範圍
- 自動產生符合規範的繁體中文 commit 訊息
- 支援多行 commit 訊息和 breaking changes

## 前置要求

- VS Code 安裝 GitHub Copilot 擴充功能
- Git 已配置用戶名稱和電子郵件
- 在 VS Code 中啟用 Agent Mode

## 啟用 Agent Mode

1. 在 VS Code 中開啟 Command Palette (`Ctrl+Shift+P`)
2. 搜尋並執行 `Copilot: Enable Agent Mode`
3. 在聊天視窗中使用 `@commit` 呼叫代理

## 使用方式

### 基本用法

```
@commit 請協助我產生 commit 訊息
```

或更具體的指令：

```
@commit 分析暫存區變更並產生符合規範的 commit 訊息
```

### Agent 自動執行的操作

1. **檢查變更** - 執行 `git status` 和 `git diff --cached`
2. **分析內容** - 理解變更的類型和影響範圍
3. **生成訊息** - 產生符合 Conventional Commits 格式的訊息
4. **確認提交** - 提示確認後執行 `git commit`

## Commit 訊息格式

遵循 [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) 規範：

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

### Type 類型

| Type | 說明 | 範例 |
|------|------|------|
| `feat` | 新增功能 | `feat(api): 新增用戶登入 API` |
| `fix` | 修正錯誤 | `fix(ui): 修正按鈕點擊無效的問題` |
| `docs` | 文件變更 | `docs(readme): 更新專案安裝說明` |
| `style` | 程式碼格式調整 | `style(css): 統一縮排格式` |
| `refactor` | 重構程式碼 | `refactor(service): 精簡驗證流程邏輯` |
| `perf` | 效能改善 | `perf(query): 優化資料庫查詢效能` |
| `test` | 測試相關 | `test(controller): 新增錯誤狀況測試案例` |
| `build` | 建構流程變更 | `build(deps): 升級 TypeScript 至 5.0` |
| `ci` | CI/CD 設定 | `ci(pipeline): 新增自動部署步驟` |
| `chore` | 其他變更 | `chore(config): 更新 ESLint 設定` |
| `revert` | 還原提交 | `revert: feat(api): 新增用戶登入 API` |

### Scope 範圍

指出變更影響的模組或元件：

**常用 Scope：**
- `api` - API 相關
- `ui` - 使用者介面
- `auth` - 認證/授權
- `config` - 配置檔案
- `docs` - 文件
- `test` - 測試
- `deps` - 相依性套件

**範例：**
```
feat(api): 新增用戶登入 API
fix(ui): 修正按鈕點擊無效的問題
docs(config): 更新環境變數說明
```

### Subject 主旨

- 使用繁體中文（台灣）
- 簡潔描述變更內容，不超過 50 字元
- 不使用句號結尾
- 使用祈使句（如「新增」而非「新增了」）

**範例：**
- ✅ `新增用戶登入 API`
- ✅ `修正按鈕點擊無效的問題`
- ❌ `新增了用戶登入 API。`（使用過去式、有句號）
- ❌ `fix button`（使用英文）

### Body 內文（選用）

提供更詳細的變更說明：

```
feat(api): 新增用戶登入 API

實作 JWT 基礎的認證機制
- 支援 email/password 登入
- 回傳 access token 和 refresh token
- 新增 token 驗證中介層
```

### Footer 頁腳（選用）

用於關聯 Issue 或標記 Breaking Changes：

```
feat(api): 修改認證 API 回應格式

BREAKING CHANGE: 認證 API 回應格式已變更

原本回應：
{ "token": "xxx" }

新回應：
{ "accessToken": "xxx", "refreshToken": "yyy" }

Closes #123
Related to #456
```

## 使用範例

### 新增功能

```bash
# 暫存變更
git add src/api/auth.ts

# 使用 Agent
@commit

# Agent 產生：
feat(api): 新增雙因素認證功能
```

### 修正錯誤

```bash
git add src/ui/Button.tsx

@commit

# Agent 產生：
fix(ui): 修正按鈕在 Safari 瀏覽器無法點擊的問題
```

### 文件更新

```bash
git add README.md

@commit

# Agent 產生：
docs(readme): 新增安裝說明和使用範例
```

### 重構程式碼

```bash
git add src/services/

@commit

# Agent 產生：
refactor(service): 簡化資料存取邏輯並移除重複程式碼
```

### 多檔案變更

```bash
git add src/api/ src/ui/ tests/

@commit

# Agent 產生：
feat(api,ui): 實作用戶個人資料編輯功能

- API 新增 PATCH /api/users/:id 端點
- UI 新增個人資料編輯表單
- 新增相關單元測試和整合測試

Closes #789
```

## 最佳實務

### 1. 單一目的

每個 commit 只處理一個邏輯變更：

❌ 不好的範例：
```
feat(api,ui): 新增登入功能、修正 bug、更新文件
```

✅ 好的範例：
```
feat(api): 新增用戶登入 API
```

然後分別 commit：
```
fix(ui): 修正按鈕樣式問題
docs(readme): 更新 API 使用說明
```

### 2. 完整功能

commit 應包含完整可運作的變更：

❌ 不完整：
```
feat(api): 新增登入 API（尚未測試）
```

✅ 完整：
```
feat(api): 新增用戶登入 API

包含單元測試和整合測試
驗證 email 格式和密碼強度
```

### 3. 清晰描述

訊息應清楚說明「做了什麼」而非「怎麼做」：

❌ 不清晰：
```
feat(api): 修改 auth.ts 檔案
```

✅ 清晰：
```
feat(api): 新增 JWT token 刷新機制
```

### 4. 避免混合

不要將多種類型的變更混在同一個 commit：

❌ 混合類型：
```
feat(api): 新增登入功能並修正 UI 樣式
```

✅ 分開 commit：
```
feat(api): 新增用戶登入 API
fix(ui): 修正登入按鈕樣式
```

## 進階功能

### Breaking Changes

當變更會破壞向後相容性時：

```
feat(api): 修改認證 API 回應格式

BREAKING CHANGE: 認證 API 的回應格式已變更

原本的 `token` 欄位已移除，改為 `accessToken` 和 `refreshToken`

Migration Guide:
更新您的程式碼從 response.token 改為 response.accessToken
```

### 關聯 Issue

在 commit 訊息中關聯相關 Issue：

```
fix(ui): 修正登入頁面在手機版顯示錯誤

- 調整 RWD 斷點設定
- 修正表單欄位寬度

Closes #123
Fixes #456
Related to #789
```

### 多行描述

提供詳細的變更說明：

```
refactor(service): 重構用戶服務層架構

重新組織程式碼結構以改善可維護性和測試性：

- 將 UserService 拆分為多個小型服務
- 引入 Repository 模式處理資料存取
- 新增 DTO 類別進行資料轉換
- 改善錯誤處理機制

效能影響：無
向後相容：是
測試覆蓋率：從 75% 提升至 92%
```

## 工作流程整合

### 日常開發流程

```powershell
# 1. 修改程式碼
code src/api/auth.ts

# 2. 執行測試確認
npm test

# 3. 暫存變更
git add src/api/auth.ts

# 4. 使用 Agent 產生 commit
# 在 VS Code Copilot Chat 中：
@commit

# 5. Agent 分析變更並產生訊息
# 確認後自動執行 git commit
```

### 與其他 Agent 整合

```
# 完成開發後
@commit  # 產生 commit

# 建立 MR
@merge-request  # 自動建立 Merge Request

# 產生工作摘要
@work-summary  # 記錄今日完成的工作
```

## 常見問題

### Q: 如果暫存區沒有變更會怎樣？

A: Agent 會提示您暫存區沒有變更，請先使用 `git add` 暫存檔案。

### Q: 可以修改 Agent 產生的訊息嗎？

A: 可以，Agent 會顯示產生的訊息供您確認，您可以在確認前修改內容。

### Q: 如何處理大量檔案變更？

A: 建議將變更拆分為多個 commit，每個 commit 處理一個邏輯單元，這樣更容易審查和回溯。

### Q: 是否支援英文 commit 訊息？

A: Agent 預設產生繁體中文訊息。如需英文，請在指令中明確說明：

```
@commit 請產生英文的 commit 訊息
```

### Q: 如何確認 commit 已成功？

A: 使用以下指令確認：

```powershell
git log -1  # 查看最後一次 commit
git show HEAD  # 查看最後一次 commit 的詳細內容
```

## 疑難排解

### Agent 沒有回應

1. 確認已啟用 Agent Mode
2. 檢查暫存區是否有變更（`git status`）
3. 重新載入 VS Code 視窗

### Commit 訊息格式不正確

1. 確認 Agent 檔案格式正確
2. 檢查是否有自訂的 commit template 衝突
3. 參考本文件的格式規範重新產生

### 無法提交 commit

1. 確認 Git 已配置用戶資訊：
   ```powershell
   git config user.name "Your Name"
   git config user.email "your@email.com"
   ```

2. 檢查是否有 pre-commit hooks 錯誤
3. 確認檔案權限正確

## 相關資源

- [Conventional Commits 規範](https://www.conventionalcommits.org/)
- [Agents 總覽](README.md)
- [Merge Request Agent](merge-request-agent.md)
- [Agent 核心指令檔案](../../.github/agents/commit.agent.md)
