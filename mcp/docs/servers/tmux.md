# tmux MCP Server

Control tmux sessions through Claude. Enables AI assistants to create, manage, and interact with terminal sessions.

## Installation

```bash
# Using Claude Code
claude mcp add tmux --scope user -- npx -y tmux-mcp

# Or add to .mcp.json manually
```

## Configuration

```json
{
  "tmux": {
    "type": "stdio",
    "command": "npx",
    "args": [
      "-y",
      "tmux-mcp"
    ],
    "env": {}
  }
}
```

## Available Tools

- **list-sessions** - List all active tmux sessions
- **find-session** - Find a tmux session by name
- **list-windows** - List windows in a tmux session
- **list-panes** - List panes in a tmux window
- **capture-pane** - Capture content from a tmux pane
- **create-session** - Create a new tmux session
- **create-window** - Create a new window in a tmux session
- **execute-command** - Execute a command in a tmux pane
- **get-command-result** - Get the result of an executed command

## Usage Examples

```javascript
// Create a new session
await mcp.callTool('tmux', 'create-session', {
  name: 'demo'
})

// Execute a command
await mcp.callTool('tmux', 'execute-command', {
  paneId: 'demo:0.0',
  command: 'voice-mode-cli conversations'
})

// Capture pane content
await mcp.callTool('tmux', 'capture-pane', {
  paneId: 'demo:0.0'
})
```

## Requirements

- tmux must be installed and running
- Node.js and npm

## Notes

- Works best when tmux is already running
- Session names must be unique
- Supports multiple windows and panes
