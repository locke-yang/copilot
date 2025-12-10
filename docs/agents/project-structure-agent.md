# Project Structure Agent 使用指南

Project Structure Agent 自動分析專案結構並生成規範化的 Copilot 指令檔案，確保整個開發團隊遵循一致的編碼規範和架構指引。

## 功能概述

該 Agent 提供以下功能：

- **自動分析專案結構** - 掃描並識別專案的資料夾層級
- **生成儲存庫級指令** - 描述整體專案架構和資料夾責任
- **生成資料夾級指令** - 為每個主要資料夾建立特定的編碼規範
- **智能推斷模式** - 從現有代碼推斷編碼慣例和設計模式
- **自動更新** - 檢測新資料夾並更新指令檔案

## 快速開始

### 基本用法

在 Copilot Chat 中輸入：

```
@project-structure
```

Agent 會自動：
1. 偵測儲存庫名稱
2. 掃描所有頂層資料夾
3. 分析每個資料夾的代碼模式
4. 生成指令檔案到 `.github/instructions/`

### 帶參數的用法

```
@project-structure
- 更新所有檔案：true
- 包含隱藏資料夾：false
- 詳細程度：detailed
```

## 指令檔案結構

### 1. 儲存庫級指令檔案

**位置：** `.github/instructions/<repository>.instructions.md`

**用途：** 描述整個專案的整體架構和各資料夾的角色

**特點：**
- 高層次的架構概述
- 資料夾組織說明
- 資料夾間的關係
- 英文撰寫
- 避免具體的代碼慣例

**內容結構：**

```markdown
---
applyTo: "**/*"
---

# [Repository Name] 專案架構

## 專案概述
[簡述專案的目的和主要功能]

## 資料夾結構

### src/
[此資料夾的責任和包含的內容]

### tests/
[此資料夾的責任和包含的內容]

### docs/
[此資料夾的責任和包含的內容]

## 資料夾間的關係
[描述資料夾如何相互作用和依賴]

## 核心原則
[描述整個專案遵循的核心原則]
```

**範例：**

```markdown
---
applyTo: "**/*"
---

# Copilot 專案架構

## 專案概述
Copilot 是一個 VS Code 擴充程式，提供 AI 輔助開發工具和 Agent 自動化框架。

## 資料夾結構

### .github/
配置檔案和工作流程定義
- agents/ - VS Code Agent 定義檔案
- instructions/ - Copilot 指令檔案
- workflows/ - GitHub Actions 工作流程

### docs/
項目文檔和指南
- agents/ - Agent 使用文檔
- guides/ - 使用指南
- api/ - API 參考文檔

### src/
主要源代碼（如果適用）

## 資料夾間的關係
- agents/ 定義 Agent 行為
- instructions/ 為每個資料夾提供編碼規範
- docs/ 提供用戶面向的文檔和指南

## 核心原則
1. Agent 檔案聚焦於 LLM 執行指令
2. 使用者文檔單獨維護
3. 指令檔案確保一致的編碼標準
```

### 2. 資料夾級指令檔案

**位置：** `.github/instructions/<folder-name>.instructions.md`

**用途：** 為該資料夾提供特定的編碼規範和慣例

**特點：**
- 僅適用於該資料夾內的代碼
- 包含具體的編碼規範
- 包含設計模式和架構指引
- 英文撰寫
- 不影響其他資料夾

**YAML Frontmatter：**

```yaml
---
applyTo: "<folder-name>/**"
---
```

**內容結構：**

```markdown
---
applyTo: "src/**"
---

# src/ 資料夾編碼規範

## 資料夾責任
[描述此資料夾的主要責任]

## 檔案組織
[描述檔案如何組織]

## 命名規範
- 檔案名稱：[規則]
- 類別/函數：[規則]
- 變數：[規則]

## 編碼風格
[描述該資料夾的編碼風格和慣例]

## 架構原則
[描述該資料夾遵循的設計模式]

## 模組依賴
[描述該資料夾與其他模組的關係]
```

**範例：**

```markdown
---
applyTo: "docs/agents/**"
---

# docs/agents/ 文檔規範

## 資料夾責任
提供 VS Code Agents 的使用文檔和指南。
每個 Agent 在 `.github/agents/` 有對應的定義檔，在此資料夾有詳細的使用指南。

## 檔案組織
- agent-name.md - 詳細使用指南
- README.md - Agents 總覽和快速導覽

## 命名規範
- 檔案名稱使用小寫和連字號：`agent-name.md`
- 檔案名稱應對應 `.github/agents/` 中的 Agent 定義

## 內容結構
每個 Agent 指南應包含：

1. 功能概述
   - 該 Agent 的主要功能
   - 適用場景

2. 快速開始
   - 基本用法
   - 帶參數的用法

3. 詳細說明
   - 功能詳解
   - 工作流程範例
   - 最佳實務

4. 故障排除
   - 常見問題
   - 解決方案

5. 相關資源
   - 連結到相關文檔
   - 相關 Agents

## 編寫風格
- 使用繁體中文編寫
- 清晰和簡潔的語言
- 包含代碼範例
- 使用結構化的標題層級
- 包含表格用於對比說明
```

## 工作流程範例

### 初始化新專案的指令檔案

#### 第 1 步：運行 Project Structure Agent

```
@project-structure
```

Agent 將：
1. 掃描專案結構
2. 偵測所有頂層資料夾
3. 分析現有的代碼模式
4. 生成指令檔案

#### 第 2 步：檢查生成的檔案

```
.github/instructions/
├── copilot.instructions.md          # 儲存庫級
├── src.instructions.md              # src/ 資料夾
├── docs.instructions.md             # docs/ 資料夾
├── tests.instructions.md            # tests/ 資料夾
└── ...
```

#### 第 3 步：編輯和優化

根據需要編輯生成的檔案：

- 調整描述以更準確反映實際情況
- 新增專案特定的規則
- 完善編碼慣例說明

### 新增資料夾時更新指令

#### 場景：新增 `scripts/` 資料夾

```
@project-structure
- 掃描新資料夾：scripts/
```

Agent 會：
1. 分析 `scripts/` 資料夾中的代碼
2. 生成 `scripts.instructions.md`
3. 更新 `copilot.instructions.md` 以包含新資料夾

### 重新生成所有指令

```
@project-structure
- 更新所有檔案：true
- 覆蓋現有檔案：true
```

使用此選項：
1. 重新掃描整個專案
2. 更新所有指令檔案
3. 提取最新的代碼模式

## 指令檔案最佳實務

### 1. 清晰的資料夾責任描述

✅ 好的描述：

```
### src/
包含應用的主要業務邏輯和功能實現。
- services/ - 業務邏輯服務
- models/ - 數據模型定義
- utils/ - 通用工具函數
```

❌ 不好的描述：

```
### src/
存放代碼
```

### 2. 具體的編碼規範

✅ 好的規範：

```markdown
## 命名規範
- 類別名稱：PascalCase（如 UserService）
- 方法名稱：camelCase（如 getUserById）
- 常數：UPPER_SNAKE_CASE（如 MAX_TIMEOUT）
- 檔案名稱：kebab-case（如 user-service.ts）
```

❌ 不具體的規範：

```markdown
## 命名規範
遵循標準命名慣例
```

### 3. 設計模式說明

清晰說明該資料夾遵循的設計模式：

```markdown
## 架構原則
- 分層架構：服務層、資料層分離
- 依賴注入：使用 IoC 容器管理依賴
- SOLID 原則：特別是單一責任和開閉原則
```

### 4. 檔案和資料夾組織

說明推薦的組織方式：

```markdown
## 檔案組織
每個功能模組應包含：
- module.ts - 模組定義
- module.service.ts - 業務邏輯
- module.controller.ts - 請求處理
- module.test.ts - 單元測試

不應有超過 20 個直接子檔案的資料夾
```

### 5. 跨資料夾依賴

說明該資料夾如何與其他資料夾互動：

```markdown
## 模組依賴
- 依賴 src/models/ 中的數據定義
- 依賴 src/utils/ 中的通用工具
- 被 src/controllers/ 調用
- 不應依賴 tests/ 或 docs/
```

### 6. 版本控制和歷史

在指令檔案末尾記錄最後更新時間：

```markdown
---

最後更新：2025-12-12
維護人：@team-lead
```

## 常見的資料夾指令

### TypeScript/JavaScript 項目

#### src.instructions.md

```markdown
---
applyTo: "src/**"
---

# src/ 編碼規範

## 資料夾責任
包含應用的主要源代碼和業務邏輯。

## 檔案組織
- components/ - React/Vue 組件
- services/ - 業務邏輯服務
- models/ - TypeScript 類型定義
- utils/ - 通用工具函數
- constants/ - 常數定義

## 命名規範
- 檔案：kebab-case (user-service.ts)
- 類別：PascalCase (UserService)
- 函數：camelCase (getUserById)
- 常數：UPPER_SNAKE_CASE (MAX_RETRY)

## 編碼風格
- 使用 TypeScript 進行類型安全
- 遵循 ESLint 配置
- 使用 Prettier 進行格式化
- 避免 any 類型，使用 unknown 或正確的類型

## 架構原則
- 分層架構：UI → Services → Models
- 依賴注入：使用建構函數注入
- 錯誤處理：使用自定義的 AppError 類別
```

### Python 項目

#### src.instructions.md

```markdown
---
applyTo: "src/**"
---

# src/ 編碼規範

## 資料夾責任
包含應用的主要 Python 代碼。

## 檔案組織
- api/ - API 端點定義
- services/ - 業務邏輯
- models/ - 數據模型
- utils/ - 通用工具

## 命名規範
- 模組：snake_case (user_service.py)
- 類別：PascalCase (UserService)
- 函數：snake_case (get_user_by_id)
- 常數：UPPER_SNAKE_CASE (MAX_TIMEOUT)

## 編碼風格
- 遵循 PEP 8 風格指南
- 使用 type hints 進行類型註解
- 使用 docstrings 記錄函數
- 目標 80 字符行長限制
```

### 文檔資料夾

#### docs.instructions.md

```markdown
---
applyTo: "docs/**"
---

# docs/ 文檔規範

## 資料夾責任
提供項目的使用文檔、API 參考和指南。

## 檔案組織
- guides/ - 使用指南
- api/ - API 參考
- architecture/ - 架構文檔

## 命名規範
- 檔案：kebab-case (getting-started.md)
- 標題：標準英文大寫

## 內容規範
- 使用英文編寫
- 包含目錄和交叉引用
- 包含代碼範例
- 定期更新版本信息

## 結構規範
每個文檔應包含：
1. 簡要概述
2. 目錄
3. 詳細內容
4. 相關連結
5. 最後更新時間
```

## 故障排除

### 指令檔案未生成

**原因：**
1. Project Structure Agent 未正確運行
2. 資料夾路徑不正確
3. 寫入權限不足

**解決方案：**
```
1. 確認 .github/instructions/ 目錄存在
2. 檢查目錄權限
3. 重新運行 Agent
```

### 生成的指令不準確

**原因：**
1. Agent 推斷的模式不正確
2. 代碼不遵循一致的模式
3. 需要手動調整

**解決方案：**
```
1. 編輯生成的檔案進行調整
2. 新增具體的規範和例外
3. 與團隊討論並達成共識
```

### 新資料夾沒有被掃描

**原因：**
1. Agent 只掃描頂層資料夾
2. 隱藏資料夾被忽略

**解決方案：**
```
1. 確認資料夾在頂層
2. 如需掃描隱藏資料夾，明確指定：
   @project-structure
   - 包含隱藏資料夾：true
```

## 配置和設定

### 在 settings.json 中啟用 Agent

```json
{
  "chat.agent.enabled": true
}
```

## 相關資源

- [Project Structure Agent 原始檔案](project-structure.agent.md)
- [Agent Generator 指南](agent-generator.md)
- [VS Code Agents 總覽](README.md)
- [.copilot-instructions.md 格式](../instructions-guide.md)

## 常見問題

**Q: 如何在多個資料夾應用相同的規範？**

A: 在 frontmatter 中使用 glob 模式：

```yaml
---
applyTo: "src/**"  # 應用於 src 及其所有子目錄
---
```

**Q: 能否為特定檔案設定特殊規範？**

A: 可以，使用更具體的路徑：

```yaml
---
applyTo: "src/components/**"  # 只應用於 components 資料夾
---
```

**Q: 如何處理嵌套的資料夾結構？**

A: 為每個重要的層級建立指令檔：

```
.github/instructions/
├── src.instructions.md              # src/
├── src-components.instructions.md  # src/components/
└── src-services.instructions.md    # src/services/
```

**Q: 多個指令檔案衝突時如何處理？**

A: 更具體的 applyTo 路徑優先級更高：

```
applyTo: "src/**"           # 較寬泛
applyTo: "src/components/**" # 優先級更高，優先應用
```

## 支援和反饋

如遇問題或有改進建議，請提交 Issue 或 Merge Request。

---

最後更新：2025-12-12
