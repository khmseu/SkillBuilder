---
name: quasar
description: "Use when working with Quasar full-stack and cross-platform Vue applications, including Quasar CLI structure, SSR/SPA/PWA/mobile/desktop build modes, boot files, layouts/pages, Quasar components, and Pinia integration."
context: fork
---

# Quasar

Use this skill when building or reviewing Quasar applications that rely on Quasar's cross-platform project model, Quasar CLI conventions, startup boot files, SSR behavior, or Quasar's component/plugin ecosystem.

This skill is based on official Quasar documentation:
- https://quasar.dev/introduction-to-quasar
- https://quasar.dev/quasar-cli-vite/directory-structure
- https://quasar.dev/quasar-cli-vite/boot-files
- https://quasar.dev/quasar-cli-vite/developing-ssr/introduction
- https://quasar.dev/quasar-cli-vite/state-management-with-pinia
- https://quasar.dev/vue-components

## Domain Focus

This skill applies when tasks involve:

- Building Vue applications with Quasar CLI.
- Targeting multiple delivery modes from one codebase: SPA, SSR, PWA, Capacitor/Cordova mobile, Electron desktop, and browser extensions.
- Organizing a Quasar project around `src/`, layouts, pages, boot files, router, and mode-specific folders.
- Initializing plugins, router hooks, or app-wide dependencies with boot files.
- Working with Quasar's UI component, plugin, directive, and composable ecosystem.
- Evaluating or implementing SSR in a Quasar app.
- Using Pinia in the Quasar-prescribed project structure.

## Best Practices

- Lean into Quasar's CLI structure instead of fighting it with ad hoc project wiring.
- Keep the main app organized around the standard `src/layouts`, `src/pages`, `src/components`, `src/router`, and `src/boot` directories.
- Use Quasar boot files only for startup-time concerns that truly need access to `app`, `router`, `store`, or SSR context.
- Keep each boot file focused on one initialization concern rather than creating a giant startup file.
- Prefer Quasar components, plugins, directives, and composables when they solve the requirement cleanly, instead of layering unnecessary third-party UI libraries.
- Use Pinia as the recommended shared-state solution in larger Quasar applications.
- Treat SSR as a deliberate tradeoff: use it when SEO or time-to-content matters, not by default for every internal tool.
- Write SSR-safe code by isolating browser-only behavior to appropriate lifecycle points or client-only contexts.
- Customize Quasar primarily through `quasar.config` and documented extension points rather than undocumented build hacks.

## Common Pitfalls

- Treating Quasar like plain Vue + Vite and ignoring its startup, mode, and configuration conventions.
- Putting arbitrary code into boot files when normal imports or local component logic would be simpler.
- Building a monolithic boot file that initializes unrelated libraries and side effects together.
- Using browser-specific APIs in SSR code paths without guarding execution context.
- Choosing SSR for apps where the extra server complexity provides little value.
- Mixing multiple heavy UI systems with Quasar, which adds duplication and design inconsistency.
- Misplacing platform-specific code instead of using Quasar's dedicated `src-ssr`, `src-pwa`, `src-capacitor`, `src-cordova`, `src-electron`, or `src-bex` folders.
- Forgetting that Pinia store setup and access patterns differ slightly when scaffolded through Quasar CLI.

## Practical Patterns

### 1) Standard Quasar app structure

Typical areas to keep stable and intentional:

```text
src/
  assets/
  components/
  css/
  layouts/
  pages/
  boot/
  router/
  stores/
  App.vue
quasar.config.ts
```

### 2) Focused boot file for app startup wiring

```ts
import { defineBoot } from '#q-app/wrappers'

export default defineBoot(({ app, router, store }) => {
  // initialize one startup concern here
})
```

### 3) Async boot file when initialization must await setup

```ts
import { defineBoot } from '#q-app/wrappers'

export default defineBoot(async ({ app }) => {
  await something()
})
```

### 4) Router integration from a boot file

```ts
import { defineBoot } from '#q-app/wrappers'

export default defineBoot(({ router }) => {
  router.beforeEach((to, from, next) => {
    next()
  })
})
```

### 5) Quasar Pinia store usage

```ts
import { defineStore } from 'pinia'

export const useCounterStore = defineStore('counter', {
  state: () => ({
    counter: 0,
  }),
  getters: {
    doubleCount: state => state.counter * 2,
  },
  actions: {
    increment() {
      this.counter++
    },
  },
})
```

### 6) Accessing router inside a Quasar Pinia store

```ts
import { defineStore } from 'pinia'

export const useWhateverStore = defineStore('whatever', {
  actions: {
    goSomewhere() {
      this.router.push('/')
    },
  },
})
```

### 7) SSR decision framing

Use SSR when:
- SEO matters.
- time-to-content on first load matters.
- the app benefits from server-rendered markup before hydration.

Avoid SSR when:
- the app is an internal dashboard where initial render latency is less important.
- the added server complexity outweighs the user-facing benefit.

## Review Checklist

- Project structure:
  - Is the Quasar CLI directory structure being used as intended?
  - Is mode-specific code placed in the correct platform folder?

- Boot files:
  - Is a boot file actually necessary for this concern?
  - Does each boot file have one focused purpose?
  - Is startup code using only the boot context values it needs?

- UI stack:
  - Are Quasar components and plugins used consistently instead of mixing overlapping UI systems?
  - Is the chosen Quasar component/plugin the simplest fit for the job?

- State and routing:
  - Is Pinia structured under `src/stores` as expected?
  - Are router interactions placed in the right location (boot file, component, or store action)?

- SSR and platform behavior:
  - Is SSR justified by SEO or first-render performance needs?
  - Is browser-only code kept out of server-rendered execution paths?
  - Are platform-specific assumptions compatible with the chosen Quasar build mode?

## Output Expectations

When producing Quasar guidance or code:

- Prefer Quasar-native conventions and documented extension points.
- Distinguish clearly between generic Vue guidance and Quasar-specific project behavior.
- Call out which advice is specific to Quasar CLI, boot files, SSR mode, or platform targets.
- Favor maintainable cross-platform patterns over mode-specific hacks when the same codebase can stay shared.
- Use Quasar terminology precisely: boot files, Quasar CLI, layouts, pages, `quasar.config`, SSR mode, Pinia integration, and platform build modes.