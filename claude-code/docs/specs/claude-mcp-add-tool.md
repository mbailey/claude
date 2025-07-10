# Claude MCP Add Tool Specification

## Overview

The `claude-mcp-add` tool provides a streamlined way to add or re-add MCP (Model Context Protocol) servers to Claude's configuration. It reads from a central configuration file containing pre-defined MCP server configurations and supports tab completion for easy selection.

## Command Interface

```bash
claude-mcp-add [SERVER_NAME]
```

### Features

- **Tab Completion**: Autocomplete available MCP server names
- **Re-add Support**: Can re-add existing servers to refresh configuration
- **Multiple Runtime Support**: Handles both npx (Node) and uvx (Python) based servers
- **Environment Variable Expansion**: Supports environment variables in configurations
- **User/Project Scope**: Can add to user or project MCP configuration

## Configuration File Structure

### Location
`packages/claude/config/mcp-servers.json`

### Schema
```json
{
  "servers": {
    "server-name": {
      "description": "Brief description of the server",
      "runtime": "npx|uvx|podman|docker",
      "command": "command-to-run",
      "args": ["array", "of", "arguments"],
      "env": {
        "KEY": "value or $ENV_VAR"
      },
      "requirements": {
        "env": ["REQUIRED_ENV_VAR"],
        "directories": ["$HOME/workspace"],
        "containers": ["mcp/server-image"]
      },
      "scope": "user|project",
      "cache_tools_list": true|false
    }
  }
}
```

### Example Configuration
```json
{
  "servers": {
    "brave-search": {
      "description": "Web search using Brave Search API",
      "runtime": "podman",
      "command": "podman",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "BRAVE_API_KEY",
        "mcp/brave-search"
      ],
      "requirements": {
        "env": ["BRAVE_API_KEY"],
        "containers": ["mcp/brave-search"]
      },
      "scope": "user"
    },
    "memory": {
      "description": "Persistent memory across conversations",
      "runtime": "npx",
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-memory"
      ],
      "env": {
        "MEMORY_FILE_PATH": "$HOME/workspace/memory.json"
      },
      "requirements": {
        "directories": ["$HOME/workspace"]
      },
      "scope": "user"
    },
    "filesystem": {
      "description": "File system operations with sandboxed access",
      "runtime": "uvx",
      "command": "uvx",
      "args": [
        "mcp-server-filesystem",
        "--allowed-paths",
        "$HOME/Code",
        "--read-only"
      ],
      "scope": "project"
    },
    "github": {
      "description": "GitHub API integration",
      "runtime": "podman",
      "command": "podman",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "GITHUB_PERSONAL_ACCESS_TOKEN",
        "ghcr.io/github/github-mcp-server"
      ],
      "requirements": {
        "env": ["GITHUB_PERSONAL_ACCESS_TOKEN"],
        "containers": ["ghcr.io/github/github-mcp-server"]
      },
      "cache_tools_list": true,
      "scope": "user"
    }
  }
}
```

## Implementation Details

### Script Location
`packages/claude/bin/claude-mcp-add`

### Key Functions

1. **Server Selection**
   - Read available servers from config file
   - Display list if no argument provided
   - Validate server name exists

2. **Requirements Check**
   - Verify required environment variables are set
   - Check for required directories
   - Verify container images (for podman/docker)

3. **Configuration Update**
   - Read existing MCP configuration
   - Add/update server configuration
   - Write back to appropriate config file
   - Handle user vs project scope

4. **Tab Completion**
   - Extract server names from config
   - Integrate with bash completion system
   - Update claude.bash completion file

### Error Handling

- Missing required environment variables
- Non-existent server name
- Invalid configuration file
- Write permission issues
- Malformed JSON

## Tab Completion Implementation

### Completion Script Update
Add to `packages/claude/shell/completions/claude.bash`:

```bash
_claude_mcp_add_completions() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local config_file="$MT_PUBLIC_HOME/packages/claude/config/mcp-servers.json"
    
    if [[ -f "$config_file" ]]; then
        # Extract server names from JSON config
        local servers=$(jq -r '.servers | keys[]' "$config_file" 2>/dev/null)
        COMPREPLY=($(compgen -W "$servers" -- "$cur"))
    fi
}

# Register completion for claude-mcp-add
complete -F _claude_mcp_add_completions claude-mcp-add
```

## Usage Examples

```bash
# Add brave search server
claude-mcp-add brave-search

# Re-add github server (refresh configuration)
claude-mcp-add github

# Show available servers (no argument)
claude-mcp-add

# Tab completion
claude-mcp-add <TAB>
# Shows: brave-search filesystem git github memory ...
```

## Integration Points

1. **Claude MCP List**: Should show servers added via this tool
2. **Claude MCP Remove**: Should handle servers added via this tool
3. **Documentation**: Update servers.md with new additions
4. **Testing**: Add tests for configuration parsing and updates

## Future Enhancements

1. **Server Templates**: Support for custom server templates
2. **Validation**: Pre-flight checks for server functionality
3. **Profiles**: Multiple configuration profiles
4. **Interactive Mode**: Guided setup for complex servers
5. **Backup**: Automatic backup before configuration changes