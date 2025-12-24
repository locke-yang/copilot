# gitlab-config-agent

## 功能說明

gitlab-config-agent 協助在專案根目錄建立或更新 `.gitlab-agent.json`，對照提供的 Schema 與專案資訊，產出可直接使用的配置（含 issue、merge request、labels、milestones、team 等預設值）。

## 前置要求

- 已在 VS Code 安裝並啟用 GitHub Copilot
- 專案為 Git 儲存庫，且設定好 `git remote`
- 建議專案根目錄存在 `.gitlab-agent.schema.json`（便於自動完成與驗證）

## 啟用方式

1. 在 Copilot Chat 視窗的 agents 下拉選單選擇 **gitlab-config-agent**
2. 確認當前工作區為目標專案根目錄

## 使用方式

### 基本用法

在聊天中說明需求，例如：

```
建立專案的 .gitlab-agent.json，target branch 用 develop，labels 用 needs-review
```

Agent 會：
- 檢查是否已有 `.gitlab-agent.json`，若無則建立最小可用範本
- 嘗試從 `git remote -v` 推導 `projectPath` 與 `instanceUrl`
- 依需求補齊 `mergeRequest.defaults`、`issue.templates`、`team.groups` 等欄位
- 產出完整 JSON 或直接寫入檔案（變更重點會在回覆中列出）

### 進階用法

```
請更新 .gitlab-agent.json：
- projectPath: company/web-portal
- default targetBranch 改 main
- reviewers 改為 @alice, @bob
- labels 使用 priority::high, status::review
```

建議同時提供：
- 期望的 branch 前綴（如 feature/、fix/）
- 常用 label 命名空間（如 priority:: / status::）
- Issue templates 路徑（如 .gitlab/issue_templates/bug.md）

## 實際應用範例

### 新增最小化配置

```
建立 .gitlab-agent.json：
- projectPath: group/project-name
- targetBranch: main
- labels: needs-review
```

### 更新既有配置

```
檢查並補齊 .gitlab-agent.json：
- 若沒有 mergeRequest.rules.requireApprovals，預設 2
- issue.defaults.labels 加入 status::todo
- 若缺里程碑，加入 2025-Q1 為 defaultMilestone
```

## 最佳實務

- 保持最小可用：先填必要欄位，後續再逐步豐富
- 使用命名空間 labels：如 `priority::high`、`status::review`
- Issue templates 置於 `.gitlab/issue_templates/` 並在配置中引用
- 避免將 Token、私密資訊寫入配置檔
- 將 `.gitlab-agent.json` 和 `.gitlab-agent.schema.json` 一併納入版本控制

## 疑難排解

- **Agent 無法推導 projectPath**：確認 `git remote -v` 存在且為 GitLab URL；必要時手動提供 `group/project`
- **Schema 驗證警告**：確認 `version` 與 `gitlab.projectPath` 皆存在，欄位大小寫需與 Schema 一致
- **Labels 未生效**：確認 GitLab 專案已建立對應 labels；必要時先在 GitLab UI 建立
- **Issue templates 路徑錯誤**：確認檔案位於 `.gitlab/issue_templates/` 並使用相對路徑

## 延伸閱讀

- [GitLab Agent 配置文件](gitlab-agent-config.md)
- [commit-agent](commit-agent.md)
- [mr-create-agent](mr-create-agent.md)
- [mr-review-agent](mr-review-agent.md)
