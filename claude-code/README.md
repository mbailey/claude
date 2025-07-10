# Claude Code - AI Coding Assistant

Command-line interface to connect with Claude AI for software development tasks. An agentic coding tool that understands your codebase and helps you code faster through natural language commands.

## Key Features

- Natural language coding assistance with full codebase understanding
- Interactive file editing with intelligent context awareness
- Built-in web search and documentation lookup
- Project memory system for conventions and context
- Model Context Protocol (MCP) support for extensibility
- Multi-platform support (Linux, macOS, Windows/WSL)
- Git integration for commits and pull requests
- Jupyter notebook support

## Quickstart

```bash
# Install globally
npm install -g @anthropic-ai/claude-code

# Start interactive session
claude

# Verify installation
claude doctor
```

## Install

### NPM Install (Recommended)

Configure npm for user installation (avoids needing sudo):

```bash
# Set up user-owned npm directory
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Install Claude Code
npm install -g @anthropic-ai/claude-code
```

### Requirements

- Node.js 18 or higher
- npm (comes with Node.js)
- Optional but recommended:
  - git 2.23+ for version control integration
  - GitHub CLI (`gh`) for PR workflows
  - ripgrep (`rg`) for enhanced file search

See [Installation Guide](./docs/install.md) for detailed setup instructions.

## Configure

### Environment Variables

- `ANTHROPIC_API_KEY`: Your Claude API key
- `CLAUDE_MCP_ENABLED`: Enable MCP servers (default: true)
- `CLAUDE_OUTPUT_WIDTH`: Terminal output width
- `CLAUDE_SANDBOX_ENABLED`: Enable code sandbox
- `CLAUDE_BEDROCK_REGION`: AWS region for Bedrock usage

### Settings Files

- `~/.claude/settings.json` - Global user settings
- `~/.claude/CLAUDE.md` - Global user instructions
- `./CLAUDE.md` - Project-specific instructions

### Key Commands

- `/help` - Show available commands
- `/memory` - Manage project conventions
- `/permissions` - Configure tool permissions
- `/mcp` - Manage MCP servers
- `Ctrl-R` - Toggle extra detail during sessions

## Containers

Claude Code can be run in containers for isolated environments:

### Docker (Development)

```bash
# Build local image
docker build -t claude-code:local .

# Run with API key
docker run -it \
  -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
  -v $(pwd):/workspace \
  claude-code:local
```

### DevContainer Support

Claude Code supports VS Code DevContainers for consistent development environments. See [DevContainer docs](https://docs.anthropic.com/en/docs/claude-code/devcontainer) for setup.

## Local Development

- **Source**: Local package in mt-public monorepo
- **Package**: [@anthropic-ai/claude-code](https://www.npmjs.com/package/@anthropic-ai/claude-code)

To work on Claude Code locally:
```bash
cd packages/claude-code
npm install
npm link
```

## Documentation

- **Official Docs**: [Claude Code Documentation](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview)
- **Best Practices**: [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- **GitHub**: [anthropics/claude-code](https://github.com/anthropics/claude-code)
- **Local Docs**: See [docs/](./docs/) directory

### Key Documentation

- [Usage Guide](./docs/usage.md) - Commands and shortcuts
- [Memory System](./docs/memory.md) - Project conventions
- [Tools Overview](./docs/tools.md) - Available tools
- [MCP Servers](./docs/mcp/README.md) - Extensibility
- [Amazon Bedrock](./docs/amazon-bedrock.md) - AWS integration

## Requirements

- Node.js 18+
- npm
- Active internet connection for API access
- Anthropic API key or AWS credentials (for Bedrock)