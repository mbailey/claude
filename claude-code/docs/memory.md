# Claude Code Memory

Claude Code uses memory files to maintain context about your projects and preferences across conversations.

📖 **Official Docs**: [Claude Code Memory Documentation](https://docs.anthropic.com/en/docs/claude-code/memory)

## Memory Editor

Access the memory editor with the `/memory` command:

```shell
 ✔ Loaded project memory • /memory
╭───────────────────────────────────────────────────────────────────────────────────╮
│                                                                                   │
│ Select memory to edit:                                                            │
│                                                                                   │
│  ❯ Project memory                Checked in at ./CLAUDE.md                        │
│    Project memory (local)        Gitignored in ./CLAUDE.local.md                  │
│    User memory                   Saved in ~/.claude/CLAUDE.md                     │
│                                                                                   │
│ 161 memories in ./CLAUDE.md                                                       │
│                                                                                   │
╰───────────────────────────────────────────────────────────────────────────────────╯
```

## Memory Types

### Project Memory (CLAUDE.md)

- **Purpose**: Team-shared conventions and knowledge
- **Location**: Project root or any parent directory
- **Contents**: Project architecture, coding standards, common workflows
- **Version Control**: Typically checked into version control

### Local Project Memory (CLAUDE.local.md)

- **Purpose**: Personal project-specific preferences
- **Location**: Same as CLAUDE.md
- **Contents**: Personal sandbox URLs, preferred test data
- **Version Control**: Typically gitignored, not shared with team

### User Memory (~/.claude/CLAUDE.md)

- **Purpose**: Global personal preferences across all projects
- **Location**: Home directory
- **Contents**: General preferences, commonly used tools

## Memory Loading

Claude Code recursively searches for memory files:

1. Starts from your current working directory
2. Moves up to the root directory
3. Loads both CLAUDE.md and CLAUDE.local.md at each level
4. Also loads user memory from ~/.claude/CLAUDE.md

## Best Practices

- Keep CLAUDE.md focused on team-relevant information
- Use CLAUDE.local.md for personal workflow preferences
- Update memory files as project conventions evolve
- Use the `/init` command to generate an initial CLAUDE.md

## File Imports with @include

CLAUDE.md files can import other files using `@path/to/file` syntax:

### How It Works
- **Syntax**: `@README.md`, `@./docs/guide.md`, `@/absolute/path.md`
- **Recursion**: Max 5 levels deep
- **Context**: Not evaluated in code blocks
- **Benefit**: Adds files directly to context without tool calls

### Example
```markdown
# Project Instructions
See @README.md for overview and @docs/conventions.md for standards.

# Personal Tools
@~/.claude/personal-tools.md
```

### Known Issue: Global CLAUDE.md Imports
**Problem**: @includes may fail in ~/.claude/CLAUDE.md ([Issue #1041](https://github.com/anthropics/claude-code/issues/1041))

**Workaround**: Edit `~/.claude.json` for each project:
```json
{
  "path": "/path/to/project",
  "hasClaudeMdExternalIncludesApproved": true
}
```