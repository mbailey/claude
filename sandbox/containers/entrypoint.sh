#!/bin/bash
#
# Entrypoint script for Claude Sandbox container
#
# This script handles container initialization, MCP server setup,
# and network filtering before executing Claude.

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Log function that respects print mode
log() {
    local level="$1"
    shift
    local message="$*"
    
    # In print mode, send all logs to stderr
    if [[ "${CLAUDE_PRINT_MODE:-false}" == "true" ]]; then
        echo -e "[$level] $message" >&2
    else
        case "$level" in
            INFO)
                echo -e "${BLUE}[INFO]${NC} $message" >&2
                ;;
            WARN)
                echo -e "${YELLOW}[WARN]${NC} $message" >&2
                ;;
            SUCCESS)
                echo -e "${GREEN}[OK]${NC} $message" >&2
                ;;
            *)
                echo -e "[$level] $message" >&2
                ;;
        esac
    fi
}

# Setup DNS filtering if whitelist is provided
setup_dns_filtering() {
    local whitelist="${CLAUDE_SANDBOX_WHITELIST:-}"
    
    if [[ -z "$whitelist" ]]; then
        return
    fi
    
    log INFO "Setting up DNS filtering..."
    
    # Create a custom resolv.conf with filtering
    # This is a simplified approach - in production you'd use a proper DNS filter
    if [[ -w /etc/resolv.conf ]]; then
        # Backup original
        cp /etc/resolv.conf /etc/resolv.conf.orig
        
        # Use a public DNS that we can control via iptables
        echo "nameserver 8.8.8.8" > /etc/resolv.conf
        echo "nameserver 8.8.4.4" >> /etc/resolv.conf
        
        log WARN "DNS filtering is experimental in this version"
    else
        log WARN "Cannot modify /etc/resolv.conf - DNS filtering disabled"
    fi
}

# Setup MCP servers
setup_mcp_servers() {
    local mcp_servers="${CLAUDE_MCP_SERVERS:-}"
    local mcp_config="${CLAUDE_MCP_CONFIG:-}"
    local mcp_passthrough="${CLAUDE_MCP_PASSTHROUGH:-false}"
    
    if [[ -z "$mcp_servers" ]] && [[ -z "$mcp_config" ]] && [[ "$mcp_passthrough" != "true" ]]; then
        return
    fi
    
    log INFO "Setting up MCP servers..."
    
    # Create MCP configuration directory
    mkdir -p "$HOME/.claude/mcp"
    
    # If config file is provided, process it
    if [[ -n "$mcp_config" ]] && [[ -f "$mcp_config" ]]; then
        log INFO "Loading MCP configuration from $mcp_config"
        
        # Parse YAML config and start servers
        # This is a simplified version - would need proper YAML parsing
        if command -v yq &>/dev/null; then
            # Process with yq if available
            log INFO "Processing MCP configuration with yq"
        else
            log WARN "yq not found - using basic parsing"
            # Basic parsing fallback
            cp "$mcp_config" "$HOME/.claude/mcp/servers.yaml"
        fi
    fi
    
    # Start individual MCP servers
    if [[ -n "$mcp_servers" ]]; then
        IFS=',' read -ra SERVERS <<< "$mcp_servers"
        for server in "${SERVERS[@]}"; do
            log INFO "Starting MCP server: $server"
            
            case "$server" in
                brave-search)
                    if [[ -n "${BRAVE_API_KEY:-}" ]]; then
                        # Start in background, output to log
                        npx -y @modelcontextprotocol/server-brave-search > "$HOME/.claude/mcp/$server.log" 2>&1 &
                        echo $! > "$HOME/.claude/mcp/$server.pid"
                        log SUCCESS "Started $server"
                    else
                        log WARN "Skipping $server - BRAVE_API_KEY not set"
                    fi
                    ;;
                memory)
                    MEMORY_FILE_PATH="${MEMORY_FILE_PATH:-/workspace/.claude-memory.json}"
                    export MEMORY_FILE_PATH
                    npx -y @modelcontextprotocol/server-memory > "$HOME/.claude/mcp/$server.log" 2>&1 &
                    echo $! > "$HOME/.claude/mcp/$server.pid"
                    log SUCCESS "Started $server"
                    ;;
                filesystem)
                    uvx mcp-server-filesystem --allowed-paths /workspace > "$HOME/.claude/mcp/$server.log" 2>&1 &
                    echo $! > "$HOME/.claude/mcp/$server.pid"
                    log SUCCESS "Started $server"
                    ;;
                *)
                    log WARN "Unknown MCP server: $server"
                    ;;
            esac
        done
    fi
    
    # Handle passthrough mode
    if [[ "$mcp_passthrough" == "true" ]]; then
        log INFO "MCP passthrough mode enabled"
        # Set up socket forwarding if needed
    fi
}

# Setup logging
setup_logging() {
    local log_file="${CLAUDE_LOG_FILE:-}"
    
    if [[ -n "$log_file" ]]; then
        log INFO "Session logging enabled: $log_file"
        
        # Create log directory
        mkdir -p "$(dirname "$log_file")"
        
        # Start logging wrapper
        exec > >(tee -a "$log_file")
        exec 2>&1
        
        # Log session start
        echo "=== Claude Sandbox Session Started ===" >> "$log_file"
        echo "Date: $(date)" >> "$log_file"
        echo "Working Directory: $(pwd)" >> "$log_file"
        echo "======================================" >> "$log_file"
    fi
}

# Cleanup function
cleanup() {
    log INFO "Shutting down MCP servers..."
    
    # Kill any MCP servers we started
    for pidfile in "$HOME"/.claude/mcp/*.pid; do
        if [[ -f "$pidfile" ]]; then
            pid=$(cat "$pidfile")
            if kill -0 "$pid" 2>/dev/null; then
                kill "$pid"
                log INFO "Stopped process $pid"
            fi
            rm -f "$pidfile"
        fi
    done
    
    # Restore DNS if modified
    if [[ -f /etc/resolv.conf.orig ]]; then
        mv /etc/resolv.conf.orig /etc/resolv.conf
    fi
}

# Set up signal handlers
trap cleanup EXIT INT TERM

# Main execution
main() {
    # Check if we're in print mode
    for arg in "$@"; do
        if [[ "$arg" == "--print" ]]; then
            export CLAUDE_PRINT_MODE=true
            break
        fi
    done
    
    log INFO "Initializing Claude Sandbox environment..."
    
    # Setup components
    setup_logging
    setup_dns_filtering
    setup_mcp_servers
    
    # Verify Claude is available
    if ! command -v claude &>/dev/null; then
        log ERROR "Claude command not found in container"
        exit 1
    fi
    
    # Show Claude version
    claude_version=$(claude --version 2>&1 || echo "unknown")
    log INFO "Claude version: $claude_version"
    
    # Execute Claude with all arguments
    log INFO "Starting Claude..."
    
    # In print mode, ensure clean output
    if [[ "${CLAUDE_PRINT_MODE:-false}" == "true" ]]; then
        exec claude "$@"
    else
        exec claude "$@"
    fi
}

# Run main with all arguments
main "$@"