# Vite Reference

## Official Documentation

- **Vite Documentation**: https://vitejs.dev/
- **Vite Configuration**: https://vitejs.dev/config/
- **Vite Plugin API**: https://vitejs.dev/guide/api-plugin
- **Vite Build Options**: https://vitejs.dev/config/build-options

## What is Vite?

Vite is a modern build tool that provides:

- **Lightning-fast dev server**: No bundling during development
- **Hot Module Replacement (HMR)**: Instant updates without page reload
- **Optimized builds**: Rollup-based production bundling
- **Plugin ecosystem**: Extensible through plugins
- **Framework agnostic**: Works with React, Vue, Svelte, etc.

## Core Concepts

### Development vs Production

**Development Mode:**
- Serves files using native ES modules
- No bundling required
- Transforms files on-demand
- Instant server start

**Production Mode:**
- Bundles with Rollup
- Code splitting
- Minification and optimization
- Asset hashing

### ES Modules

Vite leverages native ES module support in browsers:
- `import` and `export` syntax
- Dynamic `import()` for code splitting
- Fast module resolution

## Configuration

### Basic vite.config.ts

```typescript
import { defineConfig } from 'vite'

export default defineConfig({
  // Root directory
  root: process.cwd(),

  // Base public path
  base: '/',

  // Plugin array
  plugins: [],

  // Resolve options
  resolve: {
    alias: {
      '@': '/src',
    },
  },

  // Build options
  build: {
    outDir: 'dist',
    sourcemap: true,
  },
})
```

### Path Resolution

Vite uses path aliases for cleaner imports:

```typescript
resolve: {
  alias: {
    '@': '/src',
    '@components': '/src/components',
    '@utils': '/src/utils',
  },
}
```

In TypeScript projects, sync with `tsconfig.json`:
```json
{
  "compilerOptions": {
    "paths": {
      "@/*": ["./src/*"],
      "@components/*": ["./src/components/*"]
    }
  }
}
```

Use `vite-tsconfig-paths` plugin to auto-load TypeScript paths:
```typescript
import tsconfigPaths from 'vite-tsconfig-paths'

export default defineConfig({
  plugins: [tsconfigPaths()],
})
```

### Plugins

Common Vite plugins for TypeScript projects:

```typescript
import react from '@vitejs/plugin-react'
import tsconfigPaths from 'vite-tsconfig-paths'

export default defineConfig({
  plugins: [
    react(), // React support with Fast Refresh
    tsconfigPaths(), // Use tsconfig paths
  ],
})
```

## Testing Integration

Vite powers Vitest, the test framework. The same configuration file supports both:

```typescript
/// <reference types="vitest" />
import { defineConfig } from 'vite'

export default defineConfig({
  // Vite configuration
  plugins: [],
  resolve: {
    alias: {
      '@': '/src',
    },
  },

  // Vitest configuration
  test: {
    environment: 'jsdom',
    globals: true,
  },
})
```

### Benefits for Testing

1. **Shared configuration**: Same transforms, aliases, and plugins
2. **Fast test runs**: Vite's speed carries over to tests
3. **No build step**: Tests run directly on source
4. **HMR in watch mode**: Instant test updates

## Environment Variables

### .env Files

Vite loads environment variables from `.env` files:

```
# .env
VITE_API_URL=https://api.example.com
VITE_APP_TITLE=My App
```

**Naming convention:** Prefix with `VITE_` to expose to client code.

Access in code:
```typescript
const apiUrl = import.meta.env.VITE_API_URL
const isDev = import.meta.env.DEV
const isProd = import.meta.env.PROD
```

### Env File Priority

1. `.env.local` (local overrides, gitignored)
2. `.env.[mode].local`
3. `.env.[mode]`
4. `.env`

## Build Configuration

### Production Build Options

```typescript
build: {
  // Output directory
  outDir: 'dist',

  // Generate sourcemaps
  sourcemap: true,

  // Minification (esbuild, terser, or false)
  minify: 'esbuild',

  // Target browsers
  target: 'es2015',

  // Chunk size warnings
  chunkSizeWarningLimit: 500,

  // Rollup options
  rollupOptions: {
    output: {
      manualChunks: {
        vendor: ['react', 'react-dom'],
      },
    },
  },
}
```

### Code Splitting

Vite automatically splits code:
- Entry points become separate chunks
- Dynamic imports create lazy chunks
- Vendor dependencies can be split manually

```typescript
// Dynamic import for route-based code splitting
const Dashboard = lazy(() => import('./pages/Dashboard'))
```

## Performance Optimization

### Dependency Pre-bundling

Vite pre-bundles dependencies with esbuild:
- Converts CommonJS to ESM
- Reduces HTTP requests
- Improves load time

**Pre-bundle cache:** `node_modules/.vite/deps`

Force re-optimization:
```bash
rm -rf node_modules/.vite
```

### Build Optimization

```typescript
build: {
  // Enable Rollup optimizations
  rollupOptions: {
    output: {
      manualChunks: {
        // Split large dependencies
        'react-vendor': ['react', 'react-dom'],
      },
    },
  },

  // Inline small assets
  assetsInlineLimit: 4096,

  // CSS code splitting
  cssCodeSplit: true,
}
```

## Common Patterns in NX Monorepos

### Package-Level Configuration

Each library has its own `vite.config.ts`:

```typescript
import { defineConfig, mergeConfig } from 'vite'
import viteTsConfigPaths from 'vite-tsconfig-paths'
import baseConfig from '../../vitest.config'

export default mergeConfig(
  baseConfig,
  defineConfig({
    cacheDir: '../../node_modules/.vite/package-name',

    plugins: [
      viteTsConfigPaths({
        root: '../../', // Resolve from monorepo root
      }),
    ],

    test: {
      // Package-specific test config
    },
  }),
)
```

### Shared Base Configuration

Root-level config provides defaults:

```typescript
// vitest.config.ts (root)
export default defineConfig({
  test: {
    globals: true,
    pool: 'forks',
  },
})
```

Packages extend and override:

```typescript
// libs/package/vite.config.ts
import baseConfig from '../../vitest.config'

export default mergeConfig(
  baseConfig,
  defineConfig({
    test: {
      environment: 'node', // Override
    },
  }),
)
```

## Troubleshooting

### Module Resolution Issues

**Problem:** Import errors, "Cannot find module"

**Solutions:**
- Add `vite-tsconfig-paths` plugin
- Check `tsconfig.json` paths configuration
- Verify file extensions in imports
- Check `resolve.alias` in vite.config.ts

### Build Failures

**Problem:** Build succeeds in dev but fails in production

**Causes:**
- Missing type definitions
- Incorrect imports (e.g., missing extensions)
- Environment-specific code not properly guarded

**Debug:**
```bash
# Build with detailed output
vite build --debug
```

### Cache Issues

**Problem:** Stale dependencies or unexpected behavior

**Solution:**
```bash
# Clear Vite cache
rm -rf node_modules/.vite

# Clear NX cache (if using NX)
npx nx reset
```

## Integration with TypeScript

Vite handles TypeScript natively:

1. **Type checking:** Not performed by Vite during build
   - Use `tsc --noEmit` for type checking
   - Or use `vite-plugin-checker`

2. **Transpilation:** Uses esbuild for fast transforms
   - Faster than tsc
   - No type checking overhead

3. **Configuration:** Respects `tsconfig.json`
   - For path mapping with `vite-tsconfig-paths`
   - For compilation target

### Recommended Setup

```typescript
import { defineConfig } from 'vite'
import checker from 'vite-plugin-checker'

export default defineConfig({
  plugins: [
    checker({
      typescript: true, // Enable type checking during dev
    }),
  ],
})
```

## Resources

- **Official Guide**: https://vitejs.dev/guide/
- **GitHub**: https://github.com/vitejs/vite
- **Plugin Directory**: https://vitejs.dev/plugins/
- **Awesome Vite**: https://github.com/vitejs/awesome-vite
