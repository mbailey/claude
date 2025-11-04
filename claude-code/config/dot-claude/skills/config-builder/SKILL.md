---
name: config-builder
description: Create configuration systems following VoiceMode and MCPro patterns. Use when building new Python projects that need flexible configuration with .env files, environment variables, CLI arguments, and cascading precedence. Implements dotenv-based config with Click CLI integration and helper functions for path expansion and boolean parsing.
---

# Config Builder

## Overview

Create configuration systems that follow the VoiceMode and MCPro patterns: cascading .env files, environment variable support, CLI argument overrides, and helper utilities for common config tasks.

## Use Cases

Use this skill when:
- Building a new Python CLI application that needs configuration
- Creating MCP servers or tools requiring flexible configuration
- Implementing multi-environment configuration (development, production, project-specific)
- Need dotenv-style config with command-line overrides

## Configuration Pattern

The VoiceMode/MCPro configuration pattern provides:

1. **Cascading Configuration Files** - Global to project-specific
2. **Environment Variable Support** - Standard Unix pattern
3. **CLI Argument Override** - Click integration for commands
4. **Helper Functions** - Path expansion, boolean parsing, comma-separated lists
5. **Secure Defaults** - Auto-generate config files with sensible defaults

## Core Components

### 1. Cascading .env Files

Configuration loads in order (later files override earlier ones):

```python
def find_config_files() -> list[Path]:
    """
    Find configuration files by walking up the directory tree.

    Priority (closest to current directory wins):
    1. {app}.env in current or parent directories
    2. .{app}/{app}.env in current or parent directories
    3. ~/.{app}/{app}.env in user home (global config)

    Returns:
        List of Path objects in loading order (global first, then project-specific)
    """
    config_files = []

    # First add global config (lowest priority - loaded first)
    global_config = Path.home() / f".{app}" / f"{app}.env"
    if global_config.exists():
        config_files.append(global_config)

    # Walk up directory tree for project-specific configs
    current_dir = Path.cwd()
    while current_dir != current_dir.parent:
        # Check for standalone .{app}.env
        standalone_file = current_dir / f".{app}.env"
        if standalone_file.exists():
            config_files.append(standalone_file)
            break  # Stop at first found

        # Check .{app}/{app}.env
        dir_file = current_dir / f".{app}" / f"{app}.env"
        if dir_file.exists() and dir_file != global_config:
            config_files.append(dir_file)
            break

        current_dir = current_dir.parent

    return config_files
```

### 2. Load Configuration

```python
def load_config():
    """Load configuration from files, with cascading from global to project-specific."""
    config_files = find_config_files()

    # If no config files exist, create default global config
    if not config_files:
        default_path = Path.home() / f".{app}" / f"{app}.env"
        default_path.parent.mkdir(parents=True, exist_ok=True)
        with open(default_path, 'w') as f:
            f.write(DEFAULT_CONFIG_TEMPLATE)
        os.chmod(default_path, 0o600)  # Secure permissions
        config_files = [default_path]

    # Load all files in order
    for config_path in config_files:
        if config_path.exists():
            with open(config_path, 'r') as f:
                for line in f:
                    line = line.strip()
                    if not line or line.startswith('#'):
                        continue
                    if '=' in line:
                        key, value = line.split('=', 1)
                        key = key.strip()
                        value = value.strip()
                        # Only set if not in environment (env vars take precedence)
                        if key and key not in os.environ:
                            os.environ[key] = value
```

### 3. Helper Functions

```python
def env_bool(env_var: str, default: bool = False) -> bool:
    """Parse boolean from environment variable."""
    value = os.getenv(env_var, "").lower()
    return value in ("true", "1", "yes", "on") if value else default

def expand_path(path_str: str) -> Path:
    """Expand tilde and environment variables in path strings."""
    expanded = os.path.expandvars(path_str)
    expanded = os.path.expanduser(expanded)
    return Path(expanded)

def parse_comma_list(env_var: str, fallback: str) -> list:
    """Parse comma-separated list from environment variable."""
    value = os.getenv(env_var, fallback)
    return [item.strip() for item in value.split(",") if item.strip()]
```

### 4. Click CLI Integration

```python
import click
from pathlib import Path

@click.group()
@click.option('--config', type=click.Path(path_type=Path), help='Config file path')
@click.option('--debug/--no-debug', default=None, help='Enable debug mode')
@click.pass_context
def cli(ctx, config, debug):
    """Main CLI entry point."""
    # Load config from file if specified
    if config:
        load_config_from_path(config)
    else:
        load_config()  # Use cascading config discovery

    # CLI arguments override config file
    if debug is not None:
        os.environ['APP_DEBUG'] = str(debug).lower()

@cli.command()
@click.option('--output', type=click.Path(path_type=Path), help='Output directory')
def run(output):
    """Run the application."""
    output_dir = expand_path(os.getenv('APP_OUTPUT_DIR', '~/output'))
    if output:
        output_dir = output

    debug_mode = env_bool('APP_DEBUG', False)
    # ... rest of command
```

### 5. Configuration Precedence

The system follows this precedence (highest to lowest):

1. **CLI Arguments** - Explicitly passed flags/options
2. **Environment Variables** - Set in shell or parent process
3. **Project Config** - `.app.env` in project directory
4. **Global Config** - `~/.app/app.env` in user home
5. **Default Values** - Hard-coded in application

## Example Implementation

For a new application called "myapp":

```python
# config.py
import os
from pathlib import Path

# Load configuration on import
load_myapp_env()

# Helper functions
def env_bool(env_var: str, default: bool = False) -> bool:
    value = os.getenv(env_var, "").lower()
    return value in ("true", "1", "yes", "on") if value else default

def expand_path(path_str: str) -> Path:
    expanded = os.path.expandvars(path_str)
    expanded = os.path.expanduser(expanded)
    return Path(expanded)

# Application configuration
BASE_DIR = expand_path(os.getenv("MYAPP_BASE_DIR", "~/.myapp"))
DEBUG = env_bool("MYAPP_DEBUG", False)
OUTPUT_FORMAT = os.getenv("MYAPP_OUTPUT_FORMAT", "json")
API_ENDPOINTS = parse_comma_list("MYAPP_API_ENDPOINTS",
                                  "http://localhost:8080,https://api.example.com")
```

## Config File Template

Generate a default config file with comments:

```python
DEFAULT_CONFIG_TEMPLATE = '''# MyApp Configuration File
# Environment variables always take precedence over this file

#############
# Core Configuration
#############

# Base directory for all application data (default: ~/.myapp)
# MYAPP_BASE_DIR=~/.myapp

# Enable debug mode (true/false)
# MYAPP_DEBUG=false

# Output format: json, yaml, text (default: json)
# MYAPP_OUTPUT_FORMAT=json

#############
# Service Configuration
#############

# Comma-separated list of API endpoints
# MYAPP_API_ENDPOINTS=http://localhost:8080,https://api.example.com

# API timeout in seconds (default: 30)
# MYAPP_API_TIMEOUT=30

#############
# Advanced Configuration
#############

# Custom working directory
# MYAPP_WORKDIR=~/projects

# Enable experimental features (true/false)
# MYAPP_EXPERIMENTAL=false
'''
```

## Best Practices

1. **Use Namespace Prefixes** - All env vars start with `APP_` to avoid conflicts
2. **Secure Permissions** - Set config files to `0o600` (owner read/write only)
3. **Document Defaults** - Include commented examples in template
4. **Validate Values** - Check ranges, formats, required settings on startup
5. **Path Expansion** - Always use `expand_path()` for file paths
6. **Reload Support** - Provide function to reload configuration at runtime

## MCPro Pattern (Dataclass-Based)

For more complex configurations, use the MCPro dataclass pattern:

```python
from dataclasses import dataclass, field
from typing import Optional, Set
from pathlib import Path
import os
from dotenv import load_dotenv

@dataclass
class Config:
    """Application configuration."""

    # Core settings
    debug: bool = False
    log_level: str = "INFO"
    log_file: Optional[Path] = None

    # Feature flags
    enable_experimental: bool = False

    # Namespace prefix
    env_prefix: str = "MYAPP_"

    @classmethod
    def from_env(cls, env_prefix: str = "MYAPP_") -> "Config":
        """Create config from environment variables."""
        config = cls(env_prefix=env_prefix)
        config._load_dotenv_files()
        config._parse_env_vars()
        return config

    def _load_dotenv_files(self) -> None:
        """Load configuration from dotenv files in cascading order."""
        config_locations = [
            Path.home() / f".{self.env_prefix.lower().rstrip('_')}" / "config.env",
            Path.cwd() / f".{self.env_prefix.lower().rstrip('_')}" / "config.env",
            Path.cwd() / f".{self.env_prefix.lower().rstrip('_')}.env",
        ]

        for config_file in config_locations:
            if config_file.exists():
                load_dotenv(config_file, override=True)

    def _parse_env_vars(self) -> None:
        """Parse environment variables with namespace prefix."""
        self.debug = os.getenv(f"{self.env_prefix}DEBUG", "false").lower() == "true"
        self.log_level = os.getenv(f"{self.env_prefix}LOG_LEVEL", "INFO").upper()
        self.enable_experimental = os.getenv(f"{self.env_prefix}EXPERIMENTAL", "false").lower() == "true"

        if log_file := os.getenv(f"{self.env_prefix}LOG_FILE"):
            self.log_file = Path(log_file)
```

## References

See `references/` for complete examples from:
- VoiceMode: Full-featured configuration with 100+ settings
- MCPro: Dataclass-based with tool filtering and profiles
