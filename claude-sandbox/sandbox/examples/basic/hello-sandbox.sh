#!/bin/bash
#
# Basic example of using Claude Sandbox

# Get absolute path to script, even when called via symlink
command -v realpath &> /dev/null || {
    echo "Error: 'realpath' is required but not found. Please install 'coreutils' (e.g. 'brew install coreutils' on macOS)." >&2
    exit 1
}
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
EXAMPLE_DIR="$(dirname "$SCRIPT_PATH")"

# Get the sandbox binary path
SANDBOX_BIN="$(cd "$EXAMPLE_DIR/../.." && pwd)/bin/claude-sandbox"

echo "=== Claude Sandbox Basic Example ==="
echo
echo "This example demonstrates basic usage of Claude Sandbox."
echo

# Create a test project directory
TEST_DIR=$(mktemp -d)
echo "Creating test project in: $TEST_DIR"

# Create some sample files
cat > "$TEST_DIR/hello.py" << 'EOF'
def greet(name):
    """Return a greeting message."""
    return f"Hello, {name}! Welcome to Claude Sandbox."

if __name__ == "__main__":
    print(greet("World"))
EOF

cat > "$TEST_DIR/README.md" << 'EOF'
# Test Project

This is a test project for Claude Sandbox demonstration.

## Features
- Secure execution environment
- Network isolation
- Resource limits
EOF

echo "Created sample files."
echo

# Example 1: Basic usage with no network
echo "1. Running Claude with no network access (most secure):"
echo "   Command: claude-sandbox $TEST_DIR"
echo "   This would start an interactive Claude session in the test directory."
echo

# Example 2: Agent mode with print
echo "2. Using agent mode to analyze code:"
echo "   Command: claude-sandbox --print $TEST_DIR -- \"What does the hello.py file do?\""
echo "   This runs Claude in agent mode and prints the response."
echo

# Example 3: With resource limits
echo "3. Running with resource limits:"
echo "   Command: claude-sandbox --memory 1g --cpu 0.5 $TEST_DIR"
echo "   This limits Claude to 1GB RAM and half a CPU core."
echo

# Example 4: With network whitelist
echo "4. Allowing specific network access:"
echo "   Command: claude-sandbox --network whitelist --whitelist \"docs.anthropic.com,github.com\" $TEST_DIR"
echo "   This allows access only to specified domains."
echo

# Clean up
echo "Cleaning up test directory..."
rm -rf "$TEST_DIR"

echo
echo "To actually run these commands, remove the echo statements and try them!"
echo "Note: The container image will be built on first run."