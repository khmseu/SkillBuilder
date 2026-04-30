---
name: lucide-react
description: "Use when working with Lucide icons in React applications, including installation, named imports, sizing, color, stroke width, accessibility, and dynamic icon patterns. Trigger phrases: lucide, lucide-react, lucide icons, svg icons react, icon component react"
context: fork
---

# Lucide React

Use this skill when integrating or using Lucide icons in a React project.

Official sources used:
- https://lucide.dev/guide/react/getting-started
- https://lucide.dev/guide/react/basics/sizing
- https://lucide.dev/guide/react/advanced/accessibility
- https://lucide.dev/guide/

## Domain Focus

This skill applies when tasks involve:

- Installing and importing Lucide icons into a React/JSX component.
- Customizing icon size, color, and stroke width via props.
- Applying accessibility attributes to decorative or meaningful icons.
- Composing icons inside buttons and interactive elements.
- Sizing icons with Tailwind CSS utilities.
- Building dynamic icon components (mapping string names to components).

## Best Practices

- Import icons by name — each icon is a standalone tree-shakable component:
  - Only the icons you import are included in the bundle.
  - Avoid importing from a barrel that would pull in unused icons.
  - All icons render as inline SVGs and accept standard SVG attributes.

- Use props for visual customization:
  - `size` (number, default `24`) controls both width and height uniformly.
  - `color` (string, default `currentColor`) inherits text color by default.
  - `strokeWidth` (number, default `2`) adjusts line weight.
  - Pass `absoluteStrokeWidth={true}` to keep a fixed line thickness regardless of size.

- Size with CSS or Tailwind instead of the `size` prop when icons must respond to font size:
  - Use `width: 1em; height: 1em` on the icon to scale with surrounding text.
  - With Tailwind, prefer `size-*` utility classes (e.g. `className="size-6"`).

- Apply accessibility correctly:
  - Icons ship with `aria-hidden="true"` by default — this is correct for decorative icons.
  - Only expose an icon to screen readers when it conveys essential meaning on its own.
  - To expose: pass an `aria-label` prop, or add a `<title>` child element.
  - When an icon is inside a button, label the **button** — not the icon.

- Look up icon names at https://lucide.dev/icons/ — the site is searchable.

## Common Pitfalls

- Importing from a non-named path (e.g. the full lucide-react package without named imports) which prevents tree-shaking.
- Forgetting that `color` defaults to `currentColor`, so icons inherit the text color — if they look invisible, check parent color.
- Adding `aria-label` to a purely decorative icon creates screen reader noise.
- Labeling the icon inside a button instead of the button itself reduces accessibility.
- Using a dynamic icon component with a string key that isn't statically typed — always validate the key against the known icon map.
- Applying `size` prop and conflicting CSS side-by-side (the `size` prop sets inline SVG attributes; CSS rules may override them).

## Practical Patterns

### 1) Basic import and render

```jsx
import { Camera } from 'lucide-react'

function App() {
  return <Camera />
}
```

### 2) Customizing appearance

```jsx
import { Heart } from 'lucide-react'

function LikeButton() {
  return <Heart size={32} color="red" strokeWidth={1.5} />
}
```

### 3) Sizing with Tailwind

```jsx
import { PartyPopper } from 'lucide-react'

function Banner() {
  return <PartyPopper className="size-12 text-yellow-500" />
}
```

### 4) Accessible standalone icon

```jsx
import { House } from 'lucide-react'

// Pass aria-label to override the default aria-hidden
function HomeIcon() {
  return <House aria-label="Go to home" />
}
```

### 5) Icon inside a button (label the button)

```jsx
import { House } from 'lucide-react'

function HomeButton() {
  return (
    <button aria-label="Go to home">
      <House />  {/* stays aria-hidden */}
    </button>
  )
}
```

### 6) Dynamic icon component

```jsx
import * as icons from 'lucide-react'

function Icon({ name, ...props }) {
  const Component = icons[name]
  if (!Component) return null
  return <Component {...props} />
}

// Usage: <Icon name="Camera" size={20} />
```

## Review Checklist

- Are icons imported by name and not from a catch-all barrel?
- Is sizing controlled consistently (prop, CSS, or Tailwind — pick one)?
- Are decorative icons left with the default `aria-hidden`?
- Do meaningful standalone icons have `aria-label` or a `<title>` child?
- Is the accessible label on the **button/link** rather than the icon inside it?
- Does any dynamic icon map validate the key before rendering?

## Output Expectations

When producing Lucide icon code or guidance:

- Use named React component imports from `lucide-react`.
- Default to `size`, `color`, and `strokeWidth` props for basic customization.
- Apply accessibility per context: decorative vs meaningful icons.
- Integrate Tailwind sizing when the project already uses Tailwind.
- Keep icon composition simple — they are leaf SVG nodes, not compound widgets.
