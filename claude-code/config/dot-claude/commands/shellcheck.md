# Shellcheck

Run shellcheck and fix warnings across files indicated by the value of $ARGUMENTS or all files if it is not provided.

## Usage
```
shellcheck [file_patterns...]
shellcheck bin/script1 lib/script2.sh
shellcheck
```

## Instructions

1. **Determine target files**:
   {{#if ARGUMENTS}}
   - Process the specific files/patterns provided: {{ARGUMENTS}}
   - Expand any glob patterns to actual file paths
   - Validate that specified files exist and are shell scripts
   {{else}}
   - Find all shell script files in the project if no arguments provided
   - Search for files with `.sh` extension and files with shell shebangs (`#!/bin/bash`, `#!/usr/bin/env bash`, etc.)
   - Include executable files in `bin/` directories that are shell scripts
   {{/if}}

2. **Run shellcheck analysis**:
   - Execute `shellcheck` on each identified file
   - Capture all warnings and errors with file locations and line numbers
   - Group findings by severity (error, warning, info, style)

3. **Fix common issues automatically**:
   - Quote variables to prevent word splitting: `$var` → `"$var"`
   - Fix array expansions: `${arr[@]}` → `"${arr[@]}"`
   - Add missing quotes around command substitutions
   - Fix deprecated backtick syntax: `` `cmd` `` → `$(cmd)`
   - Add proper error handling where missing

4. **Report results**:
   - Show summary of files processed
   - List all issues found with severity levels
   - Indicate which issues were auto-fixed vs need manual attention
   - Provide before/after diffs for any changes made

5. **Manual review required**:
   - Complex logic errors that need human judgment
   - Structural issues requiring refactoring
   - Cases where shellcheck suggestions might break intended behavior

## Parameters

{{#if ARGUMENTS}}
- **ARGUMENTS**: {{ARGUMENTS}} - Specific files or patterns to check
{{else}}
- **ARGUMENTS**: Not provided - will scan all shell scripts in project
{{/if}}

## Examples

```
# Check specific files
shellcheck bin/deploy lib/common.sh

# Check all files matching pattern
shellcheck bin/* scripts/*.sh

# Check all shell scripts in project (no arguments)
shellcheck
```

## Notes

- Requires `shellcheck` to be installed (`apt install shellcheck` or `brew install shellcheck`)
- Will respect `.shellcheckrc` configuration files if present
- Only auto-fixes safe, common issues - complex problems require manual review
- Creates backups of files before making changes
- Follows project conventions from CONVENTIONS.md for shell scripting standards

## Common Shellcheck Issues Fixed

- **SC2086**: Quote variables to prevent word splitting
- **SC2012**: Use `find` instead of `ls` for file operations
- **SC2046**: Quote command substitutions to prevent word splitting
- **SC2006**: Use `$(...)` instead of backticks
- **SC2164**: Use `cd ... || exit` for safer directory changes
- **SC2068**: Quote array expansions to prevent word splitting