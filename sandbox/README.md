# Claude Sandbox

Run Claude Code in a secure, isolated container environment with network isolation, resource limits, and MCP server support.

## Features

- 🔒 **Security First**: Runs Claude with `--dangerously-skip-permissions` safely in isolation
- 🌐 **Network Isolation**: Default no network access with optional domain whitelisting  
- 💾 **Resource Control**: Memory, CPU, disk, and time limits
- 🤖 **Agent Mode**: Full support for `--print` mode and Claude Pro/Max accounts
- 🔧 **MCP Servers**: Run MCP servers inside the container or pass through from host
- 📁 **File-based Config**: Load whitelists and configs from files with `@filename` syntax
- 🐳 **Container Support**: Works with both Podman (preferred) and Docker

## Quick Start

```bash
# Basic usage - sandbox current directory
claude-sandbox

# With network whitelist from file
claude-sandbox --network whitelist --whitelist-file ~/.claude-sandbox/allowed-domains.txt

# Agent mode with Pro account
claude-sandbox --print -- --model claude-sonnet-4-20250514 "Analyze this code"

# With MCP servers and resource limits
claude-sandbox --mcp-config ~/.claude-sandbox/mcp-servers.yaml --memory 2g --cpu 1.5
```

## Installation

1. Ensure you have Podman or Docker installed:
```bash
# For Podman (recommended)
sudo dnf install podman  # Fedora/RHEL
sudo apt install podman  # Debian/Ubuntu

# For Docker
# Follow instructions at https://docs.docker.com/engine/install/
```

2. Add claude-sandbox to your PATH:
```bash
export PATH="$PATH:/path/to/claude/sandbox/bin"
```

3. Build the container image (happens automatically on first run):
```bash
claude-sandbox --help
```

## Configuration

### Network Whitelisting

Create `~/.claude-sandbox/allowed-domains.txt`:
```
# Anthropic services
docs.anthropic.com
api.anthropic.com

# Development
github.com
*.githubusercontent.com

# Package registries  
registry.npmjs.org
pypi.org
```

Use with:
```bash
claude-sandbox --network whitelist --whitelist-file ~/.claude-sandbox/allowed-domains.txt
```

### MCP Servers

Create `~/.claude-sandbox/mcp-servers.yaml`:
```yaml
servers:
  - name: brave-search
    type: npx
    package: "@modelcontextprotocol/server-brave-search"
    env:
      BRAVE_API_KEY: "${BRAVE_API_KEY}"
    auto_start: true

  - name: memory
    type: npx  
    package: "@modelcontextprotocol/server-memory"
    env:
      MEMORY_FILE_PATH: "/workspace/.claude-memory.json"
    auto_start: true
```

Use with:
```bash
claude-sandbox --mcp-config ~/.claude-sandbox/mcp-servers.yaml
```

### Environment Variables

Pass through environment variables by prefix:
```bash
claude-sandbox --env-prefix CLAUDE_ --env-prefix PROJECT_
```

Or don't pass the API key:
```bash
claude-sandbox --no-api-key
```

## Agent Mode

Claude Sandbox fully supports agent mode for programmatic use:

```bash
# Basic agent mode
claude-sandbox --print -- "Generate a README"

# With JSON output
claude-sandbox --print -- --output-format json "Analyze security"

# Pipe to other tools
claude-sandbox --print -- "List all functions" | grep "def "

# Stream JSON output
claude-sandbox --print -- --output-format stream-json "Refactor this code"
```

Important: In agent mode, sandbox logs go to stderr, Claude output to stdout.

## Resource Limits

Control container resources:

```bash
# Memory limit
claude-sandbox --memory 2g    # 2 gigabytes
claude-sandbox --memory 512m  # 512 megabytes

# CPU limit  
claude-sandbox --cpu 1.5      # 1.5 CPU cores
claude-sandbox --cpu 0.5      # Half a CPU core

# Time limit
claude-sandbox --timeout 30m  # 30 minutes
claude-sandbox --timeout 2h   # 2 hours
```

## Persistence

By default, Claude's configuration persists in `~/.claude-sandbox/config`.

```bash
# Use custom persistence location
claude-sandbox --persist ~/my-claude-config

# Start fresh (no persistence)
claude-sandbox --fresh
```

## Advanced Usage

### Custom Container Image

```bash
# Use official Claude image (if available)
claude-sandbox --image ghcr.io/anthropics/claude-code:latest

# Use custom built image
claude-sandbox --image my-claude:custom
```

### File-based Configuration

Use `@filename` syntax for any list option:

```bash
claude-sandbox \
  --network whitelist \
  --whitelist @domains.txt \
  --mcp-servers @servers.txt \
  --env-prefix @prefixes.txt
```

### Session Logging

```bash
# Log session to file
claude-sandbox --log ~/logs/claude-session.log

# With timestamp
claude-sandbox --log ~/logs/claude-$(date +%Y%m%d-%H%M%S).log
```

### Complex Example

```bash
claude-sandbox ~/projects/myapp \
  --network whitelist \
  --whitelist-file ~/.claude-sandbox/prod-domains.txt \
  --mcp-config ~/.claude-sandbox/mcp-prod.yaml \
  --memory 8g \
  --cpu 4.0 \
  --timeout 1h \
  --log ~/logs/session.log \
  --persist ~/.claude-sandbox/prod-config \
  --env-prefix CLAUDE_ \
  --env-prefix AWS_ \
  --print \
  -- --model claude-sonnet-4-20250514 \
  "Analyze and optimize the application"
```

## Security Considerations

1. **Network Isolation**: By default, containers have no network access
2. **Filesystem Access**: Only the specified directory is mounted
3. **No Root Access**: Runs as non-root user inside container
4. **Dropped Capabilities**: Container runs with minimal Linux capabilities
5. **Resource Limits**: Prevent resource exhaustion attacks

## Troubleshooting

### Container Image Build Fails

```bash
# Check Podman/Docker installation
podman version
docker version

# Build manually
cd /path/to/claude/sandbox/containers
podman build -t claude-sandbox:latest -f Containerfile .
```

### Permission Denied Errors

```bash
# For Podman, ensure subuid/subgid are set up
grep $USER /etc/subuid /etc/subgid

# For SELinux systems, use :Z flag (already included)
```

### MCP Servers Not Starting

```bash
# Check logs
claude-sandbox --verbose

# Ensure required environment variables are set
export BRAVE_API_KEY=your-key-here
```

### Network Whitelist Not Working

Network filtering is experimental. For production use, consider:
- Using a proxy container
- Implementing iptables rules
- Using Podman network policies

## Testing

Run the test suite:

```bash
cd /path/to/claude/sandbox
./scripts/test.sh
```

## Contributing

1. Test changes thoroughly with `./scripts/test.sh`
2. Update documentation for new features
3. Follow existing code style and patterns
4. Add tests for new functionality

## License

Part of mt-public - see repository license.

## See Also

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Podman Documentation](https://docs.podman.io/)
- [Docker Documentation](https://docs.docker.com/)
- [MCP Protocol Specification](https://modelcontextprotocol.io/)