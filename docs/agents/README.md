# VS Code Agents 使用指南

本專案提供 10 個 VS Code Agents，協助自動化開發流程。

## 快速導覽

| Agent | 功能 | 文件 |
|-------|------|------|
| agent-generator | 產生新的 Agent 檔案 | [說明](agent-generator.md) |
| Commit | 產生符合規範的 commit 訊息；多主題時輸出連續指令序列 | [說明](commit-agent.md) |
| GitLab Config | 建立或更新 `.gitlab-agent.json` 配置檔 | [說明](gitlab-config-agent.md) |
| Issue | 建立和管理 GitLab Issue | [說明](issue-agent.md) |
| MR Create | 建立和管理 GitLab MR | [說明](mr-create-agent.md) |
| MR Review | 審查 GitLab MR 提案 | [說明](mr-review-agent.md) |
| Project Structure | 產生專案結構指令 | [說明](project-structure-agent.md) |
| Review | 審查未提交的代碼變更 | [說明](review-agent.md) |
| Tag | 自動化版本發佈和標籤管理 | [說明](tag-agent.md) |
| Work Summary | 產生工作摘要報告 | [說明](work-summary-agent.md) |

## GitLab 專案配置

issue-agent、mr-create-agent 和 mr-review-agent 支援專案級配置檔案 `.gitlab-agent.json`，用於定義專案預設資訊（project ID、milestone、target branch、labels 等），提升使用效率。

📖 **詳細說明**: [GitLab Agent 配置文件](gitlab-agent-config.md)

## 通用前置要求

所有 Agent 都需要：

### 1. GitHub Copilot 擴充功能

確保已在 VS Code 中安裝並啟用 GitHub Copilot。

### 2. Agent Mode（預設啟用）

Agent Mode 在新版 VS Code 中預設啟用，無需手動設定。

### 3. Agent 檔案位置

Agent 定義檔案位於 `.github/agents/` 目錄：

```
.github/agents/
├── agent-generator.agent.md
├── commit.agent.md
├── gitlab-config.agent.md
├── issue.agent.md
├── mr-create.agent.md
├── mr-review.agent.md
├── project-structure.agent.md
├── review.agent.md
├── tag.agent.md
└── work-summary.agent.md
```

## Agent 使用方式

### 正確的 Agent 名稱設定

自訂 Agent 的顯示名稱是設定在 `.agent.md` 檔案的 YAML frontmatter 中的 `name` 字段：

```yaml
---
name: My commit-agent          # 這是顯示名稱
description: 產生符合規範的 commit 訊息
tools: [git, search]
# 其他配置...
---
```

**注意：** 如果沒有設定 `name`，預設使用檔案名（去掉 `.agent.md` 擴展）。例如檔案叫 `commit.agent.md`，名稱就是 `commit`。

### 如何使用自訂 Agent

**透過下拉選單選擇：**
1. 在 Copilot Chat 視窗頂部，點擊 agents dropdown（通常顯示目前模式，如 "Ask" 或預設 Agent）
2. 直接選擇你的自訂 Agent 名稱（就是 YAML 中設的 `name`）
3. 選中後，所有後續聊天都會使用這個 Agent 的配置（prompt、tools 等）

**重要提示：**
- 自訂 Agent **不支援 `@` 語法呼叫**
- 無法像內建 `@workspace`、`@terminal` 那樣用 `@ 臨時呼叫
- 主要透過 dropdown 切換，或透過 handoffs（在 YAML 中設定轉移按鈕）來使用

### @ 語法的使用

`@` 語法主要用於 **內建 agents 或工具**，例如：
- `@workspace` - 分析整個專案
- `@terminal` - 執行終端命令
- `@vscode` - VS Code 相關操作

這些是 Copilot 預設提供的內建 agents，無法自定義。

### Agent 連鎖（Handoffs）

某些 Agent 可以設定 handoffs，在 YAML 中定義轉移按鈕，將結果傳遞給其他 Agent：

```yaml
handoffs:
  - name: commit-agent
    description: 轉移到 commit-agent 進行提交
  - name: mr-create-agent
    description: 轉移到 mr-create-agent 建立 MR
```

## GitLab 整合 Agents

以下 Agents 需要 GitLab MCP 設定：

- **issue-agent** - 需要 `READ_ONLY_MODE=false`
- **mr-create-agent** - 需要 `READ_ONLY_MODE=false`
- **work-summary-agent** - 可使用 `READ_ONLY_MODE=true`
- **tag-agent** - 需要 `READ_ONLY_MODE=false`

請參考 [MCP 整合指南](../mcp-integration.md) 進行設定。

## Agent 分類

### 開發流程自動化

- **commit-agent** - 標準化 commit 訊息
- **mr-create-agent** - 簡化 MR 建立流程
- **tag-agent** - 自動化版本發佈和標籤管理

### 專案管理

- **issue-agent** - 統一 Issue 格式
- **gitlab-config-agent** - 建立與維護 GitLab Agent 配置檔
- **work-summary-agent** - 追蹤工作進度

### 開發工具

- **agent-generator** - 擴充 Agent 生態系統
- **project-structure-agent** - 自動產生專案文件

## 工作流程範例

### 日常開發流程

1. **開發功能**
   - 正常開發...
   - `git add .`

2. **產生 Commit**
   - 在 Copilot Chat 中選擇 **commit-agent**（透過 dropdown）
   - 提供 commit 描述

3. **建立 MR**
   - 在 Copilot Chat 中選擇 **mr-create-agent**（透過 dropdown）
   - 提供 MR 標題和詳細資訊

4. **產生每日摘要**
   - 在 Copilot Chat 中選擇 **work-summary-agent**（透過 dropdown）
   - 提供時間範圍或工作內容

### 版本發佈流程

1. **準備版本發佈**
   - 在 Copilot Chat 中選擇 **tag-agent**（透過 dropdown）
   - 指定版本號（例如 v1.2.0）

2. **自動執行**
   - 收集 commits
   - 更新 CHANGELOG.md
   - 建立 Git tag
   - 發佈 GitLab Release

### 專案初始化

1. **產生專案結構指令**
   - 在 Copilot Chat 中選擇 **project-structure-agent**（透過 dropdown）
   - 提供專案類型和詳細需求

2. **建立自訂 Agent**
   - 在 Copilot Chat 中選擇 **agent-generator**（透過 dropdown）
   - 描述新 Agent 的功能需求

## Agent 最佳實務

### 1. 清楚的指令

提供明確的指令幫助 Agent 理解需求：

❌ 不好的範例：
- 在 Copilot Chat 中簡單輸入「有個 bug」

✅ 好的範例：
- 選擇 issue-agent，然後輸入：「建立 Bug Report：登入頁面在 Safari 瀏覽器無法正常顯示」

### 2. 提供足夠的上下文

某些 Agent 需要額外資訊。例如使用 mr-create-agent 時：

```
- 標題：實作用戶認證功能
- 目標分支：develop
- 指派給：@reviewer
- 標籤：enhancement, security
```

### 3. 確認 Agent 輸出

某些 Agent 會要求確認：

使用 commit-agent 時：
1. Agent 產生建議的 commit 訊息
2. 確認或修改訊息內容
3. 確認後才執行 git commit

### 4. 使用適當的 Agent

選擇最適合任務的 Agent：

- 需要標準化 commit 訊息 → 使用 commit-agent
- 需要建立 Issue → 使用 issue-agent
- 需要建立 MR → 使用 mr-create-agent
- 需要產生報告 → 使用 work-summary-agent
- 需要自動化版本發佈 → 使用 tag-agent
- 需要擴充功能 → 使用 agent-generator

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

1. 在 Copilot Chat 中選擇 **agent-generator**（透過 dropdown）
2. 描述新 Agent 的功能需求
3. 參考 [agent-generator 文件](agent-generator.md) 了解詳細步驟

## 進階使用

### 批次處理

某些 Agent 支援批次處理多個項目。例如使用 issue-agent 時：

```
批次建立以下 Issues：
1. Bug: 登入問題
2. Feature: 新增搜尋功能
3. Task: 更新文件
```

### 自訂 Agent 配置

修改 `.agent.md` 檔案以自訂行為（需要了解 Agent 結構）：

```yaml
---
name: My Custom Agent
description: 自訂描述
tools:
  - search
  - fetch
handoffs:
  - name: Other Agent
    description: 轉移到其他 Agent
---

你的自訂 Agent 指令...
```

### 整合外部工具

Agent 可以呼叫其他工具：

- Git 命令
- GitLab API（透過 MCP）
- 檔案系統操作
- 搜尋和取得工具

## 疑難排解

### 除錯 Agent

1. 檢查 Agent YAML frontmatter 格式
2. 驗證工具權限
3. 查看 VS Code 輸出面板的錯誤訊息

### Agent 無法在下拉選單中顯示？

如果自訂 Agent 無法在 agents dropdown 中看到：

1. 確認 `.agent.md` 檔案在 `.github/agents/` 目錄中
2. 檢查 YAML frontmatter 格式是否正確
3. 確認設定了 `name` 字段（如果沒有會使用檔案名作為預設名稱）
4. 重新載入 VS Code 視窗（`Ctrl+Shift+P` → `Developer: Reload Window`）
5. 檢查 `.vscode/settings.json` 是否有衝突的設定

### Agent 看起來沒有回應？

1. 確認已從 agents dropdown 正確選擇了 Agent
2. 檢查 Agent 定義檔案中的 YAML 配置
3. 查看 VS Code 輸出面板的錯誤訊息（`Ctrl+Shift+U`）
4. 確認工具和權限設定正確

## 相關資源

- [快速開始指南](../getting-started.md)
- [MCP 整合](../mcp-integration.md)
- [專案 README](../../README.md)
- [CHANGELOG](../../CHANGELOG.md)

## 貢獻新 Agent

歡迎貢獻新的 Agent！建立新 Agent 後：

1. 將 `.agent.md` 檔案放在 `.github/agents/` 目錄
2. 確認 YAML frontmatter 中設定了 `name` 和 `description`
3. 測試 Agent 功能（透過 agents dropdown 選擇並使用）
4. 在本文件新增 Agent 說明（快速導覽表和分類）
5. 建立或更新 Agent 對應的文件檔案（如 `new-agent.md`）
6. 更新主 README.md
7. 提交 Merge Request

**新 Agent 文件範本：**

```yaml
---
name: My New Agent
description: Agent 的功能描述
tools:
  - tool1
  - tool2
---

## 功能說明

詳細描述 Agent 的功能...

## 使用方式

1. 在 Copilot Chat 中選擇 "My New Agent"（透過 dropdown）
2. 提供具體指令...

## 範例

具體使用範例...
```
