# 相容性策略指南

本指南說明兩種相容性策略的差異、使用時機和實作方式。

## 策略概述

專案提供兩種相反的相容性策略，**只能選擇其中一個**：

### 策略 A：嚴格向後相容

**檔案：** `.github/instructions/NeverBreakCompatibility.instructions.md`

**核心理念：** Backward compatibility is sacred（向後相容是神聖的）

### 策略 B：擁抱破壞性變更

**檔案：** `.github/instructions/EmbraceBreakingChanges.instructions.md`

**核心理念：** Embrace Breaking Changes（擁抱破壞性變更）

⚠️ **警告：這兩個檔案絕對不可同時存在於專案中！**

## 策略 A：嚴格向後相容

### 核心原則

1. **向後相容是神聖的** - 任何破壞現有行為的變更都是錯誤
2. **保護使用者** - 現有程式碼應該在升級後繼續運作
3. **漸進棄用** - 使用 deprecation 機制逐步淘汰舊功能

### 適用情境

**✅ 應該使用：**
- 穩定的生產環境
- 已發佈的公開 API
- 函式庫或框架專案
- 長期維護的企業系統
- 有外部依賴者的專案

**❌ 不適合使用：**
- 原型或概念驗證專案
- 內部實驗性工具
- 早期開發階段（< v1.0）
- 需要大幅重構的專案

### 實務規範

#### 1. API 設計

**新增功能：**
```csharp
// ✅ 正確：保留現有方法，新增多載
public class UserService
{
    // 現有方法（保持不變）
    public User GetUser(int id) { }
    
    // 新方法（多載）
    public User GetUser(int id, bool includeDetails) { }
}
```

**棄用功能：**
```csharp
// ✅ 正確：標記為 Obsolete，提供替代方案
[Obsolete("Use GetUserAsync instead. This method will be removed in v3.0")]
public User GetUser(int id) { }

public async Task<User> GetUserAsync(int id) { }
```

#### 2. 資料結構變更

**新增欄位：**
```csharp
// ✅ 正確：新欄位使用預設值或選用
public class UserData
{
    public string Name { get; set; }
    public string Email { get; set; }
    
    // 新欄位（選用）
    public string? Phone { get; set; }
}
```

**修改欄位：**
```csharp
// ❌ 錯誤：直接修改欄位類型
public class Config
{
    public int Timeout { get; set; }  // 從 int 改為 TimeSpan
}

// ✅ 正確：保留舊欄位，新增新欄位
public class Config
{
    [Obsolete("Use TimeoutDuration instead")]
    public int Timeout { get; set; }
    
    public TimeSpan TimeoutDuration { get; set; }
}
```

#### 3. 設定檔變更

**修改設定格式：**
```jsonc
// ❌ 錯誤：直接改變設定結構
// 舊格式
{ "timeout": 30 }

// 新格式（破壞相容性）
{ "timeoutSeconds": 30 }

// ✅ 正確：支援兩種格式
{
  "timeout": 30,        // 舊格式（deprecated）
  "timeoutSeconds": 30  // 新格式
}
```

#### 4. 錯誤處理

**修改例外類型：**
```csharp
// ❌ 錯誤：改變例外類型
public void ProcessData(string data)
{
    // 原本拋出 ArgumentException
    // 現在拋出 ValidationException（破壞相容性）
    throw new ValidationException("Invalid data");
}

// ✅ 正確：保持例外類型或向上相容
public void ProcessData(string data)
{
    // 繼續拋出 ArgumentException
    // 或使用繼承鏈讓新例外繼承舊例外
    throw new ArgumentException("Invalid data");
}
```

### 版本管理

遵循 [Semantic Versioning](https://semver.org/)：

- **Major (X.0.0)** - 允許破壞性變更（經過充分規劃）
- **Minor (0.X.0)** - 新增功能，保持相容
- **Patch (0.0.X)** - 錯誤修正，保持相容

**範例：**
```
v1.2.3 → v1.2.4  ✅ Bug fix，完全相容
v1.2.4 → v1.3.0  ✅ 新增功能，保持相容
v1.3.0 → v2.0.0  ⚠️  Major 版本，可能包含破壞性變更
```

### 遷移策略

**提供遷移路徑：**

1. **文件化變更**
```markdown
# Migration Guide v1 → v2

## Breaking Changes

### GetUser 方法簽名變更

**Before (v1):**
\`\`\`csharp
User GetUser(int id)
\`\`\`

**After (v2):**
\`\`\`csharp
Task<User> GetUserAsync(int id)
\`\`\`

**Migration:**
\`\`\`csharp
// 舊程式碼
var user = service.GetUser(123);

// 新程式碼
var user = await service.GetUserAsync(123);
\`\`\`
```

2. **提供相容性層**
```csharp
// 保留舊方法，內部呼叫新方法
[Obsolete("Use GetUserAsync")]
public User GetUser(int id)
{
    return GetUserAsync(id).GetAwaiter().GetResult();
}
```

### 最佳實務

1. **長期支援計劃** - 明確版本支援期限
2. **棄用警告** - 提前多個版本警告
3. **充分測試** - 確保升級不破壞現有功能
4. **詳細文件** - 記錄所有變更和遷移步驟

---

## 策略 B：擁抱破壞性變更

### 核心原則

1. **設計優先** - 好的設計比相容性更重要
2. **快速迭代** - 不被歷史包袱限制
3. **持續改善** - 勇於重構不良設計

### 適用情境

**✅ 應該使用：**
- 新專案（< v1.0）
- 原型開發
- 內部工具或服務
- 快速迭代階段
- 重構或架構改善專案

**❌ 不適合使用：**
- 已發佈的公開 API
- 有外部使用者的函式庫
- 穩定的生產系統
- 需要長期支援的專案

### 實務規範

#### 1. API 重新設計

**簡化複雜 API：**
```csharp
// ✅ 可接受：大幅簡化 API
// 舊設計（複雜且易錯）
public void CreateUser(string name, string email, int age, 
                       string address, string phone, 
                       bool isActive, DateTime createdAt);

// 新設計（清晰且可擴展）
public void CreateUser(UserData userData);

public record UserData(
    string Name,
    string Email,
    UserProfile Profile
);
```

#### 2. 移除技術債

**重構不良設計：**
```csharp
// ✅ 可接受：移除不良繼承結構
// 舊設計（過度工程）
public abstract class BaseService { }
public class IntermediateService : BaseService { }
public class MiddleService : IntermediateService { }
public class ConcreteService : MiddleService { }

// 新設計（簡潔）
public interface IService { }
public class Service : IService { }
```

#### 3. 資料庫架構變更

**重新設計資料表：**
```sql
-- ✅ 可接受：重新設計資料表結構
-- 舊設計
CREATE TABLE Users (
    Id INT,
    Data VARCHAR(MAX)  -- JSON 字串
);

-- 新設計（正規化）
CREATE TABLE Users (
    Id INT,
    Name VARCHAR(100),
    Email VARCHAR(255)
);
```

#### 4. 設定檔重構

**簡化設定結構：**
```jsonc
// ✅ 可接受：簡化設定格式
// 舊設計（複雜）
{
  "database": {
    "connection": {
      "server": "localhost",
      "port": 5432,
      "database": "mydb"
    }
  }
}

// 新設計（簡潔）
{
  "connectionString": "Server=localhost;Port=5432;Database=mydb"
}
```

### 版本管理

可使用更激進的版本策略：

- **0.x.x** - 快速迭代，隨時可能破壞相容性
- **1.x.x** - 較穩定，但仍可能有破壞性變更
- **主要里程碑** - 使用 Major 版本標記重大變更

**範例：**
```
v0.1.0 → v0.2.0  ⚠️  可能包含破壞性變更
v0.9.0 → v1.0.0  ⚠️  重大重構
v1.2.0 → v1.3.0  ⚠️  API 重新設計
```

### 變更管理

**記錄所有破壞性變更：**

```markdown
# CHANGELOG.md

## [2.0.0] - 2025-12-11

### BREAKING CHANGES

- **API 重新設計**: `GetUser` 方法改為 `GetUserAsync`
- **移除棄用方法**: 移除 v1.x 標記為 obsolete 的方法
- **設定檔變更**: 改用新的 YAML 格式
- **資料庫結構**: Users 資料表正規化

### Migration Notes

本版本包含重大架構改善，升級前請詳閱遷移指南。
```

### 最佳實務

1. **清楚溝通** - 明確告知團隊變更範圍
2. **提供遷移指南** - 雖然擁抱變更，但要協助遷移
3. **批次變更** - 將多個破壞性變更集中在同一版本
4. **充分測試** - 確保新設計確實更好

---

## 選擇策略

### 決策樹

```
專案已發佈且有外部使用者？
├─ 是 → 使用「嚴格向後相容」
└─ 否 → 
    專案處於早期開發階段（< v1.0）？
    ├─ 是 → 使用「擁抱破壞性變更」
    └─ 否 →
        需要快速改善設計？
        ├─ 是 → 評估影響，考慮「擁抱破壞性變更」
        └─ 否 → 使用「嚴格向後相容」
```

### 評估因素

| 因素 | 嚴格向後相容 | 擁抱破壞性變更 |
|------|------------|--------------|
| **專案階段** | 成熟期 | 早期/重構期 |
| **使用者類型** | 外部使用者 | 內部團隊 |
| **變更頻率** | 低頻 | 高頻 |
| **技術債** | 可接受 | 不可接受 |
| **團隊偏好** | 保守 | 激進 |
| **文件成本** | 高 | 中 |

### 混合策略（不建議）

⚠️ **強烈不建議**同時使用兩種策略，但如果必須：

1. **依模組區分**
   - 公開 API → 嚴格相容
   - 內部模組 → 擁抱變更

2. **依版本區分**
   - v1.x → 嚴格相容
   - v2.x → 允許破壞性變更（重大里程碑）

3. **明確標記**
   - Stable API → 嚴格相容
   - Experimental API → 可能變更

## 安裝和切換

### 安裝策略檔案

**選擇策略 A（嚴格向後相容）：**
```powershell
Copy-Item .\.github\instructions\NeverBreakCompatibility.instructions.md .\your-project\.github\instructions\
```

**選擇策略 B（擁抱破壞性變更）：**
```powershell
Copy-Item .\.github\instructions\EmbraceBreakingChanges.instructions.md .\your-project\.github\instructions\
```

### 切換策略

**從 A 切換到 B：**
```powershell
# 移除舊策略
Remove-Item .\your-project\.github\instructions\NeverBreakCompatibility.instructions.md

# 安裝新策略
Copy-Item .\.github\instructions\EmbraceBreakingChanges.instructions.md .\your-project\.github\instructions\

# 重新載入 VS Code
# Ctrl+Shift+P → Reload Window
```

### 驗證設定

**檢查當前策略：**
```powershell
# 列出已安裝的策略檔案
Get-ChildItem .\your-project\.github\instructions\*Compatibility*.md
```

應該只看到一個檔案。

## 常見問題

### Q: 可以不使用任何策略嗎？

A: 可以，但建議選擇一個以確保團隊有一致的相容性準則。

### Q: 策略可以中途改變嗎？

A: 可以，但需要：
1. 團隊達成共識
2. 更新專案文件
3. 通知所有相關人員

### Q: 如何處理策略衝突？

A: 
1. 移除不需要的策略檔案
2. 確保只有一個策略檔案存在
3. 重新載入 VS Code

### Q: 策略檔案應該納入版本控制嗎？

A: 是的，策略檔案應該與專案一起版本控制，讓所有團隊成員使用相同的策略。

## 相關資源

- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [API Design Guidelines](https://github.com/microsoft/api-guidelines)
- [指令集使用指南](instructions-guide.md)
- [快速開始](getting-started.md)
