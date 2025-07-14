# tmux MCP Server

Control tmux sessions through Claude. Enables AI assistants to create, manage, and interact with terminal sessions.

## Installation

```bash
# Using Claude Code
claude mcp add tmux -- npx -y @nickgnd/tmux-mcp

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
      "@nickgnd/tmux-mcp"
    ],
    "env": {}
  }
}
```

## Available Tools

- **list_sessions** - List all tmux sessions
- **create_session** - Create a new tmux session
- **attach_session** - Attach to a session
- **send_keys** - Send keystrokes to a pane
- **capture_pane** - Capture pane content
- **kill_session** - Terminate a session
- **split_window** - Split current window
- **select_pane** - Switch between panes

## Usage Examples

```javascript
// Create a new session
create_session({
  "session_name": "demo",
  "window_name": "main"
})

// Send commands
send_keys({
  "session_name": "demo",
  "keys": "voice-mode-cli conversations"
})

// Capture output
capture_pane({
  "session_name": "demo"
})
```

## Requirements

- tmux must be installed and running
- Node.js and npm

## Notes

- Works best when tmux is already running
- Session names must be unique
- Supports multiple windows and panes