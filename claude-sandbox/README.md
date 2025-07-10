# Claude Sandbox - Secure Code Execution Environment

Isolated execution environment for Claude Code, providing safe code execution with configurable restrictions.

## Key Features

- Secure containerized execution
- File system isolation
- Network access control
- Resource limits (CPU, memory, time)
- Support for multiple languages
- Persistent workspace option
- Tool permission management

## Quickstart

```bash
# Enable sandbox in Claude Code
export CLAUDE_SANDBOX_ENABLED=true
claude

# Or use with specific config
claude --sandbox --sandbox-config ~/.claude/sandbox.yaml

# Test sandbox
echo 'print("Hello from sandbox!")' | claude run python
```

## How It Works

1. Code runs in isolated container/VM
2. Limited file system access (workspace only)
3. Controlled network access
4. Resource usage limits enforced
5. Clean environment for each session

## Configuration

### Environment Variables

- `CLAUDE_SANDBOX_ENABLED`: Enable/disable sandbox (default: false)
- `CLAUDE_SANDBOX_IMAGE`: Container image to use
- `CLAUDE_SANDBOX_MEMORY`: Memory limit (e.g., "2G")
- `CLAUDE_SANDBOX_TIMEOUT`: Execution timeout in seconds
- `CLAUDE_SANDBOX_WORKSPACE`: Persistent workspace path

### Configuration File

```yaml
# ~/.claude/sandbox.yaml
sandbox:
  enabled: true
  
  # Container settings
  container:
    image: anthropic/claude-sandbox:latest
    memory: 2G
    cpu: 1.0
    
  # Network policy
  network:
    enabled: true
    allowed_domains:
      - github.com
      - pypi.org
      - npmjs.org
    blocked_ports:
      - 25  # SMTP
      - 22  # SSH
      
  # File system
  filesystem:
    workspace: ~/.claude/workspace
    readonly_paths:
      - /usr
      - /etc
    writable_paths:
      - /tmp
      - $WORKSPACE
      
  # Language-specific
  languages:
    python:
      version: "3.11"
      packages: ["numpy", "pandas", "matplotlib"]
    node:
      version: "20"
      packages: ["axios", "express"]
```

## Security Model

### Isolation Levels

1. **Container** (default)
   - Process isolation
   - Filesystem isolation  
   - Network namespace
   - Resource limits

2. **VM** (high security)
   - Full virtualization
   - Hardware isolation
   - Snapshot/restore
   - Higher overhead

### Permissions

```yaml
permissions:
  # File operations
  file_read: ask  # ask, allow, deny
  file_write: ask
  
  # Network
  network_access: ask
  
  # System
  process_spawn: deny
  system_info: allow
```

## Supported Languages

### Pre-installed Runtimes
- Python 3.11, 3.10, 3.9
- Node.js 20, 18
- Ruby 3.2
- Go 1.21
- Rust (latest stable)
- Java 17, 11
- C/C++ (GCC 12)

### Package Management
- Python: pip, conda
- Node.js: npm, yarn
- Ruby: gem
- Rust: cargo
- Java: maven, gradle

## Usage Examples

### Running Code

```bash
# Python script
claude run script.py

# With specific version
claude run --python=3.10 script.py

# JavaScript
claude run app.js

# With arguments
claude run script.py --arg1 value1
```

### Interactive Sessions

```bash
# Python REPL
claude sandbox python

# Node REPL
claude sandbox node

# Bash shell (restricted)
claude sandbox bash
```

### File Operations

```bash
# Upload file to sandbox
claude sandbox upload local-file.txt

# Download from sandbox
claude sandbox download sandbox-file.txt

# List sandbox files
claude sandbox ls
```

## Container Details

### Base Image
- Built on Ubuntu 22.04 minimal
- Security updates applied
- Non-root user by default
- Read-only root filesystem

### Resource Limits
- Memory: 2GB default (configurable)
- CPU: 1 core default (configurable)  
- Disk: 1GB temporary space
- Execution time: 5 minutes default
- Network bandwidth: Limited

## Development

### Building Custom Images

```dockerfile
FROM anthropic/claude-sandbox:latest

# Add custom tools
RUN apt-get update && apt-get install -y \
    your-tool \
    && rm -rf /var/lib/apt/lists/*

# Add custom packages
RUN pip install your-package
```

### Local Testing

```bash
# Build sandbox image
cd packages/claude/claude-sandbox
./scripts/build.sh

# Run tests
./scripts/test.sh

# Test specific scenario
./tests/integration/basic-test.sh
```

## Troubleshooting

### Common Issues

**"Sandbox not available"**:
- Check CLAUDE_SANDBOX_ENABLED is true
- Verify Docker/Podman is installed
- Check container runtime permissions

**"Resource limit exceeded"**:
- Increase memory/CPU limits in config
- Optimize code to use less resources
- Break up large operations

**"Network access denied"**:
- Add domain to allowed_domains
- Check network policy settings
- Verify DNS resolution works

## Documentation

- **Architecture**: [Sandbox Architecture](./docs/architecture.md)
- **Security**: [Security Model](./docs/SECURITY.md)
- **API Reference**: [Sandbox API](./docs/api.md)
- **Examples**: [Example Configurations](./examples/)

## Requirements

- Claude Code with sandbox support
- Container runtime (Docker/Podman)
- 4GB RAM minimum
- 10GB disk space for images/workspace