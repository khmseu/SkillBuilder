---
name: vite
description: "Use when working with Vite projects, vite.config, plugins, env modes, static assets, dependency pre-bundling, build output, deployment, or backend integration. Covers official Vite practices for fast dev workflows, production builds, and common configuration pitfalls."
context: fork
---

# Vite Skill

Use this skill when creating, configuring, debugging, or deploying applications built with Vite.

This skill is based on official Vite documentation:
- https://vite.dev/guide/
- https://vite.dev/config/
- https://vite.dev/guide/using-plugins
- https://vite.dev/guide/dep-pre-bundling
- https://vite.dev/guide/assets
- https://vite.dev/guide/build
- https://vite.dev/guide/env-and-mode
- https://vite.dev/guide/static-deploy
- https://vite.dev/guide/backend-integration

## Domain Focus

This skill covers:
- Project setup and standard scripts for dev, build, and preview
- Vite config patterns with type-safe and conditional configuration
- Plugin usage and ordering
- Dependency pre-bundling behavior and optimization controls
- Static asset handling, public assets, and URL transformations
- Environment variables, modes, and safe secret handling
- Production build behavior, base path deployment, and chunking strategy
- Monorepo and backend integration patterns

## Best Practices

### Project Setup and Core Scripts

- Use standard scripts in package.json:
  - dev: vite
  - build: vite build
  - preview: vite preview
- Use create-vite for scaffolding when starting new apps.
- Respect Vite Node.js requirements from the current docs before setup.
- Keep index.html at the project root as the app entry in dev unless a custom root is intentional.

### Config Patterns

- Prefer defineConfig for better IDE support and safer config authoring.
- Use conditional config functions when behavior differs between serve and build.
- Use explicit checks for optional flags such as isSsrBuild or isPreview because some tools can pass undefined.
- Use loadEnv in config only when env file values must affect config resolution itself.
- Keep config simple and explicit before introducing advanced Rolldown customization.

### Plugins

- Add plugins to devDependencies and register them in plugins.
- Prefer official Vite plugins first, then vetted community plugins.
- Use apply to scope plugins to serve or build when needed.
- Use enforce with pre or post only when plugin ordering needs explicit control.
- Re-check whether a plugin is necessary, since Vite already includes many common capabilities.

### Dependency Pre-Bundling

- Understand that pre-bundling is a development optimization, not a production build feature.
- Let automatic dependency discovery work by default before customizing optimizeDeps.
- Use optimizeDeps.include for linked or transformed dependencies that are not discovered early.
- Use optimizeDeps.exclude for small, already-valid ESM dependencies when direct browser loading is preferable.
- In monorepos, remember linked deps outside node_modules are treated as source and may require include if not ESM.
- Use vite --force or clear node_modules/.vite when debugging stale pre-bundle cache behavior.

### Assets and Public Files

- Prefer importing assets from source for hashing and graph-aware processing.
- Use the public directory only when files must keep exact names or are never imported.
- Reference public files with root-absolute paths, for example /icon.png.
- Use query suffixes intentionally:
  - ?url for explicit URL import
  - ?inline and ?no-inline for inlining behavior
  - ?raw for string import
  - ?worker and ?sharedworker for worker entry handling
- Use new URL(..., import.meta.url) only with static paths and only where SSR semantics are appropriate.

### Env Variables and Modes

- Treat mode and NODE_ENV as related but distinct concepts.
- Expose only client-safe variables via VITE_ prefix.
- Never place secrets in VITE_ variables because they are bundled into client code.
- Remember env values are strings and convert types explicitly in application code.
- Restart the dev server after changing .env files.
- Use mode-specific env files for environment variants and keep local secrets in .env.*.local with proper gitignore rules.

### Build and Deploy

- Use vite build for production output and vite preview only for local verification, not as production hosting.
- Set base correctly for nested deployment paths and static hosts.
- Use import.meta.env.BASE_URL exactly as-is when constructing dynamic base-aware URLs.
- Tune build.target only when browser support requirements demand it.
- For legacy browser support, use @vitejs/plugin-legacy instead of ad-hoc transpilation workarounds.
- Handle stale dynamic import chunks after deploys by listening for vite:preloadError and setting correct HTML cache headers.

### Backend Integration

- For traditional backend-rendered HTML, enable build.manifest and map backend templates to manifest outputs.
- Inject @vite/client and entry module scripts in development integration mode.
- In production integration, render CSS and module preload tags from the manifest dependency graph in recommended order.
- Configure server.origin or proxy behavior so assets resolve correctly during backend-served development.

## Common Pitfalls

- Treating vite preview as a production server.
- Misconfigured base causing broken paths after deployment under subpaths.
- Attempting to access non-VITE env vars on the client.
- Putting secrets in env vars that are exposed to client bundles.
- Over-customizing optimizeDeps before validating default behavior.
- Forgetting that linked monorepo deps may need ESM compatibility or optimizeDeps.include.
- Using non-static new URL patterns that cannot be transformed safely for production.
- Incorrect plugin order or running build-only plugins during serve.
- Editing env files without restarting the dev server.

## Practical Patterns

### Minimal Vite Scripts

```json
{
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  }
}
```

### Typed Vite Config

```ts
import { defineConfig } from 'vite'

export default defineConfig({
  // options
})
```

### Conditional Config by Command and Mode

```ts
import { defineConfig } from 'vite'

export default defineConfig(({ command, mode }) => {
  if (command === 'serve') {
    return { server: { port: 5173 } }
  }

  return {
    build: { sourcemap: mode !== 'production' }
  }
})
```

### Load Env Values in Config

```ts
import { defineConfig, loadEnv } from 'vite'

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '')
  return {
    server: {
      port: env.APP_PORT ? Number(env.APP_PORT) : 5173
    }
  }
})
```

### Plugin with Controlled Application and Order

```ts
import legacy from '@vitejs/plugin-legacy'
import { defineConfig } from 'vite'

export default defineConfig({
  plugins: [
    {
      ...legacy(),
      apply: 'build',
      enforce: 'post'
    }
  ]
})
```

### Optimize Dep Pre-Bundling in Monorepos

```ts
import { defineConfig } from 'vite'

export default defineConfig({
  optimizeDeps: {
    include: ['linked-dep']
  }
})
```

### Deploy Under Repository Subpath

```ts
import { defineConfig } from 'vite'

export default defineConfig({
  base: '/my-repo/'
})
```

## Review Checklist

- Are dev, build, and preview scripts present and correct?
- Is base configured appropriately for the deployment path?
- Are env values used safely, with only client-safe keys exposed via VITE_?
- Does config logic correctly distinguish serve versus build behavior?
- Are plugins scoped and ordered intentionally?
- Are optimizeDeps customizations justified by real discovery or compatibility issues?
- Are static assets handled through imports versus public directory for the right reasons?
- If backend integration is used, is manifest enabled and consumed correctly?

## Output Expectations

When assisting with Vite tasks, responses should:
- prefer official Vite conventions over generic bundler assumptions
- clearly separate development behavior from production build behavior
- call out deployment-path and env exposure risks early
- provide concrete config and script snippets that are immediately usable