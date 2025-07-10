# Claude Code Usage

## Commands

### Basic Commands

- `claude` - Start interactive session
- `claude-bedrock` - Start with Amazon Bedrock (requires `shell/aliases`)
- `claude doctor` - Update and check installation
- `claude --help` - Show all available options

### Keyboard Shortcuts

- `Ctrl-R` - Show/hide extra detail of what Claude is doing

## Slash Commands

Slash commands provide quick access to common prompts and tools.

### Built-in Commands

| Command          | Description                             |
| ---------------- | --------------------------------------- |
| `/clear`         | Clear conversation history              |
| `/compact`       | Toggle compact mode                     |
| `/cost`          | Show token usage and estimated cost     |
| `/init`          | Analyze codebase and generate CLAUDE.md |
| `/memory`        | Edit Claude memory files                |
| `/release-notes` | View release notes                      |
| `/help`          | Show all available slash commands       |

### Custom Commands

Create your own slash commands:

1. Create a file in `~/.claude/commands/COMMAND_NAME.md`
2. Support arguments: `/command arg1 "arg with spaces"`
3. Type `/` to explore all available commands

## Prompt Engineering

For complex reasoning tasks, use extended thinking:

```
think [deeply | hard]
```

See [Extended thinking tips](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview) for more details.