# git

Git repository operations within a sandboxed environment.

## CLI Command
```bash
claude mcp add git podman "run" "--rm" "-i" "--mount" "type=bind,src=$HOME/workspace,dst=/home/user" "mcp/git"
```

## JSON Configuration
```json
{
  "git": {
    "command": "podman",
    "args": [
      "run",
      "--rm",
      "-i",
      "--mount",
      "type=bind,src=$HOME/workspace,dst=/home/user",
      "mcp/git"
    ]
  }
}
```

## Requirements
- Podman container runtime
- `mcp/git` container image
- `$HOME/workspace` directory with git repositories

### Required Directories
Create the workspace directory if it doesn't exist:
```bash
mkdir -p $HOME/workspace
```