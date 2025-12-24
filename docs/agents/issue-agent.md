# issue-agent 使用指南

issue-agent 協助標準化和自動化 GitLab Issue 的建立與管理，確保 Issue 格式一致且資訊完整。

## 功能概述

該 Agent 提供以下功能：

- **Issue 類型範本** - 針對不同類型提供結構化範本
- **自動生成標籤** - 根據 Issue 類型自動指派適當的標籤
- **優先級管理** - 設定和追蹤 Issue 優先級
- **批量操作** - 支援批量建立和更新 Issue
- **關聯管理** - 連結相關 Issue 和 Merge Request

## 快速開始

### 基本用法

1. 在 Copilot Chat 中選擇 **Issue** Agent（透過 dropdown）
2. 輸入指令：

```
建立 Bug Report：登入頁面在 Safari 瀏覽器無法正常顯示
```

Agent 會自動：
1. 識別 Issue 類型（Bug Report）
2. 要求必要資訊（重現步驟、預期行為等）
3. 生成結構化的 Issue 內容
4. 建立 Issue 並返回 URL

### 帶參數的用法

```
- 類型：Feature Request
- 標題：新增暗黑模式支援
- 優先級：high
- 指派給：designer
- 里程碑：v1.2.0
```

## Issue 類型詳解

### 1. Bug Report（錯誤報告）

用於報告應用中的 Bug 或問題。

**包含內容：**
- 問題描述
- 重現步驟
- 預期行為
- 實際行為
- 環境資訊（OS、瀏覽器、版本等）
- 錯誤訊息/日誌
- 附件（截圖、錄影）

**範本範例：**

```markdown
## 問題描述
登入頁面在 Safari 瀏覽器上無法正常顯示，部分表單元素被隱藏。

## 重現步驟
1. 在 Safari 瀏覽器中開啟 https://example.com/login
2. 嘗試輸入使用者名稱和密碼
3. 觀察表單元素是否正確顯示

## 預期行為
登入表單應該正確顯示所有元素，並能正常提交。

## 實際行為
密碼輸入欄被隱藏，登入按鈕也無法點擊。

## 環境資訊
- 作業系統：macOS 13.5
- 瀏覽器：Safari 16.5
- 應用版本：v1.0.0

## 附件
- 登入頁面在 Safari 上的顯示問題截圖
- 瀏覽器控制台的錯誤訊息
```

**標籤標準：**
- `bug` - Bug 類型
- `priority::high` 或其他優先級
- `frontend` - 前端相關
- 可選：`regression`（如果是回歸問題）

**優先級指南：**
- `priority::critical` - 應用無法使用、資料遺失
- `priority::high` - 主要功能受影響
- `priority::medium` - 部分功能異常
- `priority::low` - 次要功能或視覺問題

### 2. Feature Request（功能需求）

用於提議新功能或功能改進。

**包含內容：**
- 功能描述
- 使用情境/使用者故事
- 預期效益
- 可能的實作方式
- 優先級和影響範圍

**範本範例：**

```markdown
## 功能描述
實作雙因素認證 (2FA) 功能，增強帳戶安全性。

## 使用情境
作為安全意識強的用戶，我想啟用雙因素認證，以保護我的帳戶免受未授權存取。

## 預期效益
- 增強帳戶安全性
- 符合安全合規要求
- 提升用戶信任度

## 實作方案建議
1. 支援 TOTP (Time-based One-Time Password)
2. 整合 Google Authenticator、Microsoft Authenticator 等應用
3. 提供備用碼作為恢復選項

## 使用者優先級
high - 許多企業用戶要求此功能
```

**標籤標準：**
- `feature` 或 `enhancement` - 功能類型
- `priority::` - 優先級
- 領域標籤如 `auth`, `security`

### 3. Task（工作任務）

用於追蹤具體的開發任務或改進項目。

**包含內容：**
- 任務描述
- 任務清單（子任務）
- 相關資源連結
- 驗收標準
- 預計完成時間

**範本範例：**

```markdown
## 任務描述
重構認證系統，改進代碼品質和效能。

## 子任務
- [ ] 提取認證邏輯到獨立服務
- [ ] 新增單元測試覆蓋率達 90%
- [ ] 優化資料庫查詢
- [ ] 更新相關文檔

## 相關資源
- 設計文檔：[連結]
- 相關 Issue：#123, #456
- 參考實作：[連結]

## 驗收標準
- [ ] 所有單元測試通過
- [ ] 代碼審查批准
- [ ] 性能指標改善 20% 以上
- [ ] 文檔完成更新

## 預計完成時間
2025-12-20
```

**標籤標準：**
- `task` - 工作任務
- `priority::` - 優先級
- `area/` - 所屬領域

### 4. Documentation（文件需求）

用於追蹤文件編寫或更新任務。

**包含內容：**
- 文件需求
- 目標讀者
- 文件範圍
- 相關連結

**範本範例：**

```markdown
## 文件需求
編寫 API 認證指南，幫助開發者集成認證服務。

## 目標讀者
- 第三方開發者
- 內部後端團隊

## 文件範圍
1. 認證基礎概念
2. OAuth2 流程說明
3. API 端點參考
4. 錯誤處理
5. 程式碼範例（Python、JavaScript、Java）

## 相關資源
- API 文檔：[連結]
- 相關 Issue：#789
```

**標籤標準：**
- `documentation` - 文件類
- `priority::` - 優先級
- `type/` - 文件類型如 `api-doc`, `user-guide`

## Labels 分類系統

issue-agent 使用結構化的標籤系統便於分類和追蹤。

### 類型標籤 (Type)

```
bug           - Bug 報告
feature       - 新功能
enhancement   - 功能增強
documentation - 文件
question      - 提問
task          - 工作任務
```

### 優先級標籤 (Priority)

```
priority::critical - 關鍵（立即修復）
priority::high     - 高優先級（本週修復）
priority::medium   - 中等優先級（本月修復）
priority::low      - 低優先級（待辦清單）
```

### 狀態標籤 (Status)

```
status::todo        - 待辦
status::in-progress - 進行中
status::review      - 審查中
status::blocked     - 被阻塞
```

### 領域標籤 (Area)

```
frontend    - 前端
backend     - 後端
database    - 資料庫
api         - API
ui/ux       - UI/UX
auth        - 認證
security    - 安全性
performance - 性能
infra       - 基礎設施
devops      - DevOps
```

### 其他標籤

```
good first issue  - 適合初學者
help wanted       - 需要幫助
duplicate         - 重複 Issue
wontfix          - 將不修復
regression       - 回歸問題
breaking change  - 破壞性變更
```

## 工作流程範例

### 報告 Bug 的完整流程

#### 第 1 步：識別 Bug

```
發現登入頁面在 Safari 上顯示異常
```

#### 第 2 步：建立 Bug Report

1. 在 Copilot Chat 中選擇 **Issue** Agent
2. 提供以下資訊：

```
- 類型：Bug Report
- 標題：登入頁面在 Safari 瀏覽器無法正常顯示
- 優先級：high
- 領域：frontend
```

#### 第 3 步：提供詳細信息

Agent 會要求：
- 重現步驟
- 預期行為
- 實際行為
- 環境資訊
- 截圖或日誌

#### 第 4 步：確認並建立

Agent 產生完整的 Bug Report 並建立 Issue：

```
Bug Report 已建立
Issue URL: https://gitlab.com/project/-/issues/123

後續步驟：
1. 分配給適當的開發者
2. 確認優先級
3. 建立關聯的 Merge Request
```

### 請求新功能的流程

1. 在 Copilot Chat 中選擇 **Issue** Agent
2. 提供以下資訊：

```
- 類型：Feature Request
- 標題：新增暗黑模式支援
- 優先級：medium
- 預期效益：改善夜間使用體驗，降低眼睛疲勞
- 實作方案：使用 CSS 變數和 prefers-color-scheme 媒體查詢
```

### 批量建立多個 Issue

1. 在 Copilot Chat 中選擇 **Issue** Agent
2. 提供以下資訊：

```
建立以下 Issues：

1. Bug: 登入超時設定不生效
   優先級：high
   領域：backend

2. Feature: 新增密碼強度檢查
   優先級：medium
   領域：auth

3. Task: 更新 API 文檔
   優先級：low
   領域：documentation
```

## 最佳實務

### 1. 清晰的標題

✅ 好的標題：
```
登入頁面在 Safari 瀏覽器無法正常顯示
新增雙因素認證功能
```

❌ 不好的標題：
```
頁面有問題
新增功能
```

### 2. 完整的描述

提供足夠的上下文幫助開發者快速理解問題：

✅ 好的描述：
```
## 重現步驟
1. 在 Safari 16.5 開啟登入頁面
2. 嘗試輸入密碼
3. 觀察表單

## 預期行為
密碼輸入欄應正常顯示

## 實際行為
密碼輸入欄被隱藏，無法輸入
```

❌ 不好的描述：
```
登入不工作
```

### 3. 適當的優先級

根據影響範圍設定優先級：

| 優先級 | 情況 | 例子 |
|--------|------|------|
| critical | 應用無法使用 | 登入完全失敗 |
| high | 主要功能受影響 | 登入在某些瀏覽器上失敗 |
| medium | 部分功能異常 | UI 顯示略有偏差 |
| low | 視覺或次要問題 | 字體顏色略微不符 |

### 4. 使用正確的類型

選擇最適合的 Issue 類型：

- **Bug Report** - 當前存在的問題
- **Feature Request** - 新增或改進功能
- **Task** - 開發工作項
- **Documentation** - 文件編寫

### 5. 標籤的一致性

確保標籤的一致使用，便於搜尋和篩選：

```
標籤應包含：
- 一個類型標籤（bug, feature, task 等）
- 一個優先級標籤（priority::high 等）
- 可選：一個領域標籤（frontend, backend 等）
```

### 6. 連結相關資源

在 Issue 中連結相關的 Issues、MRs 和外部資源：

```markdown
## 相關 Issue
- #123 - 相關的認證改進
- #456 - 密碼政策

## 相關 MR
- !78 - 前端修正

## 外部資源
- [文件連結]
- [設計檔]
```

### 7. 及時更新 Issue

隨著開發進展更新 Issue 狀態和資訊：

```
## 狀態更新
- [x] 問題已確認
- [x] 開發中（分配給 @dev）
- [ ] 審查中
- [ ] 完成

## 進度備註
目前進度 60%，預計本週完成審查
```

## Issue 與 Merge Request 的關聯

### 自動關聯

在 MR 描述中使用關鍵字自動關聯 Issue：

```markdown
## 相關 Issue

Closes #123        # 合併時自動關閉 Issue
Fixes #456        # 合併時自動關閉 Issue
Related to #789   # 建立關聯但不自動關閉
Blocks #101       # 表示此 MR 解決阻塊問題
```

### 手動關聯

在 GitLab UI 中使用「Link Issues」功能手動建立關聯。

## 故障排除

### Issue 建立失敗

**常見原因：**

1. **GitLab token 權限不足**
   - 確認 token 有 `api` 和 `write_repository` 權限
   - 檢查 `mcp.json` 設定

2. **專案名稱或 ID 不正確**
   - 確認專案存在且有存取權限
   - 使用完整的專案路徑

3. **必要欄位遺漏**
   - 確認標題和描述已填寫
   - 檢查標籤是否有效

**解決步驟：**

1. 驗證 GitLab 連線
   - 在 Copilot Chat 中選擇 **Issue** Agent
   - 提供指令：「列出專案的 Issues」

2. 檢查權限
   - 確認 token 有適當權限

3. 重試建立
   - 提供完整的必要資訊

### Issue 標籤無法指派

**原因：** 標籤不存在或拼寫錯誤

**解決方案：**

使用現有的標籤：
```
priority::high, frontend
```

或在 Copilot Chat 中選擇 **Issue** Agent，提供指令「列出所有可用標籤」

### 無法更新已建立的 Issue

**原因：** 權限不足或 Issue ID 不正確

**解決方案：**
```
確認：
1. Issue 存在且可存取
2. 有編輯權限
3. 使用正確的 Issue 號碼
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

- [issue-agent 原始檔案](issue.agent.md)
- [Create MR Agent 指南](create-mr-agent.md)
- [commit-agent 指南](commit-agent.md)
- [VS Code Agents 總覽](README.md)
- [MCP 整合指南](../mcp-integration.md)
- [GitLab Issue 官方文檔](https://docs.gitlab.com/ee/user/project/issues/)

## 常見問題

**Q: 如何在建立 Issue 後立即建立相關的 MR？**

A: 建立 Issue 後，使用 Create MR Agent：

```
@create-mr
- 相關 Issue：#123
- 標題：Fix: 修正登入頁面 Safari 相容性問題
```

**Q: 如何批量更新多個 Issue 的標籤？**

A: 使用 issue-agent 的批量操作：

```
@issue 批量更新以下 Issues 的標籤：
- #123, #124, #125
新增標籤：in-progress
移除標籤：todo
```

**Q: 如何根據條件篩選 Issue？**

A: 使用 Agent 的查詢功能：

```
@issue 列出所有：
- 優先級：high
- 狀態：in-progress
- 領域：frontend
```

**Q: 如何指派 Issue 給多個人？**

A: 在 GitLab 中，一個 Issue 通常只有一個主要指派人，但可以在評論中提及多個人：

```
@developer1 @developer2 @developer3
請協助審查此 Issue
```

**Q: 如何設定 Issue 的截止日期？**

A: 在建立 Issue 時指定：

```
@issue
- 標題：修正登入問題
- 優先級：high
- 截止日期：2025-12-20
```

## 支援和反饋

如遇問題或有改進建議，請提交 Issue 或 Merge Request。

---

最後更新：2025-12-12
