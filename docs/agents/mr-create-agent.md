# MR Create Agent 使用指南

MR Create Agent 協助自動化 GitLab Merge Request 的建立和管理流程，提高代碼審查的效率。

## 功能概述

該 Agent 提供以下功能：

- **自動分析分支差異** - 比較 source 和 target 分支
- **生成 MR 描述** - 根據 commits 自動產生結構化的 MR 描述
- **MR 屬性設定** - 配置標題、標籤、指派人、審查者等
- **建立和更新 MR** - 透過 GitLab API 管理 MR

## 快速開始

### 基本用法

在 Copilot Chat 中輸入：

```
@mr-create
```

Agent 會自動：
1. 檢測當前分支
2. 比較與 target 分支的差異
3. 分析 commit 歷史
4. 產生 MR 描述
5. 創建 Merge Request

### 帶參數的用法

```
@mr-create
- 標題：實作用戶認證功能
- 目標分支：develop
- 指派給：@reviewer-name
- 標籤：feature, security
- 里程碑：v1.2.0
```

## MR 描述結構

Agent 產生的 MR 描述包含以下部分：

### 1. 變更摘要

簡潔說明 MR 的目的和價值：

```markdown
## 變更摘要

實作雙因素認證 (2FA) 功能，增強帳戶安全性。
使用 TOTP 協議，支援 Google Authenticator 和 Microsoft Authenticator。
```

### 2. 變更內容

列出具體的代碼變更：

```markdown
## 變更內容

- 新增 `TwoFactorAuthService` 服務類
- 實作 TOTP 驗證邏輯
- 新增用戶登入流程中的 2FA 驗證步驟
- 新增 2FA 管理面板 UI 元件
- 更新資料庫 schema 支援 2FA 狀態
```

### 3. 測試項目

勾選清單方便追蹤測試進度：

```markdown
## 測試項目

- [x] 單元測試通過 (95% 涵蓋率)
- [x] 整合測試通過
- [x] 手動測試確認
- [ ] 端到端測試
- [ ] 性能測試
```

### 4. 影響範圍

說明受影響的模組和兼容性：

```markdown
## 影響範圍

- **模組**: 認證系統、用戶管理
- **API 變更**: 新增 `/api/2fa/setup` 和 `/api/2fa/verify` 端點
- **資料庫**: 新增 `user_2fa_settings` 表
- **前端**: 新增 2FA 設定頁面
- **向後兼容**: 完全兼容，2FA 為可選功能
```

### 5. 相關 Issue

連結相關的 Issues：

```markdown
## 相關 Issue

Closes #123
Related to #456 #789
Blocks #101
```

## 標題格式

MR 標題應遵循 Conventional Commits 格式：

### 格式規範

```
<type>(<scope>): <subject>
```

### 類型 (type)

- `feat` - 新功能
- `fix` - 修正錯誤
- `docs` - 文檔更新
- `style` - 格式和風格（不影響代碼邏輯）
- `refactor` - 代碼重構
- `perf` - 性能優化
- `test` - 添加或修改測試
- `chore` - 構建工具或依賴更新

### 範圍 (scope)

可選，指出變更影響的模組：

```
feat(auth): 新增雙因素認證功能
fix(api): 修正用戶列表查詢性能問題
docs(readme): 更新安裝指南
refactor(ui): 重構登入組件
```

### 主題 (subject)

- 使用祈使句（"新增" 而非 "已新增"）
- 首字大寫
- 不超過 50 個字符
- 末尾無句號

### 完整範例

```
feat(auth): 實作雙因素認證功能
fix(payment): 修正支付流程中的金額計算錯誤
docs(api): 添加 API 認證說明
refactor(database): 優化用戶查詢性能
perf(ui): 減少登入頁面加載時間
```

## MR 類型

### 1. Draft MR（草稿 MR）

用於早期討論和反饋，標題前加 "Draft:"

```
Draft: 實驗性功能 - 用戶行為分析模組
```

**用途：**
- 請求早期反饋
- 討論設計方案
- 分享進度更新
- 未完成的功能

### 2. WIP MR（進行中）

標題前加 "WIP:"，表示仍在開發中

```
WIP: 重構認證系統
```

### 3. 正式 MR

完整的、準備合併的變更

```
feat(auth): 實作雙因素認證功能
```

**需要：**
- 完整的實現
- 通過所有測試
- 代碼審查批准
- 更新相關文檔

## 操作類型

### 建立 MR

最常見的操作，生成 MR 並建立：

```
@mr-create
- 標題：feat(core): 優化查詢性能
- 目標分支：develop
```

Agent 會：
1. 分析分支差異
2. 提取 commit 訊息
3. 生成 MR 描述
4. 設定 MR 屬性
5. 建立 MR

### 查詢現有 MR

列出指定項目的 MR：

```
@mr-create list
```

### 檢視 MR 詳情

獲取特定 MR 的完整信息：

```
@mr-create view <mr-id>
```

### 更新 MR

修改 MR 的描述或屬性：

```
@mr-create update <mr-id>
- 描述：更新實現細節
- 標籤：bugfix, urgent
```

### 關閉 MR

標記 MR 為已拒絕或已關閉：

```
@mr-create close <mr-id>
```

## GitLab MCP 工具

Agent 使用以下 GitLab API 工具：

### mcp_gitlab_list_merge_requests

列出項目的 Merge Requests：

```
用途：查詢現有 MR、過濾狀態
返回：MR 列表（包含 IID、標題、狀態、建立人等）
```

### mcp_gitlab_get_merge_request

獲取特定 MR 的詳細信息：

```
用途：檢視 MR 完整內容
返回：MR 詳情（描述、diff_refs、批准者等）
```

### mcp_gitlab_get_merge_request_diffs

獲取 MR 的代碼差異：

```
用途：檢視具體的代碼變更
返回：文件列表和行級差異
```

### mcp_gitlab_get_branch_diffs

比較兩個分支的差異：

```
用途：分析分支差異，用於生成 MR 描述
返回：新增、修改、刪除的文件
```

### mcp_gitlab_mr_discussions

管理 MR 上的討論和評論：

```
用途：讀寫 MR 上的評論
返回：評論列表及其狀態
```

## 工作流程範例

### 完整的特性開發流程

#### 第 1 步：開發功能

```bash
git checkout -b feat/user-authentication
# 開發代碼...
git add .
git commit -m "feat(auth): 實作用戶認證"
git push origin feat/user-authentication
```

#### 第 2 步：建立 MR

```
@mr-create
- 標題：feat(auth): 實作用戶認證功能
- 目標分支：develop
- 指派給：@lead-dev
- 審查者：@security-team
- 標籤：feature, auth, security
```

Agent 會自動生成描述並建立 MR。

#### 第 3 步：MR 審查

開發團隊在 GitLab 上審查代碼，提出評論。

#### 第 4 步：更新 MR

根據反饋進行修改：

```bash
# 進行代碼修改...
git add .
git commit -m "refactor(auth): 改進錯誤處理"
git push origin feat/user-authentication
```

MR 會自動更新新的 commits。

#### 第 5 步：批准和合併

代碼審查批准後，合併 MR 到 develop 分支。

### 快速修復流程

```bash
# 建立修復分支
git checkout -b fix/login-bug

# 進行修復...
git add .
git commit -m "fix(login): 修正登入頁面在 Safari 的顯示問題"
git push origin fix/login-bug

# 建立 MR
@mr-create
- 標題：fix(login): 修正 Safari 兼容性問題
- 目標分支：develop
- 標籤：bugfix, urgent
```

### Draft MR 討論設計

```
@mr-create
- 標題：Draft: 新的認證架構設計方案
- 描述：提議使用 OAuth2 替代當前的 JWT 實現，以支持第三方集成
- 標籤：discussion, architecture
```

團隊可以在 MR 評論中討論設計方案。

## 最佳實務

### 1. 寫好 MR 描述

清晰的 MR 描述加快審查進度：

✅ 好的 MR：

```markdown
## 變更摘要
實作 TOTP 雙因素認證，提升帳戶安全性。

## 變更內容
- 新增 TwoFactorAuthService
- 整合 TOTP 庫
- 新增 UI 設定頁面

## 測試項目
- [x] 單元測試 (92% 涵蓋率)
- [x] 集成測試
- [x] 手動測試

## 影響範圍
- 新增 /api/2fa/* 端點
- 向後兼容
```

❌ 不好的 MR：

```markdown
## 變更摘要
完成了功能

## 變更內容
- 新增一些代碼
- 修改一些代碼
```

### 2. 適當的 MR 大小

- **最佳**: 200-400 行代碼變更
- **可接受**: 400-600 行
- **過大**: 超過 1000 行（應分解成多個 MR）

分解大型 MR：

```
主 MR (feat): 核心實現
├── 1. 數據模型
├── 2. 業務邏輯
├── 3. API 端點
└── 4. UI 組件
```

### 3. 命名規範

**分支名稱：**
```
feat/feature-name
fix/bug-description
docs/what-changed
refactor/module-name
```

**MR 標題：**
遵循 Conventional Commits 格式

### 4. 適時更新 MR

保持 MR 與 target 分支同步：

```bash
git fetch origin
git rebase origin/develop
git push -f origin feat/branch-name
```

### 5. 及時解決衝突

發現衝突立即解決，避免阻塞審查：

```bash
git fetch origin
git rebase origin/develop
# 解決衝突...
git add .
git rebase --continue
git push -f origin feat/branch-name
```

## 故障排除

### MR 建立失敗

**常見原因：**

1. **GitLab token 權限不足**
   - 確認 token 有 `api` 權限
   - 檢查 `mcp.json` 設定

2. **分支不存在**
   - 確認分支已推送到遠程
   - 檢查分支名稱拼寫

3. **目標分支不正確**
   - 確認 target 分支存在
   - 驗證分支權限

**解決步驟：**
```bash
# 檢查分支
git branch -r

# 確認遠程
git remote -v

# 重新推送
git push origin <branch-name>
```

### MR 描述生成不完整

可能原因：

1. Commit 訊息不規範
2. 變更過多導致超時
3. 文件名包含特殊字符

**改進方案：**
- 使用規範的 commit 訊息
- 分解大型 MR
- 手動編輯描述

### 無法合併 MR

常見原因：

1. 衝突未解決
2. CI/CD 失敗
3. 缺少必要的批准

**解決步驟：**
```bash
# 檢查衝突
git status

# 更新到最新 target
git fetch origin
git rebase origin/develop

# 重新推送
git push -f origin <branch-name>
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

## 相關文件

- [MR Create Agent 原始檔案](mr-create.agent.md)
- [Commit Agent 指南](commit-agent.md)
- [Issue Agent 指南](issue-agent.md)
- [VS Code Agents 總覽](README.md)
- [MCP 整合指南](../mcp-integration.md)

## 常見問題

**Q: 如何在 MR 中引用 Issue？**

在 MR 描述中使用：
```
Closes #123    # 自動關閉 Issue
Related to #456
Fixes #789
```

**Q: 如何設定 MR 自動合併？**

在 MR 建立時指定：
```
@mr-create
- 自動合併：true
- 刪除分支：true
```

**Q: 如何將 Draft MR 轉為正式 MR？**

在 GitLab UI 中點擊 "Mark as ready"，或透過 Agent：

```
@mr-create update <mr-id>
- 標題：feat(auth): 實作雙因素認證功能
```

**Q: 如何新增審查者？**

```
@mr-create update <mr-id>
- 審查者：@user1, @user2
```

## 支援和反饋

如遇問題或有改進建議，請提交 Issue 或 Merge Request。

---

最後更新：2025-12-12
