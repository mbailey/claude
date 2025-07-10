# filesystem

Sandboxed filesystem operations with controlled access to specific directories.

## CLI Command
```bash
claude mcp add filesystem podman "run" "-i" "--rm" "--mount" "type=bind,src=$HOME/workspace/homedir,dst=/home/user" "--mount" "type=bind,src=$HOME/Code/github.com/livekit-examples/python-agents-examples/mcp,dst=/home/user/dna,ro" "mcp/filesystem" "/home/user"
```

## JSON Configuration
```json
{
  "filesystem": {
    "command": "podman",
    "args": [
      "run",
      "-i",
      "--rm",
      "--mount",
      "type=bind,src=$HOME/workspace/homedir,dst=/home/user",
      "--mount",
      "type=bind,src=$HOME/Code/github.com/livekit-examples/python-agents-examples/mcp,dst=/home/user/dna,ro",
      "mcp/filesystem",
      "/home/user"
    ]
  }
}
```

## Requirements
- Podman container runtime
- `mcp/filesystem` container image
- `$HOME/workspace/homedir` directory (read/write access)
- `$HOME/Code/github.com/livekit-examples/python-agents-examples/mcp` directory (read-only access)

### Required Directories
Create the workspace directory if it doesn't exist:
```bash
mkdir -p $HOME/workspace/homedir
```