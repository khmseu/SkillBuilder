---
name: typescript
description: "Use when working with TypeScript, tsconfig.json, strict type checking, narrowing, generics, module resolution, declaration files, or migrating JavaScript to TypeScript. Covers official TypeScript Handbook and TSConfig guidance for practical, type-safe code and compiler configuration."
---

# TypeScript Skill

Use this skill when building, reviewing, or migrating TypeScript codebases.

Official sources used:
- https://www.typescriptlang.org/docs/
- https://www.typescriptlang.org/docs/handbook/intro.html
- https://www.typescriptlang.org/docs/handbook/2/everyday-types.html
- https://www.typescriptlang.org/docs/handbook/2/narrowing.html
- https://www.typescriptlang.org/docs/handbook/2/generics.html
- https://www.typescriptlang.org/tsconfig

## Domain Focus

This skill covers:
- Core type system usage in everyday code
- Control-flow narrowing and discriminated unions
- Generics, constraints, and reusable API design
- tsconfig structure and strictness options
- Module and interop configuration for Node and bundlers
- JavaScript to TypeScript migration patterns
- Common safety and maintainability pitfalls

## Best Practices

### Type Design

- Prefer specific types over any. Use unknown when type is genuinely unknown and narrow before use.
- Let inference do most of the work; add explicit annotations where they clarify API boundaries.
- Use union types and narrowing over broad casts.
- Use literal unions for constrained values such as status, mode, and command names.
- Use interface for extendable object contracts and type for unions, mapped/conditional types, and aliases.

### Narrowing and Control Flow

- Narrow with runtime checks TypeScript understands:
  - typeof
  - in
  - instanceof
  - equality checks
- Use discriminated unions with a shared literal discriminant key like kind or type.
- Add exhaustive checks in switch statements with never in default branches.
- Avoid non-null assertions (!) unless you can prove the value is present.

### Generics

- Keep type parameters meaningful and minimal.
- Prefer constraints with extends when behavior depends on specific capabilities.
- Use keyof constraints for property-safe helpers.
- Use generic defaults to keep APIs ergonomic when inference is insufficient.
- Avoid unnecessary variance annotations; rely on inferred variance unless you have a proven edge case.

### TSConfig

- Start with strict mode for new codebases.
- Keep strictNullChecks on unless migration constraints require staged adoption.
- Treat noImplicitAny and noImplicitThis as baseline safety checks.
- Consider exactOptionalPropertyTypes and noUncheckedIndexedAccess for safer data handling.
- Use extends to share base config and avoid duplication.
- Understand include/exclude behavior: exclude does not block files imported by included files.

### Modules and Interop

- Choose module and moduleResolution to match runtime or bundler behavior.
- For modern Node projects, prefer node18/node20/nodenext configurations as appropriate.
- For bundler-driven projects, prefer bundler resolution semantics where suitable.
- Use verbatimModuleSyntax with type-only imports to make emit behavior explicit.
- Use esModuleInterop only when interop behavior requires it.

### Emit and Build Strategy

- Use noEmit when another tool handles JavaScript output and TypeScript is used for checking.
- Use declaration and emitDeclarationOnly for library type publishing flows.
- Keep outDir/rootDir intentional to avoid surprising output layout.
- Use sourceMap in environments where debugging transpiled code is needed.

### Migration from JavaScript

- Use allowJs and checkJs for staged adoption.
- Migrate high-value modules first, especially shared utilities and domain models.
- Replace broad casts with real types incrementally.
- Use skipLibCheck only as a temporary compatibility lever, not a permanent fix.

## Common Pitfalls

- Overusing any and losing type safety across module boundaries.
- Confusing optional property absence with explicit undefined values.
- Using truthiness checks that accidentally drop valid values such as empty string or 0.
- Missing discriminant fields in unions, preventing reliable narrowing.
- Relying on type assertions instead of modeling data shape correctly.
- Misconfigured module/moduleResolution causing runtime import issues.
- Assuming paths changes runtime behavior without matching bundler/runtime alias config.
- Treating skipLibCheck as a long-term solution for dependency type conflicts.

## Practical Patterns

### Exhaustive Discriminated Union

```ts
type Shape =
  | { kind: 'circle'; radius: number }
  | { kind: 'square'; sideLength: number }

function area(shape: Shape): number {
  switch (shape.kind) {
    case 'circle':
      return Math.PI * shape.radius ** 2
    case 'square':
      return shape.sideLength ** 2
    default: {
      const _exhaustive: never = shape
      return _exhaustive
    }
  }
}
```

### Generic Property Getter

```ts
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key]
}
```

### Constrained Generic

```ts
interface Lengthwise {
  length: number
}

function withLength<T extends Lengthwise>(value: T): T {
  console.log(value.length)
  return value
}
```

### Strict-Oriented tsconfig Base

```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitOverride": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "forceConsistentCasingInFileNames": true
  }
}
```

### Bundler-Friendly Type-Check-Only Setup

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "preserve",
    "moduleResolution": "bundler",
    "verbatimModuleSyntax": true,
    "noEmit": true,
    "strict": true
  }
}
```

## Review Checklist

- Are unsafe any usages minimized and justified?
- Are unions narrowed correctly before member-specific operations?
- Are discriminated unions exhaustive where business logic branches?
- Do generics have meaningful constraints and return types?
- Does tsconfig match runtime or bundler module behavior?
- Are strictness flags aligned with project safety goals?
- Are type assertions replacing missing models where types should be improved?
- Is migration configuration temporary and tracked for cleanup?

## Output Expectations

When assisting with TypeScript tasks, responses should:
- prefer modeling and narrowing over casting
- distinguish compile-time type checks from runtime behavior
- keep tsconfig advice aligned with actual runtime or bundler context
- provide pragmatic migration guidance when strict adoption cannot happen at once