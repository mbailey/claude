# Claude Code Tools

Claude Code has access to various tools for interacting with your development environment.

## Available Tools

| Tool | Description | Permission Required |
| --- | --- | --- |
| AgentTool | Runs a sub-agent to handle complex, multi-step tasks | No |
| BashTool | Executes shell commands in your environment | Yes |
| GlobTool | Finds files based on pattern matching | No |
| GrepTool | Searches for patterns in file contents | No |
| LSTool | Lists files and directories | No |
| FileReadTool | Reads the contents of files | No |
| FileEditTool | Makes targeted edits to specific files | Yes |
| FileWriteTool | Creates or overwrites files | Yes |
| NotebookReadTool | Reads and displays Jupyter notebook contents | No |
| NotebookEditTool | Modifies Jupyter notebook cells | Yes |

## Permissions

Claude Code requires permission to use certain tools that can modify your system:

- **Read-only tools** (no permission required): File search, reading, and analysis
- **Modification tools** (permission required): File editing, creation, and command execution

### Managing Permissions

1. **Interactive approval**: Claude will ask for permission when needed
2. **Skip permissions**: Use `--dangerously-skip-permissions` flag (use with caution)
3. **Session-specific**: Use `--allowedTools` flag to pre-approve specific tools

For more details on permission management, see the [MCP Configuration guide](./mcp/configuration.md#bypassing-mcp-approval-prompts).

## Tool Categories

### Search and Discovery
- **GlobTool**: Pattern-based file finding (e.g., `**/*.js`)
- **GrepTool**: Content search with regex support
- **LSTool**: Directory exploration

### File Operations
- **FileReadTool**: View file contents
- **FileEditTool**: Make precise edits to existing files
- **FileWriteTool**: Create new files or overwrite existing ones

### Execution
- **BashTool**: Run shell commands with timeout protection
- **AgentTool**: Delegate complex tasks to sub-agents

### Notebooks
- **NotebookReadTool**: View Jupyter notebook cells
- **NotebookEditTool**: Modify notebook content

## Best Practices

1. Claude will use read-only tools first to understand your codebase
2. Modification tools are used only when necessary
3. Complex searches may be delegated to AgentTool for efficiency
4. File paths are always absolute, not relative

## More Information

For detailed documentation, see [Tools available to Claude](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview#tools-available-to-claude).