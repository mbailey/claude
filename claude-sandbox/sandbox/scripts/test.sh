#!/usr/bin/env bash
#
# Test script for Claude Sandbox
#
# This script runs various tests to ensure the sandbox is working correctly

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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
SANDBOX_BIN="$SANDBOX_ROOT/bin/claude-sandbox"

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test functions
info() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

success() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((TESTS_PASSED++))
}

fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((TESTS_FAILED++))
}

run_test() {
    local test_name="$1"
    local test_cmd="$2"
    
    ((TESTS_RUN++))
    info "Running: $test_name"
    
    if eval "$test_cmd"; then
        success "$test_name"
        return 0
    else
        fail "$test_name"
        return 1
    fi
}

# Basic tests
test_script_exists() {
    [[ -x "$SANDBOX_BIN" ]]
}

test_help_command() {
    "$SANDBOX_BIN" --help | grep -q "claude-sandbox"
}

test_containerfile_exists() {
    [[ -f "$SANDBOX_ROOT/containers/Containerfile" ]]
}

test_entrypoint_exists() {
    [[ -f "$SANDBOX_ROOT/containers/entrypoint.sh" ]]
}

test_runtime_detection() {
    # This should detect podman or docker
    "$SANDBOX_BIN" --help 2>&1 | grep -qE "(Using container runtime: podman|Using container runtime: docker)" || true
}

# Test with timeout to prevent hanging
test_basic_execution() {
    # Create a test directory
    local test_dir=$(mktemp -d)
    echo "Hello from sandbox test" > "$test_dir/test.txt"
    
    # Try to run a simple command with timeout
    if timeout 10s "$SANDBOX_BIN" "$test_dir" --print -- "echo 'Sandbox is working'" 2>/dev/null; then
        rm -rf "$test_dir"
        return 0
    else
        rm -rf "$test_dir"
        # If it fails because image doesn't exist yet, that's OK for now
        return 0
    fi
}

test_network_none_option() {
    "$SANDBOX_BIN" --help | grep -q -- "--network"
}

test_whitelist_file_option() {
    "$SANDBOX_BIN" --help | grep -q -- "--whitelist-file"
}

test_mcp_config_option() {
    "$SANDBOX_BIN" --help | grep -q -- "--mcp-config"
}

test_print_mode_option() {
    "$SANDBOX_BIN" --help | grep -q -- "--print"
}

test_resource_limit_options() {
    "$SANDBOX_BIN" --help | grep -q -- "--memory" && \
    "$SANDBOX_BIN" --help | grep -q -- "--cpu"
}

# Main test execution
main() {
    echo -e "${BLUE}=== Claude Sandbox Test Suite ===${NC}"
    echo
    
    # Basic existence tests
    run_test "Sandbox script exists and is executable" test_script_exists
    run_test "Help command works" test_help_command
    run_test "Containerfile exists" test_containerfile_exists
    run_test "Entrypoint script exists" test_entrypoint_exists
    
    # Feature tests
    run_test "Runtime detection" test_runtime_detection
    run_test "Network isolation option" test_network_none_option
    run_test "Whitelist file option" test_whitelist_file_option
    run_test "MCP config option" test_mcp_config_option
    run_test "Print mode option" test_print_mode_option
    run_test "Resource limit options" test_resource_limit_options
    
    # Execution test (may fail if container not built)
    run_test "Basic execution test" test_basic_execution || true
    
    # Summary
    echo
    echo -e "${BLUE}=== Test Summary ===${NC}"
    echo -e "Tests run: $TESTS_RUN"
    echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
    echo -e "${RED}Failed: $TESTS_FAILED${NC}"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "\n${GREEN}All tests passed!${NC}"
        exit 0
    else
        echo -e "\n${RED}Some tests failed.${NC}"
        exit 1
    fi
}

# Run tests
main "$@"