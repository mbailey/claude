# fetch

HTTP client for making web requests and fetching content.

## CLI Command
```bash
claude mcp add fetch podman "run" "-i" "--rm" "mcp/fetch"
```

## JSON Configuration
```json
{
  "fetch": {
    "command": "podman",
    "args": [
      "run",
      "-i",
      "--rm",
      "mcp/fetch"
    ]
  }
}
```

## Requirements
- Podman container runtime
- `mcp/fetch` container image