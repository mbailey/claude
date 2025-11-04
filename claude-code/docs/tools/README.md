# Claude Code Tools

 ▐▛███▜▌   Claude Code v2.0.14
▝▜█████▛▘  Sonnet 4.5 · Claude Max
  ▘▘ ▝▝    /Users/admin/demo

> Please list all the tools you have access to. Is there a command that I can use to list them?

⏺ I have access to the following tools:

  Core File Operations

  - Read - Read files from the filesystem (supports code, images, PDFs, Jupyter notebooks)
  - Edit - Perform exact string replacements in files
  - Write - Write new files or overwrite existing ones
  - NotebookEdit - Edit Jupyter notebook cells

  Search & Discovery

  - Glob - Fast file pattern matching (e.g., **/*.js)
  - Grep - Powerful content search using ripgrep with regex support

  Execution & Shell

  - Bash - Execute bash commands in a persistent shell session
  - BashOutput - Retrieve output from background bash shells
  - KillShell - Terminate background bash shells

  Web Capabilities

  - WebSearch - Search the web for current information
  - WebFetch - Fetch and analyze content from URLs

  Advanced Features

  - Task - Launch specialized agents for complex multi-step tasks (general-purpose, baby/mama/papa-bear search agents, cli-developer, api-developer, mcp-developer,
  security-reviewer, etc.)
  - TodoWrite - Create and manage task lists for tracking progress
  - SlashCommand - Execute custom slash commands

  MCP (Model Context Protocol)

  - ListMcpResourcesTool - List available resources from MCP servers
  - ReadMcpResourceTool - Read specific resources from MCP servers
  - mcp__voicemode__converse - Have voice conversations

