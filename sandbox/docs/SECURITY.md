# Security Considerations for Claude Sandbox

## Overview

Claude Sandbox is designed to run Claude Code with `--dangerously-skip-permissions` in a secure, isolated environment. This document outlines the security measures and considerations.

## Security Features

### 1. Container Isolation

- **Namespace Isolation**: Each container runs in its own namespace (PID, network, mount, etc.)
- **Non-root Execution**: Claude runs as a non-privileged user inside the container
- **Capability Dropping**: Container runs with `--cap-drop=ALL` to remove all Linux capabilities
- **No New Privileges**: `--security-opt=no-new-privileges` prevents privilege escalation

### 2. Network Isolation

- **Default Deny**: By default, containers have no network access (`--network=none`)
- **Whitelist Mode**: When enabled, only explicitly allowed domains can be accessed
- **DNS Filtering**: Experimental DNS-based filtering for whitelisted domains

### 3. Filesystem Isolation

- **Limited Mounts**: Only the specified working directory is mounted
- **Read-only Options**: System directories and configs can be mounted read-only
- **No Access to Host**: Container cannot access host filesystem outside mounted directories

### 4. Resource Limits

- **Memory Limits**: Prevent memory exhaustion attacks
- **CPU Limits**: Prevent CPU exhaustion
- **Timeout**: Maximum execution time to prevent runaway processes
- **Disk Quotas**: Can be configured at the container runtime level

## Security Best Practices

### 1. API Key Management

```bash
# Don't pass API key if not needed
claude-sandbox --no-api-key

# Use environment variable (not command line)
export ANTHROPIC_API_KEY=sk-ant-...
claude-sandbox
```

### 2. Network Whitelisting

Create a minimal whitelist:

```bash
# ~/.claude-sandbox/allowed-domains.txt
docs.anthropic.com
api.anthropic.com
# Only add domains you absolutely need
```

### 3. Filesystem Access

```bash
# Only mount what's needed
claude-sandbox /specific/project/dir

# Not the entire home directory
# BAD: claude-sandbox ~
```

### 4. Resource Limits

Always set appropriate limits:

```bash
claude-sandbox \
  --memory 2g \     # Limit memory
  --cpu 1.0 \       # Limit CPU
  --timeout 30m \   # Limit execution time
  /project
```

## Threat Model

### What Claude Sandbox Protects Against

1. **Malicious Code Execution**: Claude cannot execute arbitrary code on the host
2. **Data Exfiltration**: Network isolation prevents unauthorized data transmission
3. **Resource Exhaustion**: Resource limits prevent DoS attacks
4. **Privilege Escalation**: Container security features prevent gaining host access
5. **Filesystem Access**: Limited to explicitly mounted directories

### What Claude Sandbox Does NOT Protect Against

1. **Malicious Container Images**: Always verify the source of container images
2. **Container Runtime Vulnerabilities**: Keep Podman/Docker updated
3. **Mounted Directory Access**: Claude can read/write the mounted directory
4. **API Key Exposure**: If passed, the API key is accessible inside the container

## Security Checklist

Before running Claude Sandbox:

- [ ] Review mounted directories - only mount what's needed
- [ ] Set appropriate resource limits
- [ ] Use network isolation unless specific domains are required
- [ ] Review whitelist domains if using network whitelist mode
- [ ] Consider using `--fresh` for sensitive operations
- [ ] Enable logging for audit trails
- [ ] Keep container runtime (Podman/Docker) updated
- [ ] Review any custom configurations or images

## Reporting Security Issues

If you discover a security vulnerability in Claude Sandbox:

1. Do NOT open a public issue
2. Contact the maintainers privately
3. Provide detailed reproduction steps
4. Allow time for a fix before public disclosure

## Advanced Security Options

### SELinux Integration

For systems with SELinux:

```bash
# The :Z flag ensures proper SELinux labels
# This is already included in the script
```

### AppArmor Profiles

For systems with AppArmor, you can create custom profiles:

```bash
# Example AppArmor profile for additional restrictions
# Place in /etc/apparmor.d/claude-sandbox
```

### Audit Logging

Enable comprehensive audit logging:

```bash
claude-sandbox \
  --log /secure/audit/claude-$(date +%Y%m%d-%H%M%S).log \
  --verbose \
  /project
```

### Network Monitoring

For production use, consider:

1. Running a filtering proxy container
2. Using Podman/Docker network policies
3. Implementing iptables rules at the host level
4. Using a dedicated bridge network with restrictions

## Container Security Scanning

Periodically scan the container image:

```bash
# Using Podman
podman scan claude-sandbox:latest

# Using Docker with Trivy
trivy image claude-sandbox:latest
```

## Updates and Patches

1. Regularly rebuild the container image to get security updates
2. Monitor Claude Code releases for security fixes
3. Update the base image (debian:bookworm-slim) regularly
4. Review and update npm/pip packages

## Conclusion

Claude Sandbox provides multiple layers of security to safely run Claude Code with elevated permissions. However, security is a shared responsibility - always follow best practices and regularly review your security posture.