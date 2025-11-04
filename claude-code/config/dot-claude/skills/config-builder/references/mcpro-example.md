# MCPro Configuration Pattern

Dataclass-based configuration with tool filtering and profiles.

## Key Features

1. **Dataclass-Based** - Type-safe configuration with defaults
2. **Multiple Initialization Methods** - from_env(), from_yaml(), from_args()
3. **Configuration Merging** - Combine configs with precedence
4. **Tool Filtering** - Whitelist/blacklist patterns with wildcards
5. **Profiles** - Pre-configured tool sets
6. **Legacy Variable Support** - Deprecation warnings

## Configuration Class

```python
from dataclasses import dataclass, field
from enum import Enum
from pathlib import Path
from typing import Any, Dict, List, Optional, Set

import yaml
from dotenv import load_dotenv

class ToolProfile(Enum):
    """Pre-configured tool profiles."""
    MINIMAL = "minimal"
    STANDARD = "standard"
    DEVELOPMENT = "development"
    FULL = "full"

@dataclass
class Config:
    """Configuration for the MCPro server."""

    # Tool configuration
    tools_enabled: Optional[Set[str]] = None
    tools_disabled: Optional[Set[str]] = None
    tool_profile: Optional[ToolProfile] = None
    enable_optional: bool = False
    enable_experimental: bool = False

    # Server configuration
    debug: bool = False
    log_level: str = "INFO"
    log_file: Optional[Path] = None

    # Namespace prefix for environment variables
    env_prefix: str = "MCPRO_"

    # Profile definitions
    profiles: Dict[str, List[str]] = field(default_factory=lambda: {
        "default": ["echo", "get_time"],
        "minimal": ["echo", "get_time", "calculate"],
        "standard": ["echo", "get_time", "calculate", "file_read", "file_write"],
        "development": ["*", "!experimental_*"],
        "full": ["*"],
    })
```

## Initialization Methods

### From Environment

```python
@classmethod
def from_env(cls, env_prefix: str = "MCPRO_") -> "Config":
    """Create config from environment variables."""
    config = cls(env_prefix=env_prefix)

    # Load dotenv files in cascading order
    config._load_dotenv_files()

    # Parse environment variables
    config._parse_env_vars()

    # Handle legacy variables with deprecation warnings
    config._handle_legacy_vars()

    return config

def _load_dotenv_files(self) -> None:
    """Load configuration from dotenv files in cascading order."""
    config_locations = [
        Path.home() / ".mcpro" / "config.env",
        Path.cwd() / ".mcpro" / "config.env",
        Path.cwd() / ".mcpro.env",
    ]

    for config_file in config_locations:
        if config_file.exists():
            load_dotenv(config_file, override=True)

def _parse_env_vars(self) -> None:
    """Parse environment variables with namespace prefix."""
    # Tools configuration
    if tools_enabled := os.getenv(f"{self.env_prefix}TOOLS_ENABLED"):
        self.tools_enabled = set(tools_enabled.split(","))

    if tools_disabled := os.getenv(f"{self.env_prefix}TOOLS_DISABLED"):
        self.tools_disabled = set(tools_disabled.split(","))

    if profile := os.getenv(f"{self.env_prefix}PROFILE"):
        try:
            self.tool_profile = ToolProfile(profile.lower())
        except ValueError:
            warnings.warn(f"Invalid profile: {profile}")

    # Boolean flags
    self.enable_optional = os.getenv(f"{self.env_prefix}ENABLE_OPTIONAL", "false").lower() == "true"
    self.debug = os.getenv(f"{self.env_prefix}DEBUG", "false").lower() == "true"

    # String values
    self.log_level = os.getenv(f"{self.env_prefix}LOG_LEVEL", "INFO").upper()

    # Path values
    if log_file := os.getenv(f"{self.env_prefix}LOG_FILE"):
        self.log_file = Path(log_file)
```

### From YAML

```python
@classmethod
def from_yaml(cls, path: Path) -> "Config":
    """Create config from YAML file."""
    with open(path) as f:
        data = yaml.safe_load(f)

    config = cls()
    config._update_from_dict(data)
    return config
```

### From CLI Arguments

```python
@classmethod
def from_args(cls, **kwargs: Any) -> "Config":
    """Create config from command-line arguments."""
    config = cls()

    # Parse tools_enabled and tools_disabled from comma-separated strings
    if "tools_enabled" in kwargs and kwargs["tools_enabled"] is not None:
        tools_enabled = kwargs["tools_enabled"]
        config.tools_enabled = set(tools_enabled.split(",")) if isinstance(tools_enabled, str) else set(tools_enabled)

    if "tools_disabled" in kwargs and kwargs["tools_disabled"] is not None:
        tools_disabled = kwargs["tools_disabled"]
        config.tools_disabled = set(tools_disabled.split(",")) if isinstance(tools_disabled, str) else set(tools_disabled)

    # Set other attributes
    for key, value in kwargs.items():
        if key not in ["tools_enabled", "tools_disabled"] and hasattr(config, key) and value is not None:
            setattr(config, key, value)

    return config
```

## Configuration Merging

```python
def merge(self, other: "Config") -> "Config":
    """Merge another config into this one (other takes precedence)."""
    result = Config(
        tools_enabled=other.tools_enabled or self.tools_enabled,
        tools_disabled=other.tools_disabled or self.tools_disabled,
        tool_profile=other.tool_profile or self.tool_profile,
        enable_optional=other.enable_optional or self.enable_optional,
        debug=other.debug or self.debug,
        log_level=other.log_level if other.log_level != "INFO" else self.log_level,
        env_prefix=self.env_prefix,
        profiles=self.profiles,
    )
    return result
```

## Tool Filtering

```python
def should_load_tool(self, tool_name: str) -> bool:
    """Determine if a tool should be loaded based on configuration."""
    # Check if tool is explicitly disabled
    if self.tools_disabled and self._matches_patterns(tool_name, self.tools_disabled):
        return False

    # Check if we have an explicit whitelist
    if self.tools_enabled:
        return self._matches_patterns(tool_name, self.tools_enabled)

    # Check special categories
    if tool_name.startswith("optional_") and not self.enable_optional:
        return False

    if tool_name.startswith("experimental_") and not self.enable_experimental:
        return False

    # Default: load the tool
    return True

def _matches_patterns(self, name: str, patterns: Set[str]) -> bool:
    """Check if name matches any of the patterns (supports wildcards)."""
    import fnmatch
    return any(fnmatch.fnmatch(name, pattern) for pattern in patterns)
```

## Usage Example

```python
# Load from environment (cascades through .env files)
config = Config.from_env()

# Load from CLI args
config_args = Config.from_args(
    debug=True,
    tools_enabled="echo,get_time,calculate"
)

# Merge configs (CLI args take precedence)
final_config = config.merge(config_args)

# Use config to filter tools
tools_to_load = [
    tool for tool in available_tools
    if final_config.should_load_tool(tool.name)
]
```
