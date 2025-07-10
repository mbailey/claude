# Adding Server Documentation

This guide walks through the process of documenting an MCP server for this directory.

## Steps to Document a Server

### 1. Install and Test the Server (Optional)

If you haven't already installed the server, or want to verify it works correctly:

```bash
# For npm packages
claude mcp add server-name -- npx -y @package/name

# For uvx packages
claude mcp add server-name -- uvx package-name

# For container-based servers
claude mcp add server-name podman run -i --rm image-name
```

### 2. Gather Server Information

Whether you've installed the server or are documenting from existing sources, collect:
- The exact command used to run the server
- Required environment variables
- Available tools, prompts, and resources
- Any dependencies or requirements

**From an installed server:**
```bash
# Check your Claude configuration
claude mcp get server-name

# Look at server output when starting Claude
claude --verbose
```

**From documentation sources:**
- GitHub repository README files
- NPM package pages (npmjs.com)
- PyPI package descriptions
- MCP server registry
- Official documentation sites
- Look for `mcp.json` or server manifest files in the repository

### 3. Create Documentation

1. Copy the [template.md](./template.md) file
2. Name it after your server: `server-name.md`
3. Fill in all sections:
   - Replace `[Server Name]` with the actual name
   - Write a clear description
   - Add the project URL
   - Document the exact CLI command you used
   - Convert the CLI command to JSON format
   - List all requirements (API keys, dependencies, etc.)
   - Document all available tools, prompts, and resources
   - Provide practical examples

### 4. Update the Index

Add your server to the [README.md](./README.md) quick reference section in alphabetical order:

```markdown
- [server-name](./server-name.md) - Brief description
```

## Tips for Good Documentation

### CLI to JSON Conversion

When converting CLI commands to JSON format:

```bash
# CLI format
claude mcp add example -- command arg1 arg2 -e ENV_VAR

# Becomes JSON
{
  "example": {
    "command": "command",
    "args": ["arg1", "arg2", "-e", "ENV_VAR"]
  }
}
```

### Environment Variables

If the server needs environment variables:

```json
{
  "example": {
    "command": "command",
    "args": ["arg1"],
    "env": {
      "API_KEY": "$API_KEY",
      "CONFIG_PATH": "/path/to/config"
    }
  }
}
```

### Tool Documentation

For each tool, include:
- Tool name (exactly as it appears in the server)
- Clear description of what it does
- Any parameters or options
- Example usage

### Testing Your Documentation

Before submitting:
1. Follow your own instructions to install the server
2. Verify all commands work as documented
3. Test the examples you provided
4. Check that tool names match exactly

## Common Patterns

### NPM-based Servers
```bash
claude mcp add server-name -- npx -y @org/package-name
```

### Python/uvx Servers
```bash
claude mcp add server-name -- uvx package-name
```

### Container-based Servers
```bash
claude mcp add server-name podman run -i --rm \
  --mount type=bind,src=$HOME/data,dst=/data \
  -e API_KEY \
  image:tag
```

### Local Development Servers
```bash
claude mcp add server-name -- node /path/to/server/index.js
```

## See Also
- [← Back to MCP Servers Index](./README.md)
- [Documentation Template](./template.md)
- [MCP Documentation](https://modelcontextprotocol.io/)