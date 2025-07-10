#!/bin/bash
#
# Basic integration test for Claude Sandbox

set -euo pipefail

# Get absolute path to script, even when called via symlink
command -v realpath &> /dev/null || {
    echo "Error: 'realpath' is required but not found. Please install 'coreutils' (e.g. 'brew install coreutils' on macOS)." >&2
    exit 1
}
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

SANDBOX_BIN="$(cd "$SCRIPT_DIR/../.." && pwd)/bin/claude-sandbox"

echo "Testing Claude Sandbox..."

# Test 1: Help command
echo -n "Test 1 - Help command: "
if $SANDBOX_BIN --help | grep -q "claude-sandbox"; then
    echo "PASS"
else
    echo "FAIL"
    exit 1
fi

# Test 2: Check for required options
echo -n "Test 2 - Required options present: "
if $SANDBOX_BIN --help 2>&1 | grep -q -- "--network" && \
   $SANDBOX_BIN --help 2>&1 | grep -q -- "--print"; then
    echo "PASS" 
else
    echo "FAIL"
    exit 1
fi

# Test 3: Check container runtime availability
echo -n "Test 3 - Container runtime check: "
if command -v podman &>/dev/null || command -v docker &>/dev/null; then
    if command -v podman &>/dev/null; then
        echo "PASS (Podman found)"
    else
        echo "PASS (Docker found)"
    fi
else
    echo "WARN (No container runtime found)"
fi

echo "All tests passed!"