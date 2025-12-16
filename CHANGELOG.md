# Changelog

所有重要的變更都會記錄在此檔案中。

格式基於 [Keep a Changelog](https://keepachangelog.com/zh-TW/1.0.0/)，
版本號遵循 [語意化版本控制](https://semver.org/spec/v2.0.0.html)。

## [1.0.0] - 2025-12-16

### 新增

- **核心指令集**
  - 主要開發規範指令 (`copilot-instructions.md`)
  - 繁體中文技術詞彙對應 (`copilot-chat-instructions.md`)
  - C# 程式語言專用指令
  - GitLab 整合指令

- **相容性策略**
  - `NeverBreakCompatibility` 指令 - 嚴格向後相容策略
  - `EmbraceBreakingChanges` 指令 - 擁抱破壞性變更策略

- **VS Code Agents**
  - Agent Generator - 產生新的 Agent 檔案
  - Commit Agent - 自動產生符合規範的 commit 訊息
  - Issue Agent - GitLab Issue 建立和管理
  - MR Create Agent - GitLab Merge Request 建立和管理
  - MR Review Agent - GitLab Merge Request 審查
  - Project Structure Agent - 產生專案結構指令
  - Review Agent - 審查未提交的代碼變更
  - Tag Agent - 自動化版本發佈和標籤管理
  - Work Summary Agent - 產生工作摘要報告

- **MCP 整合**
  - GitLab MCP Server 設定範例
  - 完整的 MCP 整合指南

- **文件**
  - 快速開始指南
  - Agents 使用指南（包含各 Agent 的詳細文件）
  - MCP 整合指南
  - 指令集使用指南
  - 相容性策略說明

- **範例與工具**
  - MCP 設定範例檔案 (`mcp.json.example`)
  - 完整的專案結構範例

### 修改

- 說明文件全面更新，改為透過 Copilot Chat 的 agents dropdown 選擇自訂 Agents，移除 `@agent` 呼叫方式的敘述與範例
- `.github/instructions/glitab.instructions.md` 明確規範：使用 GitLab MCP 工具與 `glab` 進行遠端操作，限制原生 `git push/pull` 等遠端指令
- `.vscode/settings.json` 調整 Copilot Chat 相關設定，啟用 `bash -n` 驗證與顯示組織/企業 Agents
- `.github/agents/*` 統一 tools 欄位與 handoffs 串接，更新 MR/Review 類代理名稱與轉移目標（導向 Issue Agent）

### 已修正

- 移除過時的 `scripts/Copy-CopilotInstructions.ps1`，安裝流程改為使用使用者層級 `prompts` 目錄並建立 `agents.json` 索引
- `scripts/Install-AllSettings.ps1` 移除 Copilot 指令複製步驟，更新步驟順序與提示
- `scripts/Install-UserAgents.ps1` 改為安裝到 `%APPDATA%\Code\User\prompts` 並自動產生 `agents.json`

### 特色功能

- 繁體中文技術詞彙自動轉換
- 模組化指令集架構，支援按需組合
- 與 GitLab 深度整合的自動化工作流程
- 基於 Model Context Protocol 的進階整合能力
