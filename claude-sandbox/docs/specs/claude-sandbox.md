# Claude Sandbox Specification

## Overview

Claude Sandbox is a security-focused wrapper that runs Claude Code in an isolated container environment using Podman or Docker. It provides network isolation, resource limits, and filesystem sandboxing while maintaining a seamless developer experience.

## Goals

1. **Security First**: Run Claude with `--dangerously-skip-permissions` safely in an isolated environment
2. **Network Isolation**: Default to no network access with explicit domain whitelisting
3. **Resource Control**: Enforce memory, CPU, disk, and time limits
4. **Ease of Use**: Simple command that "just works" with sensible defaults
5. **Flexibility**: Support various workflows and configurations
6. **Persistence**: Option to maintain state between runs or start fresh
7. **Agent Mode Support**: Full compatibility with Claude's `--print` mode for programmatic use
8. **Pro/Max Compatibility**: Work seamlessly with Claude Pro and Max accounts

## Command Interface

```bash
claude-sandbox [OPTIONS] [DIRECTORY] [-- CLAUDE_ARGS...]
```

### Core Options

```
--runtime <podman|docker>     Container runtime (auto-detect by default, prefer podman)
--network <mode>             Network mode: none (default), host, whitelist
--whitelist <domains|@file>  Allowed domains - comma-separated or @filename (requires --network whitelist)
--whitelist-file <file>      File containing allowed domains (one per line)
--no-api-key                 Don't pass through ANTHROPIC_API_KEY
--env-prefix <prefix>        Pass through env vars with prefix (default: CLAUDE_)
--mcp-servers <list|@file>   MCP servers - comma-separated or @filename
--mcp-config <file>          File containing MCP server configurations
--mcp-passthrough            Pass through host MCP server connections
--persist <path>             Persist configuration to path (default: ~/.claude-sandbox/config)
--fresh                      Start with fresh configuration (no persistence)
--image <image>              Use specific container image (default: auto-build)
--memory <limit>             Memory limit (e.g., 4g, 512m)
--cpu <limit>                CPU limit (e.g., 2.0)
--disk <limit>               Disk space limit (e.g., 10g)
--timeout <duration>         Maximum runtime (e.g., 1h, 30m)
--log <path>                 Save session log to path
--print                      Enable agent mode (pass through to claude)
--verbose                    Show detailed output
--help                       Show help message
```

### Examples

```bash
# Basic usage - sandbox current directory
claude-sandbox

# Sandbox specific directory with network whitelist from file
claude-sandbox ~/my-project --network whitelist --whitelist-file ~/.claude-sandbox/allowed-domains.txt

# Or using @ syntax
claude-sandbox ~/my-project --network whitelist --whitelist @~/.claude-sandbox/allowed-domains.txt

# Use with MCP servers from configuration file
claude-sandbox --mcp-config ~/.claude-sandbox/mcp-servers.yaml --memory 2g --timeout 30m

# Agent mode with Claude Pro/Max account
claude-sandbox --print -- --model claude-sonnet-4-20250514

# Fresh start with custom image and agent mode
claude-sandbox --fresh --image claude-sandbox:custom --print

# Pass through specific env vars with file-based configs
claude-sandbox --env-prefix CLAUDE_ --env-prefix PROJECT_ --whitelist @whitelist.txt

# Full example with file-based configuration
claude-sandbox ~/code/myproject \
  --network whitelist \
  --whitelist-file ~/.claude-sandbox/allowed-domains.txt \
  --mcp-config ~/.claude-sandbox/mcp-servers.yaml \
  --memory 8g \
  --cpu 4.0 \
  --timeout 2h \
  --log ~/logs/claude-session.log \
  --print
```

## Configuration Files

### Whitelist File Format

`~/.claude-sandbox/allowed-domains.txt`:
```
# Comments are supported
docs.anthropic.com
api.github.com
github.com
*.amazonaws.com  # Wildcards supported
```

### MCP Server Configuration

`~/.claude-sandbox/mcp-servers.yaml`:
```yaml
servers:
  - name: brave-search
    command: npx
    args: ["-y", "@modelcontextprotocol/server-brave-search"]
    env:
      BRAVE_API_KEY: "${BRAVE_API_KEY}"  # Env var expansion
  
  - name: memory
    command: npx
    args: ["-y", "@modelcontextprotocol/server-memory"]
    env:
      MEMORY_FILE_PATH: "/workspace/.claude-memory.json"
  
  - name: filesystem
    command: uvx
    args: ["mcp-server-filesystem", "--allowed-paths", "/workspace"]
```

### @-Syntax Support

For any option accepting lists, you can use `@filename` to load from a file:
```bash
--whitelist @domains.txt
--mcp-servers @servers.txt
--env-prefix @prefixes.txt
```

## Agent Mode Support

Claude Sandbox fully supports Claude's agent mode (`--print`) for programmatic use:

```bash
# Use as an agent with JSON output
claude-sandbox --print --output-format json -- "Analyze this codebase"

# Pipe to other tools
claude-sandbox --print -- "Generate a test file" | jq '.content'

# Use with Pro/Max models
claude-sandbox --print -- --model claude-sonnet-4-20250514 "Complex task"
```

### Important Agent Mode Considerations

1. **Output Handling**: In agent mode, sandbox metadata is sent to stderr, Claude output to stdout
2. **Exit Codes**: Preserves Claude's exit codes for scripting
3. **Streaming**: Supports streaming JSON output with `--output-format stream-json`
4. **Resource Limits**: Still enforced even in agent mode

## Architecture

### Directory Structure

```
packages/claude/sandbox/
├── bin/
│   └── claude-sandbox           # Main wrapper script
├── containers/
│   ├── Containerfile           # Podman/Docker build file
│   └── entrypoint.sh           # Container entrypoint script
├── config/
│   ├── default.yaml            # Default configuration
│   ├── network-filters.yaml    # Network filtering rules
│   └── examples/               # Example configuration files
│       ├── allowed-domains.txt
│       ├── mcp-servers.yaml
│       └── env-prefixes.txt
├── scripts/
│   ├── build.sh               # Build container image
│   ├── test.sh                # Run test suite
│   └── install.sh             # Install script
├── tests/
│   ├── unit/                  # Unit tests
│   └── integration/           # Integration tests
├── docs/
│   ├── README.md              # User documentation
│   ├── SECURITY.md            # Security considerations
│   └── DEVELOPMENT.md         # Developer guide
└── examples/
    ├── basic/                 # Basic usage examples
    ├── advanced/              # Advanced configurations
    └── agent-mode/            # Agent mode examples
```

## Implementation Details

### Container Runtime Detection

1. Check for `podman` in PATH
2. If not found, check for `docker` in PATH
3. If neither found, error with installation instructions
4. Allow override with `--runtime` flag

### Network Isolation

#### Default Mode (none)
- No network access whatsoever
- Suitable for offline code analysis and generation

#### Whitelist Mode
- Use container runtime's network filtering capabilities
- Implement DNS-based filtering for allowed domains
- Block all other traffic by default

#### Implementation Options
1. **iptables rules** in container (requires privileged mode)
2. **Proxy-based filtering** using mitmproxy or similar
3. **DNS filtering** with custom DNS resolver
4. **Network policies** (Podman/Docker specific)

### MCP Server Support

#### Internal MCP Servers
- Install uvx/npx in container image
- Mount MCP server configurations
- Start servers as part of container initialization

#### Host Passthrough
- Use Unix sockets or TCP forwarding
- Map MCP server ports/sockets into container
- Maintain security isolation

### Resource Limits

#### Memory
```bash
--memory 4g  # podman run --memory=4g
```

#### CPU
```bash
--cpu 2.0    # podman run --cpus=2.0
```

#### Disk
- Use container runtime's storage quota features
- Monitor and enforce during runtime

#### Time
- Implement via wrapper script timeout
- Graceful shutdown with warning

### Configuration Persistence

#### Default Behavior
- Save to `~/.claude-sandbox/config/`
- Include:
  - Claude configuration (`.claude.json`)
  - MCP server states
  - Session history
  - Custom settings

#### Fresh Mode
- Start with clean environment
- No configuration carried over
- Useful for testing and isolation

### Logging

#### Session Logs
- Capture all input/output
- Timestamp each interaction
- Save in structured format (JSON or plaintext)
- Rotate logs to prevent disk fill

#### Debug Logs
- Container build/start details
- Network requests (in whitelist mode)
- Resource usage statistics
- Error traces

## Security Considerations

### Container Security
1. Run as non-root user inside container
2. Drop unnecessary capabilities
3. Read-only root filesystem where possible
4. No privileged mode unless required for network filtering

### File System
1. Mount working directory as read-write
2. Mount Claude binary/config as read-only
3. Use tmpfs for temporary files
4. Prevent container escape via volume mounts

### Environment Variables
1. Sanitize all environment variables
2. Only pass through explicitly allowed vars
3. Mask sensitive values in logs

### Network Security
1. Default deny all
2. Validate domain whitelist entries
3. Log all network attempts
4. Prevent DNS rebinding attacks

## Build Process

### Container Image

```dockerfile
FROM debian:bookworm-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    python3 \
    python3-pip \
    git \
    curl \
    jq \
    tini \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code
RUN npm install -g @anthropic-ai/claude-code

# Install uvx for Python MCP servers
RUN pip3 install --break-system-packages uvx

# Create non-root user
RUN useradd -m -s /bin/bash claude-user

# Setup entrypoint
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

USER claude-user
WORKDIR /workspace

ENTRYPOINT ["tini", "--", "/usr/local/bin/entrypoint.sh"]
```

### Wrapper Script Core Logic

```bash
#!/bin/bash
# claude-sandbox - Main wrapper script

# Load configuration from file with @ syntax
load_from_file() {
    local arg="$1"
    if [[ "$arg" =~ ^@ ]]; then
        local file="${arg:1}"  # Remove @ prefix
        if [[ -f "$file" ]]; then
            cat "$file" | grep -v '^#' | grep -v '^$'
        else
            echo "Error: File not found: $file" >&2
            exit 1
        fi
    else
        echo "$arg"
    fi
}

# Runtime detection
detect_runtime() {
    if command -v podman &>/dev/null; then
        echo "podman"
    elif command -v docker &>/dev/null; then
        echo "docker"
    else
        echo "error: No container runtime found" >&2
        exit 1
    fi
}

# Build container if needed
ensure_image() {
    local runtime="$1"
    local image="claude-sandbox:latest"
    
    if ! $runtime image exists "$image" &>/dev/null; then
        echo "Building claude-sandbox image..." >&2
        $runtime build -t "$image" -f containers/Containerfile containers/
    fi
}

# Parse whitelist domains
parse_whitelist() {
    local whitelist="$1"
    local domains=""
    
    if [[ -f "$whitelist" ]]; then
        domains=$(cat "$whitelist" | grep -v '^#' | grep -v '^$' | tr '\n' ',')
    else
        domains=$(load_from_file "$whitelist")
    fi
    
    echo "$domains"
}

# Handle agent mode
setup_agent_mode() {
    local is_print_mode="$1"
    local run_cmd=("${@:2}")
    
    if [[ "$is_print_mode" == "true" ]]; then
        # In agent mode, redirect container runtime messages to stderr
        run_cmd+=("2>&1" "1>&3" "3>&-" "|" "cat" ">&2")
    fi
    
    echo "${run_cmd[@]}"
}

# Main execution
main() {
    local runtime="${RUNTIME:-$(detect_runtime)}"
    local network_mode="none"
    local mount_dir="${1:-$(pwd)}"
    local is_print_mode="false"
    local claude_args=()
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --print)
                is_print_mode="true"
                claude_args+=("--print")
                shift
                ;;
            --whitelist-file)
                whitelist_domains=$(parse_whitelist "$2")
                shift 2
                ;;
            --mcp-config)
                mcp_config_file="$2"
                shift 2
                ;;
            --)
                shift
                claude_args+=("$@")
                break
                ;;
            *)
                shift
                ;;
        esac
    done
    
    ensure_image "$runtime"
    
    # Build run command
    local run_cmd=(
        "$runtime" "run"
        "--rm"
        "--interactive"
        "--tty"
        "--network=$network_mode"
        "--memory=${MEMORY:-4g}"
        "--cpus=${CPU:-2.0}"
        "-v" "$mount_dir:/workspace:Z"
        "-e" "ANTHROPIC_API_KEY"
    )
    
    # Add MCP config if provided
    if [[ -n "$mcp_config_file" ]]; then
        run_cmd+=("-v" "$mcp_config_file:/etc/claude-sandbox/mcp-servers.yaml:ro")
    fi
    
    # Handle agent mode output redirection
    if [[ "$is_print_mode" == "true" ]]; then
        # Execute with proper stream handling for agent mode
        exec 3>&1
        "${run_cmd[@]}" "claude-sandbox:latest" claude "${claude_args[@]}" 2>&1 1>&3 3>&- | cat >&2
    else
        # Normal execution
        "${run_cmd[@]}" "claude-sandbox:latest" claude "${claude_args[@]}"
    fi
}
```

## Testing Strategy

### Unit Tests
1. Runtime detection logic
2. Option parsing
3. Configuration management
4. Network filter validation

### Integration Tests
1. Basic sandbox functionality
2. Network isolation verification
3. Resource limit enforcement
4. MCP server integration
5. Persistence mechanisms

### Security Tests
1. Container escape attempts
2. Network bypass attempts
3. Resource exhaustion
4. Permission escalation

## Future Enhancements

1. **GUI Integration**: Desktop app wrapper
2. **Cloud Mode**: Run sandbox in cloud environments
3. **Multi-Container**: Separate containers for MCP servers
4. **Audit Logs**: Comprehensive security audit trail
5. **Policy Engine**: Declarative security policies
6. **Snapshot/Restore**: Save and restore sandbox states

## Migration Path

For users currently using Claude Code directly:
1. Install claude-sandbox
2. Run `claude-sandbox migrate` to import existing config
3. Gradually adopt sandbox features
4. Maintain compatibility with standard Claude CLI

## Performance Considerations

1. **Image Caching**: Pre-built images for faster startup
2. **Layer Optimization**: Minimize container layers
3. **Volume Performance**: Use appropriate mount options
4. **Network Overhead**: Minimal impact in whitelist mode

## Compliance and Standards

1. Follow OCI container standards
2. Implement standard logging formats
3. Use conventional exit codes
4. Support standard Unix signals
5. Integrate with system security tools (SELinux, AppArmor)