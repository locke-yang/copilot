# MCP (Model Context Protocol) 整合

## 什麼是 MCP？

Model Context Protocol (MCP) 是一個標準化協議，讓 GitHub Copilot 能夠與外部工具和資料來源整合。透過 MCP，Copilot 可以存取：

- GitLab API
- 資料庫系統
- 檔案系統工具
- 自訂 API 服務

## GitLab MCP 設定

本專案主要使用 GitLab MCP 整合，讓 Copilot Agents 能夠直接操作 GitLab。

### 前置要求

1. **GitLab Personal Access Token**
   - 登入 GitLab
   - 進入設定 → Access Tokens
   - 建立新的 token，勾選以下範圍：
     - `api` - 完整 API 存取
     - `read_api` - 唯讀 API 存取
   - 複製 token（只會顯示一次）

2. **Node.js 環境**
   - MCP 伺服器透過 `npx` 執行
   - 確保已安裝 Node.js 14 或更高版本

### 設定方式

有兩種設定方式：專案層級或全域層級（VS Code Profiles）。

## 選項 A：專案層級設定

在專案根目錄建立 `mcp.json` 檔案：

```jsonc
{
  "servers": {
    "gitlab": {
      "command": "npx",
      "args": ["-y", "@zereight/mcp-gitlab"],
      "env": {
        "GITLAB_API_URL": "http://git.tp.wanin.tw/api/v4",
        "GITLAB_PERSONAL_ACCESS_TOKEN": "glpat-xxxxxxxxxxxx",
        "GITLAB_ALLOWED_PROJECT_IDS": "",
        "GITLAB_READ_ONLY_MODE": "true"
      }
    }
  }
}
```

### 環境變數說明

| 變數 | 說明 | 範例 |
|------|------|------|
| `GITLAB_API_URL` | GitLab API 端點 | `http://git.tp.wanin.tw/api/v4` |
| `GITLAB_PERSONAL_ACCESS_TOKEN` | Personal Access Token | `glpat-xxxxxxxxxxxx` |
| `GITLAB_ALLOWED_PROJECT_IDS` | 允許存取的專案 ID（空白表示全部） | `123,456,789` |
| `GITLAB_READ_ONLY_MODE` | 唯讀模式 | `true` 或 `false` |

### READ_ONLY_MODE 設定

根據使用的 Agent 功能選擇適當的模式：

**READ_ONLY_MODE: true**（唯讀）
- ✅ Work Summary Agent - 產生工作摘要
- ✅ 查詢 Issues
- ✅ 查詢 Merge Requests
- ✅ 查看 Commits
- ❌ 建立 Issues
- ❌ 建立 Merge Requests
- ❌ 修改專案內容

**READ_ONLY_MODE: false**（讀寫）
- ✅ 所有唯讀功能
- ✅ Issue Agent - 建立和管理 Issues
- ✅ Merge Request Agent - 建立和管理 MRs
- ✅ Release Agent - 發佈 Releases

⚠️ **安全建議**：
- 開發環境使用 `READ_ONLY_MODE: false`
- CI/CD 環境使用 `READ_ONLY_MODE: true`
- 定期輪換 Personal Access Token

## 選項 B：VS Code Profiles 全域設定

VS Code Profiles 允許建立獨立的開發環境設定，適合需要在多個專案間共用 MCP 設定的情況。

### 什麼是 VS Code Profiles？

VS Code Profiles 是一個功能，讓您可以：
- 為不同的工作環境建立獨立設定
- 在專案間快速切換配置
- 分享完整的開發環境設定

詳見 [VS Code Profiles 文檔](https://code.visualstudio.com/docs/configure/profiles)

### 建立 GitLab MCP Profile

**步驟 1：建立新 Profile**

1. 點擊 VS Code 左下角頭像圖標
2. 選擇「建立新 Profile」或「Create Profile」
3. 設定 Profile 名稱（例如：`GitLab MCP`）
4. 選擇要包含的設定項目

**步驟 2：配置 MCP 設定**

1. 在新 Profile 中開啟設定
2. 搜尋 `copilot`
3. 設定 MCP 伺服器位置和環境變數

**步驟 3：使用 Profile**

切換 Profile：
- 點擊左下角頭像圖標
- 選擇 `GitLab MCP` Profile
- MCP 設定自動套用

### Profile 使用情境

**情境 1：多個 GitLab 伺服器**

建立不同的 Profile 連接不同的 GitLab 實例：

- `GitLab MCP (Production)` - 連接正式環境
- `GitLab MCP (Staging)` - 連接測試環境
- `GitLab MCP (Dev)` - 連接開發環境

**情境 2：不同的權限等級**

- `GitLab MCP (Read-Only)` - 唯讀模式
- `GitLab MCP (Full Access)` - 完整權限

**情境 3：團隊共享**

匯出 Profile 給團隊成員：
1. 開啟 Profile 設定
2. 選擇「Export Profile」
3. 分享設定檔案給團隊

## 驗證 MCP 設定

### 測試連線

在 Copilot Chat 中測試 GitLab MCP 是否正常運作：

```
使用 GitLab 工具列出我的所有專案
```

如果設定正確，Copilot 會透過 MCP 查詢並顯示專案列表。

### 檢查可用工具

查詢 GitLab MCP 提供的工具：

```
顯示所有可用的 GitLab API 工具
```

應該會看到類似以下的工具列表：
- `mcp_gitlab_list_projects`
- `mcp_gitlab_list_issues`
- `mcp_gitlab_list_merge_requests`
- `mcp_gitlab_get_project_events`
- 等等...

### 測試 Agent 功能

測試各個需要 GitLab MCP 的 Agent：

```
@work-summary 產生今天的工作摘要
@issue 列出所有 open 的 Issues
```

## 常見問題

### Q: mcp.json 放在哪裡？

A: 可以放在：
- 專案根目錄（專案特定設定）
- VS Code Profile（全域設定）

### Q: 如何更新 Personal Access Token？

A: 
1. 在 GitLab 產生新的 token
2. 更新 `mcp.json` 中的 `GITLAB_PERSONAL_ACCESS_TOKEN`
3. 重新載入 VS Code 視窗

### Q: 可以同時設定多個 MCP 伺服器嗎？

A: 可以，在 `mcp.json` 的 `servers` 中新增多個伺服器：

```jsonc
{
  "servers": {
    "gitlab": {
      "command": "npx",
      "args": ["-y", "@zereight/mcp-gitlab"],
      "env": { ... }
    },
    "another-service": {
      "command": "npx",
      "args": ["-y", "@some/mcp-server"],
      "env": { ... }
    }
  }
}
```

### Q: READ_ONLY_MODE 如何影響功能？

A: 
- `true` - 只能查詢資料，無法建立或修改
- `false` - 可以完整操作（建立、修改、刪除）

### Q: GITLAB_ALLOWED_PROJECT_IDS 要如何設定？

A:
- 留空 `""` - 允許存取所有專案
- 單一專案 `"123"` - 只允許專案 123
- 多個專案 `"123,456,789"` - 允許多個專案

專案 ID 可在 GitLab 專案頁面找到。

## 疑難排解

### MCP 伺服器無法啟動

**症狀**：Copilot 無法使用 GitLab 工具

**解決方法**：
1. 檢查 Node.js 是否已安裝：
   ```powershell
   node --version
   ```

2. 手動安裝 MCP 伺服器：
   ```powershell
   npx -y @zereight/mcp-gitlab
   ```

3. 檢查 `mcp.json` 格式是否正確（使用 JSON validator）

### Personal Access Token 無效

**症狀**：出現 401 Unauthorized 錯誤

**解決方法**：
1. 確認 token 沒有過期
2. 檢查 token 權限包含 `api` 或 `read_api`
3. 在 GitLab 重新產生新的 token

### 無法存取特定專案

**症狀**：某些專案無法查詢

**解決方法**：
1. 確認 token 所屬帳號有專案存取權限
2. 檢查 `GITLAB_ALLOWED_PROJECT_IDS` 設定
3. 確認專案 ID 正確

### VS Code 沒有載入 mcp.json

**症狀**：MCP 工具不可用

**解決方法**：
1. 確認 `mcp.json` 在專案根目錄
2. 重新載入 VS Code 視窗（`Ctrl+Shift+P` → `Reload Window`）
3. 檢查 VS Code 輸出面板的錯誤訊息

## 安全最佳實務

### 1. 保護 Personal Access Token

❌ **不要做：**
- 將 token 提交到 Git
- 在公開場合分享 token
- 使用過長的 token 有效期限

✅ **應該做：**
- 使用環境變數
- 將 `mcp.json` 加入 `.gitignore`
- 定期輪換 token
- 使用最小權限原則

### 2. 使用 .gitignore

將 `mcp.json` 加入 `.gitignore`：

```gitignore
# MCP 設定（包含敏感資訊）
mcp.json
```

提供範例檔案：

```powershell
# 建立範例檔案
Copy-Item mcp.json mcp.json.example

# 編輯 mcp.json.example，移除敏感資訊
code mcp.json.example
```

### 3. 環境變數方案

使用環境變數儲存敏感資訊：

```jsonc
{
  "servers": {
    "gitlab": {
      "command": "npx",
      "args": ["-y", "@zereight/mcp-gitlab"],
      "env": {
        "GITLAB_API_URL": "${GITLAB_API_URL}",
        "GITLAB_PERSONAL_ACCESS_TOKEN": "${GITLAB_TOKEN}",
        "GITLAB_ALLOWED_PROJECT_IDS": "",
        "GITLAB_READ_ONLY_MODE": "true"
      }
    }
  }
}
```

設定環境變數：

```powershell
# Windows PowerShell
$env:GITLAB_API_URL = "http://git.tp.wanin.tw/api/v4"
$env:GITLAB_TOKEN = "glpat-xxxxxxxxxxxx"
```

## 進階設定

### 自訂 MCP 伺服器

如需建立自訂 MCP 伺服器：

1. 參考 MCP SDK 文件
2. 實作自訂工具
3. 在 `mcp.json` 中設定

### 多環境設定

使用不同的設定檔案：

```powershell
# 開發環境
Copy-Item mcp.dev.json mcp.json

# 正式環境
Copy-Item mcp.prod.json mcp.json
```

### 偵錯 MCP 伺服器

啟用偵錯模式查看詳細日誌：

```jsonc
{
  "servers": {
    "gitlab": {
      "command": "npx",
      "args": ["-y", "@zereight/mcp-gitlab"],
      "env": {
        ...
        "DEBUG": "*"
      }
    }
  }
}
```

## 相關資源

- [Model Context Protocol 規範](https://modelcontextprotocol.io/)
- [GitLab MCP 伺服器](https://www.npmjs.com/package/@zereight/mcp-gitlab)
- [VS Code Profiles 文檔](https://code.visualstudio.com/docs/configure/profiles)
- [GitLab API 文檔](https://docs.gitlab.com/ee/api/)
- [Agents 使用指南](agents/README.md)
- [快速開始](getting-started.md)
