applyTo: "**/*"

## Version Control System

**MANDATORY**: This project uses a **self-hosted GitLab server** as the version control system.

---

## Core Rules

### ✅ MUST USE
1. **GitLab MCP Server Tools** - All GitLab API operations
2. **glab CLI** - Operations not covered by MCP tools

### ❌ NEVER USE
These git commands are **STRICTLY PROHIBITED** for remote operations:
- `git push`
- `git pull`
- `git fetch`
- `git remote`

**Why**: All remote operations must route through GitLab tools for proper authentication, tracking, and audit compliance.

### ✅ ALLOWED (Local Only)
```
git status          # Check local status
git log             # View history
git diff            # Compare changes
git show            # Show details
git branch          # List/manage local branches
git add             # Stage files
git commit          # Create commits
```

---

## Tool Reference

### By Category

| Category | Tools | Purpose |
|----------|-------|---------|
| **Projects** | `list_projects`, `search_repositories`, `get_project`, `create_repository`, `fork_repository` | Project management |
| **Issues** | `list_issues`, `get_issue`, `create_issue`, `update_issue`, `create_issue_note`, `list_issue_discussions` | Issue tracking |
| **Merge Requests** | `list_merge_requests`, `get_merge_request`, `create_merge_request`, `update_merge_request`, `merge_merge_request` | MR operations |
| **Diffs** | `get_branch_diffs`, `get_merge_request_diffs` | Compare changes |
| **Files** | `get_file_contents`, `create_or_update_file`, `push_files` | File operations |
| **Branches** | `create_branch`, `get_branch_diffs` | Branch management |
| **Labels** | `list_labels`, `get_label`, `create_label`, `update_label`, `delete_label` | Label management |
| **Releases** | `list_releases`, `get_release`, `create_release`, `update_release`, `delete_release` | Release management |
| **Namespaces** | `list_namespaces`, `get_namespace`, `verify_namespace` | Namespace operations |
| **Commits** | `list_commits`, `get_commit`, `get_commit_diff` | Commit info |
| **Events** | `get_project_events`, `list_events` | Activity tracking |

---

## Common Workflows

### 1️⃣ Creating a Merge Request

```powershell
# Step 1: Compare branches
get_branch_diffs --from "main" --to "feature-branch"

# Step 2: Create MR
create_merge_request \
  --project_id "namespace/project" \
  --source_branch "feature-branch" \
  --target_branch "main" \
  --title "feat: description" \
  --description "Summary of changes"
```

**Key Points:**
- Always verify changes with `get_branch_diffs` first
- Use Conventional Commits format for title
- Do NOT pass unsupported fields (MCP validates strictly)

---

### 2️⃣ Adding Comments to Issues/MRs

```powershell
# Add comment to issue
create_issue_note \
  --project_id "namespace/project" \
  --issue_iid 123 \
  --body "Your comment"

# Reply in discussion thread
create_issue_note \
  --project_id "namespace/project" \
  --issue_iid 123 \
  --discussion_id "thread_id" \
  --body "Your reply"
```

---

### 3️⃣ Issue Management

```powershell
# Create issue
create_issue \
  --project_id "namespace/project" \
  --title "bug: description" \
  --description "Details" \
  --labels "bug,priority::high"

# Update issue
update_issue \
  --project_id "namespace/project" \
  --issue_iid 123 \
  --state_event close

# List issues
list_issues --state opened
```

---

### 4️⃣ File Operations

```powershell
# Read file
get_file_contents \
  --project_id "namespace/project" \
  --file_path "src/main.ts" \
  --ref "main"

# Create or update single file
create_or_update_file \
  --project_id "namespace/project" \
  --file_path "README.md" \
  --content "# Project" \
  --commit_message "docs: update readme"

# Push multiple files
push_files \
  --project_id "namespace/project" \
  --branch "feature" \
  --files '[{"file_path":"a.txt","content":"data"}]' \
  --commit_message "feat: add files"
```

---

### 5️⃣ Branch Comparison

```powershell
# Compare branches
get_branch_diffs \
  --project_id "namespace/project" \
  --from "main" \
  --to "feature-branch"
```

---

## Tool Selection Guide

| Task | Tool | Example |
|------|------|---------|
| List projects | `list_projects` | `list_projects` |
| Search projects | `search_repositories` | `search_repositories --search "keyword"` |
| Get project info | `get_project` | `get_project --project_id "namespace/project"` |
| List issues | `list_issues` | `list_issues --state opened` |
| Get issue | `get_issue` | `get_issue --project_id "..." --issue_iid 123` |
| Create issue | `create_issue` | `create_issue --project_id "..." --title "..."` |
| Update issue | `update_issue` | `update_issue --project_id "..." --issue_iid 123 --state_event close` |
| List MRs | `list_merge_requests` | `list_merge_requests --state opened` |
| Get MR | `get_merge_request` | `get_merge_request --project_id "..." --merge_request_iid 456` |
| Create MR | `create_merge_request` | `create_merge_request --project_id "..." --source_branch "..." --target_branch "..."` |
| Merge MR | `merge_merge_request` | `merge_merge_request --project_id "..." --merge_request_iid 456` |
| Compare branches | `get_branch_diffs` | `get_branch_diffs --project_id "..." --from "main" --to "feature"` |
| Read file | `get_file_contents` | `get_file_contents --project_id "..." --file_path "path"` |
| Create file | `create_or_update_file` | `create_or_update_file --project_id "..." --file_path "..." --content "..."` |
| Push files | `push_files` | `push_files --project_id "..." --branch "main" --files '[...]' --commit_message "..."` |
| List commits | `list_commits` | `list_commits --project_id "..." --ref_name "main"` |
| Get commit | `get_commit` | `get_commit --project_id "..." --sha "abc123"` |
| Commit diff | `get_commit_diff` | `get_commit_diff --project_id "..." --sha "abc123"` |

## Error Handling

### If MCP Tool Fails

1. Check tool availability: Ensure GitLab MCP server is running
2. Verify parameters: All required fields must be provided
3. Fallback to glab: Use `glab` CLI if MCP is unavailable
4. NEVER fallback to raw git commands

### If glab Command Fails

1. Check authentication: Run `glab auth status`
2. Verify project context: Ensure you're in a GitLab project directory
3. Check command syntax: Refer to `glab --help`

### Error Matrix

| Error | Tool | Cause | Solution |
|-------|------|-------|----------|
| 404 Not Found | Any | Project/Resource not found | Verify project ID format `namespace/project` and resource IID |
| 401 Unauthorized | Any | Missing/invalid token | Check GitLab token in environment/config |
| 400 Bad Request | Any | Invalid parameter format | Verify parameter names, quote strings, unquote numbers |
| 422 Validation Error | Any | Unsupported field passed | Review tool documentation; remove unsupported fields |
| 409 Conflict | `create_*` | Resource already exists | Use update tool or add unique suffix |
| 503 Service Unavailable | Any | GitLab/MCP server down | Wait for service recovery |

---

## LLM Implementation Notes

### Tool Invocation Pattern

```
tool_name --param1 "value1" --param2 123 --param3 true
```

**Parameter Rules:**
- Tool names: Lowercase with underscores (NO `mcp_gitlab_` prefix)
- Parameter names: Double dash + lowercase + underscores
- String values: Always quoted (`"value"`)
- Numbers: Unquoted (`123`)
- Booleans: Unquoted (`true`/`false`)
- Arrays/Objects: JSON format, quoted (`'[...]'` in PowerShell)

### Response Structure (JSON)

**Standard Fields by Resource Type:**

**Issues:**
```json
{
  "id": 123,
  "iid": 45,
  "title": "Bug description",
  "state": "opened",
  "description": "Details",
  "labels": ["bug"],
  "assignees": [{"id": 1, "name": "User"}]
}
```

**Merge Requests:**
```json
{
  "id": 456,
  "iid": 12,
  "title": "Feature implementation",
  "state": "opened",
  "source_branch": "feature",
  "target_branch": "main",
  "author": {"id": 1, "name": "User"}
}
```

**Files:**
```json
{
  "file_path": "src/main.ts",
  "content": "file content here",
  "encoding": "base64"
}
```

### When to Use Each Tool

| Goal | Tool | Notes |
|------|------|-------|
| List all issues | `list_issues` | Add `--state opened` or `--state closed` |
| Get specific issue | `get_issue` | Requires `--issue_iid` |
| Create issue | `create_issue` | Requires `--title`; optional: `--description`, `--labels` |
| Add comment | `create_issue_note` | Requires `--issue_iid` and `--body` |
| Compare branches | `get_branch_diffs` | Requires `--from` and `--to` |
| Create MR | `create_merge_request` | Requires `--source_branch`, `--target_branch`, `--title` |
| Read file | `get_file_contents` | Requires `--file_path`; optional `--ref` |
| Create/update file | `create_or_update_file` | Requires `--file_path`, `--content`, `--commit_message` |
| Push multiple files | `push_files` | Requires `--branch`, `--files` (JSON array), `--commit_message` |

### Common Patterns for LLMs

**Pattern 1: Review Then Create MR**
```
1. Call get_branch_diffs to review changes
2. Analyze diff output
3. Call create_merge_request with description
```

**Pattern 2: Issue Resolution Workflow**
```
1. Call list_issues to find relevant issue
2. Call get_issue to get full details
3. Call create_issue_note to add updates/links
4. Call update_issue to close issue
```

**Pattern 3: File Update Workflow**
```
1. Call get_file_contents to read current state
2. Modify content as needed
3. Call create_or_update_file to push changes
```

---

## Quick Reference - Tool Categories

**Projects:** `list_projects` • `search_repositories` • `get_project` • `create_repository` • `fork_repository`

**Issues:** `list_issues` • `get_issue` • `create_issue` • `update_issue` • `create_issue_note` • `list_issue_discussions`

**Merge Requests:** `list_merge_requests` • `get_merge_request` • `create_merge_request` • `update_merge_request` • `merge_merge_request`

**Branches:** `list_branches` • `get_branch` • `create_branch` • `get_branch_diffs`

**Commits:** `list_commits` • `get_commit` • `get_commit_diff`

**Files:** `get_file_contents` • `create_or_update_file` • `push_files`

**Labels:** `list_labels` • `get_label` • `create_label` • `update_label` • `delete_label`

**Releases:** `list_releases` • `get_release` • `create_release` • `update_release` • `delete_release`

---

## Quick Reference

### Most Common Operations

```powershell
# Projects
list_projects
search_repositories --search "keyword"

# Issues
list_issues --state opened
create_issue --title "bug: description"

# Merge Requests
get_branch_diffs --from "main" --to "feature"
create_merge_request --project_id "ns/proj" --source_branch "feature" --target_branch "main" --title "feat: xyz"
merge_merge_request --project_id "ns/proj" --merge_request_iid 123

# Files
get_file_contents --project_id "ns/proj" --file_path "README.md" --ref "main"

# Commits
list_commits --project_id "ns/proj" --ref_name "main"
get_commit_diff --project_id "ns/proj" --sha "abc123"
```
