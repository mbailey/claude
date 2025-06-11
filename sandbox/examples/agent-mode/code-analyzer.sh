#!/bin/bash
#
# Example: Using Claude Sandbox in agent mode for code analysis

set -euo pipefail

# Get absolute path to script, even when called via symlink
command -v realpath &> /dev/null || {
    echo "Error: 'realpath' is required but not found. Please install 'coreutils' (e.g. 'brew install coreutils' on macOS)." >&2
    exit 1
}
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
EXAMPLE_DIR="$(dirname "$SCRIPT_PATH")"

# Get paths
SANDBOX_BIN="$(cd "$EXAMPLE_DIR/../.." && pwd)/bin/claude-sandbox"

echo "=== Claude Sandbox Agent Mode Example ==="
echo "This example shows how to use Claude Sandbox programmatically."
echo

# Function to analyze code with Claude
analyze_code() {
    local directory="$1"
    local prompt="$2"
    
    echo "Analyzing: $directory"
    echo "Prompt: $prompt"
    echo
    
    # Run Claude in agent mode
    # Note: This would actually execute if ANTHROPIC_API_KEY is set
    echo "Command that would be run:"
    echo "$SANDBOX_BIN --print --memory 2g \"$directory\" -- \"$prompt\""
    echo
    
    # Example of capturing output
    echo "You could capture output like this:"
    cat << 'EOF'
    response=$($SANDBOX_BIN --print "$directory" -- "$prompt")
    echo "Claude says: $response"
EOF
    echo
}

# Example 1: Analyze a Python project
echo "Example 1: Analyzing Python code"
echo "--------------------------------"
analyze_code "/path/to/python/project" "Analyze this Python codebase and identify potential improvements"

# Example 2: Security audit
echo "Example 2: Security audit with no network"
echo "-----------------------------------------"
echo "Command: $SANDBOX_BIN --print --network none /path/to/project -- \"Perform a security audit of this codebase\""
echo

# Example 3: Generate documentation
echo "Example 3: Generate documentation with resource limits"
echo "-----------------------------------------------------"
cat << 'EOF'
$SANDBOX_BIN \
    --print \
    --memory 4g \
    --cpu 2.0 \
    --timeout 10m \
    /path/to/project \
    -- "Generate comprehensive API documentation for this project"
EOF
echo

# Example 4: Using with JSON output
echo "Example 4: JSON output for parsing"
echo "----------------------------------"
cat << 'EOF'
# Get JSON output
json_response=$($SANDBOX_BIN --print /path/to/project -- --output-format json "List all functions")

# Parse with jq
echo "$json_response" | jq '.functions[]'
EOF
echo

# Example 5: Batch processing
echo "Example 5: Batch processing multiple projects"
echo "--------------------------------------------"
cat << 'EOF'
#!/bin/bash
for project in /workspace/*/; do
    echo "Analyzing $project..."
    
    $SANDBOX_BIN \
        --print \
        --fresh \
        --log "logs/$(basename "$project").log" \
        "$project" \
        -- "Summarize this project in one paragraph" \
        > "summaries/$(basename "$project").txt"
done
EOF
echo

# Example 6: CI/CD Integration
echo "Example 6: CI/CD Integration"
echo "---------------------------"
cat << 'EOF'
# In your CI pipeline
- name: Code Review with Claude
  run: |
    claude-sandbox \
      --print \
      --network none \
      --timeout 5m \
      . \
      -- "Review the recent changes and suggest improvements" \
      > claude-review.txt
    
    # Post as PR comment
    gh pr comment --body-file claude-review.txt
EOF

echo
echo "Note: These examples require ANTHROPIC_API_KEY to be set."
echo "The sandbox ensures Claude runs safely even with --dangerously-skip-permissions."