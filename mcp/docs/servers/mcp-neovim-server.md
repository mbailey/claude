# mcp-neovim-server

Run nvim with a predictable socket location or update ENV var:

```shell
nvim --listen /tmp/nvim
```

```shell
claude mcp add "MCP Neovim Server" -- npx -y mcp-neovim-server -e ALLOW_SHELL_COMMANDS=false -e NVIM_SOCKET_PATH=/tmp/nvim
```

```json
"MCP Neovim Server": {
  "command": "npx",
  "args": [
    "-y",
    "mcp-neovim-server"
  ],
  "env": {
    "ALLOW_SHELL_COMMANDS": "true",
    "NVIM_SOCKET_PATH": "/tmp/nvim"
  }
```