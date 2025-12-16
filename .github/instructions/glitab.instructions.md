applyTo: "**/*"

## Version Control System

**MANDATORY**: This project uses a **self-hosted GitLab server** as the version control system.

## Tool Usage Rules

### Primary Tools (MUST USE)

1. **GitLab MCP Server Tools** - For all GitLab API operations
2. **glab CLI** - For operations not covered by MCP tools

### Prohibited Commands

**NEVER** use the following git commands:
- `git push`
- `git pull`
- `git fetch`
- `git remote`
- Any other git commands that interact with remote repositories

**REASON**: All remote operations must go through GitLab-specific tools to ensure proper authentication and tracking.

### Allowed git Commands

Only local git operations are permitted:
- `git status`
- `git log`
- `git diff`
- `git show`
- `git branch` (local only)
- `git add`
- `git commit`

## GitLab MCP Server Capabilities

### Available Operations

| Category | Operations | MCP Tools |
|----------|-----------|-----------|
| **Projects** | List, search, get info, create, fork | `mcp_gitlab_list_projects`, `mcp_gitlab_search_repositories`, `mcp_gitlab_get_project`, `mcp_gitlab_create_repository`, `mcp_gitlab_fork_repository` |
| **Issues** | List, view, create, update, notes | `mcp_gitlab_list_issues`, `mcp_gitlab_get_issue`, `mcp_gitlab_create_issue`, `mcp_gitlab_update_issue`, `mcp_gitlab_create_issue_note` |
| **Merge Requests** | List, view, create, update, merge, diff, discussions | `mcp_gitlab_list_merge_requests`, `mcp_gitlab_get_merge_request`, `mcp_gitlab_create_merge_request`, `mcp_gitlab_update_merge_request`, `mcp_gitlab_merge_merge_request`, `mcp_gitlab_get_branch_diffs` |
| **Commits** | List, view, diff | `mcp_gitlab_list_commits`, `mcp_gitlab_get_commit`, `mcp_gitlab_get_commit_diff` |
| **Files** | Get contents, create/update, push multiple | `mcp_gitlab_get_file_contents`, `mcp_gitlab_create_or_update_file`, `mcp_gitlab_push_files` |
| **Branches** | Create, compare | `mcp_gitlab_create_branch`, `mcp_gitlab_get_branch_diffs` |
| **Labels** | List, create, update, delete | `mcp_gitlab_list_labels`, `mcp_gitlab_create_label`, `mcp_gitlab_update_label`, `mcp_gitlab_delete_label` |
| **Releases** | List, create, update, delete | `mcp_gitlab_list_releases`, `mcp_gitlab_create_release`, `mcp_gitlab_update_release`, `mcp_gitlab_delete_release` |
| **Namespaces** | List, get, verify | `mcp_gitlab_list_namespaces`, `mcp_gitlab_get_namespace`, `mcp_gitlab_verify_namespace` |
| **Events** | View project/user events | `mcp_gitlab_get_project_events`, `mcp_gitlab_list_events` |

## Standard Workflows

### 1. Creating a Merge Request

**REQUIRED STEPS** (must follow in order):

```powershell
# Step 1: Compare branches using MCP
# MUST use mcp_gitlab_get_branch_diffs tool
# Parameters: from (target branch), to (source branch)

# Step 2: Analyze the diff results
# Review changes for completeness and correctness

# Step 3: Generate MR description
# Summarize changes with:
# - Purpose of changes
# - Key modifications
# - Impact assessment

# Step 4: Create MR using glab
glab mr create --title "type: description" --description "generated summary" --target-branch main
```

### 2. Checking Project Status

```powershell
# Use MCP tools only
mcp_gitlab_get_project         # Get project details
mcp_gitlab_list_merge_requests # List open MRs
mcp_gitlab_list_issues         # List open issues
```

### 3. Working with Issues

```powershell
# List issues
mcp_gitlab_list_issues

# Create issue
mcp_gitlab_create_issue --title "type: description" --description "details"

# Update issue
mcp_gitlab_update_issue --issue_iid <id> --state_event close
```

### 4. Branch Operations

```powershell
# Create branch (MCP)
mcp_gitlab_create_branch --branch "feature/name" --ref "main"

# Local branch operations (git allowed)
git branch              # List local branches
git checkout -b feature # Create local branch
git status              # Check local status
```

## Common Patterns

### Pattern 1: Review Changes Before MR

```powershell
# 1. Get branch diff
mcp_gitlab_get_branch_diffs --from "main" --to "feature-branch"

# 2. Review output and summarize

# 3. Create MR with summary
glab mr create --title "feat: new feature" --description "Summary from diff"
```

### Pattern 2: Check MR Status

```powershell
# List MRs
mcp_gitlab_list_merge_requests --state opened

# Get specific MR
mcp_gitlab_get_merge_request --merge_request_iid <id>

# Merge MR
mcp_gitlab_merge_merge_request --merge_request_iid <id>
```

### Pattern 3: File Operations

```powershell
# Get file contents
mcp_gitlab_get_file_contents --file_path "path/to/file" --ref "main"

# Push multiple files
mcp_gitlab_push_files --branch "feature" --files '[{"file_path":"a.txt","content":"data"}]' --commit_message "update files"
```

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

## Quick Reference

### Most Common Operations

```powershell
# Projects
mcp_gitlab_list_projects
mcp_gitlab_search_repositories --search "keyword"

# Issues
mcp_gitlab_list_issues --state opened
mcp_gitlab_create_issue --title "bug: description"

# Merge Requests
mcp_gitlab_get_branch_diffs --from "main" --to "feature"
glab mr create --title "feat: xyz" --description "..." --target-branch main
mcp_gitlab_merge_merge_request --merge_request_iid 123

# Files
mcp_gitlab_get_file_contents --file_path "README.md" --ref "main"

# Commits
mcp_gitlab_list_commits --ref_name "main"
mcp_gitlab_get_commit_diff --sha "abc123"
```
