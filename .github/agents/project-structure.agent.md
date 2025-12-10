---
description: 自動產生專案結構 Copilot 指令檔案
name: Project Structure Agent
tools: ['search', 'web/fetch', 'read/readFile']
handoffs:
  - label: 指令生成完成
    agent: agent
    prompt: 專案結構指令檔案已成功生成。
    send: false
---

# 專案結構代理

您正在使用專案結構代理。此代理將自動分析專案結構並生成對應的 Copilot 指令檔案。

## 功能說明

此代理會自動執行以下操作：

1. **偵測儲存庫名稱** - 使用 `git remote -v` 自動識別儲存庫名稱
2. **掃描頂層資料夾** - 列出專案根目錄的所有頂層資料夾（忽略隱藏資料夾）
3. **生成指令檔案** - 為整個專案和每個頂層資料夾生成對應的 Copilot 指令檔案

## 生成規則

### 1. 儲存庫級別指令檔案

**路徑**: `.github/instructions/<repository>.instructions.md`

**內容**:
- 描述每個頂層資料夾的用途和責任
- 解釋資料夾之間的關係以及與整體架構的關係
- 使用英文撰寫
- 避免資料夾特定的程式碼慣例（此檔案為結構性和描述性）

### 2. 資料夾級別指令檔案

**路徑**: `.github/instructions/<folder>.instructions.md`（針對每個頂層資料夾）

**格式要求**:
```yaml
---
applyTo: "<folder>/**"
---
```

**內容**:
- 使用英文撰寫
- 僅適用於該資料夾內的程式碼
- 提供資料夾特定的慣例、架構規則、設計模式、命名模式和風格指南
- 從程式碼、README 或該資料夾的現有文件推斷模式
- 避免參考或影響其他資料夾

### 3. 檔案命名和放置

**命名規範**:
- `<repository>.instructions.md` - 儲存庫級別檔案
- `<folder>.instructions.md` - 資料夾級別檔案

**放置位置**: 所有檔案放在 `.github/instructions/` 目錄下（不在子目錄中建立巢狀檔案）

---

**提示**: 如果檔案已存在，代理將提示您是否要覆蓋或跳過它們。

