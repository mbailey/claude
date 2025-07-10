# MCP Configuration

This guide explains how to configure MCP servers for Claude Code in your projects.

## Configuration Scopes

Claude Code supports three configuration scopes:

| Scope     | Flag              | Storage Location | Availability              | Notes                        |
| --------- | ----------------- | ---------------- | ------------------------- | ---------------------------- |
| `local`   | `--scope local`   | `~/.claude.json` | Only you, current project | Default scope                |
| `project` | `--scope project` | `.mcp.json` file | Everyone with repo access | Checked into version control |
| `user`    | `--scope user`    | `~/.claude.json` | You across all projects   | Previously called `global`   |

## Managing MCP Servers

### From Within Claude Code

Show status of MCP servers:

```
> /mcp
  ⎿ MCP Server Status

    • github: connected
```

### From Command Line

List configured MCP servers:

```shell
$ claude mcp list
github: podman run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server
```

Add/update GitHub MCP server in project scope:

```bash
claude mcp add \
  --scope project \
  -- \
  github \
  podman \
  run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server
```

This updated the entry for `github` in `.mcp.json` in the project root.

```json
{
  "mcpServers": {
    "github": {
      "type": "stdio",
      "command": "podman",
      "args": ["run", "-i", "--rm", "-e", "GITHUB_PERSONAL_ACCESS_TOKEN", "ghcr.io/github/github-mcp-server"],
      "env": {}
    }
  }
}
```

## Precedence Rules

When servers with the same name exist in multiple scopes:

1. Local-scoped servers take precedence over project and user scopes
2. Project-scoped servers take precedence over user-scoped servers

## Security Considerations

### MCP Server Approval

When using project-scoped servers from `.mcp.json`, Claude Code will prompt you for approval:

```
This project wants to use the following MCP servers:
- github: podman run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server

Would you like to:
1. Allow for this session only
2. Allow for this project permanently  
3. Don't allow

Choose (1-3):
```

- **Option 1**: Allows the server for the current session only
- **Option 2**: Intended to save your choice for future sessions (Note: Some users report being prompted again in subsequent sessions)
- **Option 3**: Prevents the server from running

To reset previously saved approval choices:
```bash
claude mcp reset-project-choices
```

### Bypassing MCP Approval Prompts

There are several methods to bypass MCP server approval prompts:

#### 1. Using the `--dangerously-skip-permissions` Flag (⚠️ Use with caution)

```bash
claude --dangerously-skip-permissions
```

**WARNING**: This flag bypasses ALL permission checks, allowing Claude to:
- Execute any configured MCP servers without prompting
- Modify files without confirmation
- Run potentially dangerous operations

Only use this flag when:
- You fully trust all configured MCP servers
- Running in controlled environments
- Automating workflows where manual approval isn't feasible

#### 2. Project Approval (Option 2)

When prompted, you can choose option 2 "Allow for this project permanently". While this is intended to save your approval, some users report being prompted again in subsequent sessions.

#### 3. Configuration File Method

You can pre-approve servers by editing your Claude settings:

**Project-level** (`.claude/settings.json`):
```json
{
  "approvedServers": {
    "github": true,
    "filesystem": true
  }
}
```

**User-level** (`~/.claude.json`):
```json
{
  "trustedProjects": {
    "/path/to/project": {
      "approvedServers": ["github", "filesystem"]
    }
  }
}
```

#### 4. Session-specific Approval

Use the `--allowedTools` flag to approve specific tools for the current session:
```bash
claude --allowedTools github,filesystem
```

### Additional Security Settings

- Set environment variables with `-e` or `--env` flags
- Configure server startup timeout with `MCP_TIMEOUT` environment variable

## Tips

- My favourite servers can be found in [`.mcp.json`](../../.mcp.json)
- Starting out with `--scope project` lets you view the config in `.mcp.json`