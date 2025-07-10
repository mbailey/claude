# Claude API - Direct API Access

Documentation and examples for using Claude's API directly without CLI tools or desktop applications.

## Key Features

- Direct HTTP/REST API access
- Support for all Claude models
- Streaming and non-streaming responses
- Message batching capabilities
- Fine-grained control over parameters
- Token counting and usage tracking

## Quickstart

```bash
# Basic API call with curl
curl https://api.anthropic.com/v1/messages \
  -H "content-type: application/json" \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "max_tokens": 1024,
    "messages": [
      {"role": "user", "content": "Hello, Claude!"}
    ]
  }'
```

## Install

### API Key Setup

```bash
# Set your API key as environment variable
export ANTHROPIC_API_KEY="your-api-key-here"

# Or add to your shell profile
echo 'export ANTHROPIC_API_KEY="your-api-key-here"' >> ~/.bashrc
```

### SDK Installation

**Python**:
```bash
pip install anthropic
```

**Node.js**:
```bash
npm install @anthropic-ai/sdk
```

**TypeScript**:
```bash
npm install @anthropic-ai/sdk typescript
```

## Configure

### Environment Variables

- `ANTHROPIC_API_KEY`: Your API key (required)
- `ANTHROPIC_API_URL`: Custom API endpoint (optional)
- `ANTHROPIC_LOG_LEVEL`: Logging verbosity (optional)

### API Endpoints

- Base URL: `https://api.anthropic.com`
- Messages: `/v1/messages`
- Legacy Completions: `/v1/complete` (deprecated)

### Rate Limits

- Requests per minute: Varies by plan
- Tokens per minute: Varies by plan
- See [Rate Limits Documentation](https://docs.anthropic.com/en/api/rate-limits)

## Examples

### Python Example

```python
import anthropic

client = anthropic.Anthropic()

message = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=1024,
    messages=[
        {"role": "user", "content": "Explain quantum computing in simple terms"}
    ]
)
print(message.content)
```

### Node.js Example

```javascript
import Anthropic from '@anthropic-ai/sdk';

const anthropic = new Anthropic();

const message = await anthropic.messages.create({
  model: 'claude-3-5-sonnet-20241022',
  max_tokens: 1024,
  messages: [
    {role: 'user', content: 'Explain quantum computing in simple terms'}
  ],
});

console.log(message.content);
```

### Streaming Example

```python
import anthropic

client = anthropic.Anthropic()

with client.messages.stream(
    model="claude-3-5-sonnet-20241022",
    max_tokens=1024,
    messages=[
        {"role": "user", "content": "Tell me a story"}
    ]
) as stream:
    for text in stream.text_stream:
        print(text, end="", flush=True)
```

## Documentation

- **Official API Docs**: [Anthropic API Documentation](https://docs.anthropic.com/en/api)
- **API Reference**: [API Reference](https://docs.anthropic.com/en/api/messages)
- **SDKs**: [Python](https://github.com/anthropics/anthropic-sdk-python), [TypeScript/JavaScript](https://github.com/anthropics/anthropic-sdk-typescript)
- **Cookbook**: [Anthropic Cookbook](https://github.com/anthropics/anthropic-cookbook)

## Requirements

- Valid Anthropic API key
- Internet connection
- Supported programming language/environment
- Understanding of REST APIs (for direct HTTP usage)