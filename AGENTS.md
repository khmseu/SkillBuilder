# AGENTS.md

Agent-facing index of repository files that define or document GitHub Copilot customizations. Paths are relative to the repository root.

## Core Documentation

| Path | Type | Description |
| --- | --- | --- |
| `README.md` | repo-doc | Repository overview, layout, working conventions, and high-level workflow for maintaining customizations. |
| `agent.md` | repo-guide | Repository-level guidance for agents working in this repo, including purpose, conventions, workflow, and quality checks. |

## Custom Agents

| Path | Type | Description |
| --- | --- | --- |
| `.github/agents/docs-to-skill.agent.md` | custom-agent | Find official documentation for a technology and turn it into a GitHub Copilot skill. |

## Instructions

| Path | Type | Description |
| --- | --- | --- |
| `.github/instructions/conventional-commits.instructions.md` | instruction | Enforce Conventional Commits formatting when drafting or creating commits. |

## Skills

| Path | Type | Description |
| --- | --- | --- |
| `.github/skills/conventional-commits/SKILL.md` | skill | Write, review, lint, or automate Conventional Commits messages and SemVer-aware commit workflows. |
| `.github/skills/doc-to-skill/SKILL.md` | skill | Convert official documentation URLs into reusable skill files with practical guidance and usage patterns. |
| `.github/skills/e18e/SKILL.md` | skill | Improve JavaScript and TypeScript package ecosystem performance with e18e tooling and migration guidance. |
| `.github/skills/e18e-mcp/SKILL.md` | skill | Use `@e18e/mcp` to detect outdated or inefficient npm dependencies and analyze source imports. |
| `.github/skills/git-start/SKILL.md` | skill | Apply safe Git fundamentals for setup, branching, remotes, staging, stashing, and collaboration. |
| `.github/skills/github-vscode-pull-request-github/SKILL.md` | skill | Work with the GitHub Pull Requests and Issues VS Code extension for review and triage workflows. |
| `.github/skills/nodejs/SKILL.md` | skill | Use production-safe Node.js runtime, module, stream, process, and backend patterns. |
| `.github/skills/npm/SKILL.md` | skill | Work with npm installs, package metadata, lockfiles, scripts, workspaces, and publishing. |
| `.github/skills/nuxt/SKILL.md` | skill | Build and maintain Nuxt applications with routing, SSR, layouts, middleware, and server routes. |
| `.github/skills/quasar/SKILL.md` | skill | Work with Quasar applications across SPA, SSR, PWA, mobile, and desktop build modes. |
| `.github/skills/react/SKILL.md` | skill | Use modern React patterns for components, JSX, state, effects, refs, and rendering behavior. |
| `.github/skills/react-charts/SKILL.md` | skill | Maintain legacy projects that still depend on deprecated TanStack React Charts APIs. |
| `.github/skills/tanstack-ai/SKILL.md` | skill | Build with TanStack AI abstractions, model integrations, streaming workflows, and type-safe SDK patterns. |
| `.github/skills/tanstack-cli/SKILL.md` | skill | Use TanStack CLI commands for scaffolding, docs tooling, MCP integration, and automation. |
| `.github/skills/tanstack-config/SKILL.md` | skill | Configure TanStack Config for lint, build, test, version, and publish workflows. |
| `.github/skills/tanstack-db/SKILL.md` | skill | Work with TanStack DB collections, live queries, optimistic mutations, and reactive client data patterns. |
| `.github/skills/tanstack-devtools/SKILL.md` | skill | Integrate TanStack Devtools panels, diagnostics, and custom devtools experiences. |
| `.github/skills/tanstack-form/SKILL.md` | skill | Implement TanStack Form schemas, validation, field state, and submission workflows. |
| `.github/skills/tanstack-hotkeys/SKILL.md` | skill | Implement TanStack Hotkeys shortcuts, sequences, recording, and cross-platform keyboard handling. |
| `.github/skills/tanstack-intent/SKILL.md` | skill | Create and ship agent skills with TanStack Intent tooling and packaging conventions. |
| `.github/skills/tanstack-pacer/SKILL.md` | skill | Implement debouncing, throttling, batching, queueing, and rate limiting with TanStack Pacer. |
| `.github/skills/tanstack-query/SKILL.md` | skill | Use TanStack Query for caching, fetching, mutations, invalidation, and server-state synchronization. |
| `.github/skills/tanstack-ranger/SKILL.md` | skill | Build headless range and multi-range slider controls with TanStack Ranger. |
| `.github/skills/tanstack-router/SKILL.md` | skill | Work with TanStack Router routing trees, loaders, search params, and type-safe navigation. |
| `.github/skills/tanstack-start/SKILL.md` | skill | Build TanStack Start applications with file-based routing, server functions, and rendering modes. |
| `.github/skills/tanstack-store/SKILL.md` | skill | Build immutable reactive application state with TanStack Store and framework adapters. |
| `.github/skills/tanstack-table/SKILL.md` | skill | Build headless tables and data grids with TanStack Table row models and controlled state. |
| `.github/skills/tanstack-virtual/SKILL.md` | skill | Implement virtualization for large lists and grids with TanStack Virtual. |
| `.github/skills/typescript/SKILL.md` | skill | Apply strict, practical TypeScript patterns for typing, narrowing, generics, config, and migration. |
| `.github/skills/vite/SKILL.md` | skill | Work with Vite config, plugins, environments, assets, and production builds. |
| `.github/skills/vue/SKILL.md` | skill | Use Vue 3 Composition API patterns for components, reactivity, props, events, watchers, and TypeScript. |

## Usage Notes

- Prefer this file when you need a quick map of available repository customizations.
- Prefer the target file itself when you need implementation details, frontmatter, or exact instructions.