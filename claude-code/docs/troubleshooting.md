# Troubleshooting Claude Code

## Debugging Slow Startup

If Claude Code is starting slowly, you can trace the startup process:

### Using strace

```shell
strace -f -o claude_trace.log claude
```

This will create a detailed log of system calls during startup.

### Common Issues

1. **MCP Server Loading**: Multiple MCP servers can slow startup
   - Check configured servers: `claude mcp list`
   - Temporarily disable servers to isolate issues

2. **Large Projects**: Extensive file trees can impact performance
   - Consider using more specific working directories
   - Use `.claudeignore` to exclude unnecessary files

## Installation Issues

See [Installation Guide](./install.md) for:
- Non-root npm configuration
- Permission issues on Linux
- Node.js version requirements

## Getting Help

- Check [Claude Code Troubleshooting](https://docs.anthropic.com/en/docs/claude-code/troubleshooting)
- Report issues at [GitHub Issues](https://github.com/anthropics/claude-code/issues)
- Use `/help` in Claude Code for command assistance

## Version Information

Check your current version:
```bash
claude --version
```

Update to the latest version:
```bash
npm update -g @anthropic-ai/claude-code
```

## Logs and Debug Information

### Enable Verbose Output
- Use `Ctrl-R` during a session to show/hide extra detail
- Start with `--verbose` flag for more detailed logging

### Log Locations
- Session logs: Check your terminal output
- Error logs: Typically displayed inline during operation