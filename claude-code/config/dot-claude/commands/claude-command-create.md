# Create Claude Custom Command

Create a new custom Claude command file in the `~/.claude/commands/` directory. This command helps scaffold new slash commands with proper structure and documentation.

## Usage
```
claude-command-create command-name
claude-command-create command-name "Brief description of what the command does"
```

## Command Creation Process

1. **Parse command name** from {{ARGUMENTS}}
   - Extract first argument as command name (required)
   - Extract optional second argument as description
   - Validate command name follows kebab-case convention

2. **Check for existing command**
   - Look for existing command file: `~/.claude/commands/{{COMMAND_NAME}}.md`
   - If exists, ask user if they want to overwrite or edit existing

3. **Create command file structure**
   - Generate command file at `~/.claude/commands/{{COMMAND_NAME}}.md`
   - Use standard template with proper sections

## Command Template Structure

```markdown
# {{COMMAND_TITLE}}

{{DESCRIPTION}}

## Usage
```
{{COMMAND_NAME}} [arguments]
```

## Instructions

[Detailed instructions for Claude on how to execute this command]

## Parameters

{{#if ARGUMENTS}}
- **ARGUMENTS**: {{ARGUMENTS}}
{{/if}}

## Examples

```
{{COMMAND_NAME}} example-input
```

## Notes

- [Any special considerations or limitations]
- [Prerequisites or dependencies]
```

## Naming Conventions

Follow project conventions for command naming:
- Use `kebab-case` for command names
- Commands should be named with noun-verb pattern where appropriate
- Examples: `git-status`, `file-create`, `project-init`

## Standard Command Sections

Include these sections in all commands:
- **Usage**: Show command syntax with examples
- **Instructions**: Clear directions for Claude
- **Parameters**: Document any template variables
- **Examples**: Real usage examples
- **Notes**: Important considerations

## Command Categories

Common command categories to consider:
- **Project Management**: `project-init`, `context-prime`
- **Code Review**: `review-task`, `code-analyze`
- **Git Operations**: `git-commit`, `git-branch`
- **Documentation**: `docs-update`, `readme-generate`
- **Testing**: `test-run`, `test-create`

## Template Variables

Commands can use Handlebars template syntax:
- `{{ARGUMENTS}}`: All arguments passed to command
- `{{#if ARGUMENTS}}...{{/if}}`: Conditional content
- Custom variables as needed

## Error Handling

The command should handle common error cases:
- Missing required arguments
- Invalid command names
- File permission issues
- Existing command conflicts

## Output

After creating the command:
1. Confirm command file was created
2. Show the file path: `~/.claude/commands/{{COMMAND_NAME}}.md`
3. Remind user to test the new command with `/{{COMMAND_NAME}}`
4. Suggest adding to command documentation if appropriate

## Related Files

- View existing commands: `ls ~/.claude/commands/`
- Edit command: `{{EDITOR}} ~/.claude/commands/{{COMMAND_NAME}}.md`
- Test command: `/{{COMMAND_NAME}} test-args`