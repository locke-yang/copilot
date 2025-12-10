# VS Code Agents 使用指南

本專案提供 8 個 VS Code Agents，協助自動化開發流程。

## 快速導覽

| Agent | 功能 | 文件 |
|-------|------|------|
| Agent Generator | 產生新的 Agent 檔案 | [說明](agent-generator.md) |
| Commit | 產生符合規範的 commit 訊息 | [說明](commit-agent.md) |
| Issue | 建立和管理 GitLab Issue | [說明](issue-agent.md) |
| MR Create | 建立和管理 GitLab MR | [說明](mr-create-agent.md) |
| Project Structure | 產生專案結構指令 | [說明](project-structure-agent.md) |
| Review | 審查未提交的代碼變更 | [說明](review-agent.md) |
| Tag | 自動化版本發佈和標籤管理 | [說明](tag-agent.md) |
| Work Summary | 產生工作摘要報告 | [說明](work-summary-agent.md) |

## 通用前置要求

所有 Agent 都需要：

### 1. GitHub Copilot 擴充功能

確保已在 VS Code 中安裝並啟用 GitHub Copilot。

### 2. Agent Mode（預設啟用）

Agent Mode 在新版 VS Code 中預設啟用，無需手動設定。

**使用方式：**
- 在 Copilot Chat 視窗中輸入 `@` 開頭的 Agent 名稱
- 例如：`@commit`、`@issue`

**注意：** 輸入 `@` 可能不會顯示下拉列表，這是正常的。只要直接輸入完整的 Agent 名稱（如 `@commit`）即可使用。

### 3. Agent 檔案位置

Agent 定義檔案位於 `.github/agents/` 目錄：

```
.github/agents/
├── agent-generator.agent.md
├── commit.agent.md
├── issue.agent.md
├── mr-create.agent.md
├── project-structure.agent.md
├── review.agent.md
├── tag.agent.md
└── work-summary.agent.md
```

## Agent 使用方式

### 基本呼叫

在 Copilot Chat 視窗中使用 `@` 符號呼叫 Agent：

```
@commit
@issue 建立 Bug Report
@create-mr 為當前分支建立 MR
```

### Agent 連鎖（Handoffs）

某些 Agent 會自動將結果傳遞給其他 Agent：

```
@project-structure → 產生指令檔案
@commit → 提交 commit 後返回主代理
@tag → 發佈版本後通知完成
```

## GitLab 整合 Agents

以下 Agents 需要 GitLab MCP 設定：

- **Issue Agent** - 需要 `READ_ONLY_MODE=false`
- **MR Create Agent** - 需要 `READ_ONLY_MODE=false`
- **Work Summary Agent** - 可使用 `READ_ONLY_MODE=true`
- **Tag Agent** - 需要 `READ_ONLY_MODE=false`

請參考 [MCP 整合指南](../mcp-integration.md) 進行設定。

## Agent 分類

### 開發流程自動化

- **Commit Agent** - 標準化 commit 訊息
- **MR Create Agent** - 簡化 MR 建立流程
- **Tag Agent** - 自動化版本發佈和標籤管理

### 專案管理

- **Issue Agent** - 統一 Issue 格式
- **Work Summary Agent** - 追蹤工作進度

### 開發工具

- **Agent Generator** - 擴充 Agent 生態系統
- **Project Structure Agent** - 自動產生專案文件

## 工作流程範例

### 日常開發流程

1. **開發功能**
   ```
   # 正常開發...
   git add .
   ```

2. **產生 Commit**
   ```
   @commit
   ```

3. **建立 MR**
   ```
   @mr-create
   ```

4. **產生每日摘要**
   ```
   @work-summary 產生今天的工作摘要
   ```

### 版本發佈流程

1. **準備版本發佈**
   ```
   @tag 準備發佈 v1.2.0
   ```

2. **自動執行**
   - 收集 commits
   - 更新 CHANGELOG.md
   - 建立 Git tag
   - 發佈 GitLab Release

### 專案初始化

1. **產生專案結構指令**
   ```
   @project-structure
   ```

2. **建立自訂 Agent**
   ```
   @agent-generator 建立程式碼審查 Agent
   ```

## Agent 最佳實務

### 1. 清楚的指令

提供明確的指令幫助 Agent 理解需求：

❌ 不好的範例：
```
@issue 有個 bug
```

✅ 好的範例：
```
@issue 建立 Bug Report：登入頁面在 Safari 瀏覽器無法正常顯示
```

### 2. 提供足夠的上下文

某些 Agent 需要額外資訊：

```
@mr-create
- 標題：實作用戶認證功能
- 目標分支：develop
- 指派給：@reviewer
- 標籤：enhancement, security
```

### 3. 確認 Agent 輸出

某些 Agent 會要求確認：

```
@commit

# Agent 產生 commit 訊息
feat(auth): 新增雙因素認證功能

# 確認後才執行 git commit
```

### 4. 使用適當的 Agent

選擇最適合任務的 Agent：

- 需要標準化格式 → 使用 Commit/Issue/MR Create Agent
- 需要產生報告 → 使用 Work Summary Agent
- 需要自動化流程 → 使用 Tag Agent
- 需要擴充功能 → 使用 Agent Generator

## 常見問題

### Agent 沒有回應？

1. 確認 Agent 檔案存在於 `.github/agents/` 目錄
2. 確認輸入的 Agent 名稱正確（區分大小寫）
3. 重新載入 VS Code 視窗（`Developer: Reload Window`）
4. 檢查 `settings.json` 是否有衝突的設定

如果仍無法使用，可在 `settings.json` 中明確啟用：

```json
{
  "chat.agent.enabled": true
}
```

### GitLab Agent 無法使用？

1. 確認 `mcp.json` 已正確設定
2. 檢查 GitLab token 權限
3. 驗證 `READ_ONLY_MODE` 設定

### Agent 產生的結果不符預期？

1. 提供更明確的指令
2. 包含更多上下文資訊
3. 參考該 Agent 的詳細文件

### 如何建立自訂 Agent？

使用 Agent Generator：

```
@agent-generator 建立新的 Agent，功能是...
```

或參考 [Agent Generator 文件](agent-generator.md)。

## 進階使用

### 批次處理

某些 Agent 支援批次處理多個項目：

```
@issue 批次建立以下 Issues：
1. Bug: 登入問題
2. Feature: 新增搜尋功能
3. Task: 更新文件
```

### 自訂範本

修改 Agent 檔案以自訂行為（需要了解 Agent 結構）：

```yaml
---
description: 自訂描述
name: Custom Agent
tools: ['tool1', 'tool2']
---
```

### 整合外部工具

Agent 可以呼叫其他工具：

- Git 命令
- GitLab API（透過 MCP）
- 檔案系統操作
- 搜尋工具

## 疑難排解

### 除錯 Agent

1. 檢查 Agent YAML frontmatter 格式
2. 驗證工具權限
3. 查看 VS Code 輸出面板的錯誤訊息

### 重設 Agent Mode

如果 Agent 行為異常：

1. 檢查 `.vscode/settings.json` 中的 Agent 設定
2. 重新載入 VS Code 視窗（`Ctrl+Shift+P` → `Developer: Reload Window`）
3. 確認 `.github/agents/` 目錄中的 Agent 檔案存在

**強制啟用 Agent Mode：**

在 `settings.json` 中新增：

```json
{
  "github.copilot.advanced": {
    "agentEnabled": true
  }
}
```

## 相關資源

- [快速開始指南](../getting-started.md)
- [MCP 整合](../mcp-integration.md)
- [專案 README](../../README.md)
- [CHANGELOG](../../CHANGELOG.md)

## 貢獻新 Agent

歡迎貢獻新的 Agent！使用 Agent Generator 建立新 Agent 後：

1. 測試 Agent 功能
2. 在本文件新增 Agent 說明
3. 更新主 README.md
4. 提交 Merge Request
