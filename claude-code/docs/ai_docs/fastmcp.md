# FastMCP - Python Framework for MCP Servers

## Overview

FastMCP is the fast, Pythonic way to build Model Context Protocol (MCP) servers and clients. It provides a high-level, decorator-based API that simplifies creating MCP servers that expose tools, resources, and prompts to LLMs.

**Key URLs:**
- GitHub Repository: https://github.com/jlowin/fastmcp
- PyPI Package: https://pypi.org/project/fastmcp/
- Documentation: https://gofastmcp.com/getting-started/welcome
- MCP Protocol: https://modelcontextprotocol.io/

## Installation

```bash
# Using pip
pip install fastmcp

# Using uv (recommended)
uv add fastmcp
```

Requirements:
- Python 3.10+
- Automatically includes FastAPI and Pydantic

## Core Concepts

### 1. Tools
Tools allow LLMs to perform actions by executing Python functions. They're ideal for computations, API calls, or operations with side effects.

```python
from fastmcp import FastMCP

mcp = FastMCP("MyServer")

@mcp.tool()
def add(a: int, b: int) -> int:
    """Add two numbers"""
    return a + b

@mcp.tool()
async def fetch_data(url: str) -> str:
    """Fetch data from a URL (async example)"""
    import httpx
    async with httpx.AsyncClient() as client:
        response = await client.get(url)
        return response.text
```

### 2. Resources
Resources expose read-only data sources. They're similar to GET endpoints in REST APIs.

```python
@mcp.resource("greeting://{name}")
def get_greeting(name: str) -> str:
    """Get a personalized greeting"""
    return f"Hello, {name}!"

@mcp.resource("data://users")
def list_users() -> str:
    """List all users"""
    return json.dumps({"users": ["alice", "bob", "charlie"]})
```

### 3. Prompts
Prompts create reusable, standardized interactions for common tasks.

```python
@mcp.prompt()
def code_review_prompt(language: str, code_snippet: str) -> str:
    """Generate a code review prompt"""
    return f"Please review this {language} code:\n\n{code_snippet}\n\nFocus on best practices and potential improvements."
```

## Basic Server Example

```python
# server.py
from fastmcp import FastMCP
from datetime import datetime
import json

# Create server instance
mcp = FastMCP("Demo Server")

# In-memory storage
data_store = {}

@mcp.tool()
def store_data(key: str, value: str) -> str:
    """Store data with a key"""
    data_store[key] = {
        "value": value,
        "timestamp": datetime.now().isoformat()
    }
    return f"Stored {key}"

@mcp.tool()
def retrieve_data(key: str) -> str:
    """Retrieve data by key"""
    if key in data_store:
        return json.dumps(data_store[key])
    return f"Key {key} not found"

@mcp.resource("data://all")
def get_all_data() -> str:
    """Get all stored data"""
    return json.dumps(data_store, indent=2)

if __name__ == "__main__":
    mcp.run()
```

## Running Servers

### Using FastMCP CLI
```bash
# Run with default settings (STDIO transport)
fastmcp run server.py

# Run with specific module:object notation
fastmcp run server:mcp
```

### Direct Python Execution
```bash
python server.py
uv run python server.py
```

### With Custom Host/Port (for HTTP/SSE)
```python
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "server:mcp",
        host="0.0.0.0",  # Important for containers
        port=8000
    )
```

## Transport Options

FastMCP supports multiple transport protocols:

1. **STDIO** (default) - Standard input/output communication
2. **HTTP** - RESTful API endpoints
3. **SSE** (Server-Sent Events) - Real-time streaming

### SSE Server Configuration
For SSE servers, see the dedicated guide: [FastMCP SSE Server](./fastmcp-sse-server.md)

## Client Usage

FastMCP also provides a client library for interacting with MCP servers:

```python
from fastmcp import Client

# Configuration for multiple servers
config = {
    "mcpServers": {
        "weather": {"url": "https://weather-api.example.com/mcp"},
        "database": {"command": "python", "args": ["./db_server.py"]}
    }
}

# Create client
client = Client(config)

async def main():
    async with client:
        # Call tools with server prefixes
        weather = await client.call_tool("weather_get_forecast", {"city": "London"})
        data = await client.call_tool("database_query", {"sql": "SELECT * FROM users"})
```

## Advanced Features

### 1. Context Parameter
Access session information and capabilities:

```python
from fastmcp import Context

@mcp.tool()
async def advanced_tool(query: str, context: Context) -> str:
    """Tool with context access"""
    # Log messages
    await context.info(f"Processing query: {query}")
    
    # Access resources
    data = await context.read_resource("data://config")
    
    # Sample from LLM
    response = await context.sample(
        messages=[{"role": "user", "content": f"Analyze: {query}"}],
        max_tokens=100
    )
    
    return response.content
```

### 2. Error Handling
```python
from fastmcp.exceptions import ResourceError

@mcp.tool()
def safe_operation(value: str) -> str:
    """Tool with error handling"""
    try:
        # Perform operation
        result = process_value(value)
        return result
    except ValueError as e:
        raise ResourceError(f"Invalid value: {e}")
```

### 3. Type Validation
FastMCP uses Pydantic for automatic type validation:

```python
from pydantic import BaseModel
from typing import List, Optional

class UserData(BaseModel):
    name: str
    age: int
    email: Optional[str] = None

@mcp.tool()
def create_user(user_data: UserData) -> str:
    """Create a user with validated data"""
    # user_data is automatically validated
    return f"Created user: {user_data.name}"
```

## Testing

FastMCP provides built-in testing utilities:

```python
# test_server.py
import pytest
from server import mcp

@pytest.mark.asyncio
async def test_add_tool():
    result = await mcp.test_call_tool("add", {"a": 5, "b": 3})
    assert result == 8

@pytest.mark.asyncio
async def test_resource():
    result = await mcp.test_read_resource("greeting://World")
    assert result == "Hello, World!"
```

## Configuration Files

### Basic MCP Configuration (.mcp.json)
```json
{
  "mcpServers": {
    "myserver": {
      "command": "python",
      "args": ["server.py"]
    }
  }
}
```

### With Environment Variables
```json
{
  "mcpServers": {
    "myserver": {
      "command": "python",
      "args": ["server.py"],
      "env": {
        "API_KEY": "${MY_API_KEY}",
        "DEBUG": "true"
      }
    }
  }
}
```

## Best Practices

1. **Use Type Hints**: Always add type hints for better validation and documentation
2. **Add Docstrings**: Document your tools, resources, and prompts clearly
3. **Handle Errors**: Use appropriate error handling and meaningful error messages
4. **Keep Tools Focused**: Each tool should do one thing well
5. **Use Async When Needed**: For I/O operations, use async functions
6. **Version Your Server**: Include version information in your server name
7. **Test Your Components**: Use the built-in testing utilities

## Common Use Cases

1. **Database Integration**: Query and manipulate databases
2. **API Wrappers**: Provide LLM access to external APIs
3. **File Operations**: Read, write, and process files
4. **System Commands**: Execute system operations safely
5. **Data Processing**: Transform and analyze data
6. **Notification Services**: Send emails, SMS, or other notifications

## Integration with LLM Applications

FastMCP servers integrate seamlessly with:
- Claude Desktop
- Cursor IDE
- Any MCP-compatible application

Simply add your server configuration to the application's MCP settings.

## Resources

- **Tutorials**: 
  - [FastMCP Tutorial: Building MCP Servers in Python](https://www.firecrawl.dev/blog/fastmcp-tutorial-building-mcp-servers-python)
  - [How to Create MCP Server Using FastMCP](https://docs.vultr.com/how-to-create-mcp-server-using-fastmcp-in-python)
  - [A Beginner's Guide to FastMCP](https://apidog.com/blog/fastmcp/)

- **Examples**:
  - [GitHub Repository Examples](https://github.com/jlowin/fastmcp/tree/main/examples)
  - [MCP Server in Python Guide](https://www.digitalocean.com/community/tutorials/mcp-server-python)

## Related Documentation

- [FastMCP SSE Server Guide](./fastmcp-sse-server.md) - Detailed guide for creating SSE-based MCP servers with FastMCP