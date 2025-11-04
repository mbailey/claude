# Claude - Comprehensive AI Assistant Access

This package provides documentation and resources for all methods of accessing Claude AI, Anthropic's advanced AI assistant.

## Access Methods

### 🖥️ [Claude Code](./claude-code/) - CLI Development Tool
The official command-line interface for AI-powered software development. Features include codebase understanding, file editing, web search, and git integration.

### 💻 [Claude Desktop](./claude-desktop/) - Native Application  
Native desktop app for Windows and macOS with quick keyboard access, desktop extensions, and seamless OS integration.

### 🌐 [Claude Web](./claude-web/) - Browser Interface
Access Claude through any modern browser at [claude.ai](https://claude.ai). No installation required, with full features including Projects and Artifacts.

### 📱 [Claude Mobile](./claude-mobile/) - iOS & Android Apps
Native mobile apps with voice input, image analysis, and cross-device sync. Available on App Store and Google Play.

### 🔧 [Claude API](./claude-api/) - Direct Integration
Programmatic access for developers to integrate Claude into applications. Supports multiple programming languages and streaming responses.

### 🔌 [Claude MCP](./claude-mcp/) - Model Context Protocol
Cross-platform protocol for extending Claude's capabilities through server integrations. Works with Claude Code and Claude Desktop.

### 🔒 [Claude Sandbox](./claude-sandbox/) - Secure Execution
Isolated environment for safe code execution with Claude Code. Provides containerized security and resource limits.

### ⚡ [Claude Skills](./skills/) - Dynamic Task Capabilities
Modular folders of instructions, scripts, and resources that Claude loads dynamically to improve performance on specialized tasks. Token-efficient alternative to MCP for extending capabilities.

## Quick Start

Choose your preferred access method:

```bash
# CLI Development
npm install -g @anthropic-ai/claude-code
claude

# Desktop App
# Download from https://claude.ai/download

# Web Browser
open https://claude.ai

# Mobile
# Search "Claude" in App Store or Play Store

# API Integration
pip install anthropic
# or
npm install @anthropic-ai/sdk
```

## Features Comparison

| Feature | Web | Desktop | Mobile | Code | API |
|---------|-----|---------|--------|------|-----|
| Chat Interface | ✓ | ✓ | ✓ | ✓ | - |
| File Upload | ✓ | ✓ | ✓ | ✓ | ✓ |
| Projects | ✓ | ✓ | - | - | - |
| Artifacts | ✓ | ✓ | - | - | - |
| Voice Input | - | - | ✓ | - | - |
| Code Execution | - | - | - | ✓ | - |
| Git Integration | - | - | - | ✓ | - |
| MCP Support | Limited | ✓ | - | ✓ | - |
| Offline Access | - | Partial | Partial | - | - |
| Custom Integration | - | - | - | - | ✓ |

## Getting Started

1. **Choose Your Platform**: Select the access method that best fits your needs
2. **Set Up Authentication**: Create an account at [claude.ai](https://claude.ai) or get an API key
3. **Install/Access**: Follow the specific guide for your chosen platform
4. **Start Using Claude**: Begin with simple queries and explore advanced features

## Common Use Cases

### For Developers
- **Claude Code**: Full-featured development environment
- **API**: Custom integrations and automation
- **MCP**: Extend capabilities with custom servers

### For General Users
- **Web**: Full features, no installation
- **Desktop**: Quick access, desktop integration
- **Mobile**: On-the-go access with voice

### For Teams
- **Web**: Team workspaces and collaboration
- **API**: Scalable integrations
- **Desktop**: Consistent experience across team

## Documentation Structure

Each access method has its own comprehensive documentation:

```
claude/
├── README.md              # This file
├── claude-api/            # API integration guide
├── claude-code/           # CLI tool documentation
├── claude-desktop/        # Desktop app guide
├── claude-mcp/            # MCP protocol docs
├── claude-mobile/         # Mobile app guide
├── claude-sandbox/        # Sandbox documentation
├── claude-web/            # Web interface guide
└── skills/                # Skills documentation and examples
```

## Security & Privacy

- All methods use secure HTTPS connections
- No training on user conversations (Pro/Team plans)
- Local data storage options available
- See individual platform docs for specific security features

## Support & Resources

- **Help Center**: [support.anthropic.com](https://support.anthropic.com)
- **API Documentation**: [docs.anthropic.com](https://docs.anthropic.com)
- **Status Page**: [status.anthropic.com](https://status.anthropic.com)
- **Community**: [community.anthropic.com](https://community.anthropic.com)

## Contributing

This repository contains documentation and examples. For issues or contributions:

1. Check existing documentation
2. Submit issues for corrections or clarifications
3. Propose new examples or guides
4. Follow the contribution guidelines

## External Tools

- **[voice-mcp](https://github.com/mbailey/voice-mcp)**: Voice control integration for Claude ([website](https://voice-mcp.com))

## License

Documentation is provided under MIT license. Claude itself is a proprietary service by Anthropic.
