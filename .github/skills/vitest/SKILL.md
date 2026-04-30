---
name: vitest
description: "Use when writing, configuring, or running tests with Vitest, including test files, mocking, snapshots, coverage, jsdom environment, concurrent tests, and integration with Vite config. Trigger phrases: vitest, vite test, vitest config, write vitest test, vitest mock, vitest coverage, vitest setup"
context: fork
---

# Vitest

Use this skill when writing or configuring tests with Vitest.

Official sources used:
- https://vitest.dev/guide/
- https://vitest.dev/guide/features
- https://vitest.dev/config/

## Domain Focus

This skill applies when tasks involve:

- Writing unit or integration tests in a Vite-based project.
- Configuring Vitest inside `vite.config.ts` or a dedicated `vitest.config.ts`.
- Setting up jsdom or happy-dom environments for component tests.
- Mocking modules, functions, and timers with `vi`.
- Running snapshot tests, type tests, or benchmarks.
- Configuring coverage reporting, watch mode, or CI shard runs.
- Migrating from Jest to Vitest.

## Best Practices

- Colocate configuration with Vite:
  - Add a `test` block inside `vite.config.ts` (add `/// <reference types="vitest/config" />` at the top).
  - Use a separate `vitest.config.ts` only when test and app configs must diverge.
  - Use `mergeConfig` from `vitest/config` to extend an existing Vite config.

- Test file naming:
  - Files named `*.test.ts` / `*.test.tsx` / `*.spec.ts` are picked up automatically.
  - Use `.test-d.ts` for type-level tests with `expectTypeOf` / `assertType`.

- Use `vi` for mocking (Jest-compatible API):
  - `vi.fn()` — create a mock function.
  - `vi.spyOn(obj, 'method')` — spy on an existing method.
  - `vi.mock('module-name')` — auto-mock a module at the top of the file.
  - `vi.useFakeTimers()` / `vi.useRealTimers()` — control time.
  - Reset mocks between tests with `clearMocks`, `mockReset`, or `restoreMocks` config options.

- Set the test environment to match what you're testing:
  - `environment: 'node'` (default) — for Node.js utilities.
  - `environment: 'jsdom'` — for DOM/browser behavior (requires `jsdom` package).
  - `environment: 'happy-dom'` — faster DOM alternative (requires `happy-dom` package).
  - Scope environment per file with `@vitest-environment jsdom` docblock.

- Always use `expect` from the **test context** (`{ expect }` parameter) in concurrent tests — not the global — to avoid assertion collisions.

- Use `setupFiles` in config to run setup code before each test file (e.g., `@testing-library/jest-dom` matchers).

- Prefer `vitest run` in CI; Vitest defaults to `watch` mode in development automatically.

- Use `--coverage` with the `v8` or `istanbul` provider for code coverage:
  - Install `@vitest/coverage-v8` or `@vitest/coverage-istanbul`.
  - Set thresholds in config to enforce minimum coverage.

## Common Pitfalls

- Putting `vitest.config.ts` alongside `vite.config.ts` without `mergeConfig` — the Vitest config overrides, not merges, the Vite config.
- Importing from `vitest` in source files (only `import.meta.vitest` is guarded for in-source tests).
- Forgetting that `VITE_*` prefixed env vars are loaded from `.env` files; all others are not auto-loaded.
- Using `jest.fn()` instead of `vi.fn()` after migrating from Jest — Vitest does not automatically inject Jest globals unless `globals: true` is set in config.
- Not installing `jsdom` or `happy-dom` separately when using a DOM environment — they are not bundled with Vitest.
- Running `expect` from closure scope in concurrent tests instead of the test context `expect`.
- Skipping `setupFiles` for global matchers (like `@testing-library/jest-dom`) — matchers won't be available without it.

## Practical Patterns

### 1) Minimal config in `vite.config.ts`

```ts
/// <reference types="vitest/config" />
import { defineConfig } from 'vite'

export default defineConfig({
  test: {
    environment: 'jsdom',
    setupFiles: ['./src/test-setup.ts'],
  },
})
```

### 2) Separate `vitest.config.ts` extending Vite config

```ts
import { defineConfig, mergeConfig } from 'vitest/config'
import viteConfig from './vite.config'

export default mergeConfig(viteConfig, defineConfig({
  test: {
    environment: 'jsdom',
    coverage: { provider: 'v8', include: ['src/**'] },
  },
}))
```

### 3) Basic test

```ts
import { expect, test } from 'vitest'
import { add } from './math'

test('adds two numbers', () => {
  expect(add(1, 2)).toBe(3)
})
```

### 4) Mocking a module

```ts
import { vi, test, expect } from 'vitest'
import { fetchUser } from './api'
import { getUserName } from './user'

vi.mock('./api', () => ({ fetchUser: vi.fn() }))

test('returns user name', async () => {
  vi.mocked(fetchUser).mockResolvedValue({ name: 'Alice' })
  expect(await getUserName(1)).toBe('Alice')
})
```

### 5) Concurrent tests (use context `expect`)

```ts
import { describe, it } from 'vitest'

describe.concurrent('suite', () => {
  it('test one', async ({ expect }) => {
    expect(1 + 1).toBe(2)
  })
  it('test two', async ({ expect }) => {
    expect(2 + 2).toBe(4)
  })
})
```

### 6) In-source testing

```ts
// src/math.ts
export function multiply(a: number, b: number) {
  return a * b
}

if (import.meta.vitest) {
  const { it, expect } = import.meta.vitest
  it('multiplies', () => expect(multiply(3, 4)).toBe(12))
}
```

### 7) Coverage npm script

```json
{
  "scripts": {
    "test": "vitest run",
    "test:watch": "vitest",
    "coverage": "vitest run --coverage"
  }
}
```

## Review Checklist

- Is the `test` config block inside `vite.config.ts` or a separate `vitest.config.ts` using `mergeConfig`?
- Is the correct `environment` set for the code under test (`node`, `jsdom`, or `happy-dom`)?
- Are `jsdom` / `happy-dom` installed as devDependencies when a DOM environment is used?
- Are mocks created with `vi.fn()` / `vi.mock()` rather than `jest.*` equivalents?
- Are `setupFiles` used for global matchers (e.g., `@testing-library/jest-dom`)?
- Are concurrent tests using `expect` from the test context param, not from closure?
- Does CI run `vitest run` (not `vitest`) to avoid watch mode hanging?

## Output Expectations

When producing Vitest configuration or test code:

- Prefer integration with existing `vite.config.ts` via `/// <reference types="vitest/config" />`.
- Use Vitest's native `vi` API for mocking; avoid mixing in Jest globals unless `globals: true` is set.
- Suggest `jsdom` environment for React component tests.
- Include `coverage` config when the task involves test coverage setup.
- Keep test files colocated with source files (`src/foo.test.ts` next to `src/foo.ts`) unless the project uses a separate `tests/` directory.
