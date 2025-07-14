# Changelog

Updates CHANGELOG.md in the project root based on recent commits.

## Usage
```
changelog
changelog "v1.2.0"
```

## Instructions

1. **Analyze recent commits**:
   - Run `git log --oneline -20` to review recent commit history
   - Run `git log --pretty=format:"%h %s" --since="1 week ago"` for recent changes
   - Check if CHANGELOG.md exists in project root

2. **Determine version scope**:
   {{#if ARGUMENTS}}
   - Use "{{ARGUMENTS}}" as the version number
   {{else}}
   - Check package.json, Cargo.toml, or version file for current version
   - Suggest appropriate version bump based on changes (major.minor.patch)
   {{/if}}

3. **Categorize changes**:
   - **Added**: New features, capabilities, or files
   - **Changed**: Updates to existing functionality
   - **Deprecated**: Features marked for future removal
   - **Removed**: Deleted features or files
   - **Fixed**: Bug fixes and corrections
   - **Security**: Security-related fixes or improvements

4. **Update CHANGELOG.md**:
   - Follow [Keep a Changelog](https://keepachangelog.com) format
   - Add new version section at the top (under "## [Unreleased]" if present)
   - Include date in ISO format: YYYY-MM-DD
   - Group commits by category
   - Write user-focused descriptions (not just commit messages)

5. **Format entries**:
   - Start each entry with "- " 
   - Use present tense and imperative mood
   - Include relevant issue/PR numbers if available
   - Focus on user impact, not implementation details

6. **Verification**:
   - Review the updated CHANGELOG.md for accuracy
   - Ensure all significant changes are included
   - Check formatting consistency with existing entries

## Parameters

{{#if ARGUMENTS}}
- **ARGUMENTS**: {{ARGUMENTS}} - Version number for the changelog entry
{{else}}
- **ARGUMENTS**: Not provided - will suggest appropriate version
{{/if}}

## Examples

```
# Update changelog with automatic version suggestion
changelog

# Update changelog for specific version
changelog "v2.0.0"

# Will create entries like:
# ## [2.0.0] - 2024-01-15
# ### Added
# - New authentication system with OAuth2 support
# - Command-line interface for user management
# 
# ### Changed
# - Improved error messages for better debugging
# - Updated dependencies to latest versions
#
# ### Fixed
# - Memory leak in database connection pool
# - Incorrect date formatting in logs
```

## Changelog Format

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2024-01-15
### Added
- Initial release
```

## Notes

- Creates CHANGELOG.md if it doesn't exist
- Preserves existing changelog entries
- Groups related commits into meaningful user-facing changes
- Follows semantic versioning for version numbers
- Includes only notable changes (skips minor refactoring, typos)
- Links versions to GitHub compare URLs if repository detected

## Version Bump Guidelines

- **Patch** (x.x.1): Bug fixes, minor improvements
- **Minor** (x.1.0): New features, backwards-compatible changes
- **Major** (1.0.0): Breaking changes, major features