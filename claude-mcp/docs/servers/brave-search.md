# brave-search

Web search capabilities using the Brave Search API.

## CLI Command
```bash
claude mcp add brave-search --scope user -- npx -y @modelcontextprotocol/server-brave-search
```

## JSON Configuration
```json
{
  "brave-search": {
    "command": "npx",
    "args": [
      "-y",
      ""@modelcontextprotocol/server-brave-search",
      "mcp/brave-search"
    ]
  }
}
```

## Requirements
- `BRAVE_API_KEY` environment variable
- Podman container runtime
- `mcp/brave-search` container image