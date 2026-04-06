---
name: nuxt
description: "Use when working with Nuxt full-stack Vue applications, including file-based routing, SSR and rendering modes, Nitro server routes, data fetching with useFetch/useAsyncData, layouts, middleware, and Nuxt-specific conventions."
---

# Nuxt

Use this skill when building or reviewing Nuxt applications that rely on Nuxt's full-stack conventions, rendering pipeline, routing system, server handlers, and SSR-aware data fetching.

This skill is based on official Nuxt documentation:
- https://nuxt.com/docs/4.x/getting-started/introduction
- https://nuxt.com/docs/4.x/getting-started/data-fetching
- https://nuxt.com/docs/4.x/directory-structure/app/app
- https://nuxt.com/docs/4.x/directory-structure/app/pages
- https://nuxt.com/docs/4.x/directory-structure/server

## Domain Focus

This skill applies when tasks involve:

- Building full-stack Vue applications with Nuxt.
- Working with file-based routing in `app/pages/`.
- Structuring `app.vue`, layouts, pages, route metadata, and navigation.
- Implementing SSR-safe data fetching with `useFetch()` and `useAsyncData()`.
- Deciding when to use `$fetch` for client-triggered requests.
- Creating server routes, middleware, plugins, and utilities in `server/`.
- Using Nitro-backed runtime features such as API routes, runtime config, and deployable server output.

## Best Practices

- Lean into Nuxt conventions instead of manually rebuilding routing, SSR, or server plumbing.
- Use `app.vue` as the global shell and include `<NuxtPage />` when the pages system is enabled.
- Use `<NuxtLayout>` when you need layout composition across multiple pages.
- Prefer file-based routing through `app/pages/` and `definePageMeta()` before reaching for router customization.
- Use `useFetch()` or `useAsyncData()` for data needed during rendering or hydration.
- Use `$fetch` for event-driven browser actions such as form submissions, button clicks, or mutations.
- Give `useAsyncData()` explicit stable keys for cache sharing and refetch control.
- Keep page components to a single root element so transitions and client-side navigation behave correctly.
- Use server method suffixes like `.get.ts` and `.post.ts` to make route intent explicit.
- Pass `event` to `useRuntimeConfig(event)` inside server handlers when runtime overrides matter.

## Common Pitfalls

- Using plain `$fetch` for initial page data in universal rendering, causing duplicate server/client fetches.
- Using `useAsyncData()` for side effects rather than data fetching and caching.
- Forgetting that `server: false` delays fetching until hydration completes on initial load.
- Reusing the same `useAsyncData` key with inconsistent options like different `transform`, `pick`, or handler logic.
- Building reactive fetch URLs incorrectly by watching a ref while the URL string remains fixed.
- Forgetting `<NuxtPage />` in `app.vue` or parent route components that should render child pages.
- Returning responses from server middleware instead of only extending or inspecting request context.
- Importing `#server` code into client-side code.
- Referencing reactive component state inside `definePageMeta()`, which is hoisted.
- Assuming server routes support the same full dynamic routing behavior as pages.

## Practical Patterns

### 1) Minimal app shell with pages

```vue
<template>
  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
</template>
```

### 2) SSR-safe page data with `useFetch`

```vue
<script setup lang="ts">
const { data: users, status } = await useFetch('/api/users')
</script>

<template>
  <div v-if="status === 'pending'">Loading...</div>
  <ul v-else>
    <li v-for="user in users" :key="user.id">{{ user.name }}</li>
  </ul>
</template>
```

### 3) Custom async loading with explicit cache key

```vue
<script setup lang="ts">
const route = useRoute()

const { data: user, error } = await useAsyncData(
  `user:${route.params.id}`,
  () => myGetFunction('users', { id: route.params.id }),
)
</script>
```

### 4) Event-driven mutation with `$fetch`

```vue
<script setup lang="ts">
async function submitForm() {
  await $fetch('/api/submit', {
    method: 'POST',
    body: { message: 'Hello' },
  })
}
</script>

<template>
  <button @click="submitForm">Submit</button>
</template>
```

### 5) File-based page metadata and navigation

```vue
<script setup lang="ts">
definePageMeta({
  layout: 'default',
  middleware: ['auth'],
})

async function goToSearch(name: string) {
  await navigateTo({
    path: '/search',
    query: { name },
  })
}
</script>
```

### 6) Server route with method-specific file

```ts
export default defineEventHandler(async (event) => {
  const body = await readBody(event)
  return { body }
})
```

### 7) Runtime config in server handlers

```ts
export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig(event)

  return await $fetch('https://api.example.com/data', {
    headers: {
      Authorization: `Bearer ${config.apiSecret}`,
    },
  })
})
```

## Review Checklist

- Application structure:
  - Does `app.vue` include the right global shell pieces (`<NuxtPage />`, `<NuxtLayout>`) for the chosen structure?
  - Are routes expressed with file-based conventions before custom router overrides?

- Data fetching:
  - Is `useFetch()` or `useAsyncData()` used for render-time data?
  - Is `$fetch` reserved for client-triggered or mutation-style requests?
  - Are async data keys explicit and consistent when shared?
  - Are `lazy`, `server`, `immediate`, `pick`, `transform`, and `watch` options chosen intentionally?

- Pages and navigation:
  - Do page components have a single root element?
  - Is `definePageMeta()` used safely without reactive hoisted values?
  - Is `navigateTo()` awaited or returned?

- Server code:
  - Are server handlers placed in the correct `server/api`, `server/routes`, or `server/middleware` directory?
  - Are HTTP methods expressed explicitly when relevant?
  - Do middleware files avoid returning full responses?
  - Is `#server` used only from server code?

- Runtime behavior:
  - Is the rendering mode choice aligned with the page's needs (SSR, static, hybrid, or client-only)?
  - Are headers/cookies forwarded deliberately and safely?

## Output Expectations

When producing Nuxt guidance or code:

- Prefer Nuxt-native conventions over lower-level Vue or router workarounds.
- Distinguish clearly between universal render-time data loading and browser-only interactions.
- Explain whether code runs in page/app context, server route context, or both.
- Use Nuxt terminology precisely: Nitro, `useFetch`, `useAsyncData`, `navigateTo`, `definePageMeta`, `app/pages`, `server/api`.
- Call out caching, hydration, and payload consequences when suggesting fetch patterns.