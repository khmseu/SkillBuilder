---
name: e18e
description: "Use when improving JavaScript/TypeScript package ecosystem performance with e18e docs and tooling, including @e18e/cli analyze and migrate workflows, dependency replacement guidance, and secure npm publishing practices."
---

# e18e Skill

Use this skill when auditing, modernizing, or migrating JavaScript/TypeScript package dependencies and release workflows using e18e guidance.

This skill is based on official e18e documentation:
- https://e18e.dev/docs/
- https://e18e.dev/docs/cli/
- https://e18e.dev/docs/cli/analyze
- https://e18e.dev/docs/cli/migrate
- https://e18e.dev/docs/replacements/
- https://e18e.dev/docs/publishing

## Domain Focus

This skill covers:
- Running project analysis with `@e18e/cli analyze`
- Planning and executing dependency migrations with `@e18e/cli migrate`
- Interpreting replacement recommendations from the e18e replacements catalog
- Applying secure npm publishing practices from e18e guidance
- Reducing dependency risk and improving runtime/build performance pragmatically

## Best Practices

### Analyze First, Then Migrate

- Start with `npx @e18e/cli analyze` before making dependency changes.
- Treat analysis output as a decision aid, not an automatic mandate; validate compatibility and behavior in your project context.
- Use `--log-level debug` when analysis output is unclear or incomplete.
- Use `--manifest <path>` when you need custom replacement policies in addition to the default e18e replacements.

### Safe Migration Workflow

- Use `npx @e18e/cli migrate --interactive` for controlled package-by-package migrations.
- Use `--dry-run` first to inspect proposed changes before writing files.
- Scope file changes with `--include` when migrating incrementally in large repositories.
- Prefer small, reviewable migration batches rather than replacing many packages in a single change.
- Re-run tests, type checks, and linting after each migration batch.

### Replacements Strategy

- Prioritize replacing packages that are unmaintained, insecure, or known to have better modern alternatives.
- Read migration notes for each suggested replacement; similar packages may need analogous but not identical changes.
- Favor replacements that support modern JavaScript and TypeScript ergonomics where possible.
- Keep a changelog of migrated packages and rationale for easier review and rollback.

### Secure Publishing and Release Hygiene

- Enable 2FA on npm and GitHub accounts used for publishing.
- Prefer trusted publishing (OIDC) over long-lived npm tokens when repository setup allows it.
- Pin GitHub Actions to full commit SHAs in publish workflows.
- Separate build and publish jobs so publish credentials are not exposed to build-time scripts.
- Use install safeguards such as `--ignore-scripts` in automation when appropriate.
- Harden repo settings with branch protection and minimal workflow permissions.

## Common Pitfalls

- Running `migrate` directly on large codebases without `--dry-run` or `--interactive`.
- Treating every replacement recommendation as mandatory without validating runtime behavior.
- Applying codemods broadly without scoping file patterns, causing noisy or risky diffs.
- Mixing performance migrations with unrelated refactors in the same commit.
- Keeping legacy publish tokens when trusted publishing is available.
- Leaving workflow permissions too broad or actions unpinned.

## Practical Patterns

### Baseline Analysis

```bash
npx @e18e/cli analyze
```

### Analysis With Explicit Package Manager and Debug Logs

```bash
npx @e18e/cli analyze --pack pnpm --log-level debug
```

### Analyze With Custom Replacement Manifest

```bash
npx @e18e/cli analyze --manifest ./replacements.custom.json
```

### Preview Migration Before Writing Changes

```bash
npx @e18e/cli migrate chalk --dry-run
```

### Interactive Migration Session

```bash
npx @e18e/cli migrate --interactive
```

### Incremental Migration Scope

```bash
npx @e18e/cli migrate chalk lodash --include "src/**/*.{ts,js,tsx,jsx}"
```

## Review Checklist

- Did we run `analyze` before selecting migration targets?
- Were proposed migrations previewed with `--dry-run` when risk was non-trivial?
- Are migrations scoped and split into reviewable batches?
- Were tests, type checks, and linting run after each migration step?
- Were replacement choices documented with rationale and compatibility notes?
- Is the publish workflow hardened (2FA, trusted publishing, pinned actions, least-privilege permissions)?

## Output Expectations

When helping with e18e tasks, prefer guidance that:
- starts from measured analysis output rather than assumptions
- balances performance gains with compatibility and maintainability
- uses explicit rollback-aware migration sequencing
- includes secure publishing and supply-chain controls as first-class requirements
