# Copilot 指令集使用指南

本指南說明如何使用和自訂 Copilot 指令集。

## 指令集架構

### 核心指令集

#### .github/copilot-instructions.md

主要開發規範，採用 Linus Torvalds 風格：

**核心原則：**
- **Simplicity First** - 函式短小、專注、易讀
- **Pragmatism** - 解決實際問題，避免理論化
- **No Special Cases** - 盡可能通用化特殊情況
- **No Temporary Code** - 移除臨時測試程式碼
- **No Unprompted Tests** - 不自動產生測試
- **Production Code** - 禁止 mock/stub/placeholder

**Shell 規範：**
- 預設使用 PowerShell
- 使用 `;` 串連指令（非 `&&`）
- Windows 路徑風格 (`.\path\file`)
- Linux 指令使用 `bash -c`

**範例：**
```powershell
# PowerShell
Get-ChildItem; Set-Location .\src

# Linux 指令
bash -c "ls -la ./src"
```

#### .github/copilot-chat-instructions.md

繁體中文技術詞彙對應表。

**主要功能：**
- 統一技術詞彙翻譯
- 提升中文技術文件品質
- 確保團隊溝通一致性

**常用對應：**
| 英文 | 繁體中文 |
|------|---------|
| Interface | 介面 |
| Repository | 儲存庫 |
| Dependency Injection | 依賴注入 |
| Middleware | 中介層 |
| Cache | 快取 |
| Thread | 執行緒 |
| Database | 資料庫 |

### 語言特定指令

#### .github/instructions/csharp.instructions.md

C# 開發規範。

**適用範圍：**
```yaml
applyTo: "**/*.cs"
```

**主要規範：**
- **編碼**：UTF-8（無 BOM）
- **縮排**：Tab（4 空格）
- **命名**：
  - 私有欄位：`_camelCase`
  - 公開屬性：`PascalCase`
  - 方法：`PascalCase`
  - 區域變數：`camelCase`

**最佳實務：**
- 避免魔術數字，使用常數
- 使用 `StringBuilder` 取代字串串接
- 優先使用 LINQ 而非迴圈
- 實作 `IDisposable` 的類別使用 `using`

#### .github/instructions/gitlab.instructions.md

GitLab MCP 工具指令。

**適用範圍：**
```yaml
applyTo: "**/*"
```

**主要功能：**
- 定義 GitLab API 工具使用規則
- Issue/MR 管理慣例
- 活動記錄查詢方式

## 相容性策略指令

### 選項 A：嚴格向後相容

**檔案：** `NeverBreakCompatibility.instructions.md`

**核心原則：**
1. **Backward compatibility is sacred** - 向後相容是神聖的
2. **Any breaking change is a bug** - 任何破壞性變更都是錯誤

**適用情境：**
- ✅ 穩定的生產環境
- ✅ 長期維護的專案
- ✅ 公開 API 或函式庫
- ✅ 企業級應用系統

**實務規範：**
- 新增功能時保持現有介面不變
- 使用 `[Obsolete]` 標記棄用功能
- 提供遷移指南和相容性層
- 版本號遵循 Semantic Versioning

**範例：**
```csharp
// ❌ 錯誤：直接修改現有方法簽名
public void ProcessData(string data, bool validate) { }

// ✅ 正確：保留舊方法，新增多載
public void ProcessData(string data) { }
public void ProcessData(string data, bool validate) { }

// ✅ 更好：使用選用參數保持相容
public void ProcessData(string data, bool validate = false) { }
```

### 選項 B：擁抱破壞性變更

**檔案：** `EmbraceBreakingChanges.instructions.md`

**核心原則：**
1. **Embrace Breaking Changes** - 擁抱破壞性變更
2. **Breaking changes are acceptable if they improve design** - 為了改善設計可接受破壞性變更

**適用情境：**
- ✅ 新專案或原型開發
- ✅ 快速迭代階段
- ✅ 內部工具或服務
- ✅ 重構或架構改善

**實務規範：**
- 優先考慮程式碼品質和設計
- 大膽重構不良設計
- 記錄所有破壞性變更
- 提供清晰的遷移指南

**範例：**
```csharp
// ✅ 可接受：重新設計 API 以改善使用體驗
// 舊設計（複雜且易錯）
public void SaveUser(string name, string email, int age, 
                    string address, string phone);

// 新設計（清晰且可擴展）
public void SaveUser(UserData userData);

// ✅ 可接受：簡化複雜的繼承結構
// 舊設計
public class BaseService { }
public class IntermediateService : BaseService { }
public class ConcreteService : IntermediateService { }

// 新設計
public class Service { }  // 扁平化結構
```

### 選擇策略指引

**使用「嚴格向後相容」當：**
- 專案已發佈且有外部使用者
- 需要長期穩定支援
- 修改成本高於維護成本
- 團隊偏好保守策略

**使用「擁抱破壞性變更」當：**
- 專案處於早期開發階段
- 內部使用，可控制影響範圍
- 現有設計存在嚴重問題
- 團隊偏好激進改善

⚠️ **重要：絕對不可同時使用兩種策略！**

## 指令集自訂

### 建立新的指令檔案

**步驟 1：建立檔案**

```powershell
New-Item .\.github\instructions\custom.instructions.md
```

**步驟 2：定義 YAML Frontmatter**

```markdown
---
applyTo: "**/*.js"
---

# JavaScript Coding Standards

## 核心規範

1. 使用 ES6+ 語法
2. 優先使用 `const`，需要時才用 `let`
3. 避免使用 `var`
```

**步驟 3：測試指令**

在專案中開啟 `.js` 檔案，使用 Copilot Chat 測試：

```
請說明這個專案的 JavaScript 編碼規範
```

### 修改現有指令

**範例：調整 C# 縮排規則**

編輯 `.github/instructions/csharp.instructions.md`：

```markdown
---
applyTo: "**/*.cs"
---

# C# Coding Standards

## 縮排規則

- 使用 4 個空格（原本是 Tab）
- 不使用 Tab 字元
```

### applyTo 模式

`applyTo` 使用 glob 模式匹配檔案：

| 模式 | 說明 | 範例 |
|------|------|------|
| `**/*.cs` | 所有 C# 檔案 | `src/User.cs`, `tests/UserTest.cs` |
| `src/**` | src 目錄下所有檔案 | `src/api/Auth.ts`, `src/ui/Button.tsx` |
| `**/*Test.cs` | 所有測試檔案 | `UserTest.cs`, `ServiceTest.cs` |
| `**/Controllers/*.cs` | Controllers 資料夾中的 C# 檔案 | `src/Controllers/UserController.cs` |

### 優先順序

當多個指令檔案套用到同一檔案時：

1. 更具體的 `applyTo` 模式優先
2. 後載入的指令覆蓋先載入的
3. 檔案特定指令 > 通用指令

**範例：**
```
.github/instructions/
├── global.instructions.md        (applyTo: "**/*")
├── csharp.instructions.md        (applyTo: "**/*.cs")
└── controllers.instructions.md   (applyTo: "**/Controllers/*.cs")

# 對於 src/Controllers/UserController.cs：
# 套用順序：controllers → csharp → global
```

## 團隊協作

### 共享指令集

**方法 1：Git Submodule**

```powershell
# 在團隊共用 repo 中維護指令集
git submodule add https://gitlab.com/your-team/copilot-instructions.git .github/shared

# 在專案中引用
# 符號連結或複製共用指令
```

**方法 2：專案範本**

```powershell
# 建立專案範本包含指令集
# 新專案從範本初始化
dotnet new install YourTeam.ProjectTemplate
dotnet new yourtemplate
```

### 版本控制

指令集應納入版本控制：

```gitignore
# 不要忽略指令檔案
!.github/copilot-instructions.md
!.github/instructions/*.instructions.md
```

### Code Review

在 MR/PR 中審查指令集變更：

- 確認變更符合團隊共識
- 評估對現有專案的影響
- 更新相關文件

## 最佳實務

### 1. 保持簡潔

指令應簡潔明確：

❌ 冗長：
```markdown
當你需要建立一個新的類別時，請確保你遵循以下所有規則，
包括但不限於命名規範、程式碼風格、註解格式等等...
```

✅ 簡潔：
```markdown
## 類別命名

- 使用 PascalCase
- 名稱應為名詞
- 避免縮寫
```

### 2. 提供範例

用範例說明規則：

```markdown
## 錯誤處理

使用 try-catch 包裝可能失敗的操作：

\`\`\`csharp
try
{
    var result = await _service.ProcessAsync(data);
    return Ok(result);
}
catch (ValidationException ex)
{
    return BadRequest(ex.Message);
}
\`\`\`
```

### 3. 避免衝突

不同指令檔案避免規則衝突：

❌ 衝突：
```markdown
# global.instructions.md
使用 Tab 縮排

# csharp.instructions.md
使用 4 空格縮排
```

✅ 一致：
```markdown
# global.instructions.md
（無縮排規則）

# csharp.instructions.md
使用 Tab 縮排（4 空格寬度）
```

### 4. 定期審查

定期審查和更新指令集：

- 每季審查一次
- 新成員加入時重新評估
- 技術棧變更時更新

## 疑難排解

### Copilot 未遵循指令

**可能原因：**
1. 指令檔案路徑錯誤
2. YAML frontmatter 格式錯誤
3. `applyTo` 模式不匹配

**解決方法：**
```powershell
# 檢查檔案位置
Get-ChildItem .\.github\instructions\

# 驗證 YAML 格式
# 使用線上 YAML validator

# 測試 applyTo 模式
# 確認檔案路徑符合 glob 模式
```

### 指令衝突

**症狀：** Copilot 行為不一致

**解決方法：**
1. 檢查多個指令檔案是否有衝突規則
2. 使用更具體的 `applyTo` 模式
3. 移除或合併衝突的指令

### VS Code 未載入指令

**解決方法：**
1. 確認檔案在 `.github/` 目錄下
2. 重新載入 VS Code 視窗
3. 檢查 Copilot 擴充功能狀態

## 相關資源

- [GitHub Copilot 文檔](https://docs.github.com/en/copilot)
- [VS Code Copilot 擴充功能](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
- [Glob 模式語法](https://github.com/isaacs/node-glob#glob-primer)
- [YAML 語法](https://yaml.org/)
- [快速開始](getting-started.md)
- [Agents 使用指南](agents/README.md)
