# NX Reference

## Official Documentation

- **NX Documentation**: https://nx.dev/
- **NX Vite Plugin**: https://nx.dev/nx-api/vite
- **NX Test Executor**: https://nx.dev/nx-api/vite/executors/test
- **NX Run Commands**: https://nx.dev/nx-api/nx/documents/run-many

## What is NX?

NX is a powerful monorepo build system and set of extensible dev tools. It orchestrates tasks across multiple packages in a workspace, providing:

- **Smart caching**: Avoids re-running unchanged code
- **Distributed task execution**: Runs tasks in parallel across packages
- **Dependency graph analysis**: Understands project relationships
- **Consistent tooling**: Standardizes build, test, and lint across projects

## How NX Executes Tests

### Execution Context

When NX runs tests with `@nx/vite:test` executor:

1. **Working directory**: Always runs from project root
2. **Config location**: Uses vite.config.ts from the target package
3. **Flag passthrough**: Passes CLI flags (like --coverage) to Vitest
4. **Result caching**: Caches successful test results based on file hashes

### Project Configuration

Each package defines its test target in `project.json`:

```json
{
  "name": "package-name",
  "targets": {
    "test": {
      "executor": "@nx/vite:test"
    }
  }
}
```

The `@nx/vite:test` executor:
- Locates the package's vite.config.ts
- Invokes Vitest with the configuration
- Collects test results and updates cache
- Reports success/failure back to NX

### Running Tests

#### Single Package
```bash
# Run tests for one package
npx nx run package-name:test

# With options
npx nx run package-name:test --coverage
npx nx run package-name:test --watch
```

#### Multiple Packages
```bash
# Run all tests
npx nx run-many --target=test --all

# Run with parallelization control
npx nx run-many --target=test --all --parallel=3

# Run only affected packages
npx nx affected --target=test
```

### NX CLI Options

Common flags for test execution:

- `--skip-nx-cache`: Bypass cache, always run tests
- `--parallel=N`: Limit concurrent test processes
- `--verbose`: Show detailed execution logs
- `--output-style=stream`: Show test output in real-time
- `--configuration=<name>`: Use named configuration variant

### NX Cache

NX caches test results to avoid re-running unchanged tests:

**Cache key includes:**
- Source file contents
- Test file contents
- Configuration files (vite.config.ts, tsconfig.json)
- Dependencies (node_modules)
- Environment variables affecting tests

**Cache location:** `node_modules/.cache/nx`

**Clear cache:** `npx nx reset`

### Troubleshooting NX Test Execution

#### Tests not running
1. Check project.json has test target
2. Verify executor is "@nx/vite:test"
3. Look for errors with: `NX_VERBOSE_LOGGING=true npx nx run package-name:test`

#### Unexpected cached results
- Clear cache: `npx nx reset`
- Run with: `--skip-nx-cache`

#### Parallel execution issues
- Reduce parallelization: `--parallel=1`
- Check for shared resource conflicts

## NX Workspace Structure

Typical monorepo layout:
```
workspace-root/
├── nx.json                 # NX workspace config
├── package.json           # Root dependencies and scripts
├── apps/                  # Application projects
│   └── app-name/
│       ├── project.json
│       └── vite.config.ts
└── libs/                  # Library packages
    └── lib-name/
        ├── project.json
        ├── vite.config.ts
        └── src/
```

## Integration with Vite

NX's `@nx/vite:test` executor is a thin wrapper around Vitest that:
1. Resolves the package's vite.config.ts path
2. Sets up the working directory (always project root)
3. Passes configuration and CLI flags to Vitest
4. Captures output for caching and reporting

The actual test execution is handled by Vitest with the configuration from vite.config.ts.
