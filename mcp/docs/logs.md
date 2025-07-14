# Claude Code Logs

## Viewing Logs

### Debug Mode
Run Claude Code with debug output:
```bash
claude --debug
```

### MCP Server Logs Location
MCP server logs are stored in:
```
~/.cache/claude-cli-nodejs/<project-path>/
```

For example:
```
~/.cache/claude-cli-nodejs/-home-user-Code-github-com-mbailey-voicemode/
```

This directory contains individual log files for each MCP server:
- `mcp-logs-brave-search`
- `mcp-logs-voice-mode`
- `mcp-logs-tmux-mcp`
- `mcp-logs-MCP Neovim Server`
- etc.

## Log Types

- **Debug logs**: Show detailed Claude Code operations (use `--debug` flag)
- **MCP server logs**: Capture communication between Claude Code and MCP servers
- **Error logs**: Help troubleshoot connection and runtime issues

## Convenient Access from Project

You can create a symlink to the MCP logs in your project directory:

```bash
claude-symlink-mcp-logs
```

This creates `.claude/cache` symlink pointing to your MCP logs, making them easily accessible:
```bash
ls .claude/cache/mcp-logs-*
```

## Tips

- Use `--debug` flag when troubleshooting Claude Code issues
- Check individual MCP server log files for server-specific problems
- Log directory paths are based on your current project location
- Use `claude-symlink-mcp-logs` for easy access to logs from your project