# Claude Desktop - AI Assistant Application

Native desktop application for Claude AI, providing seamless access to Claude's capabilities directly from your computer without needing a web browser.

## Key Features

- Native desktop experience for Windows and macOS
- Quick keyboard shortcut access (Ctrl+Alt+Space)
- Desktop Extensions for integrating with local applications
- Model Context Protocol (MCP) support
- Direct file and folder access capabilities
- Integration with messaging apps and calendars
- One-click extension installation

## Quickstart

```bash
# Download from official site
open https://claude.ai/download

# Or direct download links:
# macOS: Download from App Store
# Windows: Download x64 or ARM64 version

# Launch with keyboard shortcut
Ctrl+Alt+Space (Windows/Linux)
Cmd+Space (macOS)
```

## Install

### macOS

```bash
# Via App Store (Recommended)
open "https://apps.apple.com/us/app/claude-by-anthropic/id6473753684"

# Or download directly
curl -L https://claude.ai/download/macos -o Claude.dmg
open Claude.dmg
# Drag Claude.app to Applications folder
```

### Windows

```bash
# Download installer (choose architecture)
# x64: For Intel/AMD processors
# ARM64: For ARM-based Windows devices

# Via PowerShell
Invoke-WebRequest -Uri "https://claude.ai/download/windows-x64" -OutFile "ClaudeSetup.exe"
.\ClaudeSetup.exe

# Or download ARM64 version
Invoke-WebRequest -Uri "https://claude.ai/download/windows-arm64" -OutFile "ClaudeSetup-ARM64.exe"
```

### Linux

Currently, Claude Desktop is not officially available for Linux. Linux users can:
- Use the web interface at claude.ai
- Use Claude Code CLI tool for terminal access
- Run Windows version via Wine (experimental)

## Configure

### Desktop Extensions

Claude Desktop supports extensions for enhanced functionality:

```bash
# Extensions are installed directly from within the app
# 1. Open Claude Desktop
# 2. Navigate to Extensions menu
# 3. Browse and install verified extensions
```

Available extension types:
- **Filesystem Access**: Read/write local files
- **iMessage Integration**: Access messages
- **Calendar Integration**: Connect to calendar apps
- **Email Integration**: Access email clients

### Environment Variables

- `CLAUDE_DESKTOP_DATA_DIR`: Custom data directory location
- `CLAUDE_MCP_ENABLED`: Enable/disable MCP support (default: true)

### Settings

Access settings within the app:
- Preferences → General: Theme, startup options
- Preferences → Extensions: Manage installed extensions
- Preferences → Privacy: Data handling options

## Containers

Claude Desktop is a native application and doesn't run in containers. For containerized Claude access, consider:

- Claude Code CLI in Docker
- Web interface via headless browser containers

## Local Development

- **Source**: Proprietary (closed source)
- **Extensions SDK**: Available for building custom extensions
- **MCP Servers**: Can develop custom MCP servers for integration

### Building Extensions

```bash
# Clone extension template
git clone https://github.com/anthropics/claude-extension-template
cd claude-extension-template

# Install dependencies
npm install

# Build extension
npm run build

# Package for distribution
npm run package
```

## Documentation

- **Official**: [Claude Desktop Help](https://support.anthropic.com/en/articles/10065433-installing-claude-for-desktop)
- **Extensions**: [Desktop Extensions Guide](https://www.anthropic.com/engineering/desktop-extensions)
- **MCP Protocol**: [Model Context Protocol Docs](https://modelcontextprotocol.io)
- **App Store**: [Claude on App Store](https://apps.apple.com/us/app/claude-by-anthropic/id6473753684)

## Requirements

### macOS
- macOS 12.0 or later
- Apple Silicon or Intel processor
- 4GB RAM minimum

### Windows
- Windows 10 version 1809 or later
- x64 or ARM64 processor
- 4GB RAM minimum
- .NET Framework 4.8+

### General
- Active internet connection
- Claude account (free or paid)
- 500MB available disk space