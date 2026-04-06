---
name: nodejs
description: "Use when working with Node.js runtime APIs, module systems (CommonJS/ESM), package exports/imports, streams, child processes, process/env behavior, and backend service patterns. Covers official Node.js API and package-resolution guidance for practical, production-safe Node development."
---

# Node.js Skill

Use this skill when building, reviewing, or debugging Node.js applications and libraries.

Official sources used:
- https://nodejs.org/docs/latest/api/
- https://nodejs.org/docs/latest/api/modules.html
- https://nodejs.org/docs/latest/api/esm.html
- https://nodejs.org/docs/latest/api/packages.html
- https://nodejs.org/docs/latest/api/stream.html
- https://nodejs.org/docs/latest/api/process.html
- https://nodejs.org/docs/latest/api/child_process.html

## Domain Focus

This skill covers:
- Node.js module systems (CommonJS and ESM) and interop
- package.json fields relevant to runtime behavior (type, exports, imports, main)
- Stream safety, backpressure, and pipeline patterns
- Process lifecycle, environment variables, and exit behavior
- Child process APIs and command execution safety
- Practical production concerns: error handling, portability, and performance hazards

## Best Practices

### Module System Clarity

- Be explicit about module intent with package.json type and file extensions (.mjs/.cjs when needed).
- Prefer one dominant module style per package; isolate interop boundaries.
- In ESM, include file extensions for relative imports.
- Use node: specifiers for built-ins (for example node:fs, node:path) to avoid ambiguity.
- Use dynamic import() for asynchronous loading and optional dependencies.

### Package Boundary Design

- Prefer exports for public entry points instead of relying only on main.
- Define only supported subpaths; avoid accidental deep-import APIs.
- Include default condition in conditional exports for broader runtime compatibility.
- Use imports with # aliases for internal package-only paths.
- Keep exports/imports targets relative (./...) and inside package boundaries.

### Process and Runtime Behavior

- Prefer setting process.exitCode over calling process.exit() directly.
- Let the event loop drain naturally after writing to stdout/stderr.
- Treat uncaughtException as last-resort cleanup and restart, not recovery.
- Handle unhandledRejection explicitly and fail predictably.
- Validate and normalize environment variables at startup.

### Streams and I/O

- Prefer stream.pipeline() (or stream/promises pipeline) over manual pipe chains.
- Respect backpressure: if write() returns false, wait for drain.
- Use finished() when completion notification is required.
- Prefer streaming for large payloads; avoid buffering entire content when unnecessary.
- Use AbortSignal where supported for cancellation-aware stream flows.

### Child Processes and Security

- Prefer spawn/execFile over exec when possible.
- Never pass unsanitized user input into shell commands.
- Set explicit timeouts, maxBuffer, and cwd/env where relevant.
- Handle both error and close/exit events to avoid blind spots.
- Use stdio: ignore for detached background children that should outlive parent.

### Error Handling and API Shape

- Distinguish operational errors (I/O, network, timeout) from programmer errors.
- Keep async APIs consistently async; avoid maybe-sync behavior.
- Propagate rich error context (code, cause, operation metadata).
- Avoid swallowing errors in callbacks, promises, and stream handlers.
- Return structured failures at boundaries (HTTP response, queue ack/nack, CLI exit code).

## Common Pitfalls

- Mixing ESM and CommonJS implicitly and getting resolution/interop surprises.
- Omitting file extensions in ESM relative imports.
- Introducing exports without preserving previously used public subpaths.
- Calling process.exit() immediately after async writes, causing truncated output.
- Ignoring stream backpressure and causing memory bloat.
- Using exec with interpolated user input (command injection risk).
- Relying on deprecated or legacy behaviors (for example folders-as-modules assumptions).
- Assuming require/import resolution rules are identical.

## Practical Patterns

### Safe ESM File Access with URL

```js
import { readFile } from 'node:fs/promises'

const configUrl = new URL('./config.json', import.meta.url)
const configRaw = await readFile(configUrl, 'utf8')
const config = JSON.parse(configRaw)
```

### Backpressure-Aware Pipeline

```js
import { pipeline } from 'node:stream/promises'
import { createReadStream, createWriteStream } from 'node:fs'
import { createGzip } from 'node:zlib'

await pipeline(
  createReadStream('input.log'),
  createGzip(),
  createWriteStream('input.log.gz')
)
```

### Predictable Exit Without Forced Termination

```js
import process from 'node:process'

function failUsage(message) {
  console.error(message)
  process.exitCode = 1
}
```

### Safer Subprocess Invocation

```js
import { execFile } from 'node:child_process'
import { promisify } from 'node:util'

const execFileAsync = promisify(execFile)

const { stdout } = await execFileAsync('node', ['--version'], {
  timeout: 5000,
  maxBuffer: 1024 * 256,
})
```

### Explicit Package Entry Points

```json
{
  "type": "module",
  "exports": {
    ".": "./dist/index.js",
    "./cli": "./dist/cli.js"
  },
  "imports": {
    "#internal/*": "./src/internal/*.js"
  }
}
```

## Review Checklist

- Is the module system explicit and consistent for this package?
- Are ESM imports using correct relative specifiers and extensions?
- Are package exports/imports intentional and backward-compatible?
- Is process termination handled safely (exitCode vs forced exit)?
- Are stream flows pipeline-based and backpressure-aware?
- Are child process calls hardened against injection and runaway output?
- Are async boundaries consistently handled with useful error context?
- Are runtime-specific assumptions (paths, shell behavior, platform quirks) accounted for?

## Output Expectations

When assisting with Node.js tasks, responses should:
- separate runtime behavior from language-level JavaScript assumptions
- call out ESM/CommonJS implications clearly
- prioritize stream safety, subprocess safety, and graceful shutdown
- recommend APIs that reduce footguns in production code