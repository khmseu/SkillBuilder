---
name: tailwindcss
description: "Use when working with Tailwind CSS utility classes, installation/configuration, responsive variants, state variants, dark mode, and reusable component styling patterns. Trigger phrases: tailwind, tailwind css, tailwindcss, utility classes, tailwind variants, tailwind responsive, tailwind dark mode"
---

# Tailwind CSS

Use this skill when building or maintaining UIs styled with Tailwind CSS.

Official sources used:
- https://tailwindcss.com/docs
- https://tailwindcss.com/docs/installation
- https://tailwindcss.com/docs/styling-with-utility-classes
- https://tailwindcss.com/docs/responsive-design
- https://tailwindcss.com/docs/dark-mode

## Domain Focus

This skill applies when tasks involve:

- Installing and wiring Tailwind CSS into a build tool (for example Vite/PostCSS/CLI).
- Styling UI with utility classes directly in markup.
- Using state variants (`hover:`, `focus:`, `disabled:`, `group-*`, etc.).
- Building responsive layouts with breakpoint variants (`sm:`, `md:`, `lg:`, etc.).
- Implementing dark mode styling with `dark:` utilities.
- Managing duplication and creating reusable component patterns safely.
- Handling class conflicts, prefixes, and `!important` usage intentionally.

## Best Practices

- Prefer utility-first composition in markup:
  - Build styles by combining small, single-purpose classes.
  - Keep structure and styling close to improve maintainability.
  - Favor design-token/theme-backed values over ad hoc one-offs.

- Use variants for behavior and context:
  - Style interaction states with `hover:`, `focus:`, `active:`, `disabled:`.
  - Use responsive prefixes for breakpoint behavior instead of custom media queries first.
  - Use `dark:` classes for dark-mode overrides and keep light/dark styles explicit.

- Keep class generation predictable:
  - Use class names that can be statically detected by Tailwind scanning.
  - Avoid runtime-only class string construction patterns that hide full class names.
  - Keep source/content detection aligned with where templates/components live.

- Manage reuse at the right level:
  - Prefer component/partial extraction for repeated UI patterns across files.
  - Use loops and multi-cursor editing for localized duplication.
  - Use custom CSS sparingly for truly reusable single-element abstractions.

- Resolve conflicts deliberately:
  - Avoid applying conflicting utilities to the same element.
  - Reach for `!` modifiers only as a last resort.
  - Use a class prefix strategy when integrating into legacy CSS-heavy codebases.

## Common Pitfalls

- Building class names dynamically so Tailwind cannot detect/generate them.
- Mixing conflicting utilities (for example multiple display utilities) and assuming class order in markup decides the winner.
- Overusing arbitrary values where theme tokens would preserve consistency.
- Excessive custom CSS that recreates the utility framework instead of composing utilities.
- Treating dark mode or responsive behavior as separate CSS files instead of variant-based composition.
- Applying global `important` behavior too early in integration and masking real specificity issues.

## Practical Patterns

### 1) Basic utility composition

```html
<div class="mx-auto max-w-sm rounded-xl bg-white p-6 shadow-lg">
  <h2 class="text-xl font-semibold text-slate-900">Card title</h2>
  <p class="mt-2 text-sm text-slate-600">Utility-first styling example.</p>
</div>
```

### 2) State and responsive variants

```html
<button class="rounded-md bg-sky-500 px-4 py-2 font-medium text-white hover:bg-sky-700 disabled:opacity-50 sm:px-5">
  Save changes
</button>
```

### 3) Dark mode pairing

```html
<div class="rounded-lg bg-white p-6 text-slate-900 dark:bg-slate-800 dark:text-slate-100">
  Dark mode ready content
</div>
```

### 4) One-off arbitrary value (use sparingly)

```html
<div class="grid grid-cols-[24rem_2.5rem_minmax(0,1fr)] gap-4">
  <!-- ... -->
</div>
```

## Review Checklist

- Are utilities composed clearly without conflicting classes?
- Are responsive and state behaviors expressed via variants where appropriate?
- Are dark mode styles explicitly paired with base styles?
- Are class names statically discoverable by Tailwind's scanning process?
- Is duplication handled by components/partials before introducing custom CSS?
- Are arbitrary values and important modifiers used only when justified?

## Output Expectations

When producing Tailwind guidance or code:

- Prefer practical utility-class solutions over abstract CSS architecture advice.
- Explain variant usage (state, responsive, dark mode) where behavior matters.
- Keep examples framework-agnostic unless the task is framework-specific.
- Favor maintainable composition and token consistency over clever one-off classes.
