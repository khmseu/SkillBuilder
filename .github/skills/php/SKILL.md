---
name: php
description: "Use when working with PHP language features, runtime behavior, CLI usage, and security guidance from the official PHP manual. Trigger phrases: php, php language, php cli, php security, php manual, write php, debug php"
---

# PHP Skill

Use this skill when building, reviewing, or debugging PHP applications and scripts.

Official sources used:
- https://www.php.net/docs.php
- https://www.php.net/manual/en/
- https://www.php.net/manual/en/langref.php
- https://www.php.net/manual/en/security.php
- https://www.php.net/manual/en/features.commandline.php

## Domain Focus

This skill covers:
- Core PHP language syntax, types, functions, and control structures
- Runtime behavior across web and CLI SAPIs
- Modern PHP language features (for example enums, attributes, fibers, and match)
- Error and exception handling patterns using Throwable/Error/Exception
- Security-first PHP practices from the official security manual

## Best Practices

### Language and Type Safety

- Prefer explicit parameter, return, and property types in new code.
- Use strict comparisons (`===`, `!==`) when exact type behavior matters.
- Keep function signatures stable and specific instead of relying on implicit type juggling.
- Use enums for constrained domain values instead of string constants when feasible.
- Use attributes only when they add clear, inspectable metadata value.

### Structure and Reuse

- Keep files focused: one responsibility per class/module-level file.
- Use namespaces and imports consistently; avoid mixed global/qualified calls without reason.
- Prefer autoloaded class usage over manual include chains in larger codebases.
- Keep framework glue and domain logic separated to improve testability.
- Use exceptions for exceptional paths, not normal control flow.

### Runtime and Error Handling

- Catch and handle predictable failures at boundaries (I/O, network, database).
- Surface actionable error context while avoiding sensitive data leakage.
- Use `Throwable`-aware handling in top-level entry points.
- Configure environment-appropriate error reporting (development vs production).
- In CLI scripts, set explicit exit codes for failure paths.

### CLI and SAPI Awareness

- Distinguish CLI behavior from web server behavior when using superglobals and I/O.
- Use `PHP_SAPI` or `php_sapi_name()` when code must branch by runtime context.
- Use standard input/output streams for interactive or pipeline-based CLI scripts.
- Keep CLI scripts deterministic and side-effect aware for automation.
- Verify CLI vs CGI assumptions when deploying or packaging scripts.

### Security Fundamentals

- Treat all user input as untrusted and validate/normalize early.
- Use parameterized queries for database access to prevent SQL injection.
- Keep include/require targets constrained and predictable.
- Minimize sensitive error output in production.
- Keep PHP runtime and dependencies current as part of routine maintenance.

## Common Pitfalls

- Relying on loose comparisons where type juggling changes behavior.
- Mixing CLI and web assumptions (for example request variables or output handling).
- Using unchecked dynamic includes or file paths derived from user input.
- Catching broad exceptions and silently ignoring failures.
- Exposing stack traces or internal paths in production responses.
- Treating old snippets as universally valid across current PHP versions.

## Practical Patterns

### Strict Types and Explicit Contracts

```php
<?php
declare(strict_types=1);

function formatUserLabel(string $name, int $id): string
{
    return sprintf('%s#%d', $name, $id);
}
```

### Explicit Runtime Branching for CLI

```php
<?php
declare(strict_types=1);

if (PHP_SAPI === 'cli') {
    fwrite(STDOUT, "Running in CLI\n");
} else {
    echo "Running in web SAPI";
}
```

### Boundary Error Handling with Exit Codes

```php
<?php
declare(strict_types=1);

try {
    // perform operation
    exit(0);
} catch (Throwable $e) {
    fwrite(STDERR, "Operation failed\n");
    exit(1);
}
```

## Review Checklist

- Are types and comparisons explicit where correctness depends on them?
- Is runtime behavior correct for the target SAPI (CLI vs web)?
- Are exceptions handled at the right boundary with useful context?
- Are input validation and SQL/file handling hardened against common attacks?
- Are error outputs safe for production environments?
- Does code avoid hidden coupling through globals and implicit includes?

## Output Expectations

When assisting with PHP tasks, responses should:
- align recommendations with the official PHP manual
- call out version/runtime-sensitive behavior explicitly
- prioritize secure defaults for input handling, data access, and error output
- favor clear, maintainable code over clever implicit behavior
