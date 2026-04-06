---
name: npm
description: "Use when working with npm, package.json, npm install, npm publish, npm workspaces, npm dependency management, npm scripts, package metadata, lockfiles, or registry publishing. Covers official npm CLI practices for installs, metadata, workspaces, publishing, and common dependency pitfalls."
---

# NPM Skill

Use this skill when creating, maintaining, or reviewing projects that use npm as the package manager.

This skill is based on the official npm documentation at:
- https://docs.npmjs.com/about-npm
- https://docs.npmjs.com/cli/v11/commands/npm-install
- https://docs.npmjs.com/cli/v11/configuring-npm/package-json
- https://docs.npmjs.com/cli/v11/using-npm/workspaces
- https://docs.npmjs.com/creating-and-publishing-unscoped-public-packages

## Domain Focus

This skill covers:
- Choosing the right npm install behavior for application and library work
- Writing and reviewing `package.json` metadata correctly
- Managing dependencies, devDependencies, peerDependencies, optionalDependencies, and overrides
- Using lockfiles and reproducible install workflows correctly
- Structuring and operating npm workspaces
- Preparing packages for publishing and avoiding accidental publication or data leaks

## Best Practices

### Dependency Management

- Treat `package.json` as the source of truth for allowed version ranges and `package-lock.json` as the source of truth for exact resolved versions.
- Use `npm ci` instead of `npm install` in CI when you need strict lockfile fidelity and reproducible installs.
- Put runtime requirements in `dependencies` and development-only tooling in `devDependencies`.
- Use `peerDependencies` for plugin or host-package compatibility, and keep peer ranges broad when semver compatibility allows it.
- Use `peerDependenciesMeta` to mark optional peer integrations instead of forcing every consumer to install them.
- Use `optionalDependencies` only when your code can genuinely continue to work without them.
- Use `overrides` at the project root to pin or replace vulnerable or incompatible transitive dependencies.
- Prefer registry versions over git dependencies unless there is a strong reason not to, because git dependencies can trigger extra install/build behavior.

### package.json Conventions

- For publishable packages, always provide `name` and `version`.
- Keep package names lowercase, URL-safe, and distinct from Node core modules.
- Include useful discovery and maintenance metadata: `description`, `keywords`, `homepage`, `bugs`, `repository`, and `license`.
- Use SPDX license identifiers or SPDX expressions instead of deprecated legacy license object formats.
- Set `private: true` for projects that should never be published.
- Use `publishConfig` when publish-time registry, access, or tag settings must be constrained.
- Prefer the normalized object form for `repository` to avoid publish warnings.
- Use `files` deliberately so published tarballs contain only what consumers need.
- Prefer `exports` to define the supported public surface of a package when appropriate.
- If a package exposes a CLI, define `bin` correctly and ensure the target file starts with `#!/usr/bin/env node`.

### Installs and Lockfiles

- Understand that `npm install` updates the lockfile when declared ranges and locked versions no longer agree.
- Use `--save-dev`, `--save-peer`, `--save-optional`, and `--no-save` intentionally rather than relying on defaults when the dependency role matters.
- Use `--save-exact` when your workflow requires exact dependency specs instead of npm's default semver range behavior.
- Use `--omit` and `--include` to control what lands on disk without changing logical dependency resolution.
- Use `--ignore-scripts` or `--dry-run` when auditing or testing install behavior safely.

### Workspaces

- Define workspaces in the root `package.json` using explicit paths or globs.
- Use `npm init -w <path>` to create and register a workspace consistently.
- Add dependencies to a specific workspace with `npm install <pkg> -w <workspace>`.
- Run scripts across workspaces with `--workspace` or `--workspaces` rather than manual directory loops.
- Use `--if-present` when running scripts across multiple workspaces that may not all define the same script.
- Remember that workspace command execution order follows the order declared in the root `workspaces` array.

### Publishing and Security

- Review package contents before publishing to avoid shipping secrets, keys, credentials, PII, or unnecessary test data.
- Use `.npmignore`, `.gitignore`, and the `files` field carefully to control publish contents.
- Test an unpublished package locally before release, for example by installing it from its local path.
- Use trusted publishing in CI when available instead of long-lived registry tokens.
- Be explicit about access and registry settings when publishing scoped or internal packages.

## Common Pitfalls

- Putting build tools, test frameworks, or transpilers in `dependencies` instead of `devDependencies`.
- Forgetting that `private: true` is the simplest guard against accidental publication.
- Assuming `npm install` is equivalent to `npm ci` in CI or release workflows.
- Using narrow `peerDependencies` ranges that create avoidable install conflicts.
- Depending on git URLs with lifecycle scripts, which can force repeated builds during installation.
- Publishing too many files because `files`, `.npmignore`, and generated artifacts were not reviewed.
- Mixing `bin` and `directories.bin`, which npm treats as an error.
- Assuming workspace commands run in arbitrary order; npm uses the order in the root workspace list.
- Putting overrides in nested packages or published dependencies and expecting them to affect root resolution.

## Practical Patterns

### Typical Application Package

```json
{
  "name": "my-app",
  "private": true,
  "version": "1.0.0",
  "scripts": {
    "dev": "node server.js",
    "test": "node --test"
  },
  "dependencies": {
    "express": "^5.0.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0"
  }
}
```

### Library With Clear Publish Metadata

```json
{
  "name": "@acme/widgets",
  "version": "1.2.0",
  "description": "Reusable widget primitives",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "git+https://github.com/acme/widgets.git"
  },
  "files": [
    "dist",
    "README.md"
  ],
  "exports": {
    ".": "./dist/index.js"
  }
}
```

### Monorepo Workspaces

```json
{
  "name": "acme-monorepo",
  "private": true,
  "workspaces": [
    "packages/*"
  ]
}
```

Useful commands:

```bash
npm init -w ./packages/core
npm install lodash -w core
npm run test --workspaces --if-present
```

### Root-Level Override For A Vulnerable Dependency

```json
{
  "overrides": {
    "some-transitive-package": "1.2.3"
  }
}
```

## Review Checklist

- Is the dependency in the correct section of `package.json`?
- Is the versioning policy appropriate: semver range, exact pin, peer range, or override?
- Does the project need `npm ci` instead of `npm install` for this workflow?
- Is the package metadata complete and normalized for publishing?
- Could `private: true` or `publishConfig` prevent an accidental release?
- Are publish contents constrained with `files` or ignore rules?
- If workspaces are used, is the command scoped correctly with `-w`, `--workspace`, or `--workspaces`?
- If a git or file dependency is used, is that intentional and safe for the target workflow?

## Output Expectations

When helping with npm tasks, prefer guidance that:
- distinguishes app dependencies from publishable library concerns
- calls out lockfile and install-mode consequences explicitly
- uses official npm terminology for dependency types and workspace behavior
- recommends safer publishing and dependency-resolution patterns when there is risk