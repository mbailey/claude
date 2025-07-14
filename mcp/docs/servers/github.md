# github

GitHub API integration for repository and organization management with advanced automation capabilities.

**Project URL:** [https://github.com/github/github-mcp-server](https://github.com/github/github-mcp-server)

## CLI Command
```bash
claude mcp add github podman "run" "-i" "--rm" "-e" "GITHUB_PERSONAL_ACCESS_TOKEN" "ghcr.io/github/github-mcp-server"
```

## JSON Configuration
```json
{
  "github": {
    "command": "podman",
    "args": [
      "run",
      "-i",
      "--rm",
      "-e",
      "GITHUB_PERSONAL_ACCESS_TOKEN",
      "ghcr.io/github/github-mcp-server"
    ],
    "cache_tools_list": true
  }
}
```

## Requirements
- `GITHUB_PERSONAL_ACCESS_TOKEN` environment variable with appropriate scopes
- Podman or Docker container runtime
- Access to `ghcr.io/github/github-mcp-server` container image
- Network access to GitHub API (or GitHub Enterprise instance)

## Features
- Full GitHub API integration via Model Context Protocol
- Support for both GitHub Cloud and GitHub Enterprise
- Flexible toolset configuration - enable only the tools you need
- Read-only mode for safe exploration
- Dynamic toolset discovery based on repository context
- OAuth and Personal Access Token authentication
- Streaming support for real-time updates

## Available Tools
The server provides comprehensive tool coverage organized by category:

### Repository Management
- Repository operations (create, update, delete, clone)
- Branch and tag management
- File and content operations

### Issues & Projects
- Issue creation, updates, and management
- Project board operations
- Milestone tracking

### Pull Requests
- PR creation and management
- Review operations
- Merge functionality

### Actions & Workflows
- Workflow triggering and management
- Action status monitoring
- Artifact handling

### Code Security
- Security scanning results
- Vulnerability management
- Secret scanning

### Additional Tools
- Notifications management
- User and organization operations
- Search functionality
- Context-aware operations

## Configuration Options

### Toolset Selection
Control which tool groups are enabled:
```bash
# Enable specific toolsets
claude mcp add github podman "run" "-i" "--rm" \
  "-e" "GITHUB_PERSONAL_ACCESS_TOKEN" \
  "-e" "GITHUB_TOOLSETS=repos,issues,pull_requests" \
  "ghcr.io/github/github-mcp-server"
```

Available toolsets:
- `context` - Context-aware operations
- `actions` - GitHub Actions management
- `code_security` - Security features
- `issues` - Issue management
- `pull_requests` - PR operations
- `repos` - Repository management
- `notifications` - Notification handling
- `orgs` - Organization operations
- `search` - Search functionality
- `users` - User operations

### Read-Only Mode
For safe exploration without modification risks:
```bash
claude mcp add github podman "run" "-i" "--rm" \
  "-e" "GITHUB_PERSONAL_ACCESS_TOKEN" \
  "ghcr.io/github/github-mcp-server" \
  "--read-only"
```

### GitHub Enterprise
Configure for GitHub Enterprise instance:
```bash
claude mcp add github podman "run" "-i" "--rm" \
  "-e" "GITHUB_PERSONAL_ACCESS_TOKEN" \
  "ghcr.io/github/github-mcp-server" \
  "--gh-host" "github.mycompany.com"
```

## Tool Approval
To approve specific tools for this server, add to your Claude settings:

```json
{
  "toolApprovals": {
    "github": {
      "create_issue": true,
      "create_pull_request": true,
      "list_repos": true,
      "get_file_contents": true
    }
  }
}
```

## Example Usage

### List repositories
Ask: "What repositories do I have access to?"

### Create an issue
Ask: "Create an issue in myrepo titled 'Bug: Login fails' with details about the error"

### Review pull requests
Ask: "Show me open pull requests in myproject that need review"

### Check workflow status
Ask: "What's the status of the CI workflow in my main branch?"

## See Also
- [← Back to MCP Servers Index](./README.md)
- [MCP Documentation](https://modelcontextprotocol.io/)
- [GitHub API Documentation](https://docs.github.com/en/rest)
- [git](./git.md) - Local git operations server