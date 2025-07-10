# Claude Code Installation Guide

This guide covers installing Claude Code with proper npm configuration to avoid requiring root/sudo access.

## Prerequisites

- Node.js 18 or higher
- npm (comes with Node.js)
- Optional but recommended:
  - git 2.23+ for version control integration
  - GitHub CLI (`gh`) for PR workflows
  - ripgrep (`rg`) for enhanced file search

## Configure npm for Non-Root Installation

By default, global npm packages require root access. To avoid this, configure npm to use a user-owned directory:

### Option 1: Using npm's prefix (Recommended)

1. Create a directory for global packages:
   ```bash
   mkdir -p ~/.npm-global
   ```

2. Configure npm to use this directory:
   ```bash
   npm config set prefix '~/.npm-global'
   ```

3. Add the bin directory to your PATH. Add this to your `~/.bashrc` or `~/.zshrc`:
   ```bash
   export PATH=~/.npm-global/bin:$PATH
   ```

4. Reload your shell configuration:
   ```bash
   source ~/.bashrc  # or source ~/.zshrc
   ```

### Option 2: Using npmrc file

Alternatively, create a `.npmrc` file in your home directory:

```bash
echo "prefix=${HOME}/.npm-global" >> ~/.npmrc
```

Then add the PATH export as shown above.

## Install Claude Code

Once npm is configured, install Claude Code without sudo:

```bash
npm install -g @anthropic-ai/claude-code
```

## Verify Installation

1. Check that Claude Code is installed:
   ```bash
   claude --version
   ```

2. Run the doctor command to verify your setup:
   ```bash
   claude doctor
   ```

## Initial Setup

1. **First Run**: Start Claude Code:
   ```bash
   claude
   ```
   You'll be prompted to authenticate on first use.

2. **Create Memory Files** (Optional):
   - Global user preferences: `~/.claude/CLAUDE.md`
   - Project-specific settings: `./CLAUDE.md` in your project root

3. **Configure Permissions** (Optional):
   Claude Code has conservative default permissions. To adjust:
   - During sessions: Select "Always allow" when prompted
   - Use the `/permissions` command in Claude
   - Edit `~/.claude/settings.json` manually

## Amazon Bedrock Setup (Optional)

If using Amazon Bedrock instead of the default API:

1. Ensure you have AWS credentials configured
2. Source the environment file before running Claude:
   ```bash
   source /path/to/claude/shell/env
   claude
   ```

Or use the alias if configured:
```bash
claude-bedrock
```

## Troubleshooting

### Permission Denied Errors

If you get EACCES errors during installation:

1. Verify npm prefix is set correctly:
   ```bash
   npm config get prefix
   ```
   Should show your user directory, not `/usr/local`

2. Ensure PATH includes your npm bin directory:
   ```bash
   echo $PATH | grep -q "$HOME/.npm-global/bin" && echo "PATH is set" || echo "PATH needs update"
   ```

### Node Version Issues

Claude Code requires Node.js 18+. Check your version:
```bash
node --version
```

If you need to update Node.js, consider using a version manager like `nvm` or `fnm`.

## Additional Tools

For the best experience, install these optional tools:

```bash
# GitHub CLI for PR workflows
# Install method varies by OS - see https://cli.github.com
gh --version

# ripgrep for fast file searching
# Install method varies by OS
rg --version
```

## Next Steps

- Read the [Claude Code Overview](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview)
- Review [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- Set up [MCP servers](./mcp/README.md) for extended functionality
- Create custom slash commands in `~/.claude/commands/`