---
name: zendframework
description: "Use when maintaining or migrating Zend Framework (ZF) applications and components, including zend-mvc, Expressive, and package rename migration to Laminas. Trigger phrases: zendframework, zend framework, zf2, zf3, zend-mvc, zend expressive, migrate zend to laminas"
context: fork
---

# Zend Framework Skill

Use this skill when working on legacy Zend Framework codebases, planning upgrades, or migrating from Zend Framework to Laminas.

Official sources used:
- https://framework.zend.com/
- https://docs.zendframework.com/
- https://docs.laminas.dev/migration/

## Domain Focus

This skill covers:
- Legacy Zend Framework architecture and package ecosystem awareness
- zend-mvc and Expressive (middleware) maintenance workflows
- Dependency, namespace, and configuration migration from `zendframework/*` to `laminas/*`
- Safe migration sequencing using official Laminas tooling
- Risk control for teams maintaining production ZF2/ZF3 applications

## Best Practices

### Treat Zend Framework as Legacy and Plan Forward

- Assume Zend Framework is in legacy/archived state and favor migration-minded changes.
- Keep new work incremental and avoid broad rewrites without test coverage.
- Prefer compatibility-preserving refactors before package-level migration.
- Document whether a code path is temporary legacy support or post-migration target.
- Track high-risk integration points early (authentication, session, routing, custom factories).

### Stabilize Before Migration

- Ensure the application is under version control before running migration tooling.
- Run and fix existing tests before changing dependencies.
- Baseline current runtime behavior (routes, middleware order, error handling).
- Remove dead code and unused modules to reduce migration surface area.
- Freeze unrelated feature work during migration windows.

### Use Official Migration Tooling Correctly

- Use `laminas/laminas-migration` via global Composer install or cloned tool, not as a local project dependency.
- Run migration from project root and use excludes/filters for large non-source directories.
- Review rewritten symbols and config keys before dependency reinstall.
- Reinstall dependencies and run full tests immediately after migration.
- Prefer non-conservative upgrades unless strict lock retention is required.

### Keep Dependency and Config Changes Explicit

- Treat package renames (`zendframework/*` -> `laminas/*`) as separate, reviewable commits when possible.
- Audit custom code for hardcoded `Zend\\` namespaces and legacy config keys.
- Verify DI/container wiring after namespace and package changes.
- Confirm middleware pipeline order and route dispatch behavior after migration.
- Recheck serialization/session boundaries across package substitutions.

### Security and Operational Hygiene

- Review historical Zend security advisories relevant to installed legacy components.
- Update exposed packages to maintained Laminas equivalents where available.
- Keep production error output minimal while preserving actionable logs.
- Validate authentication and authorization behavior through regression tests.
- Re-run smoke tests for critical business workflows before deployment.

## Common Pitfalls

- Treating Zend Framework docs as current without accounting for Laminas move.
- Installing `laminas-migration` locally and breaking migration execution.
- Migrating dependencies without first stabilizing or testing legacy behavior.
- Missing custom namespaces, config keys, or factory references during rewrites.
- Assuming zend-mvc and Expressive migration impacts are identical.
- Performing migration and major feature changes in the same release.

## Practical Patterns

### High-Level Migration Sequence

```bash
composer global require laminas/laminas-migration
cd path/to/project
laminas-migration migrate -e data -e public/images
composer install
```

### Composer Package Rename Audit

```bash
composer show | rg '^zendframework/'
composer show | rg '^laminas/'
```

### Namespace Reference Spot Check

```bash
rg 'Zend\\\\|zendframework/' src config module
```

## Review Checklist

- Is the change for legacy maintenance or migration, and is that scope explicit?
- Are migration prerequisites met (version control, baseline tests, rollback path)?
- Were package, namespace, and config rewrites reviewed rather than auto-accepted?
- Do routing, middleware, DI/container, session, and auth flows still pass tests?
- Were dependency and behavioral changes split clearly for safer rollout?
- Is there a post-migration cleanup plan for temporary compatibility code?

## Output Expectations

When assisting with Zend Framework tasks, responses should:
- treat Zend Framework as legacy and recommend Laminas-aligned paths
- prioritize safe, reversible migration and maintenance steps
- call out where automated rewrites require manual verification
- minimize operational risk with test-first, incremental change guidance
