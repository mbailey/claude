# MCP Servers

This document provides configuration details for Model Context Protocol (MCP) servers used in this project.

## Quick Reference

- [mcp-neovim-server](./mcp-neovim-server.md) - Neovim integration server
- [tmux](./tmux.md) - Terminal multiplexer control and interaction
- [voice-mode](./voice-mode.md) - Voice conversation with TTS/STT
- [brave-search](./brave-search.md) - Web search using Brave Search API
- [fetch](./fetch.md) - HTTP requests and web content fetching
- [filesystem](./filesystem.md) - File system operations with sandboxed access
- [git](./git.md) - Git repository operations
- [github](./github.md) - GitHub API integration
- [memory](./memory.md) - Persistent memory across conversations

## Adding Server Documentation

- [Adding Server Docs](./adding-server-docs.md) - Step-by-step guide
- [Documentation Template](./template.md) - Template for server documentation

## Usage Notes

### Environment Variables
Set required environment variables before using MCP servers:

```bash
export BRAVE_API_KEY="your-brave-api-key"
export GITHUB_PERSONAL_ACCESS_TOKEN="your-github-token"
```

### Container Images
Ensure the required container images are available:

```bash
# Pull MCP container images
podman pull mcp/brave-search
podman pull mcp/fetch
podman pull mcp/filesystem
podman pull mcp/git
podman pull ghcr.io/github/github-mcp-server
```


### Managing Servers from CLI

```bash
# List configured servers
claude mcp list

# Remove a server
claude mcp remove server-name

# Get server details
claude mcp get server-name
```
