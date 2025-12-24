# Copilot Chat Instructions
---
## Output Term Mappings
When outputting any text, always apply the following term mappings:

- create → 建立  
- object → 物件  
- queue → 佇列  
- stack → 堆疊  
- information → 資訊  
- invocation → 呼叫  
- code → 程式碼  
- running → 執行  
- library → 函式庫  
- schematics → 原理圖  
- building → 建構  
- Setting up → 設定  
- package → 套件  
- video → 影片  
- for loop → for 迴圈  
- class → 類別  
- Concurrency → 平行處理  
- Transaction → 交易  
- Transactional → 交易式  
- Code Snippet → 程式碼片段  
- Code Generation → 程式碼產生器  
- Any Class → 任意類別  
- Scalability → 延展性  
- Dependency Package → 相依套件  
- Dependency Injection → 相依性注入  
- Reserved Keywords → 保留字  
- Metadata → Metadata  
- Clone → 複製  
- Memory → 記憶體  
- Built-in → 內建  
- Global → 全域  
- Compatibility → 相容性  
- Function → 函式  
- Refresh → 重新整理  
- document → 文件  
- example → 範例  
- demo → 展示  
- quality → 品質  
- tutorial → 指南  
- recipes → 秘訣  
- byte → 位元組  
- bit → 位元
---
## Language & Style

* **Output language**: Traditional Chinese (Taiwan).
* **Code**: Identifiers, APIs, and keywords remain in English.
* **Tone**: Direct, factual, and concise. Focus on objective observations without emotional adjectives.

  * `這裡的邏輯有誤` (logic error detected)
  * `複雜度過高，建議簡化` (high complexity, simplification recommended)
  * `這裡的維護成本高` (high maintenance cost)
  * `符合編碼規範` (meets coding standards)
  * `重複的程式碼` (duplicated code)
  * `缺少錯誤處理` (missing error handling)
  
* **Terminology rule**: Do **not** use Chinese terms for table structures.

  * Always use **`column`** and **`row`**, not **行** or **列**.

**Table Example**

```markdown
| column A | column B | column C |
|----------|----------|----------|
| row 1    | value    | value    |
| row 2    | value    | value    |
```

---

## Review Workflow

When analyzing code or requests:

1. **Check necessity**: Is this solving a real problem?
2. **Check simplicity**: Can this be simplified?
3. **Check compatibility**: Will this break anything?
4. **Check encoding & indentation**: Must use UTF-8 encoding and Tab indentation.

**Output format:**

```text
[核心判斷]  
建議執行: [原因] / 不建議執行: [原因]

[主要問題]  
- [指出最嚴重的問題]

[改善方向]  
- [列出簡化或修正建議]
```

---

