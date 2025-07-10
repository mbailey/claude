#!/bin/bash
#
# Build script for Claude Sandbox container image

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Get absolute path to script, even when called via symlink
command -v realpath &> /dev/null || {
    echo "Error: 'realpath' is required but not found. Please install 'coreutils' (e.g. 'brew install coreutils' on macOS)." >&2
    exit 1
}
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

# Script directory
SANDBOX_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Detect container runtime
if command -v podman &>/dev/null; then
    RUNTIME="podman"
elif command -v docker &>/dev/null; then
    RUNTIME="docker"
else
    echo -e "${RED}Error: No container runtime found. Please install podman or docker.${NC}"
    exit 1
fi

echo -e "${BLUE}=== Claude Sandbox Container Build ===${NC}"
echo -e "Using runtime: ${GREEN}$RUNTIME${NC}"
echo

# Build the container
echo -e "${BLUE}Building container image...${NC}"
cd "$SANDBOX_ROOT/containers"

if $RUNTIME build -t claude-sandbox:latest -f Containerfile .; then
    echo -e "${GREEN}✓ Container image built successfully!${NC}"
    echo
    echo -e "${BLUE}Image details:${NC}"
    $RUNTIME images claude-sandbox:latest
    echo
    echo -e "${GREEN}You can now use claude-sandbox!${NC}"
    echo -e "Try: ${BLUE}claude-sandbox --help${NC}"
else
    echo -e "${RED}✗ Build failed!${NC}"
    exit 1
fi