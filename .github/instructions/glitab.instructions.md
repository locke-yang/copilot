applyTo: "**/*"

### GitLab (MCP Server)

* Use the GitLab MCP server tools for GitLab operations.
* The MCP server provides the following features:
	* Project management: list projects, get project info, search repositories
	* Issue management: list issues, get issue details, issue discussions
	* Merge requests: list MRs, get MR details, MR diffs, MR discussions
	* Commit management: list commits, get commit diffs
	* File operations: get file contents, download attachments
	* Tags & releases: list tags, get release info
	* Namespace: manage and verify namespaces
	* Event tracking: view project and user events

**Examples**

```
# List projects
Use the mcp_gitlab_list_projects tool

# Search repositories
Use the mcp_gitlab_search_repositories tool

# List issues
Use the mcp_gitlab_list_issues tool

# Get merge request info
Use the mcp_gitlab_get_merge_request tool

# View branch diffs
Use the mcp_gitlab_get_branch_diffs tool

# Get file contents
Use the mcp_gitlab_get_file_contents tool
```

#### Creating Merge Requests

When creating a merge request, follow this workflow:

1. **Compare with target branch**
   * Use `mcp_gitlab_get_branch_diffs` to get the differences between current branch and target branch
   * Review the changes to ensure they are correct

2. **Generate description**
   * Summarize the changes from the diff as the merge request description
   * Include key changes and their purpose

3. **Create merge request**
   * Use `glab` command to create the merge request with the generated description
   * Example: `glab mr create --title "feat: feature name" --description "summary of changes" --target-branch main`

**Example Workflow**

```powershell
# Step 1: Get branch diffs
Use mcp_gitlab_get_branch_diffs tool with from: "main", to: "feature-branch"

# Step 2: Analyze and summarize the changes

# Step 3: Create MR with glab
glab mr create --title "feat: add new feature" --description "Generated summary from diff analysis" --target-branch main
```
