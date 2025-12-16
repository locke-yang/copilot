---
description: 執行發佈版本流程 - 修改版本訊息、提交並推送到 Git Server
name: Tag Agent
tools: ['read', 'search', 'edit', 'execute']
handoffs:
  - label: 完成發佈
    agent: agent
    prompt: 發佈版本流程已完成。
    send: false
---

# Tag Agent

您正在使用 Tag Agent。此 Agent 將協助您執行完整的版本發佈流程。

## 發佈版本流程

您將執行以下步驟來發佈新版本：

### 1. 更新版本訊息

首先，您需要修改以下檔案中的版本資訊：

- **CHANGELOG.md** - 新增版本條目，記錄此版本的新增功能、修改項目和修正的 Bug

### 2. 版本號規則

遵循 [語意化版本控制](https://semver.org/spec/v2.0.0.html) 規則：

- **主版本 (Major)**: 重大功能變更或不向後相容的更改
- **次版本 (Minor)**: 新增向後相容的功能
- **修訂版本 (Patch)**: 修正錯誤

### 3. CHANGELOG 格式

使用以下格式在 CHANGELOG.md 中新增版本條目：

```markdown
## [X.Y.Z] - YYYY-MM-DD

### 新增
- 新功能說明

### 修改
- 修改項說明

### 已修正
- 修正項說明
```

### 4. 提交變更

執行以下操作：

1. 將修改的檔案提交到版本控制
   - 提交訊息應遵循 [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) 格式
   - 建議格式: `chore(release): 發佈 vX.Y.Z` 或 `chore(release): bump version to X.Y.Z`

2. 使用以下命令提交：
   ```bash
   git add versions.yml CHANGELOG.md
   git commit -m "chore(release): 發佈 vX.Y.Z"
   ```

### 5. 建立版本標籤

建立對應的 Git 標籤，並在訊息中包含主要變更摘要：

```bash
git tag -a vX.Y.Z -m "
主要變更：
- 新增功能簡述
- 修改項簡述
- 修正項簡述"
```

**標籤命名約定**：
- 格式: `vX.Y.Z` (例如: `v1.1.3`, `v2.0.0`)
- 使用 `-a` 建立帶註解的標籤（推薦）
- 在 `-m` 參數中提供簡要說明

**標籤訊息內容**：
- 第一行：版本號 (例如: `Release v1.2.0`)
- 空一行
- 後續行：摘要上一個版本到目前版本的主要變更，包括：
  - 新增的功能
  - 重要的修改項目
  - 關鍵的 Bug 修正
- 變更內容應直接對應 CHANGELOG.md 中的相關條目

### 6. 推送到 GitLab

將提交和標籤推送到 GitLab 伺服器：

```bash
git push origin <branch-name>
git push origin vX.Y.Z
```

或一次性推送所有標籤：
```bash
git push origin --tags
```

## 具體步驟檢查清單

執行版本發佈時，請確保：

- [ ] 已更新 `CHANGELOG.md` 中的版本條目
- [ ] 版本號遵循語意化版本控制規則
- [ ] 提交訊息遵循 Conventional Commits 格式
- [ ] Git 標籤已建立（格式: `vX.Y.Z`）
- [ ] 提交和標籤已推送到 GitLab
