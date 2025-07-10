# github

GitHub API integration for repository and organization management.

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
- `GITHUB_PERSONAL_ACCESS_TOKEN` environment variable
- Podman container runtime
- Access to `ghcr.io/github/github-mcp-server` container image