# Claude Code Integration Plan

## Overview

This document outlines the plan to integrate the private `claude-code` repository into the unified `claude` package structure, preparing it for public release.

## Current Structure

```
packages/
├── claude/
│   ├── code (symlink to ../claude-code)
│   ├── desktop/
│   └── sandbox/
└── claude-code/ (separate private repo)
    ├── ai_docs/
    ├── bin/
    ├── claude-tools/
    ├── config/
    ├── docs/
    ├── shell/
    ├── spikes/
    ├── tasks/
    └── templates/
```

## Proposed Structure

```
packages/
└── claude/
    ├── README.md             # Main Claude package documentation (entry point)
    │
    ├── claude-api/           # Direct API access documentation
    │   ├── README.md         # API integration guide
    │   ├── examples/         # Code examples for different languages
    │   └── docs/             # API-specific documentation
    │
    ├── claude-code/          # Official Claude Code CLI tool
    │   ├── README.md         # Claude Code specific documentation
    │   ├── bin/              # Executable scripts
    │   ├── claude-tools/     # Log replay tools (Claude Code specific)
    │   ├── config/           # Configuration files
    │   │   └── dot-claude/   # Example configs only (no personal commands/settings)
    │   ├── docs/             # Claude Code specific docs
    │   │   ├── ai_docs/      # Documentation for AI/LLMs to consume
    │   │   ├── core-tools/   # Tool documentation
    │   │   └── specs/        # Technical specifications
    │   ├── shell/            # Shell scripts and completions
    │   ├── spikes/           # Experimental features
    │   ├── tasks/            # Task automation
    │   └── templates/        # Project templates
    │
    ├── claude-desktop/       # Claude Desktop native app
    │   ├── README.md         # Desktop app documentation
    │   ├── extensions/       # Desktop extension examples
    │   └── docs/             # Desktop-specific docs
    │
    ├── claude-mcp/           # Model Context Protocol (cross-platform)
    │   ├── README.md         # MCP overview and setup
    │   ├── servers/          # MCP server documentation
    │   │   ├── README.md     # Server directory index
    │   │   ├── filesystem.md # File system access
    │   │   ├── github.md     # GitHub integration
    │   │   └── ...           # Other MCP servers
    │   └── examples/         # MCP configuration examples
    │
    ├── claude-mobile/        # Claude mobile apps (iOS & Android)
    │   ├── README.md         # Mobile app information
    │   ├── ios/              # iOS-specific info
    │   └── android/          # Android-specific info
    │
    ├── claude-sandbox/       # Claude Code sandbox environment
    │   ├── README.md
    │   ├── bin/
    │   ├── config/
    │   ├── containers/
    │   └── tests/
    │
    ├── claude-web/           # Claude web interface (claude.ai)
    │   ├── README.md         # Web interface guide
    │   ├── bookmarklets/     # Useful bookmarklets
    │   └── docs/             # Web-specific tips and tricks
    │
    └── assets/               # Shared assets (logos, images, etc.)
```

## Migration Steps

### Phase 1: Preparation
1. **Audit sensitive content** ✓ (Already completed)
   - No actual secrets found
   - Minor path cleanups identified

2. **Clean up personal references**
   - Replace `/home/m/` with generic paths in docs
   - Remove commented personal alias in `shell/aliases`
   - Exclude personal configs from `config/dot-claude/`:
     - Keep only example commands and templates
     - Move personal commands to private repo
   - Create example files with safe defaults

3. **Create backup**
   - Archive current claude-code repo
   - Document current symlink setup

### Phase 2: Directory Restructuring
1. **Remove symlink**
   ```bash
   rm packages/claude/code
   ```

2. **Move claude-code into claude**
   ```bash
   mv packages/claude-code packages/claude/claude-code
   ```

3. **Create new directory structure**
   ```bash
   mkdir -p packages/claude/assets
   mkdir -p packages/claude/claude-api/examples
   mkdir -p packages/claude/claude-mcp/servers
   mkdir -p packages/claude/claude-mcp/examples
   mkdir -p packages/claude/claude-mobile/ios
   mkdir -p packages/claude/claude-mobile/android
   mkdir -p packages/claude/claude-web/bookmarklets
   mv packages/claude/desktop packages/claude/claude-desktop
   mv packages/claude/sandbox packages/claude/claude-sandbox
   # Move MCP docs from claude-code to claude-mcp
   mv packages/claude/claude-code/docs/mcp packages/claude/claude-mcp/docs
   # Move sandbox docs
   mkdir -p packages/claude/claude-sandbox/docs/specs
   mv packages/claude/claude-code/docs/sandbox.md packages/claude/claude-sandbox/docs/
   mv packages/claude/claude-code/docs/specs/claude-sandbox.md packages/claude/claude-sandbox/docs/specs/
   ```

### Phase 3: Documentation Updates
1. **Update all relative paths** in documentation
2. **Create unified README.md** for claude package as main entry point
3. **Move ai_docs** to docs/ai_docs/ within claude-code
4. **Reorganize documentation**:
   - Move entire `docs/mcp/` directory to `claude-mcp/`
   - Move `docs/sandbox.md` to `claude-sandbox/docs/`
   - Move `docs/specs/claude-sandbox.md` to `claude-sandbox/docs/specs/`
   - Remove `docs/files.md` (limited value)
   - Merge `docs/monorepos.md` into `docs/usage.md`
   - Merge `docs/troubleshooting.md` into main documentation
5. **Update tool references** to new paths
6. **Create README.md for each access method**:
   - claude-api/README.md
   - claude-mobile/README.md
   - claude-web/README.md
7. **Ensure each subdirectory has its own focused documentation**

### Phase 4: Git Integration
1. **Remove claude-code git history** (if keeping private)
   ```bash
   rm -rf packages/claude/claude-code/.git
   ```

2. **Add to main repository**
   ```bash
   git add packages/claude/claude-code
   ```

3. **Update .gitignore** to exclude any remaining sensitive files

### Phase 5: Testing & Validation
1. **Test all scripts** with new paths
2. **Verify documentation** links work
3. **Check shell completions** still function
4. **Test MCP configurations**

## Benefits of This Structure

### 1. **Clear Organization**
- All access methods use consistent `claude-*` naming
- Each directory represents a different way to interact with Claude
- README.md at root serves as the main entry point/index
- No redundant top-level docs folder - each component self-documents

### 2. **Modularity**
- Each component is self-contained
- Easy to understand what each directory contains
- Can be developed/released independently

### 3. **Public-Ready**
- No ambiguous "code" directory
- Professional structure for open source
- Clear separation of concerns

### 4. **Maintainability**
- Shared documentation reduces duplication
- Consistent structure across components
- Easy to add new Claude-related tools

## Considerations

### 1. **Breaking Changes**
- Users with existing installations may need to update paths
- Shell aliases might need updating
- Documentation links will change

### 2. **Naming Consistency**
- Use `claude-code` consistently (with hyphen)
- Maintain official branding
- Update all references in docs

### 3. **Future Growth**
- Structure allows for adding:
  - `claude-api/` - API client libraries
  - `claude-extensions/` - Browser/editor extensions
  - `claude-mobile/` - Mobile app resources
  - `claude-tools/` - Shared tools that work across Claude products (if needed)

## Next Steps

1. **Review and approve** this plan
2. **Schedule migration** during low-activity period
3. **Prepare announcement** for users about changes
4. **Execute migration** following the phases above
5. **Update all external references** (npm, GitHub, docs)

## Questions to Resolve

1. Should we preserve git history from claude-code repo?
2. Do we need to maintain backwards compatibility with old paths?
3. Should we create redirects for old documentation URLs?
4. What version number should we use after integration?
5. Should personal commands/configs be in a separate private repo or subdirectory?
6. How to handle mt-public symlinks - whole repo or selective directories?

---

*This plan ensures a smooth transition from separate repositories to a unified, public-ready Claude package structure.*