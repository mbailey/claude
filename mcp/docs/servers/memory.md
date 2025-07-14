# memory

Persistent memory storage across conversation sessions.

## CLI Command
```bash
claude mcp add memory npx "-y" "@modelcontextprotocol/server-memory"
```

## JSON Configuration
```json
{
  "memory": {
    "command": "npx",
    "args": [
      "-y",
      "@modelcontextprotocol/server-memory"
    ],
    "env": {
      "MEMORY_FILE_PATH": "$HOME/workspace/memory.json"
    }
  }
}
```

## Requirements
- Node.js and npm/npx
- `@modelcontextprotocol/server-memory` package
- Write access to `$HOME/workspace/` directory for memory persistence