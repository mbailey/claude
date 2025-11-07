# Vitest Reference

## Official Documentation

- **Vitest Documentation**: https://vitest.dev/
- **Vitest Configuration**: https://vitest.dev/config/
- **Vitest Coverage**: https://vitest.dev/guide/coverage
- **Vitest CLI**: https://vitest.dev/guide/cli
- **Vitest API**: https://vitest.dev/api/

## What is Vitest?

Vitest is a blazing fast unit test framework powered by Vite. Key features:

- **Vite-powered**: Uses Vite for instant HMR during test development
- **Jest-compatible API**: Easy migration from Jest
- **ESM/TypeScript native**: First-class ESM and TypeScript support
- **Smart & instant watch mode**: Only re-runs affected tests
- **Component testing**: Built-in support for Vue, React, Svelte, etc.

## Test Configuration

### Basic Configuration

In `vite.config.ts` or `vitest.config.ts`:

```typescript
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    // Test environment (jsdom, node, happy-dom, edge-runtime)
    environment: 'jsdom',

    // Glob patterns for test files
    include: ['src/**/*.{test,spec}.{js,ts,jsx,tsx}'],
    exclude: ['node_modules', 'dist', '.git'],

    // Global test APIs (describe, it, expect, etc.)
    globals: true,

    // Test execution
    pool: 'forks', // or 'threads', 'vmForks'
    poolOptions: {
      threads: {
        singleThread: false
      }
    },

    // Timeouts
    testTimeout: 10000,
    hookTimeout: 10000,
  },
})
```

### Merging Configurations

Common pattern in NX monorepos - merge base config with package-specific config:

```typescript
import { defineConfig, mergeConfig } from 'vite'
import baseConfig from '../../vitest.config'

export default mergeConfig(
  baseConfig,
  defineConfig({
    test: {
      // Package-specific overrides
      environment: 'node',
    },
  }),
)
```

## Coverage Configuration

### Coverage Providers

**v8** (recommended):
- Faster
- Built into Node.js
- Lower overhead
- Install: `npm install --save-dev @vitest/coverage-v8`

**istanbul** (alternative):
- More detailed reports
- Better source map support
- Install: `npm install --save-dev @vitest/coverage-istanbul`

### Coverage Configuration Options

```typescript
coverage: {
  // Enable/disable coverage
  enabled: false, // Set to true or use --coverage flag

  // Provider selection
  provider: 'v8', // or 'istanbul'

  // Output directory (relative to project root)
  reportsDirectory: './coverage',

  // Reporter formats
  reporter: [
    'text',        // Console output
    'json',        // Detailed JSON data
    'json-summary',// Compact summary JSON
    'html',        // HTML report for viewing
    'lcov',        // For CI tools
  ],

  // Custom reporter with options
  reporter: [
    ['json-summary', { file: 'coverage/summary.json' }],
    ['html', { subdir: 'html' }],
  ],

  // File inclusions/exclusions
  include: ['src/**/*.ts'],
  exclude: [
    'node_modules/',
    'dist/',
    '**/*.test.ts',
    '**/*.spec.ts',
  ],

  // Coverage thresholds
  thresholds: {
    statements: 80,
    branches: 75,
    functions: 80,
    lines: 80,
  },

  // Additional options
  all: true, // Include untested files
  clean: true, // Clean coverage directory before run
  skipFull: false, // Skip files with 100% coverage
}
```

### Reporter Options

**json-summary with custom file path:**
```typescript
reporter: [['json-summary', { file: 'custom/path/summary.json' }]]
```

**html with subdirectory:**
```typescript
reporter: [['html', { subdir: 'coverage-html' }]]
```

**Multiple reporters:**
```typescript
reporter: [
  'text',
  ['json-summary', { file: 'coverage/summary.json' }],
  ['html', { subdir: 'html' }],
  'lcov',
]
```

## Running Tests

### CLI Commands

```bash
# Run all tests
vitest

# Run once (no watch mode)
vitest run

# Run with coverage
vitest run --coverage

# Watch mode
vitest watch

# Run specific test file
vitest run src/module.test.ts

# Run tests matching pattern
vitest run --testNamePattern="user login"

# Run with specific reporter
vitest run --reporter=verbose
vitest run --reporter=json --outputFile=results.json

# UI mode (visual test runner)
vitest --ui
```

### Watch Mode

In watch mode, Vitest:
- Watches for file changes
- Only re-runs affected tests
- Provides interactive commands:
  - `a` - run all tests
  - `f` - run failed tests only
  - `u` - update snapshots
  - `q` - quit watch mode

## Test Writing

### Basic Test Structure

```typescript
import { describe, it, expect, beforeEach, afterEach } from 'vitest'

describe('MyModule', () => {
  beforeEach(() => {
    // Setup before each test
  })

  afterEach(() => {
    // Cleanup after each test
  })

  it('should do something', () => {
    expect(true).toBe(true)
  })

  it.skip('skipped test', () => {
    // This test will be skipped
  })

  it.only('focused test', () => {
    // Only this test will run
  })
})
```

### Mocking

```typescript
import { vi } from 'vitest'

// Mock module
vi.mock('./module', () => ({
  functionName: vi.fn(() => 'mocked'),
}))

// Mock implementation
const mockFn = vi.fn()
mockFn.mockImplementation(() => 42)
mockFn.mockResolvedValue('async result')

// Spy on object method
const spy = vi.spyOn(object, 'method')

// Clear mocks
vi.clearAllMocks()
vi.resetAllMocks()
```

## Performance Optimization

### Parallelization

```typescript
test: {
  // Use threads for CPU-bound tests
  pool: 'threads',

  // Use forks for better isolation
  pool: 'forks',

  // Limit concurrent workers
  poolOptions: {
    threads: {
      maxThreads: 4,
      minThreads: 1,
    }
  }
}
```

### Test Isolation

```typescript
test: {
  // Isolate environment between files
  isolate: true,

  // Pool options for isolation
  pool: 'forks', // Better isolation than threads
}
```

## Troubleshooting

### Common Issues

**Tests not found:**
- Check `include` patterns match test files
- Verify file extensions are included in pattern
- Check `exclude` patterns aren't too broad

**Slow test execution:**
- Reduce parallelization: `maxThreads: 1`
- Use `pool: 'forks'` for better performance
- Check for slow setup/teardown code

**Coverage not generating:**
- Ensure coverage provider installed
- Add `--coverage` flag or `enabled: true`
- Check coverage paths are correct
- Verify tests are passing

**Import errors:**
- Check `vite.config.ts` has correct path resolution
- Verify TypeScript paths in `tsconfig.json`
- May need `vite-tsconfig-paths` plugin

## Integration with Vite

Vitest leverages Vite's features:

- **Dev server**: Same transformation pipeline as dev
- **Plugins**: Vite plugins work in tests
- **HMR**: Instant test updates on file changes
- **ESM**: Native ES modules support

Configuration is shared between Vite and Vitest:
```typescript
export default defineConfig({
  // Vite config
  plugins: [react()],
  resolve: {
    alias: {
      '@': '/src'
    }
  },

  // Vitest config
  test: {
    environment: 'jsdom',
  },
})
```
