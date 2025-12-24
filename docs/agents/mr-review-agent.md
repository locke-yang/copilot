# mr-review-agent 使用指南

mr-review-agent 專為審查 GitLab Merge Request（MR）設計，協助團隊提升代碼品質、減少缺陷並加速審查流程。

## 功能概述
- 取得 MR diff、討論與註解
- 分析所有變更內容
- 彙整現有討論，避免重複建議
- 產生結構化審查報告
- 提供具體改進建議與代碼範例

## 快速開始

### 基本用法

1. 在 Copilot Chat 中選擇 **MR Review** Agent（透過 dropdown）
2. 提供 MR 資訊

```
- MR: !123
```

或

```
- 來源分支: feature/login
- 目標分支: develop
```

### 指定審查類型

```
- 類型：安全審查
- 詳細程度：詳細
```

## 審查報告範例

```markdown
# Merge Request 審查報告 - 2025-12-12

## MR 概述
- 標題：新增用戶認證功能
- 作者：alice
- 來源分支 → 目標分支：feature/auth → develop
- 主要變更內容：
  - 新增登入/登出 API
  - 實作 JWT 驗證
  - 增加單元測試

## 變更摘要
- 變更檔案數：5
- 新增 320 行，刪除 20 行

## 審查結果

### ✅ 良好實踐
- 測試覆蓋完整
- 錯誤處理清晰
- 架構分層明確

### ⚠️ 需要改進
1. 密碼驗證未加密（高優先級）
2. Token 過期時間硬編碼（中優先級）

### 🐛 潛在問題
1. SQL 注入風險
2. 競態條件

### 💡 改進建議
- 使用 bcrypt 處理密碼
- 參數化查詢防止 SQL 注入
- 將設定移至 config 檔

## 檢查清單
- [x] 代碼風格符合專案規範
- [ ] **沒有明顯的 Bug 或邏輯錯誤**
- [x] 命名清晰且有意義
- [ ] **包含必要的錯誤處理**
- [x] 有適當的註解和文檔
- [x] 包含或更新測試
- [x] 沒有遺留的調試代碼
- [ ] **沒有安全性問題**

## 下一步建議
1. 修正高優先級安全問題
2. 增加輸入驗證
3. 優化資料庫查詢

---

## 審查類型
- 快速審查：檢查明顯問題與風格
- 詳細審查：深入分析邏輯與架構
- 安全審查：聚焦安全性問題
- 效能審查：聚焦效能優化

## 工作流程範例

### 1. 指定 MR 審查

在 Copilot Chat 中選擇 **MR Review** Agent，提供：
```
- MR: !456
```

### 2. 指定分支審查

在 Copilot Chat 中選擇 **MR Review** Agent，提供：
```
- 來源分支: feature/api
- 目標分支: main
```

### 3. 指定審查重點

在 Copilot Chat 中選擇 **MR Review** Agent，提供：
```
- 聚焦：安全性、效能
```

### 4. 產生審查報告後
- 依建議修正代碼
- 重新執行 mr-review-agent
- 通過後再進行合併

## 最佳實務
- 先處理高優先級問題（安全、Bug）
- 參考專案 instructions 檔案
- 與 MR 作者積極溝通
- 保持審查紀錄

## 常見問題

**Q: 可以同時審查多個 MR 嗎？**
A: 一次僅支援一個 MR，請分次審查。

**Q: 可以自訂審查規則嗎？**
A: 可於 `.github/instructions/` 設定專案規範。

**Q: 審查報告會自動保存嗎？**
A: 不會，請手動複製保存。

## 相關資源
- [mr-review-agent 原始檔案](mr-review.agent.md)
- [commit-agent 指南](commit-agent.md)
- [mr-create-agent 指南](mr-create-agent.md)
- [VS Code Agents 總覽](README.md)

---

最後更新：2025-12-12
