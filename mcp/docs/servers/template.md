# [Server Name]

Brief description of what this server does and its primary purpose.

**Project URL:** [https://github.com/[org]/[repo]](https://github.com/[org]/[repo])

## CLI Command
```bash
claude mcp add [server-name] [command] [args...]
```

## JSON Configuration
```json
{
  "[server-name]": {
    "command": "[command]",
    "args": [
      "[arg1]",
      "[arg2]"
    ],
    "env": {
      "[ENV_VAR]": "[value]"
    }
  }
}
```

## Requirements
- List any required environment variables
- List any required dependencies (e.g., container runtime, npm packages)
- List any required directories or file permissions
- List any external services or APIs needed

## Features
- List the main features or capabilities this server provides
- Include any notable limitations or constraints

## Available Tools
List all tools provided by this server:
- `tool_name` - Brief description of what this tool does
- `another_tool` - Description of another tool

## Available Prompts
List any prompts provided by this server:
- `prompt_name` - Brief description of the prompt

## Available Resources
List any resources exposed by this server:
- `resource_type://path` - Description of the resource

## Tool Approval
To approve specific tools for this server, add to your Claude settings:

```json
{
  "toolApprovals": {
    "[server-name]": {
      "tool_name": true,
      "another_tool": true
    }
  }
}
```

## Example Usage
Provide practical examples of how to use this server's capabilities.

## Configuration Options
Document any additional configuration options or environment variables that can customize the server's behavior.

## See Also
- [← Back to MCP Servers Index](./README.md)
- [MCP Documentation](https://modelcontextprotocol.io/)
- [Related Server Name](./related-server.md) - If this server works well with another
- Any other relevant links or documentation