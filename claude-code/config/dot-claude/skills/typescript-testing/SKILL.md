---
name: typescript-testing
description: Configure and troubleshoot TypeScript testing with NX and Vite. Use this skill when working with test configuration, coverage reporting, or debugging test execution issues in TypeScript projects using NX monorepo structure with Vite/Vitest test runner.
---

# TypeScript Testing with NX and Vite

## Overview

This skill provides practical guidance for configuring and troubleshooting tests in TypeScript projects using NX monorepos with Vite/Vitest. Focus on immediate problem-solving and common workflows while detailed technical references are available separately.

## When to Use This Skill

Use when:
- Setting up test configuration for TypeScript libraries in NX monorepo
- Configuring coverage reporting
- Debugging why coverage files aren't generated
- Troubleshooting test failures or execution issues
- Understanding how NX executes tests with Vite/Vitest
- Running individual tests or controlling parallelization

## Quick Reference: Key Concepts

**NX** - Monorepo build system that orchestrates test execution
- Runs tests from project root
- Uses `@nx/vite:test` executor
- Caches results to avoid re-running unchanged tests

**Vite** - Fast build tool that powers Vitest
- Provides instant HMR in development
- Transforms TypeScript without type checking
- Shares configuration with Vitest

**Vitest** - Fast test framework built on Vite
- Jest-compatible API
- Coverage via v8 or istanbul providers
- Coverage must be explicitly enabled

**For detailed information:** See `references/nx-reference.md`, `references/vite-reference.md`, and `references/vitest-reference.md`

## Test Configuration

### Basic Setup

A package's `vite.config.ts` configures tests:

```typescript
import { defineConfig, mergeConfig } from 'vite';
import viteTsConfigPaths from 'vite-tsconfig-paths';
import baseConfig from '../../vitest.config';

export default mergeConfig(
  baseConfig,
  defineConfig({
    plugins: [
      viteTsConfigPaths({ root: '../../' }),
    ],
    test: {
      environment: 'jsdom', // or 'node' for backend
      include: ['src/**/*.{test,spec}.{js,mjs,cjs,ts,mts,cts,jsx,tsx}'],
    },
  }),
);
```

### Coverage Configuration

Add coverage block to enable reporting:

```typescript
test: {
  environment: 'jsdom',
  include: ['src/**/*.{test,spec}.{js,mjs,cjs,ts,mts,cts,jsx,tsx}'],
  coverage: {
    enabled: false, // or true for automatic coverage
    provider: 'v8',
    reporter: [['json-summary', { file: '../../coverage/package-name.json' }]],
    exclude: ['node_modules/', 'dist/', 'src/**/*.{test,spec}.{ts,tsx}'],
  },
}
```

**Coverage file paths:**
- Relative to vite.config.ts location
- 2-level packages: `../../coverage/filename.json`
- 3-level packages: `../../../coverage/filename.json`
- Use unique filenames per package

## Running Tests

### Common Commands

```bash
# Single package
npx nx run package-name:test
npx nx run package-name:test --coverage

# All packages
npx nx run-many --target=test --all
npx nx run-many --target=test --all --coverage

# Control parallelization
npx nx run-many --target=test --all --parallel=2

# Individual test file
npx nx run package-name:test -- src/lib/module.test.ts
```

## Troubleshooting

### Coverage Files Not Generated

**Common causes:**

1. **Coverage not enabled**
   - Having config doesn't auto-enable coverage
   - Add `--coverage` flag OR set `enabled: true`

2. **Wrong file path**
   - Check relative path matches package depth
   - Verify: 2 levels = `../../`, 3 levels = `../../../`

3. **Tests failing**
   - Coverage won't generate if tests fail
   - Fix tests first

4. **Missing provider**
   - Install: `npm install --save-dev @vitest/coverage-v8`

**Debug steps:**
```bash
# Run with coverage and verbose output
npx nx run package-name:test --coverage -- --reporter=verbose

# Check coverage dependency
grep "coverage-v8" package.json

# Verify coverage directory
ls -la coverage/
```

### Tests Failing with npm run test:coverage

**Common causes:**

1. **Parallel execution conflicts**
   - Reduce: `--parallel=2` or `--parallel=1`
   - Limit workers: `-- --maxWorkers=1`

2. **Shared state issues**
   - Tests not isolated properly
   - Missing cleanup in `afterEach` hooks

3. **Resource exhaustion**
   - Too many tests running simultaneously
   - Reduce parallelization

4. **Timing issues with coverage**
   - Coverage changes execution timing
   - Check for race conditions

### Running Individual Tests

```bash
# Direct Vitest (from package directory)
npx vitest run src/lib/module.test.ts

# Through NX
npx nx run package-name:test -- src/lib/module.test.ts

# Watch mode
npx nx run package-name:test -- --watch
```

### NX Execution Issues

If tests won't run:

1. Check `project.json` has `"executor": "@nx/vite:test"`
2. Verify `vite.config.ts` exists and is valid
3. Check test file patterns match actual files
4. Debug: `NX_VERBOSE_LOGGING=true npx nx run package-name:test`

**Key facts:**
- NX runs from project root, not package directory
- Coverage flag passes through to Vitest
- Config comes from package's vite.config.ts
- Results are cached; use `--skip-nx-cache` to bypass

## Best Practices

### Standard Coverage Configuration

Use consistent setup across packages:

```typescript
coverage: {
  enabled: false, // Opt-in via --coverage flag
  provider: 'v8',
  reporter: [
    ['json-summary', { file: '../../coverage/package-name.json' }],
    ['html', { subdir: 'html/package-name' }] // Optional
  ],
  exclude: ['node_modules/', 'dist/', 'src/**/*.{test,spec}.{ts,tsx}'],
  thresholds: { // Optional: enforce minimum coverage
    statements: 80,
    branches: 75,
    functions: 80,
    lines: 80
  }
}
```

### Test Organization

- Keep tests alongside source: `module.ts` + `module.test.ts`
- Use consistent naming: `*.test.ts` (avoid mixing with `*.spec.ts`)
- Separate integration tests if needed

### Performance

- Use `pool: 'forks'` for better isolation (in base config)
- Limit parallel execution for heavy tests
- Use `test.only()` for focused development
- Skip slow tests with `test.skip()`

## Common Workflows

### Adding Coverage to Package Without It

1. Verify tests exist: `find libs/package-name -name "*.test.ts"`
2. Add coverage config to `vite.config.ts`
3. Use unique output filename
4. Test: `npx nx run package-name:test --coverage`
5. Verify file in `/coverage/`

### Debugging Coverage Path Resolution

Temporarily add logging to understand paths:

```typescript
coverage: {
  reporter: [['json-summary', {
    file: (() => {
      const path = '../../coverage/package.json';
      console.log('Coverage path:', path);
      console.log('Config dir:', __dirname);
      return path;
    })()
  }]]
}
```

## Reference Documentation

Load these as needed for deeper understanding:

- **references/nx-reference.md** - NX architecture, execution model, caching, CLI options
- **references/vitest-reference.md** - Vitest configuration, coverage options, test writing, mocking
- **references/vite-reference.md** - Vite concepts, plugins, build optimization, TypeScript integration

Each reference includes official documentation links and detailed technical information.
