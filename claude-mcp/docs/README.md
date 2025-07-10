# Model Context Protocol (MCP)

## What is MCP?

Model Context Protocol (MCP) is an open protocol that enables LLMs to access external tools and data sources. It follows a client-server architecture where Claude Code (the client) connects to specialized servers.

## Quick Links

- [MCP Configuration](./configuration.md) - How to configure MCP servers in Claude Code
- [MCP Servers](./servers/README.md) - Documentation for available MCP servers
- [MCP Logs](./logs.md) - How to view and troubleshoot MCP server logs
- [Recommended Servers](./recommended-servers.md) - Curated list of recommended MCP servers

## Getting Started

1. **Choose an MCP server** from the [servers directory](./servers/README.md)
2. **Configure it** using the [configuration guide](./configuration.md)
3. **Start using it** in your Claude Code conversations

## Key Concepts

- **Servers**: Specialized programs that provide tools, prompts, and resources to Claude
- **Scopes**: Control where server configurations are stored (local, project, or user)
- **Tools**: Functions that servers expose for Claude to use
- **Prompts**: Pre-configured instructions that become slash commands
- **Resources**: Data sources that servers can provide access to

## Learn More

- [MCP Official Documentation](https://modelcontextprotocol.io/)
- [MCP GitHub Repository](https://github.com/modelcontextprotocol/mcp)