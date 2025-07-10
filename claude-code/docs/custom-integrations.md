# Claude Custom Integrations

- [About Custom Integrations Using Remote MCP Anthropic Help Center](https://support.anthropic.com/en/articles/11175166-about-custom-integrations-using-remote-mcp)

## Remote MCP Overview

Remote MCP (Model Context Protocol) enables Claude to connect directly to external tools and data sources.

### Key Features
- **Direct Integration**: Claude can access and interact with external applications
- **Data Operations**: Read, create, modify, or delete data in connected tools
- **Custom Servers**: Build your own MCP servers to integrate any tool
- **Beta Access**: Available for Claude Max, Team, and Enterprise plans

### Setup Process
1. Go to Claude.ai Settings → Integrations
2. Add custom integration with remote MCP server URL
3. Authenticate and grant permissions
4. For Teams/Enterprise: Only Owners can enable org-wide integrations

### Security Notes
- Only connect to trusted servers
- Review all permission requests carefully
- Watch for potential prompt injections
- Monitor tool behaviors for unexpected changes

### Resources
- [Model Context Protocol GitHub](https://github.com/modelcontextprotocol)
- [MCP Documentation](https://modelcontextprotocol.io/introduction)

### Current Limitations
- Advanced Research mode cannot invoke tools from local MCP servers
- Beta feature - expect changes and improvements


