# GitLab Agent 配置文件

本文件說明如何配置 `.gitlab-agent.json` 以優化 GitLab Copilot Agents（issue-agent、mr-create-agent、mr-review-agent）的使用體驗。

## 概述

`.gitlab-agent.json` 是專案級的配置檔案，用於定義 GitLab 專案的預設資訊、標籤規範、團隊成員、合併請求規則等。透過配置檔案，Agent 可以自動套用預設值，減少手動輸入，提升工作效率。

## 配置檔案位置

在專案根目錄建立 `.gitlab-agent.json`：

```
project-root/
├── .gitlab-agent.json          # GitLab Agent 配置檔案
├── .gitlab-agent.schema.json   # JSON Schema（可選，用於 IDE 自動完成）
├── .gitlab/
│   └── issue_templates/        # Issue 範本目錄（可選）
├── src/
└── ...
```

## 配置檔案結構

### 完整範例

```json
{
  "$schema": "./.gitlab-agent.schema.json",
  "version": "1.0",
  "gitlab": {
    "projectPath": "group/project-name",
    "instanceUrl": "https://gitlab.com",
    "branches": {
      "default": "develop",
      "protected": ["main", "develop"],
      "prefixes": {
        "feature": "feature/",
        "fix": "fix/",
        "hotfix": "hotfix/"
      }
    },
    "issue": {
      "labels": {
        "types": ["bug", "feature", "enhancement", "documentation", "question"],
        "priorities": {
          "critical": "priority::critical",
          "high": "priority::high",
          "medium": "priority::medium",
          "low": "priority::low"
        },
        "statuses": {
          "todo": "status::todo",
          "inProgress": "status::in-progress",
          "review": "status::review",
          "blocked": "status::blocked"
        },
        "areas": ["frontend", "backend", "database", "api", "ui/ux"]
      },
      "defaults": {
        "labels": ["status::todo"],
        "assignees": []
      },
      "templates": {
        "bug": ".gitlab/issue_templates/bug.md",
        "feature": ".gitlab/issue_templates/feature.md",
        "task": ".gitlab/issue_templates/task.md",
        "documentation": ".gitlab/issue_templates/documentation.md"
      }
    },
    "mergeRequest": {
      "defaults": {
        "targetBranch": "develop",
        "sourceBranchPrefix": "feature/",
        "labels": ["needs-review"],
        "reviewers": ["@alice", "@bob"],
        "deleteSourceBranch": true,
        "squash": false,
        "autoMerge": false
      },
      "rules": {
        "requireApprovals": 2,
        "requireDiscussionResolution": true
      }
    },
    "milestones": {
      "active": ["v1.0.0", "v1.1.0", "v2.0.0"],
      "defaultMilestone": "v1.1.0"
    },
    "team": {
      "members": [
        {
          "username": "alice",
          "name": "Alice",
          "roles": ["developer", "reviewer"]
        },
        {
          "username": "bob",
          "name": "Bob",
          "roles": ["reviewer", "maintainer"]
        }
      ],
      "groups": {
        "frontend": ["@alice"],
        "backend": ["@bob"]
      }
    }
  }
}
```

## 配置項目說明

### 1. 基本資訊

#### `version`（必要）
- **類型**: `string`
- **說明**: 配置檔案版本，目前為 `"1.0"`

#### `gitlab.projectPath`（必要）
- **類型**: `string`
- **格式**: `group/project-name`
- **說明**: GitLab 專案路徑，用於識別專案
- **範例**: `"my-org/my-project"`

#### `gitlab.instanceUrl`（可選）
- **類型**: `string`
- **預設**: `"https://gitlab.com"`
- **說明**: GitLab 實例 URL，私有部署時需指定
- **範例**: `"https://gitlab.example.com"`

### 2. 分支管理 (`gitlab.branches`)

#### `default`
- **類型**: `string`
- **說明**: 預設分支名稱（通常是主開發分支）
- **範例**: `"develop"`, `"main"`, `"master"`

#### `protected`
- **類型**: `array<string>`
- **說明**: 受保護的分支列表，不應直接推送
- **範例**: `["main", "develop"]`

#### `prefixes`
- **類型**: `object`
- **說明**: 分支命名前綴規範
- **範例**:
  ```json
  {
    "feature": "feature/",
    "fix": "fix/",
    "hotfix": "hotfix/"
  }
  ```

### 3. Issue 配置 (`gitlab.issue`)

#### `labels`
定義專案使用的標籤分類：

- **`types`**: Issue 類型標籤
  - 範例: `["bug", "feature", "enhancement", "documentation"]`

- **`priorities`**: 優先級標籤映射
  - 範例:
    ```json
    {
      "critical": "priority::critical",
      "high": "priority::high",
      "medium": "priority::medium",
      "low": "priority::low"
    }
    ```

- **`statuses`**: 狀態標籤映射
  - 範例:
    ```json
    {
      "todo": "status::todo",
      "inProgress": "status::in-progress",
      "review": "status::review",
      "blocked": "status::blocked"
    }
    ```

- **`areas`**: 領域/模組標籤
  - 範例: `["frontend", "backend", "database", "api", "ui/ux"]`

#### `defaults`
新建 Issue 時的預設值：

- **`labels`**: 預設標籤
  - 範例: `["status::todo"]`

- **`assignees`**: 預設 assignee（通常留空，讓使用者選擇）
  - 範例: `[]` 或 `["@alice"]`

#### `templates`
Issue 範本檔案路徑：

```json
{
  "bug": ".gitlab/issue_templates/bug.md",
  "feature": ".gitlab/issue_templates/feature.md",
  "task": ".gitlab/issue_templates/task.md",
  "documentation": ".gitlab/issue_templates/documentation.md"
}
```

### 4. Merge Request 配置 (`gitlab.mergeRequest`)

#### `defaults`
新建 MR 時的預設值：

- **`targetBranch`**: 預設目標分支
  - 範例: `"develop"`

- **`sourceBranchPrefix`**: 來源分支前綴
  - 範例: `"feature/"`

- **`labels`**: 預設標籤
  - 範例: `["needs-review"]`

- **`reviewers`**: 預設 reviewer
  - 範例: `["@alice", "@bob"]`

- **`deleteSourceBranch`**: 合併後刪除來源分支
  - 類型: `boolean`
  - 預設: `true`

- **`squash`**: 合併時壓縮 commits
  - 類型: `boolean`
  - 預設: `false`

- **`autoMerge`**: Pipeline 成功後自動合併
  - 類型: `boolean`
  - 預設: `false`

#### `rules`
MR 審查規則：

- **`requireApprovals`**: 需要的 approval 數量
  - 類型: `integer`
  - 範例: `2`

- **`requireDiscussionResolution`**: 合併前須解決所有討論
  - 類型: `boolean`
  - 範例: `true`

### 5. Milestones (`gitlab.milestones`)

#### `active`
- **類型**: `array<string>`
- **說明**: 當前活躍的 milestone 清單
- **範例**: `["v1.0.0", "v1.1.0", "v2.0.0"]`

#### `defaultMilestone`
- **類型**: `string | null`
- **說明**: 預設 milestone（可選）
- **範例**: `"v1.1.0"` 或 `null`

### 6. 團隊管理 (`gitlab.team`)

#### `members`
團隊成員清單，用於 assignee 和 reviewer 建議：

```json
{
  "members": [
    {
      "username": "alice",
      "name": "Alice",
      "roles": ["developer", "reviewer"]
    },
    {
      "username": "bob",
      "name": "Bob",
      "roles": ["reviewer", "maintainer"]
    }
  ]
}
```

- **`username`** (必要): GitLab 使用者名稱
- **`name`** (可選): 顯示名稱
- **`roles`** (可選): 角色列表
  - 可選值: `"developer"`, `"reviewer"`, `"maintainer"`, `"owner"`

#### `groups`
團隊分組，用於按領域分配任務：

```json
{
  "groups": {
    "frontend": ["@alice", "@charlie"],
    "backend": ["@bob", "@david"],
    "devops": ["@eve"]
  }
}
```

## Agent 配置讀取流程

各 Agent 啟動時會依照以下優先順序取得專案資訊：

### 階層式配置讀取

```
1. 讀取專案根目錄的 `.gitlab-agent.json`
   ✓ 成功 → 載入所有預設值
   ✗ 失敗 → 繼續步驟 2

2. 執行 `git remote -v` 解析專案路徑
   ✓ 成功 → 設定 projectPath 和 instanceUrl
   ✗ 失敗 → 繼續步驟 3

3. 檢查 `.vscode/settings.json` 中的 `copilot.gitlab`
   ✓ 成功 → 載入配置
   ✗ 失敗 → 繼續步驟 4

4. 互動式詢問必要資訊
   - 詢問：projectPath, targetBranch
   - 可選：儲存為 `.gitlab-agent.json` 供下次使用
```

### Git Remote 自動偵測

當無 `.gitlab-agent.json` 時，Agent 會嘗試解析 Git Remote URL：

```bash
$ git remote -v
origin  git@gitlab.com:group/project-name.git (fetch)
origin  git@gitlab.com:group/project-name.git (push)
```

自動解析出：
- **GitLab instance**: `gitlab.com`
- **Project path**: `group/project-name`

支援的 URL 格式：
- SSH: `git@gitlab.com:group/project.git`
- HTTPS: `https://gitlab.com/group/project.git`

## 最佳實踐

### 1. 版本控制

✅ **建議**: 將 `.gitlab-agent.json` 加入版本控制
```bash
git add .gitlab-agent.json .gitlab-agent.schema.json
git commit -m "chore: add GitLab Agent configuration"
```

這樣團隊成員可以共享相同的配置。

❌ **避免**: 將 GitLab Token 放入配置檔案
Token 應存放在 MCP 設定中，不應 commit 到版本控制。

### 2. Label 命名規範

建議使用**命名空間**格式：

```json
{
  "priorities": {
    "critical": "priority::critical",
    "high": "priority::high"
  },
  "statuses": {
    "todo": "status::todo",
    "inProgress": "status::in-progress"
  }
}
```

優點：
- 易於識別和分類
- 避免命名衝突
- 支援 GitLab Scoped Labels

### 3. 分支策略

根據團隊工作流程選擇：

#### Git Flow 風格
```json
{
  "branches": {
    "default": "develop",
    "protected": ["main", "develop"],
    "prefixes": {
      "feature": "feature/",
      "fix": "fix/",
      "hotfix": "hotfix/",
      "release": "release/"
    }
  },
  "mergeRequest": {
    "defaults": {
      "targetBranch": "develop"
    }
  }
}
```

#### Trunk-Based 風格
```json
{
  "branches": {
    "default": "main",
    "protected": ["main"],
    "prefixes": {
      "feature": "",
      "fix": "fix-"
    }
  },
  "mergeRequest": {
    "defaults": {
      "targetBranch": "main",
      "squash": true
    }
  }
}
```

### 4. 團隊規模考量

#### 小型團隊（<5人）
```json
{
  "mergeRequest": {
    "defaults": {
      "reviewers": ["@alice", "@bob"],
      "deleteSourceBranch": true
    },
    "rules": {
      "requireApprovals": 1,
      "requireDiscussionResolution": false
    }
  }
}
```

#### 大型團隊（>10人）
```json
{
  "mergeRequest": {
    "defaults": {
      "reviewers": [],  // 由 Agent 根據變更內容建議
      "deleteSourceBranch": true,
      "squash": true
    },
    "rules": {
      "requireApprovals": 2,
      "requireDiscussionResolution": true
    }
  },
  "team": {
    "groups": {
      "frontend": ["@alice", "@charlie"],
      "backend": ["@bob", "@david"],
      "mobile": ["@eve", "@frank"]
    }
  }
}
```

### 5. Milestone 管理

#### 按版本管理
```json
{
  "milestones": {
    "active": ["v1.0.0", "v1.1.0", "v2.0.0"],
    "defaultMilestone": "v1.1.0"
  }
}
```

#### 按時間管理
```json
{
  "milestones": {
    "active": ["2025-Q1", "2025-Q2"],
    "defaultMilestone": "2025-Q1"
  }
}
```

#### 按 Sprint 管理
```json
{
  "milestones": {
    "active": ["Sprint 10", "Sprint 11", "Sprint 12"],
    "defaultMilestone": "Sprint 11"
  }
}
```

### 6. Issue 範本

建立 `.gitlab/issue_templates/` 目錄並加入範本檔案：

**`.gitlab/issue_templates/bug.md`**:
```markdown
## 問題描述
[簡要描述遇到的問題]

## 重現步驟
1. 
2. 
3. 

## 預期行為
[描述預期應該發生什麼]

## 實際行為
[描述實際發生了什麼]

## 環境資訊
- OS: 
- Browser: 
- Version: 

## 錯誤訊息/截圖
[貼上錯誤訊息或上傳截圖]
```

然後在配置中引用：
```json
{
  "issue": {
    "templates": {
      "bug": ".gitlab/issue_templates/bug.md"
    }
  }
}
```

## 配置範例

### 範例 1: 開源專案

```json
{
  "version": "1.0",
  "gitlab": {
    "projectPath": "opensource/awesome-project",
    "instanceUrl": "https://gitlab.com",
    "branches": {
      "default": "main",
      "protected": ["main"],
      "prefixes": {
        "feature": "feature/",
        "fix": "fix/"
      }
    },
    "issue": {
      "labels": {
        "types": ["bug", "feature", "documentation", "question"],
        "priorities": {
          "high": "priority::high",
          "medium": "priority::medium",
          "low": "priority::low"
        }
      },
      "defaults": {
        "labels": []
      }
    },
    "mergeRequest": {
      "defaults": {
        "targetBranch": "main",
        "labels": ["needs-review"],
        "reviewers": [],
        "deleteSourceBranch": true,
        "squash": false
      },
      "rules": {
        "requireApprovals": 2,
        "requireDiscussionResolution": true
      }
    }
  }
}
```

### 範例 2: 企業專案

```json
{
  "version": "1.0",
  "gitlab": {
    "projectPath": "company/internal-app",
    "instanceUrl": "https://gitlab.company.com",
    "branches": {
      "default": "develop",
      "protected": ["main", "develop", "staging"],
      "prefixes": {
        "feature": "feature/",
        "fix": "fix/",
        "hotfix": "hotfix/"
      }
    },
    "issue": {
      "labels": {
        "types": ["bug", "feature", "enhancement", "documentation", "task"],
        "priorities": {
          "critical": "priority::critical",
          "high": "priority::high",
          "medium": "priority::medium",
          "low": "priority::low"
        },
        "statuses": {
          "todo": "status::todo",
          "inProgress": "status::in-progress",
          "review": "status::review",
          "blocked": "status::blocked",
          "done": "status::done"
        },
        "areas": ["frontend", "backend", "database", "api", "infrastructure", "security"]
      },
      "defaults": {
        "labels": ["status::todo", "needs-triage"]
      }
    },
    "mergeRequest": {
      "defaults": {
        "targetBranch": "develop",
        "sourceBranchPrefix": "feature/",
        "labels": ["needs-review"],
        "reviewers": ["@tech-lead"],
        "deleteSourceBranch": true,
        "squash": true,
        "autoMerge": false
      },
      "rules": {
        "requireApprovals": 2,
        "requireDiscussionResolution": true
      }
    },
    "milestones": {
      "active": ["2025-Q1", "2025-Q2"],
      "defaultMilestone": "2025-Q1"
    },
    "team": {
      "members": [
        {"username": "alice", "name": "Alice Chen", "roles": ["developer", "frontend"]},
        {"username": "bob", "name": "Bob Wang", "roles": ["developer", "backend"]},
        {"username": "charlie", "name": "Charlie Lin", "roles": ["reviewer", "tech-lead"]},
        {"username": "david", "name": "David Liu", "roles": ["maintainer", "devops"]}
      ],
      "groups": {
        "frontend": ["@alice"],
        "backend": ["@bob"],
        "devops": ["@david"],
        "reviewers": ["@charlie", "@david"]
      }
    }
  }
}
```

### 範例 3: 最小化配置

只包含必要資訊的最簡配置：

```json
{
  "version": "1.0",
  "gitlab": {
    "projectPath": "group/project-name",
    "mergeRequest": {
      "defaults": {
        "targetBranch": "main"
      }
    }
  }
}
```

Agent 會使用預設值或互動詢問其他資訊。

## 故障排除

### 問題 1: Agent 無法讀取配置檔案

**症狀**: Agent 每次都詢問專案資訊

**解決方法**:
1. 確認檔案名稱為 `.gitlab-agent.json`（注意開頭的點）
2. 確認檔案位於專案根目錄
3. 檢查 JSON 格式是否正確（使用 JSON validator）
4. 確認 `projectPath` 格式正確（`group/project-name`）

### 問題 2: JSON Schema 警告

**症狀**: IDE 顯示 schema 載入錯誤

**解決方法**:
1. 確保 `.gitlab-agent.schema.json` 也在專案根目錄
2. 或使用線上 schema URL：
   ```json
   {
     "$schema": "https://raw.githubusercontent.com/.../gitlab-agent.schema.json"
   }
   ```

### 問題 3: Labels 不符合預期

**症狀**: Agent 建議的 labels 與配置不同

**解決方法**:
1. 確認 GitLab 專案中已建立對應的 labels
2. 使用 GitLab API 或 UI 建立缺少的 labels
3. 確保 label 名稱完全一致（區分大小寫）

### 問題 4: Git Remote 偵測失敗

**症狀**: 無 `.gitlab-agent.json` 時 Agent 無法自動偵測專案

**解決方法**:
1. 確認專案是 Git 儲存庫：`git status`
2. 確認已設定 remote：`git remote -v`
3. 確認 remote URL 格式正確（GitLab URL）
4. 手動建立 `.gitlab-agent.json` 配置檔案

## VS Code Workspace 設定（可選）

如果不想使用 `.gitlab-agent.json`，也可以在 `.vscode/settings.json` 中配置：

```json
{
  "copilot.gitlab": {
    "projectPath": "group/project-name",
    "instanceUrl": "https://gitlab.com",
    "defaultBranch": "develop",
    "defaultLabels": ["needs-review"],
    "defaultReviewers": ["@alice", "@bob"]
  }
}
```

**注意**: 此方式功能較有限，建議使用 `.gitlab-agent.json` 獲得完整功能。

## 相關資源

- [issue-agent 文件](./issue-agent.md)
- [mr-create-agent 文件](./mr-create-agent.md)
- [mr-review-agent 文件](./mr-review-agent.md)
- [GitLab API 文件](https://docs.gitlab.com/ee/api/)
- [GitLab Labels 文件](https://docs.gitlab.com/ee/user/project/labels.html)
- [GitLab Workflow 文件](https://docs.gitlab.com/ee/topics/gitlab_flow.html)

## 總結

`.gitlab-agent.json` 配置檔案可以大幅提升 GitLab Agents 的使用體驗：

✅ **自動偵測專案資訊**，無需每次手動輸入
✅ **統一團隊規範**，確保 Issue 和 MR 的一致性
✅ **提供智慧建議**，根據專案配置建議 labels、reviewers 等
✅ **提升工作效率**，減少重複性操作

根據專案規模和團隊需求，選擇適合的配置深度，從最簡化到完整配置都可以運作良好。
