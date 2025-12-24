# agent-generator

## 功能說明

agent-generator 協助建立符合專案規範的 VS Code Agent 檔案。

**主要功能：**
- 產生包含正確 YAML frontmatter 的 Agent 檔案
- 生成的 Agent 只包含 LLM 執行需要的核心指令
- 自動更新 README.md 的使用說明
- 參考現有 Agent 的結構模式

## 前置要求

- VS Code 安裝 GitHub Copilot 擴充功能
- 在 VS Code 中啟用 Agent Mode

## 使用方式

### 基本步驟

1. 在 Copilot Chat 中選擇 **agent-generator**（透過 dropdown）
2. 描述要建立的 Agent 功能

### 基本用法

```
建立一個新的 Agent，名稱為 Code Review，功能是檢查程式碼品質
```

### 指定詳細資訊

```
建立 Agent：
- 名稱：API Client Generator
- 用途：根據 OpenAPI 規格產生 API Client 程式碼
- 需要工具：read/readFile、search
- 分析 swagger.json 檔案
```

### 建立專案特定 Agent

```
建立 Database Migration Agent
- 功能：檢查和執行資料庫遷移腳本
- 需要工具：read/readFile、terminal
- 驗證遷移腳本的 SQL 語法
```

## Agent 檔案結構

生成的 Agent 檔案包含：

1. **YAML Frontmatter** - description、name、tools、handoffs
2. **執行流程** - 編號步驟說明
3. **核心規則/規範** - 依功能定義
4. **工具列表** - 使用的 MCP 工具或系統工具
5. **分析要點/核心原則** - LLM 執行關鍵指引

### 範例結構

```yaml
---
description: Agent 的簡短描述（一句話）
name: Agent Name
tools: ['tool1', 'tool2']
handoffs:
  - label: 完成標籤
    agent: agent
    prompt: 完成訊息
    send: false
---

# Agent Name

簡短說明 Agent 的用途。

## 執行流程

1. 步驟一
2. 步驟二
3. 步驟三

## 核心規則

- 規則一
- 規則二

## 工具列表

- `tool1` - 工具說明
- `tool2` - 工具說明

## 核心原則

- 原則一
- 原則二
```

## Agent 類型參考

可參考的現有 Agent 檔案結構：

### 規範型 Agent
參考 [`commit.agent.md`](../../.github/agents/commit.agent.md)
- 明確的格式規範
- 類型和範圍定義
- 範例和最佳實務

### 範本型 Agent
參考 [`issue.agent.md`](../../.github/agents/issue.agent.md)
- 多種範本選擇
- 欄位和屬性定義
- 分類和標籤系統

### 流程型 Agent
參考 [`mr-create.agent.md`](../../.github/agents/mr-create.agent.md)
- 步驟化的執行流程
- API 整合說明
- 狀態和驗證檢查

### 分析型 Agent
參考 [`work-summary.agent.md`](../../.github/agents/work-summary.agent.md)
- 資料收集和分類
- 報告生成邏輯
- 統計和摘要規則

## 最佳實務

### 1. 明確定義用途

清楚說明 Agent 要解決的問題：

❌ 不明確：
```
建立一個處理檔案的 Agent
```

✅ 明確：
```
建立一個 Agent，功能是分析 Markdown 文件並產生目錄結構
```

### 2. 最小化工具權限

只包含必要的工具權限：

```yaml
tools: ['read/readFile', 'search']  # 只需要讀取和搜尋
```

而非：

```yaml
tools: ['*']  # 避免使用萬用字元
```

### 3. 結構化流程

使用清晰的編號步驟：

```markdown
## 執行流程

1. 讀取配置檔案
2. 驗證設定格式
3. 執行轉換邏輯
4. 產生輸出檔案
```

### 4. 參考現有 Agent

查看 `.github/agents/` 中的範例：

```powershell
# 列出所有 Agent 檔案
Get-ChildItem .\.github\agents\*.agent.md
```

### 5. 分離使用說明

**Agent 檔案中（LLM 用）：**
- 執行流程
- 規則和規範
- 工具列表
- 核心原則

**README.md 中（使用者用）：**
- 前置要求
- 安裝步驟
- 使用範例
- 最佳實務
- 疑難排解

## 生成後的更新

### 1. Agent 檔案

生成的檔案位於 `.github/agents/<agent-name>.agent.md`

### 2. README.md 更新

自動在以下章節新增內容：

- **檔案結構** - 新增 Agent 檔案路徑
- **VS Code Agents** - 新增 Agent 簡介
- **Agent 使用指南** - 新增詳細說明

### 3. 驗證生成結果

```powershell
# 檢查 Agent 檔案格式
code .\.github\agents\<agent-name>.agent.md

# 驗證 YAML frontmatter
# 確認 description、name、tools 欄位完整
```

## 檔案命名規則

- 使用小寫字母和連字號：`agent-name.agent.md`
- 檔案名稱應簡潔且具描述性
- 避免使用縮寫（除非是通用縮寫）
- 儲存路徑：`.github/agents/`

**範例：**
- ✅ `code-review.agent.md`
- ✅ `api-client-generator.agent.md`
- ❌ `cr.agent.md`（過度縮寫）
- ❌ `CodeReview.agent.md`（使用大寫）

## 常見使用情境

### 程式碼品質檢查

```
建立程式碼審查 Agent
- 檢查程式碼風格
- 分析潛在錯誤
- 建議改善方向
```

### 文件生成

```
建立 API 文件生成 Agent
- 掃描程式碼註解
- 產生 API 文件
- 支援 Markdown 和 HTML 格式
```

### 測試自動化

```
建立單元測試生成 Agent
- 分析函式簽名
- 產生測試案例
- 遵循專案測試慣例
```

### 資料轉換

```
建立資料格式轉換 Agent
- 支援 JSON、XML、YAML
- 驗證資料結構
- 保持資料完整性
```

## 疑難排解

### Agent 檔案格式錯誤

檢查 YAML frontmatter 格式：

```yaml
---
description: 必須是字串
name: 必須是字串
tools: ['必須是陣列']
handoffs:
  - label: 必須是字串
    agent: 必須是 'agent'
    prompt: 必須是字串
    send: 必須是布林值
---
```

### 工具名稱無效

確認工具名稱正確：

- ✅ `read/readFile`
- ✅ `search`
- ❌ `write/createFile`（無效）

### Agent 無法呼叫

1. 確認 Agent Mode 已啟用
2. 檢查檔案名稱是否正確（必須是 `.agent.md` 結尾）
3. 重新載入 VS Code 視窗

## 進階功能

### 自訂 Handoffs

設定 Agent 完成後的行為：

```yaml
handoffs:
  - label: 提交變更
    agent: commit
    prompt: 使用 commit agent 提交變更
    send: true
```

### 整合 GitLab MCP

需要 GitLab API 的 Agent：

```
@agent-generator 建立 GitLab Issue 統計 Agent
- 使用 GitLab MCP 工具
- 統計 Issue 數量和狀態
- 產生圖表報告
```

### 多步驟工作流程

建立包含多個步驟的複雜 Agent：

```
@agent-generator 建立部署檢查 Agent
- 執行流程：
  1. 檢查分支狀態
  2. 執行測試
  3. 驗證建置
  4. 確認部署準備
```

## 相關文件

- [Agents 總覽](README.md)
- [快速開始](../getting-started.md)
- [主 README](../../README.md)
- [Agent 核心指令檔案](../../.github/agents/agent-generator.agent.md)
