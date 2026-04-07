---
name: testing-library
description: "Use when writing tests with @testing-library/react or @testing-library/dom, including render, screen queries, user interactions, async assertions, and accessible query priority. Trigger phrases: testing library, react testing library, @testing-library, screen.getBy, render component test, write component test, test react component"
---

# Testing Library (React)

Use this skill when writing or reviewing tests that use `@testing-library/react` or `@testing-library/dom`.

Official sources used:
- https://testing-library.com/docs/
- https://testing-library.com/docs/react-testing-library/intro
- https://testing-library.com/docs/react-testing-library/api
- https://testing-library.com/docs/queries/about
- https://testing-library.com/docs/guiding-principles

## Domain Focus

This skill applies when tasks involve:

- Rendering React components in tests with `render()`.
- Querying the DOM with `screen.*` queries.
- Firing user events and async waiting patterns.
- Asserting element presence, text content, and ARIA attributes.
- Testing custom hooks with `renderHook()`.
- Integrating with Vitest or Jest and `jsdom`.

## Best Practices

### Guiding principle
> The more your tests resemble the way your software is used, the more confidence they can give you.

- Query elements the way a user (or assistive technology) would find them.
- Avoid testing implementation details — test what the component renders and behaves, not how it implements it.
- Avoid querying by `container.querySelector`, class names, or internal component state.

### Query priority (high to low)

1. **`getByRole`** — preferred for all interactive and semantic elements. Filter with `name` option.
   ```js
   screen.getByRole('button', { name: /submit/i })
   ```
2. **`getByLabelText`** — best for form fields associated with `<label>`.
3. **`getByPlaceholderText`** — use when no label exists.
4. **`getByText`** — for non-interactive elements (paragraphs, headings, etc.).
5. **`getByDisplayValue`** — for controlled inputs showing current values.
6. **`getByAltText`** — for images with `alt`.
7. **`getByTitle`** — inconsistently supported by screen readers; prefer `getByRole`.
8. **`getByTestId`** — escape hatch only; use `data-testid` when nothing semantic works.

### Query type selection

| Query | When no match | When >1 match |
|---|---|---|
| `getBy` | throws | throws (use `getAllBy` for multiples) |
| `queryBy` | returns `null` | throws |
| `findBy` | rejects after timeout | rejects |

- Use `queryBy` to assert an element is **absent** (it returns `null` instead of throwing).
- Use `findBy` / `findAllBy` for elements that appear asynchronously.

### `screen` object
- Always import and use `screen` rather than destructuring queries from `render()`.
- `screen` is pre-bound to `document.body` and is available globally after a `render` call.

### Async interactions
- Use `findBy*` for elements that appear after user actions or data loads.
- Use `waitFor()` for assertions that require polling.
- Wrap async user interactions in `act()` when not using `@testing-library/user-event`.

### Custom render
- Wrap `render()` in a custom helper when components require providers (Router, Store, Theme, etc.):
  ```js
  // test-utils.js
  import { render } from '@testing-library/react'
  import { MyProviders } from './providers'

  const customRender = (ui, options) =>
    render(ui, { wrapper: MyProviders, ...options })

  export { customRender as render, screen }
  ```

## Common Pitfalls

- Using `container.querySelector` — this is an escape hatch that bypasses the accessible query API.
- Querying by class name or internal state — breaks on refactoring.
- Using `getByText` for buttons with accessible roles — prefer `getByRole('button', { name: ... })`.
- Forgetting `await` on `findBy*` queries — they return Promises, not elements.
- Re-querying elements after async state changes instead of using `findBy` or `waitFor`.
- Deep-nesting providers in every test individually — use a custom `render` helper instead.
- Using `cleanup()` manually with Jest/Vitest — it is called automatically via `afterEach`.
- Setting `reactStrictMode: false` globally to suppress warnings instead of fixing the root cause.

## Practical Patterns

### 1) Basic render and assert

```jsx
import { render, screen } from '@testing-library/react'
import Greeting from './Greeting'

test('shows greeting message', () => {
  render(<Greeting name="Alice" />)
  expect(screen.getByText('Hello, Alice!')).toBeInTheDocument()
})
```

### 2) Interact with a button

```jsx
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import Counter from './Counter'

test('increments count on click', async () => {
  render(<Counter />)
  await userEvent.click(screen.getByRole('button', { name: /increment/i }))
  expect(screen.getByText('Count: 1')).toBeInTheDocument()
})
```

### 3) Wait for async content

```jsx
test('loads and displays data', async () => {
  render(<DataList />)
  const items = await screen.findAllByRole('listitem')
  expect(items).toHaveLength(3)
})
```

### 4) Assert element is absent

```jsx
test('hides error before submission', () => {
  render(<LoginForm />)
  expect(screen.queryByRole('alert')).toBeNull()
})
```

### 5) Test a custom hook

```jsx
import { renderHook, act } from '@testing-library/react'
import useCounter from './useCounter'

test('increments counter', () => {
  const { result } = renderHook(() => useCounter())
  act(() => result.current.increment())
  expect(result.current.count).toBe(1)
})
```

## Review Checklist

- Is `screen` used for all queries instead of destructuring from `render`?
- Does query selection follow the priority order (role > label > text > testid)?
- Are `findBy*` queries awaited for async elements?
- Is `queryBy*` used (not `getBy*`) when asserting absence?
- Are providers wrapped in a reusable custom `render` helper?
- Does the test verify user-observable behavior, not internal state?

## Output Expectations

When writing or reviewing component tests:

- Use accessible `screen.getByRole(...)` queries as the default.
- Use `@testing-library/user-event` for user interactions over `fireEvent`.
- Colocate tests with components (`.test.tsx` next to component files).
- Write tests that read like user stories, not implementation traces.
- Avoid mocking things that are already cheap to render (providers, utilities).
