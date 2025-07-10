# Commit

Commits all changes, grouped sensibly into logical commits with meaningful messages.

## Usage
```
commit
commit "Custom commit message prefix"
```

## Instructions

1. **Analyze repository state**:
   - Run `git status` to see all untracked and modified files
   - Run `git diff` to understand the nature of changes
   - Run `git log --oneline -5` to understand recent commit patterns

2. **Group changes logically**:
   - **Documentation**: README.md, docs/, *.md files
   - **Configuration**: Config files, settings, .env examples
   - **Features**: New functionality, major additions
   - **Fixes**: Bug fixes, corrections, improvements
   - **Tests**: Test files, test data, test configurations
   - **Refactoring**: Code cleanup, reorganization without behavior change
   - **Dependencies**: Package files, requirements, lock files
   - **Tooling**: Build scripts, CI/CD, development tools

3. **Create meaningful commits**:
   {{#if ARGUMENTS}}
   - Use "{{ARGUMENTS}}" as prefix for commit messages where appropriate
   - Format: "{{ARGUMENTS}}: specific description"
   {{else}}
   - Use conventional commit format where appropriate
   - Follow existing commit message patterns from git log
   {{/if}}

4. **Commit strategy**:
   - Stage and commit related files together
   - Use descriptive commit messages that explain "why" not just "what"
   - Keep commits atomic - each commit should represent one logical change
   - Order commits logically (dependencies first, then features, then docs)

5. **Commit message format**:
   - Follow project's existing commit message style
   - Include scope when relevant: `feat(cli): add new command`
   - Use imperative mood: "add feature" not "added feature"
   - Keep first line under 50 characters when possible
   - Add detailed description if changes are complex

6. **Verification**:
   - Run `git status` after each commit to verify staging
   - Show final `git log --oneline -3` to confirm commits
   - Ensure no untracked files remain that should be committed

## Parameters

{{#if ARGUMENTS}}
- **ARGUMENTS**: {{ARGUMENTS}} - Custom commit message prefix
{{else}}
- **ARGUMENTS**: Not provided - will use conventional commit messages
{{/if}}

## Examples

```
# Commit all changes with grouped, descriptive messages
commit

# Commit with custom prefix
commit "feature: user authentication"

# Will create commits like:
# - "docs: update README and installation guide"
# - "feat: add user authentication system"
# - "test: add unit tests for auth module"
```

## Commit Grouping Logic

**High Priority Groups (commit first):**
1. **Dependencies**: package.json, requirements.txt, go.mod, Cargo.toml
2. **Configuration**: Settings, config files, environment examples
3. **Core Features**: Main functionality changes
4. **Bug Fixes**: Error corrections, issue resolutions

**Lower Priority Groups (commit after):**
5. **Tests**: Test files, test data, test configurations
6. **Documentation**: README, docs/, markdown files
7. **Tooling**: Build scripts, automation, development tools
8. **Cleanup**: Code formatting, unused file removal

## Notes

- Follows git best practices for atomic commits
- Respects existing project commit message conventions
- Will not commit files that should be gitignored
- Creates backup of staged changes before committing
- Handles both new files and modifications appropriately
- Preserves git history readability with logical grouping

## Safety Features

- Reviews all changes before committing
- Confirms file staging before each commit
- Provides summary of what will be committed
- Allows for manual review of commit messages
- Skips empty commits automatically