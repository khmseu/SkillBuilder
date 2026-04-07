---
name: prettier
description: "Use when configuring, running, or integrating Prettier for code formatting, including .prettierrc options, CLI usage, editor integration, pre-commit hooks, and CI checks. Trigger phrases: prettier, code formatter, format code, prettierrc, prettier config, prettier cli, prettier check"
---

# Prettier

Use this skill when setting up, configuring, or running Prettier as a code formatter.

Official sources used:
- https://prettier.io/docs/
- https://prettier.io/docs/options
- https://prettier.io/docs/configuration

## Domain Focus

This skill applies when tasks involve:

- Installing and wiring Prettier into a project.
- Writing or reviewing a `.prettierrc` / `prettier.config.*` configuration file.
- Integrating Prettier with ESLint, editor extensions, pre-commit hooks, or CI.
- Understanding which options to set and which to leave at defaults.
- Formatting specific file types or overriding options per pattern.

## Best Practices

- Let Prettier decide formatting — its value is in removing formatting decisions, not in customizing them. Keep the config minimal.

- Use a config file rather than CLI flags for repeatable behavior:
  - `.prettierrc` (JSON/YAML), `prettier.config.js` (ESM), or `"prettier"` key in `package.json`.
  - Checked-in config ensures all contributors and tooling use the same settings.

- The most commonly necessary options:
  - `singleQuote: true` — if your codebase uses single quotes.
  - `semi: false` — if you prefer semicolon-free style.
  - `trailingComma: "all"` — enables trailing commas including function params (default in v3).
  - `tabWidth: 2` (default) or `4` — match your team preference.
  - `printWidth: 80` — a _guideline_, not a hard limit; Prettier decides actual wrapping.

- Use `overrides` to apply different settings per file type:
  ```json
  { "overrides": [{ "files": "*.md", "options": { "proseWrap": "always" } }] }
  ```

- Integrate with ESLint safely:
  - Use `eslint-config-prettier` to disable ESLint rules that conflict with Prettier.
  - Do not use `eslint-plugin-prettier` — it outputs formatting errors as lint errors and slows down both tools.

- Run Prettier in CI with `prettier --check .` to fail the build on unformatted files.

- Use `--write` locally; never use `--write` in CI (it would silently pass by modifying files).

- Integrate with `.editorconfig` — Prettier reads the file and applies compatible settings (indent, line endings, etc.) unless overridden by `.prettierrc`.

- Set `endOfLine: "lf"` explicitly in the config and pair with a `.gitattributes` `* text=auto eol=lf` entry to prevent CRLF/LF churn on Windows.

## Common Pitfalls

- Setting `printWidth` and expecting it to behave like ESLint's `max-len` — it is a soft formatting target, not a hard line length limit.
- Placing `parser` at the top level of config — only use it inside `overrides`. At top level it disables automatic file-type detection.
- Running both `eslint --fix` and `prettier --write` in the wrong order — always run Prettier _after_ ESLint auto-fix, or let them run independently.
- Customizing every option extensively — Prettier's strength is opinionated defaults. Heavy customization defeats the purpose.
- Using `--require-pragma` in new projects — it is meant for gradual adoption in large codebases that haven't been formatted yet.
- Formatting markdown with `proseWrap: "always"` in projects where GitHub renders line-break-sensitive text — use `"preserve"` (the default) unless you know your renderer is safe.
- Skipping `.prettierignore` — always add `node_modules`, build outputs, and generated files.

## Practical Patterns

### 1) Minimal config (`.prettierrc`)

```json
{
  "singleQuote": true,
  "semi": false,
  "trailingComma": "all"
}
```

### 2) ESM config (`prettier.config.mjs`)

```js
/** @type {import("prettier").Config} */
export default {
  singleQuote: true,
  semi: false,
  trailingComma: 'all',
  tabWidth: 2,
}
```

### 3) Per-file-type overrides

```json
{
  "semi": false,
  "overrides": [
    { "files": "*.json", "options": { "tabWidth": 4 } },
    { "files": "*.md",   "options": { "proseWrap": "always" } }
  ]
}
```

### 4) npm scripts

```json
{
  "scripts": {
    "format": "prettier --write .",
    "format:check": "prettier --check ."
  }
}
```

### 5) `.prettierignore`

```
node_modules
dist
build
coverage
*.min.js
```

### 6) CI check (GitHub Actions example)

```yaml
- name: Check formatting
  run: npx prettier --check .
```

## Review Checklist

- Is there a `.prettierrc` (or equivalent) config file committed to the repo?
- Is the `parser` option absent from the top level of config?
- Is a `.prettierignore` file present and covering build/generated files?
- Is `eslint-config-prettier` in use when ESLint is also configured?
- Does CI run `prettier --check .` (not `--write`)?
- Is `endOfLine: "lf"` set to prevent cross-platform line ending drift?

## Output Expectations

When producing Prettier configuration or scripts:

- Default to a minimal config — only override what differs from the defaults.
- Prefer `.prettierrc` JSON for simplicity; suggest `prettier.config.mjs` for comment support.
- Call out the `--check` vs `--write` distinction when configuring CI.
- Recommend `eslint-config-prettier` and dissuade `eslint-plugin-prettier` when ESLint is in use.
