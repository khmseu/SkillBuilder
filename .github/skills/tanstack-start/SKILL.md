---
name: tanstack-start
description: Use when working with TanStack Start (React), including file-based routing, isomorphic execution boundaries, server functions, server routes, SSR/SPA/static modes, environment variables, and deployment targets. Covers official TanStack Start guidance for safe full-stack patterns.
context: fork
---

# TanStack Start

## Domain Focus

This skill applies to TanStack Start React applications that need:

- File-based full-stack routing with TanStack Router conventions.
- Clear server/client execution boundaries.
- Type-safe server functions (RPC-style) and server routes (raw HTTP handlers).
- Correct handling of loaders, SSR, SPA mode, and prerender/static generation.
- Secure environment variable usage across server and client.
- Production deployment to Vite-compatible providers (Cloudflare, Netlify, Railway, Nitro, etc.).

Use this skill whenever building or reviewing a Start codebase where code may run in both environments and where route + server integration is central.

## Best Practices

### Project Setup and Lifecycle

- Scaffold with official Start flows:
  - `npx @tanstack/cli@latest create`
  - Official examples when you want a known-good baseline.
- For RC usage in production, pin versions and stay current with release notes.
- Treat TanStack Start as TanStack Router + Vite full-stack runtime capabilities.

### Execution Model and Environment Boundaries

- Assume code is **isomorphic by default** unless explicitly constrained.
- Remember route `loader`s are isomorphic and may run on both server and client.
- Use explicit environment controls:
  - `createServerFn` for server execution callable from client (RPC transport).
  - `createServerOnlyFn` for true server-only utilities.
  - `createClientOnlyFn` / `<ClientOnly>` / hydration-aware logic for browser-only behavior.
- Keep secrets out of any isomorphic path that can enter client bundles.

### Server Functions

- Define server functions with `createServerFn` and an explicit HTTP method when relevant.
- Always validate inputs (`inputValidator`, e.g., Zod schemas).
- Organize for maintainability:
  - `.functions.ts` for server function wrappers.
  - `.server.ts` for server-only internals (DB, secrets, private helpers).
  - shared client-safe schemas/types in regular `.ts` modules.
- Statically import server functions where needed; avoid dynamic imports for them.

### Server Routes

- Use route file conventions in `src/routes` for API-like handlers.
- Use `server.handlers` for method maps and `createHandlers` when per-method middleware is needed.
- Apply route-level middleware for shared concerns (auth/logging), then method-specific middleware for endpoint-specific checks.
- Use dynamic params (`$id`) and escaped path tokens only when needed and documented.
- Ensure route path uniqueness: do not define duplicate files resolving to same route.

### Environment Variables

- Server-side access: `process.env.*` (all vars available in server context).
- Client-side access: only `import.meta.env.VITE_*`.
- Keep secrets (DB URLs, API secrets, JWT secrets) server-only.
- Use typed env declarations to reduce runtime config mistakes.
- Use `.env.local` for local overrides and keep it out of version control.

### Rendering and Delivery Modes

- Use SSR when SEO or first-content performance is important.
- Use SPA mode when static shell deployment simplicity is a priority.
- In SPA mode:
  - Configure shell generation (`/_shell.html` by default).
  - Add correct rewrites so unresolved routes map to shell.
  - Allow-list server paths (`/_serverFn/*`, `/api/*`) when needed.
- Use prerendering/static generation for routes that can be materialized ahead of time.

### Hosting and Deployment

- TanStack Start supports any Vite-compatible deployment target.
- Prefer official provider integrations where available:
  - Cloudflare plugin + Wrangler for Workers.
  - Netlify plugin for platform-aware builds/dev emulation.
  - Nitro for broad adapter surface.
- Keep build/deploy scripts explicit and environment-appropriate.

## Common Pitfalls

- Assuming loaders are server-only and reading secrets directly in loader code.
- Putting sensitive values in `VITE_*` variables.
- Mixing server-only logic into client-executed modules.
- Dynamic-importing server function modules.
- Using duplicate server route files that resolve to identical paths.
- Enabling SPA mode without proper rewrite rules to the shell.
- Forgetting to route server function/server route prefixes through infrastructure in SPA/static setups.
- Hydration flashes when shell-specific and hydrated UI rendering are not coordinated.

## Practical Patterns

### 1) Safe server function with validation

```tsx
import { createServerFn } from '@tanstack/react-start'
import { z } from 'zod'

const Input = z.object({ id: z.string().min(1) })

export const getUser = createServerFn({ method: 'GET' })
  .inputValidator(Input)
  .handler(async ({ data }) => {
    // Server-only code path
    return db.user.findUnique({ where: { id: data.id } })
  })
```

### 2) Loader calling server function (isomorphic-safe)

```tsx
export const Route = createFileRoute('/users/$id')({
  loader: ({ params }) => getUser({ data: { id: params.id } }),
  component: UsersPage,
})
```

### 3) Server route with route-level and method-level middleware

```tsx
export const Route = createFileRoute('/api/users/$id')({
  server: {
    middleware: [authMiddleware],
    handlers: ({ createHandlers }) =>
      createHandlers({
        GET: async ({ params }) =>
          new Response(JSON.stringify({ id: params.id })),
        POST: {
          middleware: [validationMiddleware],
          handler: async ({ request, params }) => {
            const body = await request.json()
            return new Response(JSON.stringify({ id: params.id, body }))
          },
        },
      }),
  },
})
```

### 4) Environment boundary usage

```tsx
// server
const getSecret = createServerFn().handler(async () => {
  return { hasSecret: Boolean(process.env.JWT_SECRET) }
})

// client
export function Header() {
  return <h1>{import.meta.env.VITE_APP_NAME}</h1>
}
```

### 5) SPA mode shell configuration

```ts
// vite.config.ts
export default defineConfig({
  plugins: [
    tanstackStart({
      spa: {
        enabled: true,
        prerender: {
          outputPath: '/_shell.html',
        },
      },
    }),
  ],
})
```

## Review Checklist

- Execution model:
  - Is any secret-bearing code path guaranteed server-only?
  - Are loaders free of direct secret access?

- Server functions:
  - Inputs validated?
  - Correct method semantics and static imports?
  - Server-only helpers isolated from client bundles?

- Server routes:
  - No duplicate route path resolutions?
  - Middleware layered correctly (global vs method-specific)?

- Environment variables:
  - Only public values in `VITE_*`?
  - Sensitive vars accessed only via server context?

- Rendering/deploy mode:
  - SSR vs SPA/prerender choice justified?
  - SPA rewrites and allow-lists configured for `/_serverFn/*` and API paths?

- Hosting:
  - Provider-specific plugin/config present when required?
  - Build/deploy scripts aligned with target runtime?

## Output Expectations

When producing TanStack Start guidance or code:

- Start by clarifying where each code path executes (server, client, or both).
- Prefer official Start patterns over generic framework assumptions.
- Include input validation and type-safe boundaries by default.
- Surface deployment and rewrite implications whenever SPA/static modes are used.
- Call out security boundaries explicitly for env vars and server-only logic.

## Source Docs

This skill is derived from official TanStack Start documentation:

- https://tanstack.com/start/latest/docs/framework/react/overview
- https://tanstack.com/start/latest/docs/framework/react/getting-started
- https://tanstack.com/start/latest/docs/framework/react/quick-start
- https://tanstack.com/start/latest/docs/framework/react/guide/execution-model
- https://tanstack.com/start/latest/docs/framework/react/guide/server-functions
- https://tanstack.com/start/latest/docs/framework/react/guide/static-server-functions
- https://tanstack.com/start/latest/docs/framework/react/guide/server-routes
- https://tanstack.com/start/latest/docs/framework/react/guide/environment-variables
- https://tanstack.com/start/latest/docs/framework/react/guide/spa-mode
- https://tanstack.com/start/latest/docs/framework/react/guide/hosting
