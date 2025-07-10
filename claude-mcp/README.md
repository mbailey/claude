# Claude MCP - Model Context Protocol

Cross-platform protocol for extending Claude's capabilities through server integrations. Works with Claude Code, Claude Desktop, and other MCP-compatible clients.

## Key Features

- Standardized protocol for tool integrations
- Works across Claude Code and Claude Desktop
- Language-agnostic server implementations
- Built-in security and permissions
- Resource sharing and tool execution
- Async communication support

## Quickstart

```bash
# Install an MCP server (example: filesystem)
npm install -g @modelcontextprotocol/server-filesystem

# Configure in Claude Desktop or Claude Code
# Add to MCP settings:
{
  "mcpServers": {
    "filesystem": {
      "command": "mcp-server-filesystem",
      "args": ["--root", "/path/to/allowed/directory"]
    }
  }
}
```

## How MCP Works

1. **Servers** provide capabilities (tools, resources)
2. **Clients** (Claude Code, Desktop) connect to servers
3. **Protocol** handles communication between them
4. **Permissions** control what servers can do

## Available Servers

### Official Servers
- **filesystem** - File system access
- **github** - GitHub API integration
- **git** - Git repository operations
- **fetch** - Web content fetching
- **memory** - Persistent memory storage

### Community Servers
- **brave-search** - Web search via Brave
- **slack** - Slack workspace access
- **postgres** - PostgreSQL database access
- **shell** - Shell command execution
- See [servers/](./servers/) for full list

## Configure

### Claude Code Configuration

```json
// ~/.claude/settings.json
{
  "mcpServers": {
    "filesystem": {
      "command": "mcp-server-filesystem",
      "args": ["--root", "$HOME/Documents"]
    },
    "github": {
      "command": "mcp-server-github",
      "env": {
        "GITHUB_TOKEN": "$GITHUB_TOKEN"
      }
    }
  }
}
```

### Claude Desktop Configuration

```json
// ~/Library/Application Support/Claude/mcp-settings.json (macOS)
// %APPDATA%\Claude\mcp-settings.json (Windows)
{
  "servers": {
    "filesystem": {
      "command": "node",
      "args": ["/path/to/mcp-server-filesystem/index.js"],
      "rootPath": "/allowed/path"
    }
  }
}
```

## Creating MCP Servers

### Basic Server (Node.js)

```javascript
import { Server } from '@modelcontextprotocol/sdk';

const server = new Server({
  name: 'my-server',
  version: '1.0.0',
});

// Define tools
server.setRequestHandler('tools/list', async () => ({
  tools: [{
    name: 'my_tool',
    description: 'Does something useful',
    inputSchema: {
      type: 'object',
      properties: {
        input: { type: 'string' }
      }
    }
  }]
}));

// Handle tool calls
server.setRequestHandler('tools/call', async (request) => {
  if (request.params.name === 'my_tool') {
    return {
      content: [{
        type: 'text',
        text: `Processed: ${request.params.arguments.input}`
      }]
    };
  }
});

server.listen();
```

### Python Server

```python
from mcp.server import Server
from mcp.types import Tool, TextContent

server = Server("my-server")

@server.list_tools()
async def list_tools() -> list[Tool]:
    return [
        Tool(
            name="my_tool",
            description="Does something useful",
            input_schema={
                "type": "object",
                "properties": {
                    "input": {"type": "string"}
                }
            }
        )
    ]

@server.call_tool()
async def call_tool(name: str, arguments: dict) -> TextContent:
    if name == "my_tool":
        return TextContent(
            type="text",
            text=f"Processed: {arguments['input']}"
        )

if __name__ == "__main__":
    server.run()
```

## Security & Permissions

### Permission Model
- Servers declare required permissions
- Users approve permissions on first use
- Permissions are stored per server
- Can be revoked anytime

### Best Practices
1. Run servers with minimal permissions
2. Use environment variables for secrets
3. Validate all inputs
4. Log security-relevant operations
5. Use allowlists for file/URL access

## Development

### Testing Servers

```bash
# Test with MCP CLI
npx @modelcontextprotocol/cli test my-server

# Debug mode
MCP_DEBUG=true my-server

# With Claude Code
claude --mcp-debug
```

### Server Guidelines
1. Follow the MCP specification exactly
2. Handle errors gracefully
3. Provide clear tool descriptions
4. Validate inputs thoroughly
5. Return helpful error messages

## Documentation

- **Official Site**: [modelcontextprotocol.io](https://modelcontextprotocol.io)
- **Specification**: [MCP Specification](https://spec.modelcontextprotocol.io)
- **SDK Docs**: [SDK Documentation](https://sdk.modelcontextprotocol.io)
- **Server Registry**: [MCP Servers Directory](https://github.com/modelcontextprotocol/servers)

## Troubleshooting

### Connection Issues
- Check server is installed correctly
- Verify command path is absolute
- Check permissions on executable
- Review MCP logs

### Common Errors

**"Server not found"**:
```bash
# Make sure server is in PATH or use absolute path
which mcp-server-name
# Or specify full path in config
```

**"Permission denied"**:
```bash
# Check file permissions
chmod +x /path/to/server
# Check Claude has access to the directory
```

**"Connection timeout"**:
- Server may be taking too long to start
- Check server logs for errors
- Try running server manually first

## Resources

- [Creating Your First Server](./docs/getting-started.md)
- [Security Best Practices](./docs/security.md)
- [Server Examples](./examples/)
- [Community Servers](./servers/)