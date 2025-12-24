# review-agent 使用指南

review-agent 協助審查未提交的代碼變更，提供專業的代碼審查意見和改進建議。

## 功能概述

該 Agent 提供以下功能：

- **變更分析** - 自動分析 Git 工作區的所有變更
- **代碼品質檢查** - 檢查代碼風格、命名、複雜度
- **潛在問題識別** - 發現可能的 Bug 和邏輯錯誤
- **安全性審查** - 識別安全漏洞和風險
- **效能分析** - 發現效能瓶頸和優化機會
- **最佳實務建議** - 推薦行業標準做法

## 快速開始

### 基本用法

1. 在 Copilot Chat 中選擇 **Review** Agent（透過 dropdown）
2. 提供指令

Agent 會自動：
1. 檢查所有未提交的變更
2. 分析代碼品質和潛在問題
3. 提供結構化的審查報告
4. 給出具體的改進建議

### 指定審查類型

在 Copilot Chat 中選擇 **Review** Agent，提供：

```
- 類型：安全審查
- 詳細程度：詳細
```

### 審查特定檔案

在 Copilot Chat 中選擇 **Review** Agent，提供：

```
- 檔案：src/auth/login.ts
```

## 審查報告結構

### 完整報告範例

```markdown
# 代碼審查報告 - 2025-12-12

## 變更概述
本次變更實作了用戶認證功能，包含登入、登出和 token 驗證。
主要修改 auth 模組，新增 3 個檔案，修改 2 個檔案。

## 變更檔案
- src/auth/login.service.ts (+120 -0) [新增]
- src/auth/token.util.ts (+45 -0) [新增]
- src/auth/auth.controller.ts (+80 -10) [修改]
- src/models/user.model.ts (+15 -5) [修改]
- tests/auth/login.test.ts (+200 -0) [新增]

**總計**: +460 -15 行

## 審查結果

### ✅ 良好實踐

1. **完整的測試覆蓋**
   - 新增功能包含完整的單元測試
   - 測試覆蓋登入成功、失敗、邊界情況

2. **清晰的錯誤處理**
   - 使用自定義的 AuthError 類別
   - 錯誤訊息清晰且有意義

3. **符合專案架構**
   - 遵循分層架構：Controller → Service → Model
   - 依賴注入正確實作

4. **良好的命名**
   - 函數和變數命名語意清晰
   - 遵循專案的命名規範

### ⚠️ 需要改進

#### 1. 密碼驗證邏輯（中等優先級）

**檔案**: `src/auth/login.service.ts:45`

**問題**:
```typescript
if (user.password === plainPassword) {
  // 登入成功
}
```

**建議**:
使用加密庫比對密碼，不應直接比對明文：

```typescript
import bcrypt from 'bcrypt';

const isPasswordValid = await bcrypt.compare(plainPassword, user.passwordHash);
if (isPasswordValid) {
  // 登入成功
}
```

#### 2. Token 過期時間硬編碼（低優先級）

**檔案**: `src/auth/token.util.ts:12`

**問題**:
```typescript
const expiresIn = 3600; // 1 hour
```

**建議**:
使用配置檔案管理：

```typescript
import config from '@/config';

const expiresIn = config.auth.tokenExpiry;
```

#### 3. 缺少輸入驗證（高優先級）

**檔案**: `src/auth/auth.controller.ts:23`

**問題**:
```typescript
async login(req: Request) {
  const { username, password } = req.body;
  return await this.loginService.login(username, password);
}
```

**建議**:
新增輸入驗證：

```typescript
import { validate } from '@/utils/validator';
import { LoginSchema } from '@/schemas/auth';

async login(req: Request) {
  const { username, password } = validate(req.body, LoginSchema);
  
  if (!username || !password) {
    throw new ValidationError('使用者名稱和密碼為必填');
  }
  
  return await this.loginService.login(username, password);
}
```

### 🐛 潛在問題

#### 1. SQL 注入風險（高風險）

**檔案**: `src/auth/login.service.ts:30`

**問題**:
```typescript
const query = `SELECT * FROM users WHERE username = '${username}'`;
const user = await db.query(query);
```

**影響**: 攻擊者可以透過特殊字符注入 SQL 指令

**解決方案**:
使用參數化查詢：

```typescript
const query = 'SELECT * FROM users WHERE username = ?';
const user = await db.query(query, [username]);
```

#### 2. 競態條件（中風險）

**檔案**: `src/auth/login.service.ts:55`

**問題**:
```typescript
const loginAttempts = await this.getLoginAttempts(userId);
if (loginAttempts >= 5) {
  throw new TooManyAttemptsError();
}
await this.incrementLoginAttempts(userId);
```

**影響**: 多個並發請求可能繞過登入次數限制

**解決方案**:
使用原子操作或鎖：

```typescript
const result = await db.query(
  'UPDATE login_attempts SET count = count + 1 WHERE user_id = ? AND count < 5',
  [userId]
);

if (result.affectedRows === 0) {
  throw new TooManyAttemptsError();
}
```

### 💡 改進建議

#### 1. 新增登入日誌

**建議**:
記錄每次登入嘗試以供審計：

```typescript
async login(username: string, password: string) {
  try {
    const user = await this.findUser(username);
    const isValid = await this.validatePassword(user, password);
    
    if (isValid) {
      await this.logLoginAttempt(user.id, 'success', req.ip);
      return this.generateToken(user);
    } else {
      await this.logLoginAttempt(user.id, 'failed', req.ip);
      throw new InvalidCredentialsError();
    }
  } catch (error) {
    await this.logLoginAttempt(null, 'error', req.ip);
    throw error;
  }
}
```

#### 2. 實作速率限制

**建議**:
新增 IP 層級的速率限制：

```typescript
import rateLimit from 'express-rate-limit';

const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 分鐘
  max: 5, // 最多 5 次嘗試
  message: '登入嘗試過於頻繁，請稍後再試'
});

app.post('/api/auth/login', loginLimiter, authController.login);
```

#### 3. 優化資料庫查詢

**目前**:
```typescript
const user = await db.query('SELECT * FROM users WHERE username = ?', [username]);
const profile = await db.query('SELECT * FROM profiles WHERE user_id = ?', [user.id]);
```

**優化**:
使用 JOIN 減少查詢次數：

```typescript
const result = await db.query(`
  SELECT u.*, p.* 
  FROM users u 
  LEFT JOIN profiles p ON u.id = p.user_id 
  WHERE u.username = ?
`, [username]);
```

## 檢查清單

- [x] 代碼風格符合專案規範
- [ ] **沒有明顯的 Bug 或邏輯錯誤** - 發現 SQL 注入和競態條件
- [x] 命名清晰且有意義
- [ ] **包含必要的錯誤處理** - 缺少輸入驗證
- [x] 有適當的註解和文檔
- [x] 包含或更新測試
- [x] 沒有遺留的調試代碼
- [ ] **沒有安全性問題** - 發現安全漏洞

## 下一步建議

### 立即處理（高優先級）
1. ✅ 修正 SQL 注入漏洞
2. ✅ 新增輸入驗證
3. ✅ 使用 bcrypt 比對密碼

### 短期改進（中優先級）
4. 修正競態條件
5. 新增登入日誌
6. 實作速率限制

### 長期優化（低優先級）
7. 優化資料庫查詢
8. 將配置移到設定檔
9. 新增更多測試案例

## 總體評價

**代碼品質**: ⭐⭐⭐☆☆ (3/5)

**優點**:
- 良好的測試覆蓋率
- 清晰的架構設計
- 符合專案規範

**待改進**:
- 存在安全漏洞需立即修正
- 缺少輸入驗證
- 需要更完善的錯誤處理

**建議**: 修正高優先級問題後再提交。
```

## 審查類型

### 1. 快速審查（Quick Review）

用於日常提交前的快速檢查。

在 Copilot Chat 中選擇 **Review** Agent，提供：

```
- 類型：快速審查
```

**檢查內容：**
- 代碼風格
- 明顯的語法錯誤
- 常見的反模式
- 基本的命名規範

**時長：** 1-2 分鐘

### 2. 詳細審查（Detailed Review）

深入分析代碼品質和設計。

在 Copilot Chat 中選擇 **Review** Agent，提供：

```
- 類型：詳細審查
```

**檢查內容：**
- 架構設計
- 邏輯完整性
- 效能考量
- 可維護性
- 測試覆蓋

**時長：** 5-10 分鐘

### 3. 安全審查（Security Review）

聚焦於安全性問題。

在 Copilot Chat 中選擇 **Review** Agent，提供：

```
- 類型：安全審查
```

**檢查內容：**
- SQL 注入
- XSS 漏洞
- CSRF 保護
- 認證和授權
- 敏感資料處理
- 依賴漏洞

**時長：** 3-5 分鐘

### 4. 效能審查（Performance Review）

識別效能瓶頸。

在 Copilot Chat 中選擇 **Review** Agent，提供：

```
- 類型：效能審查
```

**檢查內容：**
- 資料庫查詢優化
- 算法複雜度
- 記憶體使用
- 不必要的計算
- 快取策略

**時長：** 3-5 分鐘

## 審查重點詳解

### 代碼品質

#### 複雜度檢查

❌ **過於複雜**:
```typescript
function processUser(user) {
  if (user) {
    if (user.active) {
      if (user.verified) {
        if (user.age >= 18) {
          return true;
        }
      }
    }
  }
  return false;
}
```

✅ **簡化後**:
```typescript
function canProcessUser(user) {
  return user?.active && user?.verified && user?.age >= 18;
}
```

#### DRY 原則

❌ **重複代碼**:
```typescript
function saveUser(user) {
  if (!user.name) throw new Error('名稱為必填');
  if (!user.email) throw new Error('Email 為必填');
  if (!user.age) throw new Error('年齡為必填');
  // ...
}
```

✅ **重構後**:
```typescript
function validateRequired(obj, fields) {
  for (const field of fields) {
    if (!obj[field]) {
      throw new Error(`${field} 為必填`);
    }
  }
}

function saveUser(user) {
  validateRequired(user, ['name', 'email', 'age']);
  // ...
}
```

### 命名規範

#### 清晰的命名

❌ **不清楚的命名**:
```typescript
function calc(a, b) {
  return a * b * 0.9;
}
```

✅ **清晰的命名**:
```typescript
function calculateDiscountedPrice(price, quantity) {
  const DISCOUNT_RATE = 0.9;
  return price * quantity * DISCOUNT_RATE;
}
```

### 錯誤處理

#### 完善的錯誤處理

❌ **缺少錯誤處理**:
```typescript
async function getUser(id) {
  const user = await db.query('SELECT * FROM users WHERE id = ?', [id]);
  return user[0];
}
```

✅ **完善的錯誤處理**:
```typescript
async function getUser(id) {
  try {
    if (!id) {
      throw new ValidationError('使用者 ID 為必填');
    }
    
    const users = await db.query('SELECT * FROM users WHERE id = ?', [id]);
    
    if (users.length === 0) {
      throw new NotFoundError(`找不到 ID 為 ${id} 的使用者`);
    }
    
    return users[0];
  } catch (error) {
    if (error instanceof ValidationError || error instanceof NotFoundError) {
      throw error;
    }
    throw new DatabaseError('查詢使用者時發生錯誤', error);
  }
}
```

### 安全性

#### 常見安全問題

**1. SQL 注入**

❌ 不安全:
```typescript
const query = `SELECT * FROM users WHERE email = '${email}'`;
```

✅ 安全:
```typescript
const query = 'SELECT * FROM users WHERE email = ?';
const result = await db.query(query, [email]);
```

**2. XSS 防護**

❌ 不安全:
```typescript
element.innerHTML = userInput;
```

✅ 安全:
```typescript
element.textContent = userInput;
// 或使用 DOMPurify
element.innerHTML = DOMPurify.sanitize(userInput);
```

**3. 敏感資料處理**

❌ 不安全:
```typescript
console.log('用戶登入:', { username, password });
```

✅ 安全:
```typescript
console.log('用戶登入:', { username });
// 密碼不應出現在日誌中
```

## 工作流程範例

### 提交前審查

#### 第 1 步：檢查變更

```bash
git status
git diff
```

#### 第 2 步：運行 review-agent

在 Copilot Chat 中選擇 **Review** Agent，提供指令

#### 第 3 步：處理建議

根據審查報告修正問題：
- 立即修正高優先級問題
- 記錄中低優先級問題
- 考慮重構建議

#### 第 4 步：重新審查

修正後在 Copilot Chat 中再次選擇 **Review** Agent

#### 第 5 步：提交

確認沒有重大問題後在 Copilot Chat 中選擇 **Commit** Agent 進行提交

### Merge Request 前審查

在 Copilot Chat 中選擇 **Review** Agent，提供：

```
- 類型：詳細審查
- 檢查清單：完整
```

確保代碼品質符合團隊標準。

### 安全檢查

```
@review
- 類型：安全審查
- 聚焦：認證和授權
```

特別注意安全相關的變更。

## 最佳實務

### 1. 定期審查

建議頻率：
- 每次提交前進行快速審查
- 每天結束前進行詳細審查
- 重要功能完成後進行安全審查

### 2. 優先處理高風險問題

按優先級處理：
1. 安全漏洞
2. 邏輯錯誤
3. 效能問題
4. 代碼風格

### 3. 保持審查記錄

將審查報告保存供日後參考：

```
reviews/
├── 2025-12-12-auth-implementation.md
├── 2025-12-11-api-refactor.md
└── 2025-12-10-bug-fixes.md
```

### 4. 團隊規範

確保審查標準與團隊一致：
- 參考專案的 `.github/instructions/` 檔案
- 遵循團隊的編碼規範
- 使用專案配置的 linter 和 formatter

## 故障排除

### Agent 沒有發現明顯問題

**可能原因：**
1. 變更太小或太簡單
2. 代碼品質已經很好
3. 需要更詳細的審查

**解決方案：**
```
在 Copilot Chat 中選擇 **Review** Agent，提供：
```
- 類型：詳細審查
- 聚焦：架構設計
```

### 建議過於嚴格

**調整審查標準：** 在 Copilot Chat 中選擇 **Review** Agent，提供：
```
- 嚴格程度：寬鬆
- 聚焦：關鍵問題
```

### 不確定如何修正

**要求具體指導：** 在 Copilot Chat 中選擇 **Review** Agent，提供：
```
- 提供範例：true
- 詳細說明：true
```

## 配置和設定

### 在 settings.json 中啟用 Agent

```json
{
  "chat.agent.enabled": true
}
```

## 相關資源

- [review-agent 原始檔案](review.agent.md)
- [commit-agent 指南](commit-agent.md)
- [Create MR Agent 指南](create-mr-agent.md)
- [VS Code Agents 總覽](README.md)

## 常見問題

**Q: review-agent 會自動修正代碼嗎？**

A: 不會。Agent 只提供審查報告和建議，需要手動修正代碼。

**Q: 如何自訂審查規則？**

A: 修改專案的 `.github/instructions/` 檔案，Agent 會基於這些規則進行審查。

**Q: 能否審查已提交的代碼？**

A: review-agent 主要用於審查未提交的變更。對於已提交的代碼，建議使用 GitLab MR 審查功能。

**Q: 審查報告會自動保存嗎？**

A: 不會。如需保存，請手動複製報告內容。

## 支援和反饋

如遇問題或有改進建議,請提交 Issue 或 Merge Request。

---

最後更新：2025-12-12
