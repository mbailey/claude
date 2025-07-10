# Claude Code Sandbox

Running Claude Code in a sandboxed environment provides security isolation and consistent development environments. This guide covers various approaches to sandboxing Claude Code.

## Why Use a Sandbox?

Claude Code requires permissions to:
- Execute shell commands
- Read and write files
- Access network resources
- Modify git repositories

While Claude includes safety features, running it in a sandbox provides:
- **Additional security layer** - Isolate Claude from your host system
- **Consistent environments** - Reproducible development setup
- **Permission automation** - Skip permission prompts in secure containers
- **Network isolation** - Control external access

## Official Devcontainer

Anthropic provides an official devcontainer configuration that works with VS Code and other compatible tools.

### Features
- Node.js 20 base image
- Pre-installed development tools (git, zsh, fzf, gh)
- Network security tools (iptables, ipset)
- Non-root user configuration
- Persistent bash history

### Usage with VS Code
1. Install the "Dev Containers" extension
2. Open your project folder
3. Run "Dev Containers: Open Folder in Container"
4. Claude Code will be available inside the container

## Community Sandbox Solutions

### textcortex/claude-code-sandbox
Run Claude Code without permission prompts in Docker containers.

```bash
# Clone the repository
git clone https://github.com/textcortex/claude-code-sandbox # [★ 27 | ⚡ 6]
cd claude-code-sandbox

# Build and run
docker build -t claude-sandbox .
docker run -it -v $(pwd):/workspace claude-sandbox
```

**Features:**
- Auto-approves all permissions
- Volume mounting for project files
- Network isolation options

### RchGrav/claudebox
Comprehensive Docker development environment with pre-configured profiles.

```bash
# Using claudebox
docker pull rchgrav/claudebox:latest
docker run -it \
  -v $(pwd):/workspace \
  -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
  rchgrav/claudebox
```

**Features:**
- Multiple development profiles
- Enhanced security with network firewall
- Restricts outbound connections to whitelisted domains
- Default-deny network policy

### deepworks-net/docker.claude-code
Windows-specific Docker setup without WSL requirement.

**Features:**
- PowerShell automation scripts
- Windows-native Docker Desktop support
- Proper permission handling
- Project file mounting

## DIY Docker Sandbox

Create a minimal secure sandbox:

```dockerfile
FROM node:20-slim

# Install essential tools
RUN apt-get update && apt-get install -y \
    git \
    curl \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /bin/bash claude && \
    echo "claude ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set up workspace
WORKDIR /workspace
RUN chown claude:claude /workspace

# Switch to non-root user
USER claude

# Install Claude Code
RUN npm install -g @anthropic-ai/claude-code

# Set environment
ENV ANTHROPIC_API_KEY=""
ENV NODE_ENV=development

CMD ["claude"]
```

Build and run:
```bash
docker build -t claude-sandbox .
docker run -it \
  -v $(pwd):/workspace \
  -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
  claude-sandbox
```

## Security Considerations

### Container Limitations
- Containers share the host kernel
- Not suitable for completely untrusted code
- Kernel vulnerabilities can allow container escape
- For maximum security, use VM-based isolation

### Best Practices
1. **Run as non-root user** - Never run Claude as root in containers
2. **Use network policies** - Restrict outbound connections
3. **Mount minimal volumes** - Only mount necessary project directories
4. **Set resource limits** - Prevent resource exhaustion
5. **Regular updates** - Keep base images and Claude Code updated

### Network Security

Example iptables rules for restricting network access:
```bash
# Allow only Anthropic API
iptables -A OUTPUT -d api.anthropic.com -j ACCEPT
iptables -A OUTPUT -d cdn.anthropic.com -j ACCEPT

# Allow DNS
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT

# Allow package registries (if needed)
iptables -A OUTPUT -d registry.npmjs.org -j ACCEPT
iptables -A OUTPUT -d github.com -j ACCEPT

# Default deny
iptables -A OUTPUT -j DROP
```

## Podman Alternative

For rootless containers, use Podman:

```bash
# Run with Podman (rootless by default)
podman run -it \
  -v $(pwd):/workspace:Z \
  -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
  --userns=keep-id \
  claude-sandbox
```

## Permission Automation

In secure sandbox environments, you can skip permission prompts:

```bash
# Only use in isolated environments!
claude --dangerously-skip-permissions
```

� **Warning**: Only use `--dangerously-skip-permissions` in properly isolated containers where you trust the code being executed.

## Monitoring and Logging

### Container Logs
```bash
# View Claude Code activity
docker logs -f <container-id>

# Save logs to file
docker logs <container-id> > claude-session.log
```

### File System Monitoring
```bash
# Monitor file changes
inotifywait -mr /workspace

# Track file access
auditctl -w /workspace -p rwa
```

## Troubleshooting

### Common Issues

**Permission Denied**
- Ensure proper volume mount permissions
- Check user ID mapping (especially with Podman)
- Verify file ownership in container

**Network Access**
- Check firewall rules if using network isolation
- Ensure DNS resolution works
- Verify API key is correctly set

**Performance**
- Use bind mounts instead of volumes for better I/O
- Allocate sufficient resources to container
- Consider using native installation for production work

## See Also

- [Claude Code Security Documentation](https://docs.anthropic.com/en/docs/claude-code/security)
- [Docker Security Best Practices](https://docs.docker.com/develop/security-best-practices/)
- [OCI Container Security](https://github.com/opencontainers/runtime-spec/blob/main/config.md#security) [★ 3.4k | ⚡ 572]