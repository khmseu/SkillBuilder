---
name: tanstack-table
description: "Use when building headless tables/datagrids with TanStack Table, including column defs, row models, sorting, filtering, pagination, and controlled table state."
context: fork
---

# TanStack Table



## Domain Focus

Use this skill when working with TanStack Table, including:

- Core APIs, patterns, and framework adapters documented in official docs.
- Production-safe setup, configuration, and integration decisions.
- Type-safe usage patterns and error handling conventions.
- Performance and DX trade-offs specific to this library.

## Best Practices

- Start from official quick-starts and framework adapters before custom abstractions.
- Keep a thin wrapper around third-party integration points so upgrades remain simple.
- Prefer typed APIs and validated inputs/outputs for reliability across app layers.
- Add library-specific logic incrementally, then profile before introducing advanced optimizations.
- Keep examples and helper utilities close to official patterns to reduce maintenance cost.

## Common Pitfalls

- Mixing incompatible versions across TanStack packages and adapters.
- Bypassing documented patterns in favor of framework-agnostic assumptions.
- Over-abstracting early, which hides important library semantics.
- Treating alpha/beta features as stable without version pinning and release tracking.
- Skipping error states, loading states, and invalid-input handling.

## Practical Patterns

- Begin with the official starter route for your framework/runtime.
- Isolate library configuration in one module and import it everywhere else.
- Prefer composable primitives/hooks over one-off imperative code.
- Use explicit typing for public utility functions and shared contracts.

## Review Checklist

- Does code follow the current official docs for TanStack Table?
- Are versions and adapters aligned with the chosen framework/runtime?
- Are edge cases and error states handled in library-facing code?
- Are abstractions minimal and preserving library intent?
- Is the implementation easy to upgrade with future minor/major releases?

## Output Expectations

When producing code or guidance with this skill:

- Cite official docs and use current terminology from the project.
- Prefer concrete, copy-ready snippets over generic advice.
- Call out version constraints and stability level (stable/alpha/beta/RC).
- Include migration or fallback notes if a feature is experimental.

## Source Docs

- https://tanstack.com/table/latest
