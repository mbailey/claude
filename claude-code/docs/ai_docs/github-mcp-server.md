# GitHub MCP Server

## Overview
The GitHub MCP Server is the official GitHub integration for the Model Context Protocol (MCP). It provides comprehensive GitHub API access through MCP tools, enabling Claude and other AI assistants to interact with GitHub repositories, issues, pull requests, and more.

## Installation
The GitHub MCP server is distributed as a container image:
```bash
podman pull ghcr.io/github/github-mcp-server
```

Note: Unlike other MCP servers, this is NOT available as an npm package. It must be run via container runtime (Docker/Podman).

## Authentication
Requires a GitHub Personal Access Token (PAT) with appropriate scopes:
- Set via `GITHUB_PERSONAL_ACCESS_TOKEN` environment variable
- Token scopes needed depend on operations:
  - `repo` - Full repository access
  - `read:org` - Read organization data
  - `workflow` - GitHub Actions access
  - `write:discussion` - Discussions access

## Capabilities

### Repository Operations
- Create new repositories
- Clone repositories
- Search repositories
- Get repository information
- List branches and commits

### Issues Management
- Create issues
- Update issue status and metadata
- Search issues
- Add comments and reactions

### Pull Requests
- Create pull requests
- Update PR status
- Merge pull requests
- Review PR changes
- Add comments and reviews

### Other Features
- User and organization information
- GitHub Actions workflow management
- Branch protection rules
- Release management

## Configuration

### Standard MCP Configuration
```json
{
  "mcpServers": {
    "github": {
      "command": "podman",
      "args": [
        "run", "-i", "--rm",
        "-e", "GITHUB_PERSONAL_ACCESS_TOKEN",
        "ghcr.io/github/github-mcp-server"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

### Limiting Toolsets
You can restrict available tools using the `--toolsets` flag:
```json
{
  "args": [
    "run", "-i", "--rm",
    "-e", "GITHUB_PERSONAL_ACCESS_TOKEN",
    "ghcr.io/github/github-mcp-server",
    "--toolsets", "issues,prs"
  ]
}
```

Available toolsets:
- `issues` - Issue operations
- `prs` - Pull request operations
- `repos` - Repository operations
- `users` - User/org operations
- `actions` - GitHub Actions

### Dynamic Toolsets
Enable dynamic tool discovery based on context:
```json
{
  "args": [
    "...",
    "--dynamic-toolsets"
  ]
}
```

## Container Integration Notes

### Running in Podman
When running inside a container that also runs Claude:
1. The GitHub MCP server container needs to be accessible from the Claude container
2. Use container networking or run both in the same pod
3. Environment variable must be passed through properly
4. May need to mount Podman socket for container-in-container execution

### Example Podman Setup
```bash
# Option 1: Run as sidecar in same pod
podman pod create --name claude-mcp
podman run -d --pod claude-mcp --name github-mcp \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=$GITHUB_TOKEN \
  ghcr.io/github/github-mcp-server

# Option 2: Use host networking (less secure)
podman run --network host ...

# Option 3: Mount Podman socket (for Podman-in-Podman)
podman run -v /run/podman/podman.sock:/run/podman/podman.sock ...
```

## Security Considerations
- Never hardcode tokens in configuration files
- Use environment variable substitution
- Limit token scopes to minimum required
- Consider using GitHub Apps for production use
- Token should be mounted as secret in container environments

## Limitations
- Container-only distribution (no npm package)
- Requires container runtime (Docker/Podman)
- Network complexity when running in containerized Claude
- Rate limits apply based on GitHub API limits
- Podman-in-Podman requires socket mounting or privileged mode

## Alternative Approaches
If Docker adds too much complexity, consider:
1. Running GitHub MCP server on host, connecting via network
2. Using a different GitHub MCP implementation that has npm package
3. Building a simple proxy service

## Resources
- [GitHub MCP Server Repository](https://github.com/github/github-mcp-server)
- [MCP Documentation](https://modelcontextprotocol.com)
- [GitHub Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)