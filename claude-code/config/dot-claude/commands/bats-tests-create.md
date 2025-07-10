# Bats Tests Create

Create comprehensive BATS (Bash Automated Testing System) tests for shell scripts and CLI tools.

## Usage
```
bats-tests-create [script_path...]
bats-tests-create bin/my-script
bats-tests-create bin/script1 bin/script2
bats-tests-create
```

## Instructions

1. **Determine target scripts**:
   {{#if ARGUMENTS}}
   - Create tests for the specific scripts provided: {{ARGUMENTS}}
   - Validate that specified files exist and are executable
   {{else}}
   - Find all executable scripts in common directories (`bin/`, `libexec/`, etc.)
   - Focus on scripts that don't already have test coverage
   {{/if}}

2. **Analyze each script**:
   - Read script content to understand functionality
   - Identify command-line arguments and options
   - Parse help text (`-h`, `--help`) to understand usage
   - Detect expected input/output patterns
   - Identify error conditions and edge cases

3. **Create test structure**:
   - Create or update `test/` directory in project root
   - Generate test file: `test/test_[script-name].bats`
   - Follow BATS testing conventions and project standards

4. **Generate comprehensive tests**:
   - **Basic functionality tests**: Core features work as expected
   - **Argument validation**: Required args, invalid options, help text
   - **Error handling**: Missing files, permissions, invalid input
   - **Edge cases**: Empty input, large files, special characters
   - **Integration tests**: Script works with real data/files using actual filesystem operations
   - **Output validation**: Correct format, expected content
   - **Avoid mocks**: Use real files, actual commands, and genuine filesystem interactions

5. **Test categories to include**:
   - `@test "displays help when -h flag is used"`
   - `@test "displays help when --help flag is used"`
   - `@test "exits with error when required arguments missing"`
   - `@test "processes valid input correctly"`
   - `@test "handles file not found gracefully"`
   - `@test "validates input parameters"`
   - `@test "produces expected output format"`

## Parameters

{{#if ARGUMENTS}}
- **ARGUMENTS**: {{ARGUMENTS}} - Specific scripts to create tests for
{{else}}
- **ARGUMENTS**: Not provided - will create tests for all scripts without existing coverage
{{/if}}

## Examples

```
# Create tests for specific script
bats-tests-create bin/deploy

# Create tests for multiple scripts
bats-tests-create bin/backup bin/restore

# Create tests for all scripts (no arguments)
bats-tests-create
```

## Test File Template

Each test file follows this structure:
```bash
#!/usr/bin/env bats

# Test setup
setup() {
    # Load any helper functions
    load test_helper
    # Set up test environment
    export TEST_DIR="$BATS_TMPDIR/test"
    mkdir -p "$TEST_DIR"
}

# Cleanup after tests
teardown() {
    rm -rf "$TEST_DIR"
}

@test "script displays help with -h flag" {
    run bin/script-name -h
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
}

@test "script handles missing required argument" {
    run bin/script-name
    [ "$status" -ne 0 ]
    [[ "$output" =~ "Error:" ]]
}
```

## BATS Conventions

- Use `run` command to capture exit status and output
- Check exit status with `[ "$status" -eq 0 ]`
- Use `[[ "$output" =~ "pattern" ]]` for output matching
- Create helper functions in `test/test_helper.bash`
- Use `$BATS_TMPDIR` for temporary files
- Group related tests with descriptive names

## Notes

- Requires BATS to be installed (`git clone https://github.com/bats-core/bats-core.git`)
- Follows project conventions from CONVENTIONS.md for testing
- Creates `test/test_helper.bash` with common functions if needed
- Tests should be runnable with `bats test/` or `bin/test` if it exists
- Includes both positive and negative test cases
- Tests are designed to be fast and reliable
- **No mocking**: Tests use real files, actual commands, and genuine interactions
- Create temporary test data in `$BATS_TMPDIR` rather than mocking file operations

## Test Helper Functions

Common helper functions to include in `test/test_helper.bash`:
- `setup_test_files()`: Create test data files
- `cleanup_test_files()`: Remove test artifacts
- `assert_file_exists()`: Verify file creation
- `assert_contains()`: Check string in output
- `skip_if_missing()`: Skip tests if dependencies missing