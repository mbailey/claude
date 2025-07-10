# FastMCP SSE Server

## Overview
FastMCP is a Python framework for building Model Context Protocol (MCP) servers. It provides a simple way to create MCP servers that can expose tools, resources, and prompts via HTTP endpoints, including Server-Sent Events (SSE) for real-time communication.

## Installation
```bash
pip install fastmcp
# or with UV (recommended)
uv pip install fastmcp
```

Requirements:
- Python 3.10+
- FastAPI (included with fastmcp)
- Pydantic (included with fastmcp)

## Creating a Simple SSE MCP Server

### Basic Example
```python
# sse_demo_server.py
from fastmcp import FastMCP

# Create server instance
mcp = FastMCP("Demo SSE Server")

@mcp.tool()
def get_weather(city: str) -> str:
    """Get the weather for a city."""
    # Mock implementation
    return f"The weather in {city} is sunny and 72°F"

@mcp.tool()
def calculate(expression: str) -> str:
    """Evaluate a mathematical expression."""
    try:
        result = eval(expression)
        return f"Result: {result}"
    except Exception as e:
        return f"Error: {str(e)}"

# Run with: fastmcp run sse_demo_server:mcp
```

### Advanced Example with Resources
```python
# advanced_sse_server.py
from fastmcp import FastMCP
from datetime import datetime
import json

mcp = FastMCP("Advanced SSE Server")

# In-memory data store
data_store = {}

@mcp.resource("data://items")
def list_items() -> str:
    """List all stored items."""
    return json.dumps(data_store, indent=2)

@mcp.tool()
def store_item(key: str, value: str) -> str:
    """Store an item in memory."""
    data_store[key] = {
        "value": value,
        "timestamp": datetime.now().isoformat()
    }
    return f"Stored {key}"

@mcp.tool()
def get_item(key: str) -> str:
    """Retrieve an item from memory."""
    if key in data_store:
        return json.dumps(data_store[key])
    return f"Item {key} not found"

@mcp.prompt()
def data_analysis_prompt(topic: str) -> str:
    """Generate a prompt for data analysis."""
    return f"Analyze the data related to {topic} and provide insights."

# Run with custom host/port for container
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "advanced_sse_server:mcp",
        host="0.0.0.0",  # Important for container access
        port=8000
    )
```

## Container Deployment

### Dockerfile
```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install FastMCP
RUN pip install fastmcp

# Copy server code
COPY sse_demo_server.py .

# Expose port
EXPOSE 8000

# Run server
CMD ["uvicorn", "sse_demo_server:mcp", "--host", "0.0.0.0", "--port", "8000"]
```

### Docker Compose Example
```yaml
version: '3.8'
services:
  sse-mcp-server:
    build: .
    ports:
      - "8000:8000"
    environment:
      - MCP_ENV=production
```

## MCP Configuration

### .mcp.json Configuration
```json
{
  "mcpServers": {
    "sse-demo": {
      "url": "http://localhost:8000/sse",
      "transport": "sse"
    }
  }
}
```

### With Custom Headers
```json
{
  "mcpServers": {
    "sse-demo": {
      "url": "http://localhost:8000/sse",
      "transport": "sse",
      "headers": {
        "Authorization": "Bearer ${SSE_AUTH_TOKEN}",
        "X-Custom-Header": "value"
      }
    }
  }
}
```

## Running in Podman

### Build and Run
```bash
# Build image
podman build -t sse-mcp-server .

# Run container
podman run -d \
  --name sse-mcp \
  -p 8000:8000 \
  sse-mcp-server

# Check logs
podman logs sse-mcp
```

### As Part of Pod
```bash
# Create pod
podman pod create --name claude-mcp -p 8000:8000

# Run SSE server in pod
podman run -d \
  --pod claude-mcp \
  --name sse-mcp \
  sse-mcp-server
```

## Testing the SSE Server

### Using curl
```bash
# Test SSE endpoint
curl -N http://localhost:8000/sse

# Test tool listing
curl http://localhost:8000/tools
```

### Using Python Client
```python
import httpx
import json

# Test SSE connection
with httpx.stream("GET", "http://localhost:8000/sse") as response:
    for line in response.iter_lines():
        if line.startswith("data: "):
            data = json.loads(line[6:])
            print(data)
```

## Key Features

1. **Automatic SSE Endpoint**: FastMCP automatically creates `/sse` endpoint
2. **Tool Discovery**: Tools are automatically exposed via MCP protocol
3. **Type Safety**: Uses Pydantic for type validation
4. **Hot Reload**: Supports development with auto-reload
5. **Built-in Documentation**: Automatic OpenAPI docs at `/docs`

## Environment Variables

FastMCP servers can use environment variables:
```python
import os

@mcp.tool()
def get_config() -> str:
    """Get configuration from environment."""
    api_key = os.getenv("API_KEY", "not-set")
    env = os.getenv("MCP_ENV", "development")
    return f"Environment: {env}, API Key: {'set' if api_key != 'not-set' else 'not set'}"
```

## Container Considerations

1. **Host Binding**: Use `host="0.0.0.0"` for container deployments
2. **Port Mapping**: Ensure ports are properly exposed and mapped
3. **Health Checks**: Add health endpoint for container orchestration
4. **Logging**: Configure proper logging for container environments
5. **Security**: Don't expose sensitive endpoints without authentication

## Minimal SSE Server for Testing

```python
# minimal_sse.py
from fastmcp import FastMCP

mcp = FastMCP("Minimal SSE")

@mcp.tool()
def echo(message: str) -> str:
    """Echo back the message."""
    return message

@mcp.tool()
def ping() -> str:
    """Simple ping test."""
    return "pong"

# That's it! Run with: fastmcp run minimal_sse:mcp
```

## Troubleshooting

1. **Connection Refused**: Ensure server binds to `0.0.0.0` not `127.0.0.1` in containers
2. **CORS Issues**: FastMCP handles CORS by default, but check browser console
3. **SSE Timeout**: Some proxies may timeout long-lived connections
4. **Port Conflicts**: Use different ports if 8000 is already in use

## Resources
- [FastMCP Documentation](https://github.com/jlowin/fastmcp)
- [MCP Specification](https://modelcontextprotocol.com)
- [SSE Protocol](https://developer.mozilla.org/en/docs/Web/API/Server-sent_events)