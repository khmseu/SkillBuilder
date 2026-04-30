---
name: e18e-mcp
description: "Use when integrating or operating @e18e/mcp to detect inefficient or outdated npm dependencies, analyze source imports, and apply migration guidance via MCP tools/resources in AI coding workflows."
context: fork
---

# @e18e/mcp Skill

Use this skill when setting up or using the official e18e MCP server in AI-assisted coding workflows.

This skill is based on official documentation:
- https://www.npmjs.com/package/@e18e/mcp
- https://github.com/e18e/mcp#readme

## Domain Focus

This skill covers:
- Installing and wiring the `@e18e/mcp` stdio server in MCP-capable clients
- Running dependency checks against install commands
- Running import analysis against source files
- Using replacement documentation resources for migration planning
- Applying migration recommendations safely with review and validation steps

## Capabilities Reference

The server exposes:

- Tools
  - `npm-i-checker`: checks install commands such as `npm i`, `pnpm add`, `yarn add`, and `bun i`, then returns suggested alternatives.
  - `code-checker`: analyzes a JS/TS/JSX/TSX source file and returns replacement suggestions based on imports.
- Resource template
  - `replacement-docs` via `e18e://docs/{slug}` for curated package migration guidance.
- Prompt
  - `task`: returns a system prompt that reminds the model to run dependency checks before answering.

## Best Practices

### Setup and Invocation

- Prefer ephemeral execution via `npx -y @e18e/mcp` unless your environment requires global installation.
- Keep server wiring explicit in client configuration to reduce ambiguity about command and args.
- Scope server registration at the right level (`workspace` for project-specific behavior, `global` for personal defaults).

### Analysis Workflow

- Run `npm-i-checker` on proposed install commands before adding new dependencies.
- Run `code-checker` on files touched in dependency migration changes to surface stale imports.
- Use replacement docs (`e18e://docs/{slug}`) to understand migration intent, caveats, and expected code changes.
- Treat suggestions as recommendations, then validate against project constraints and runtime behavior.

### Safe Migration Strategy

- Apply dependency replacement in small batches rather than one large migration.
- Prefer dry-run style planning in your workflow (inspect suggestions first, then patch deliberately).
- Re-run tests, type checks, and linting after each migration batch.
- Document why each replacement was accepted or deferred.

### Operational Guardrails

- Note that the project is in early stages; pin/verify behavior during upgrades.
- Keep fallback plans for packages where replacement suggestions conflict with app-specific requirements.
- Do not auto-accept replacements in critical paths without performance and behavior checks.

## Common Pitfalls

- Running migrations without checking install commands first.
- Feeding partial or outdated source snippets to `code-checker`, which can hide relevant imports.
- Applying broad replacements without validating side effects in tests.
- Assuming all suggested alternatives are drop-in compatible.
- Configuring MCP clients with incorrect command/args format.

## Practical Patterns

### MCP Server Command

```bash
npx -y @e18e/mcp
```

### Dependency Gate Before Install

Input to `npm-i-checker`:

```text
pnpm add chalk glob rimraf
```

Expected outcome:
- Suggestions for more modern or better-maintained alternatives where available.

### Source Import Audit

Input to `code-checker`:

```ts
import chalk from "chalk"
import glob from "glob"
```

Expected outcome:
- Suggested replacements and migration direction for flagged imports.

### Replacement Guide Lookup

Read resource:

```text
e18e://docs/chalk
```

Expected outcome:
- Curated migration notes to guide code and dependency updates.

## Review Checklist

- Is the MCP server configured with `npx` and `-y @e18e/mcp` correctly?
- Was `npm-i-checker` run for new install commands?
- Was `code-checker` run on impacted files after dependency edits?
- Were replacement docs consulted for each flagged package?
- Were migrations validated with tests, types, and linting?
- Were non-trivial replacement decisions documented?

## Output Expectations

When helping with @e18e/mcp tasks, prefer guidance that:
- uses checker outputs before prescribing dependency changes
- keeps migrations incremental and reversible
- distinguishes recommendation from mandatory action
- includes verification steps after every dependency/import change
