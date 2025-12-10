# Copilot Instructions Collection

完整的 GitHub Copilot 指令集合，包含通用開發規範、特定程式語言指令以及繁體中文技術詞彙對應。

## 📚 文件導覽

- **[快速開始](docs/getting-started.md)** - 安裝與基本設定
- **[VS Code Agents](docs/agents/)** - Agent 使用指南
- **[MCP 整合](docs/mcp-integration.md)** - Model Context Protocol 設定
- **[指令集使用指南](docs/instructions-guide.md)** - 核心指令集說明
- **[相容性策略](docs/compatibility-strategies.md)** - 向後相容性設定

## 🚀 快速開始

### 基本安裝

```powershell
# 複製主要指令集
Copy-Item .\.github\copilot-instructions.md .\your-project\.github\
Copy-Item .\.github\copilot-chat-instructions.md .\your-project\.github\
```

### 選擇相容性策略（擇一）

```powershell
# 選項 A: 嚴格向後相容（穩定專案）
Copy-Item .\.github\instructions\NeverBreakCompatibility.instructions.md .\your-project\.github\instructions\

# 選項 B: 擁抱破壞性變更（快速迭代）
Copy-Item .\.github\instructions\EmbraceBreakingChanges.instructions.md .\your-project\.github\instructions\
```

⚠️ **重要：只能選擇其中一個策略！**

詳細安裝步驟請參考 [快速開始指南](docs/getting-started.md)

## 🤖 VS Code Agents

| Agent | 功能 | 文件 |
|-------|------|------|
| **Agent Generator** | 產生新的 Agent 檔案 | [說明](docs/agents/agent-generator.md) |
| **Commit** | 產生符合規範的 commit 訊息 | [說明](docs/agents/commit-agent.md) |
| **Issue** | 建立和管理 GitLab Issue | [文件](docs/agents/) |
| **Merge Request** | 建立和管理 GitLab MR | [文件](docs/agents/) |
| **Project Structure** | 產生專案結構指令 | [文件](docs/agents/) |
| **Release** | 自動化版本發佈 | [文件](docs/agents/) |
| **Work Summary** | 產生工作摘要報告 | [文件](docs/agents/) |

### 使用 Agents

1. 在 Copilot Chat 中使用 `@agent-name` 呼叫
2. Agent Mode 已預設開啟，無需額外設定
3. 支援的 Agent 列表如下表所示

詳見 [Agents 使用指南](docs/agents/README.md)

## 📋 指令集結構

```
.github/
├── copilot-instructions.md           # 主要開發規範
├── copilot-chat-instructions.md      # 繁中詞彙對應
├── agents/                           # Agent 核心指令（LLM 用）
│   ├── agent-generator.agent.md
│   ├── commit.agent.md
│   ├── issue.agent.md
│   ├── merge-request.agent.md
│   ├── project-structure.agent.md
│   ├── release.agent.md
│   └── work-summary.agent.md
└── instructions/                     # 開發規範指令
    ├── csharp.instructions.md
    ├── gitlab.instructions.md
    ├── NeverBreakCompatibility.instructions.md
    └── EmbraceBreakingChanges.instructions.md

docs/                                 # 使用者文件
├── getting-started.md
├── mcp-integration.md
├── instructions-guide.md
├── compatibility-strategies.md
└── agents/
    ├── README.md
    ├── agent-generator.md
    ├── commit-agent.md
    └── ...
```

## 🎯 核心功能

### 繁體中文技術詞彙

自動將技術英文詞彙轉換為繁體中文，統一團隊技術文件用語。

**範例：**
- Interface → 介面
- Repository → 儲存庫
- Dependency Injection → 依賴注入

### 開發規範

- **程式碼品質控制** - 統一命名規範與格式化
- **向後相容性檢查** - 可選擇嚴格或寬鬆策略
- **Conventional Commits** - Git commit 訊息規範
- **PowerShell/Bash 整合** - 混合使用指引

### GitLab 整合

透過 MCP (Model Context Protocol) 整合 GitLab：

- 建立和管理 Issues
- 建立和管理 Merge Requests
- 產生工作摘要報告
- 自動化版本發佈

設定方式請參考 [MCP 整合指南](docs/mcp-integration.md)

## 💡 適用對象

- ✅ C# / .NET 開發團隊
- ✅ 需要繁體中文技術文件的開發團隊
- ✅ 重視程式碼品質與一致性的專案團隊
- ✅ 使用 GitHub Copilot 進行 AI 輔助開發的組織

## 📖 主要指令集

### 通用開發規範

- **`.github/copilot-instructions.md`** - 核心開發規範
  - 簡潔優先原則
  - 實用主義導向
  - 避免特殊情況
  - Shell 指令指引（PowerShell/Bash）

- **`.github/copilot-chat-instructions.md`** - 繁中詞彙對應
  - 技術詞彙中英對照
  - 統一術語使用
  - 提升文件可讀性

### 語言特定指令

- **`.github/instructions/csharp.instructions.md`** - C# 開發規範
  - 命名慣例
  - 程式碼風格
  - 最佳實務

- **`.github/instructions/gitlab.instructions.md`** - GitLab MCP 工具指令
  - GitLab API 工具使用
  - Issue/MR 管理
  - 活動記錄查詢

### 相容性策略（擇一）

**選項 A：嚴格向後相容**
- 檔案：`NeverBreakCompatibility.instructions.md`
- 適用：穩定專案、生產環境
- 原則：任何破壞性變更都是錯誤

**選項 B：擁抱破壞性變更**
- 檔案：`EmbraceBreakingChanges.instructions.md`
- 適用：新專案、快速迭代
- 原則：為了改善設計可接受破壞性變更

⚠️ **絕對不可同時使用兩種策略！**

詳見 [相容性策略指南](docs/compatibility-strategies.md)

## 🔧 VS Code 設定

### 建議的擴充套件

- GitHub Copilot
- GitHub Copilot Chat
- C# Dev Kit（.NET 開發）
- PowerShell

### 專案設定

```powershell
# 複製建議的 VS Code 設定
Copy-Item .\.vscode\* .\your-project\.vscode\
```

包含：
- Copilot 相關設定優化
- 編輯器行為與格式化規則
- 語言特定設定
- 鍵盤快捷鍵

## 📝 使用範例

### 產生 Commit 訊息

```
@commit 分析暫存區變更並產生符合規範的 commit 訊息
```

### 建立 GitLab Issue

```
@issue 建立 bug report
- 問題：登入後頁面顯示空白
- 標籤：bug, frontend, priority::high
```

### 產生工作摘要

```
@work-summary 產生今天的工作摘要
```

### 建立 Merge Request

```
@merge-request 從當前分支建立 MR 到 main
```

更多範例請參考 [Agents 使用指南](docs/agents/README.md)

## 🤝 貢獻指南

歡迎貢獻新的程式語言或框架指令集！

### 新增指令集

1. 在 `.github/instructions/` 建立新檔案
2. 遵循指令檔案格式
3. 更新文件說明
4. 提交 Merge Request

### 新增 Agent

使用 Agent Generator 快速建立：

```
@agent-generator 建立新的 Agent
```

詳見 [Agent Generator 文件](docs/agents/agent-generator.md)

## 🐛 問題回報

- 發現指令集錯誤或改善建議 → 開啟 Issue
- 指令與實際需求不符 → 提供具體案例
- 繁體中文詞彙對應問題 → 提供建議翻譯

## 📚 相關資源

- [Conventional Commits 規範](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [VS Code Profiles 文檔](https://code.visualstudio.com/docs/configure/profiles)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [GitLab API 文檔](https://docs.gitlab.com/ee/api/)

## 📄 授權條款

本專案採用 MIT 授權條款，歡迎自由使用與貢獻。

---

**需要協助？** 參考 [快速開始指南](docs/getting-started.md) 或在 GitLab 上開啟 Issue。
