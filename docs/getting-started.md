# 快速開始指南

本指南協助您在專案中快速設定 Copilot Instructions。

## 前置要求

- Visual Studio Code
- GitHub Copilot 擴充功能
- Git（如需使用 Agent 功能）

## 基本安裝

### 1. 複製指令集到您的專案

```powershell
# 複製主要指令集
Copy-Item .\.github\copilot-instructions.md .\your-project\.github\

# 複製 Chat 指令集
Copy-Item .\.github\copilot-chat-instructions.md .\your-project\.github\
```

### 2. 使用特定語言指令

```powershell
# 複製 C# 指令集
Copy-Item .\.github\instructions\csharp.instructions.md .\your-project\.github\instructions\

# 複製 GitLab 指令集
Copy-Item .\.github\instructions\gitlab.instructions.md .\your-project\.github\instructions\
```

### 3. 使用 Project Structure Agent 生成指令

Agent 可自動偵測專案結構並產生相應的指令檔案：

1. 開啟 Copilot Chat 視窗
   - Agent Mode 在新版中預設啟用
   - 如需手動設定，在 `.vscode/settings.json` 中加入：
   ```json
   {
     "github.copilot.advanced": {
       "agentEnabled": true
     }
   }
   ```

2. 在聊天視窗中使用 `@project-structure` 指令

3. Agent 會自動：
   - 偵測 Git 儲存庫名稱
   - 掃描專案頂層資料夾結構
   - 產生專案層級與資料夾層級的 Copilot 指令檔案

適用於為現有專案建立結構化的 Copilot 指令集。

### 4. 選擇相容性策略（擇一使用）

根據專案特性選擇適合的相容性策略：

#### 選項 A：嚴格向後相容性（適用於穩定專案）

```powershell
Copy-Item .\.github\instructions\NeverBreakCompatibility.instructions.md .\your-project\.github\instructions\
```

**特點：**
- 將向後相容性視為最高原則
- 任何破壞現有行為的變更都被視為錯誤
- 適用於穩定的生產環境或長期維護的專案

#### 選項 B：擁抱破壞性變更（適用於快速迭代專案）

```powershell
Copy-Item .\.github\instructions\EmbraceBreakingChanges.instructions.md .\your-project\.github\instructions\
```

**特點：**
- 向後相容性不是優先考量
- 為了改善設計或功能而接受破壞性變更
- 適用於快速迭代的新專案或重構階段

⚠️ **重要：同一時間只能使用其中一個策略！**

### 5. 套用 VS Code 設定

```powershell
# 複製建議的 VS Code 設定
Copy-Item .\.vscode\* .\your-project\.vscode\
```

## 啟用 Agent Mode

VS Code Agents 需要啟用 Agent Mode 才能使用。

### 啟用步驟

1. 開啟 Command Palette
   - Windows/Linux: `Ctrl+Shift+P`
   - macOS: `Cmd+Shift+P`

2. 搜尋並執行：`Copilot: Enable Agent Mode`

3. 在 Copilot Chat 視窗中使用 `@agent-name` 呼叫 Agent

### 驗證 Agent Mode 已啟用

在 Copilot Chat 視窗中輸入 `@`，應該會看到可用的 Agent 列表：
- `@agent-generator`
- `@commit`
- `@issue`
- `@merge-request`
- `@project-structure`
- `@release`
- `@work-summary`

## 自訂調整

### 修改指令集內容

根據專案需求編輯指令檔案：

```powershell
# 編輯主要指令集
code .\your-project\.github\copilot-instructions.md
```

### 新增專案特定指令

在 `.github/instructions/` 目錄建立新的指令檔案：

```markdown
<!-- .github/instructions/your-custom.instructions.md -->
---
applyTo: "**/*.js"
---

## 您的自訂規則

1. 規則一
2. 規則二
```

### 調整 VS Code 設定

根據團隊偏好修改 `.vscode/settings.json`：

```json
{
  "github.copilot.enable": {
    "*": true
  },
  "github.copilot.advanced": {
    "debug.overrideEngine": "gpt-4"
  }
}
```

## 驗證安裝

### 測試 Copilot 指令集

1. 開啟專案中的任一檔案
2. 開啟 Copilot Chat (`Ctrl+Alt+I`)
3. 詢問：「請說明這個專案的開發規範」
4. Copilot 應該能參考您設定的指令集回答

### 測試 Agent

```
@commit
```

Agent 應該自動檢查暫存區並協助產生 commit 訊息。

## 常見問題

### Copilot 沒有讀取指令檔案？

1. 確認檔案放在 `.github/` 目錄下
2. 重新載入 VS Code 視窗（`Ctrl+Shift+P` → `Reload Window`）
3. 檢查檔案名稱是否正確

### Agent 無法使用？

1. 確認已啟用 Agent Mode
2. 檢查 `.github/agents/` 目錄是否存在
3. 確認 Agent 檔案有正確的 YAML frontmatter

### 相容性策略衝突？

確保只使用一個相容性策略檔案。如果同時存在兩個檔案，請刪除其中一個：

```powershell
# 刪除不需要的策略
Remove-Item .\your-project\.github\instructions\EmbraceBreakingChanges.instructions.md
```

## 下一步

- 查看 [Agents 使用指南](agents/README.md) 了解各個 Agent 的詳細功能
- 閱讀 [MCP 整合](mcp-integration.md) 設定 GitLab 整合
- 參考 [指令集使用指南](instructions-guide.md) 深入了解指令集結構

## 需要協助？

- 查看專案 [CHANGELOG.md](../CHANGELOG.md) 了解最新變更
- 在 GitLab 上提出 Issue 回報問題
- 參考各個 Agent 的詳細文件
