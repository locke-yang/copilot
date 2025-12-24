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

2. 在 Copilot Chat 視窗頂部的 agents dropdown 中選擇 **Project Structure**

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

## 使用自訂 Agents

VS Code 自訂 Agents 透過 agents dropdown 選擇使用。

### 使用步驟

1. 確認 Agent 檔案已安裝在 `.github/agents/` 目錄

2. 開啟 Copilot Chat 視窗

3. 在視窗頂部點擊 agents dropdown（通常顯示 "Ask" 或目前 Agent 名稱）

4. 從下拉選單中選擇您要使用的 Agent：
   - **Agent Generator** - 產生新的 Agent 檔案
   - **Commit** - 產生符合規範的 commit 訊息
   - **Issue** - 建立和管理 GitLab Issue
   - **MR Create** - 建立和管理 GitLab MR
   - **MR Review** - 審查 GitLab MR 提案
   - **Project Structure** - 產生專案結構指令
   - **Review** - 審查未提交的代碼變更
   - **Tag** - 自動化版本發佈和標籤管理
   - **Work Summary** - 產生工作摘要報告

**重要：** 自訂 Agent 不支援 `@` 語法呼叫，必須透過 dropdown 選擇。

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

1. 在 Copilot Chat 視窗頂部點擊 agents dropdown
2. 選擇 **Commit** Agent
3. 提供 commit 相關描述

Agent 應該自動檢查暫存區並協助產生 commit 訊息。

## 常見問題

### Copilot 沒有讀取指令檔案？

1. 確認檔案放在 `.github/` 目錄下
2. 重新載入 VS Code 視窗（`Ctrl+Shift+P` → `Reload Window`）
3. 檢查檔案名稱是否正確

### Agent 無法在下拉選單中顯示？

1. 確認 `.github/agents/` 目錄存在且包含 `.agent.md` 檔案
2. 檢查 Agent 檔案的 YAML frontmatter 格式是否正確
3. 確認設定了 `name` 字段（若未設定會使用檔案名作為預設名稱）
4. 重新載入 VS Code 視窗（`Ctrl+Shift+P` → `Developer: Reload Window`）
5. 檢查 `.vscode/settings.json` 是否有衝突的設定

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
