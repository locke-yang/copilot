# work-summary-agent 使用指南

work-summary-agent 使用 GitLab Activity API 自動產生工作摘要報告，協助團隊追蹤和總結開發進度。

## 功能概述

該 Agent 提供以下功能：

- **自動收集活動** - 從 GitLab 提取指定時間範圍的所有活動
- **智能分類** - 將活動分類為「完成」、「進行中」、「阻塞」
- **關聯追蹤** - 連結相關的 Issues、MRs 和 Commits
- **統計分析** - 生成活動統計和進度指標
- **多種時間粒度** - 支援每日、每週、每月摘要
- **專案篩選** - 可針對特定專案生成摘要

## 快速開始

### 基本用法

1. 在 Copilot Chat 中選擇 **Work Summary** Agent（透過 dropdown）
2. 輸入指令

Agent 會自動：
1. 提取今日的所有 GitLab 活動
2. 分類成「完成」、「進行中」、「阻塞」
3. 生成結構化的 Markdown 報告
4. 儲存到 `daily-summary/YYYY-MM-DD.md`

### 帶參數的用法

```
- 時間範圍：本週
- 專案：project-name
- 輸出格式：詳細
- 儲存位置：weekly-summary/
```

## 摘要報告結構

### 報告格式

```markdown
# 工作摘要 - 2025-12-12

**今日主要成果**: 完成用戶認證功能開發和代碼審查，修正 3 個相關 Bug

## 完成 (Done)

### Issues
- [#123] 實作雙因素認證功能 (merged, 2 hours ago, MR: !45)
- [#124] 修正登入超時問題 (closed, 1 hour ago)

### Merge Requests
- [!45] feat(auth): 實作雙因素認證 (merged, develop, 5 commits)
- [!46] fix(login): 修正登入超時問題 (merged, develop, 2 commits)

## 進行中 (In Progress)

### Issues
- [#125] 新增密碼強度檢查 (opened, assigned to @dev, updated 10 minutes ago)
- [#126] 性能優化 (opened, in-progress label)

### Merge Requests
- [!47] refactor(auth): 重構認證模組 (draft, 3 commits)

## 阻塞 (Blocked)

### Issues
- [#127] 等待安全審查 (opened, blocked label, waiting for @security-team)

### Merge Requests
無

## Commits

- `a1b2c3d` feat(auth): 實作 TOTP 驗證 (10:30)
- `d4e5f6g` test(auth): 新增 2FA 單元測試 (10:45)
- `h7i8j9k` fix(login): 修正 Safari 相容性問題 (14:20)
- `l0m1n2o` docs(auth): 更新認證文檔 (15:30)

## 統計資訊

- **總 Commits**: 4 個
- **Merge Requests**: 2 個已合併, 1 個進行中
- **Issues**: 2 個已關閉, 2 個進行中, 1 個阻塞
- **程式碼變更**: +234 -45 行
- **代碼審查**: 2 個已批准

## 頂層貢獻者

- @dev1: 3 commits
- @dev2: 1 commit

## 下一步

1. 解除 #127 的阻塊 - 等待安全審查
2. 完成 !47 的代碼審查
3. 開始密碼強度檢查實作
```

## 活動分類規則

Agent 使用以下規則自動分類活動：

### 完成 (Done)

#### Issues
- 狀態：`closed` (已關閉)
- 時間範圍內關閉的所有 Issue

#### Merge Requests
- 狀態：`merged` (已合併)
- 時間範圍內合併到目標分支

#### Commits
- 已合併到主分支（main/develop）
- 不在功能分支上

**範例：**
```markdown
### 完成 (Done)

### Issues
- [#123] 實作雙因素認證功能 (closed at 2025-12-12 10:30)

### Merge Requests
- [!45] feat(auth): 實作雙因素認證 (merged at 2025-12-12 11:00, 5 commits)
```

### 進行中 (In Progress)

#### Issues
- 狀態：`opened` (開啟)
- 在時間範圍內有活動或評論
- 不是 `blocked` 或 `draft` 狀態

#### Merge Requests
- 狀態：`opened` (開啟)
- 或標記為 `WIP`、`Draft`
- 尚未合併

#### Commits
- 在功能分支上的新 commits
- 尚未合併到主分支

**範例：**
```markdown
### 進行中 (In Progress)

### Issues
- [#125] 新增密碼強度檢查 (opened, assigned to @dev, in-progress label)

### Merge Requests
- [!47] refactor(auth): 重構認證模組 (draft, 3 commits, needs review)
```

### 阻塞 (Blocked)

#### Issues
- 有 `blocked` 標籤
- 或在評論中明確提及阻塞原因
- 等待外部輸入或決定

#### Merge Requests
- 有 `blocked` 標籤
- 有未解決的衝突
- 有 `needs-work` 或類似的阻塊標籤
- 等待強制審批

#### 阻塊原因
- 等待某人的行動
- 等待外部系統或資源
- 設計決策待定
- 依賴其他任務完成

**範例：**
```markdown
### 阻塞 (Blocked)

### Issues
- [#127] 等待安全審查 (opened, blocked label, waiting for @security-team)

### Merge Requests
- [!48] security: 加強驗證機制 (conflicts with main, needs resolution)
```

## 工作流程範例

### 每日工作摘要

#### 第 1 步：運行 Agent

在 Copilot Chat 中選擇 **Work Summary** Agent，提供指令「產生今天的工作摘要」

#### 第 2 步：查看報告

Agent 會：
1. 提取今日所有 commits, MRs, Issues
2. 分類活動
3. 生成 `daily-summary/2025-12-12.md`

#### 第 3 步：分享和討論

```
完成的工作摘要：
daily-summary/2025-12-12.md

主要成果：
- 完成用戶認證功能開發
- 修正 3 個相關 Bug
- 代碼審查 2 個 MR

進行中：
- 性能優化（2 issues）
- 密碼強度檢查（1 MR）

阻塞：
- 安全審查待批（1 issue）
```

### 每週工作摘要

在 Copilot Chat 中選擇 **Work Summary** Agent，提供：

```
- 時間範圍：本週
- 輸出格式：詳細
- 儲存位置：weekly-summary/
```

生成 `weekly-summary/2025-W50.md`，包含：
- 本週完成的工作
- 進行中的項目
- 遇到的阻塊
- 統計數據和趨勢

### 每月績效報告

在 Copilot Chat 中選擇 **Work Summary** Agent，提供：

```
- 時間範圍：本月
- 輸出格式：詳細
- 包含統計：true
```

生成 `monthly-summary/2025-12.md`，包含：
- 月度成果概述
- 主要里程碑達成情況
- 團隊貢獻分析
- 性能指標

### 特定專案摘要

在 Copilot Chat 中選擇 **Work Summary** Agent，提供：

```
- 專案：mobile-app
- 時間範圍：過去一週
```

只包含 `mobile-app` 專案的活動。

## 報告內容詳解

### 主要成果摘要

簡潔描述本時間段最重要的完成事項：

```markdown
**今日主要成果**: 完成用戶認證功能開發和代碼審查，修正 3 個相關 Bug
```

**編寫指南：**
- 一句話，20-50 字
- 強調最有價值的成果
- 包含數字時注意準確性

### Issues 部分

顯示時間範圍內所有 Issues 的狀態變化：

```markdown
### Issues
- [#123] 標題 (狀態, 時間, 額外資訊)
```

**欄位說明：**
- `#123` - Issue 編號（可點擊連結）
- `標題` - Issue 標題
- `狀態` - closed/opened/in-progress
- `時間` - 狀態變化時間（相對時間）
- `額外資訊` - 關聯的 MR、指派人等

### Merge Requests 部分

顯示時間範圍內的 MR 狀態：

```markdown
### Merge Requests
- [!45] feat(auth): 實作雙因素認證 (merged, develop, 5 commits)
```

**欄位說明：**
- `!45` - MR 編號
- `feat(auth):...` - MR 標題
- `merged` - 狀態（merged/opened/draft）
- `develop` - 目標分支
- `5 commits` - commit 數量

### Commits 部分

列出時間範圍內的所有 commits：

```markdown
## Commits
- `a1b2c3d` feat(auth): 實作 TOTP 驗證 (10:30)
- `d4e5f6g` test(auth): 新增 2FA 單元測試 (10:45)
```

**欄位說明：**
- `a1b2c3d` - commit 簡碼
- `feat(auth):...` - commit 訊息
- `(10:30)` - commit 時間

### 統計資訊

提供量化的指標：

```markdown
## 統計資訊
- **總 Commits**: 4 個
- **Merge Requests**: 2 個已合併, 1 個進行中
- **Issues**: 2 個已關閉, 2 個進行中, 1 個阻塞
- **程式碼變更**: +234 -45 行
- **代碼審查**: 2 個已批准
```

## 最佳實務

### 1. 定期生成摘要

建議頻率：
- **每日** - 用於團隊日會（standup）
- **每週** - 用於週報和進度追蹤
- **每月** - 用於績效評估和計劃

### 2. 解讀阻塊

仔細查看「阻塊」部分，識別需要幫助的項目：

```
阻塊原因分類：
- 等待審批 - 建立跟進計畫
- 技術困難 - 安排技術討論
- 資源限制 - 尋求協助
```

### 3. 追蹤趨勢

比較多個摘要識別模式：

```
趨勢分析：
- 週一通常 commits 數最多
- 阻塊項目數逐周增加 → 需要改進流程
- 代碼審查時間在改善 → 流程優化有效
```

### 4. 使用摘要進行規劃

基於摘要的資訊規劃下一時期的工作：

```
決策依據：
- 已完成的工作 → 評估生產力
- 進行中的項目 → 優先級調整
- 阻塊項目 → 清除障礙
```

## 時間範圍選項

### 相對時間

在 Copilot Chat 中選擇 **Work Summary** Agent，提供：

```
- 時間範圍：today         # 今天
- 時間範圍：this week     # 本週
- 時間範圍：this month    # 本月
- 時間範圍：past 7 days   # 過去 7 天
- 時間範圍：past 30 days  # 過去 30 天
```

### 絕對時間

在 Copilot Chat 中選擇 **Work Summary** Agent，提供：

```
- 開始日期：2025-12-01
- 結束日期：2025-12-12
```

## 儲存位置規範

### 預設儲存位置

```
daily-summary/YYYY-MM-DD.md      # 每日摘要
weekly-summary/YYYY-Www.md       # 每週摘要（W 為週數）
monthly-summary/YYYY-MM.md       # 每月摘要
```

### 自訂儲存位置

在 Copilot Chat 中選擇 **Work Summary** Agent，提供：

```
- 儲存位置：reports/2025/
```

## 故障排除

### 無法連接 GitLab

**原因：** GitLab MCP 未正確配置或 token 無效

**解決方案：**
```
1. 檢查 mcp.json 設定
2. 驗證 GITLAB_TOKEN 有效
3. 確認 READ_ONLY_MODE 設定（可為 true）
4. 測試 GitLab 連線
```

### 活動資訊遺漏

**原因：**
1. 時間範圍設定不正確
2. 專案權限不足
3. 活動篩選規則過於嚴格

**解決方案：**
```
1. 確認時間範圍包含所有活動
2. 檢查專案存取權限
3. 調整篩選條件
```

### 分類不准確

**原因：** 活動標籤或狀態不規範

**解決方案：**
```
1. 確保使用標準的標籤名稱
2. 確認 Issue/MR 狀態正確
3. 新增明確的阻塊原因標籤
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
        "READ_ONLY_MODE": "true"  // 可使用只讀模式
      }
    }
  }
}
```

## 相關資源

- [work-summary-agent 原始檔案](work-summary.agent.md)
- [issue-agent 指南](issue-agent.md)
- [Create MR Agent 指南](create-mr-agent.md)
- [VS Code Agents 總覽](README.md)
- [MCP 整合指南](../mcp-integration.md)

## 常見問題

**Q: 如何在團隊內共享工作摘要？**

A: 生成摘要後，可以：
1. 在 Slack 或團隊聊天中分享檔案連結
2. 複製內容到團隊文檔
3. 在代碼庫中提交摘要作為 commit

**Q: 如何生成多個專案的合併摘要？**

A: 運行 Agent 時指定多個專案：

```
@work-summary
- 專案：project1, project2, project3
- 時間範圍：本週
```

**Q: 能否自訂摘要格式？**

A: 現有格式是標準化的，但可以：
1. 編輯生成的摘要
2. 使用不同的儲存位置
3. 合併多個摘要檔案

**Q: 如何持續追蹤長期進度？**

A: 建立一個進度追蹤檔：

```markdown
# 季度進度追蹤

## 目標
1. 實作認證系統
2. 優化資料庫查詢
3. 提升代碼覆蓋率到 85%

## 每週進度
- [W50](weekly-summary/2025-W50.md) - 完成認證核心功能
- [W51](weekly-summary/2025-W51.md) - 開始性能優化
```

## 支援和反饋

如遇問題或有改進建議，請提交 Issue 或 Merge Request。

---

最後更新：2025-12-12
