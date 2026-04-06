---
name: react
description: Use when working with React components, JSX, state management, effects, refs, controlled inputs, rendering performance, and modern React patterns. Covers official React docs and API reference for practical, predictable React development.
---

# React

## Domain Focus

This skill applies when tasks involve:

- Building or refactoring React components using JSX and props.
- Modeling UI behavior with state (`useState`, `useReducer`) and lifting state.
- Managing side effects (`useEffect`) and dependency correctness.
- Working with refs (`useRef`) for DOM access and non-render data.
- Creating controlled form elements (`input`, `select`) and handling events.
- Performance-sensitive rendering patterns (`memo`, `useMemo`, `useCallback`).
- Navigating modern React guidance (React Compiler, Rules of React, hooks linting).

Use this skill for app and component code that runs in web React environments and for guidance on when React DOM APIs are appropriate.

## Best Practices

- Prefer composition and clear data flow:
  - Keep components small and focused.
  - Pass minimal props needed by children.
  - Lift shared state to the closest common parent.

- Keep components and hooks pure:
  - Avoid mutating props/state.
  - Derive render-only values during render instead of storing redundant state.
  - Treat render as a pure function of props, state, and context.

- Use state intentionally:
  - Use `useState` for local component state.
  - Use updater functions (`setX(prev => ...)`) when next state depends on previous state.
  - Use `useReducer` when state transitions are complex or action-driven.

- Use effects only for synchronization with external systems:
  - Network subscriptions, timers, browser APIs, third-party widgets.
  - Always include all reactive dependencies.
  - Implement symmetrical cleanup when setup allocates resources.
  - Prefer changing effect code to remove unnecessary dependencies rather than suppressing lints.

- Reach for refs for non-render state:
  - Store mutable values like timeout IDs or element handles in `useRef`.
  - Use refs for imperative DOM operations (focus, measure, scroll).
  - Avoid reading/writing `ref.current` during render except predictable initialization.

- Build forms correctly:
  - Controlled input/select: pass `value`/`checked` with synchronous `onChange`.
  - Uncontrolled input/select: use `defaultValue`/`defaultChecked`.
  - Do not switch an element between controlled and uncontrolled modes.
  - Use labels (`label`, `htmlFor`, `useId`) for accessibility.

- Optimize performance after correctness:
  - Treat `memo`, `useMemo`, and `useCallback` as optimizations, not semantic requirements.
  - Avoid unnecessary object/function churn in props and effect dependencies.
  - Pair memoization with stable inputs; otherwise optimization is defeated.
  - If using React Compiler, manual memoization may be reduced.

## Common Pitfalls

- Effect misuse:
  - Using `useEffect` for pure data derivation or event handling logic that belongs in render/event handlers.
  - Missing dependencies or suppressing `react-hooks/exhaustive-deps`.
  - Infinite loops caused by effect-updated state changing dependencies.

- State shape and updates:
  - Redundant duplicated state (for example, storing `fullName` derived from first and last names).
  - Mutating arrays/objects in state instead of replacing immutably.
  - Expecting state updates to be immediate inside the same event handler (state is a snapshot).

- Hook rule violations:
  - Calling hooks conditionally, in loops, or nested functions.
  - Calling hooks outside components or custom hooks.

- Controlled input errors:
  - `value` without `onChange` (read-only field by mistake).
  - Checkbox using `e.target.value` instead of `e.target.checked`.
  - Passing `null`/`undefined` to controlled `value`.
  - Caret-jump bugs from asynchronous or transformed updates in `onChange`.

- Memoization overuse/misuse:
  - Wrapping everything in `useMemo`/`useCallback` without measured bottlenecks.
  - Assuming memoization is guaranteed forever (cache can be dropped in some cases).
  - Custom `arePropsEqual` that ignores function props or performs expensive deep equality.

## Practical Patterns

### 1) Derive data during render

```jsx
function TicketForm() {
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');

  const fullName = firstName + ' ' + lastName;

  return (
    <>
      <input value={firstName} onChange={e => setFirstName(e.target.value)} />
      <input value={lastName} onChange={e => setLastName(e.target.value)} />
      <p>{fullName}</p>
    </>
  );
}
```

### 2) Effect for external sync with cleanup

```jsx
function ChatRoom({ roomId }) {
  useEffect(() => {
    const connection = createConnection(roomId);
    connection.connect();
    return () => connection.disconnect();
  }, [roomId]);

  return <h1>Room: {roomId}</h1>;
}
```

### 3) Reduce effect dependencies by moving dynamic objects inside

```jsx
function ChatRoom({ roomId }) {
  useEffect(() => {
    const options = { serverUrl: 'https://localhost:1234', roomId };
    const connection = createConnection(options);
    connection.connect();
    return () => connection.disconnect();
  }, [roomId]);
}
```

### 4) Controlled input and checkbox

```jsx
function ProfileForm() {
  const [name, setName] = useState('');
  const [subscribed, setSubscribed] = useState(false);

  return (
    <>
      <input value={name} onChange={e => setName(e.target.value)} />
      <input
        type="checkbox"
        checked={subscribed}
        onChange={e => setSubscribed(e.target.checked)}
      />
    </>
  );
}
```

### 5) Stable callbacks and memoized children only when needed

```jsx
const List = memo(function List({ items, onSelect }) {
  return items.map(item => (
    <button key={item.id} onClick={() => onSelect(item.id)}>
      {item.label}
    </button>
  ));
});

function Page({ items }) {
  const handleSelect = useCallback((id) => {
    console.log(id);
  }, []);

  return <List items={items} onSelect={handleSelect} />;
}
```

## Review Checklist

- Component purity and state updates:
  - No direct state/prop mutation.
  - No redundant derived state unless justified.

- Hooks and effects:
  - Hooks are called at top level only.
  - Effect dependencies match referenced reactive values.
  - No lint suppression hiding dependency bugs.
  - Cleanup exists for subscriptions/timers/external resources.

- Forms and accessibility:
  - Controlled fields have synchronous `onChange` updates.
  - No controlled/uncontrolled mode switching.
  - Inputs/selects are properly labeled.

- Performance:
  - Memoization used only where profiling/observations justify it.
  - Props to memoized children are stable or intentionally changed.
  - No expensive custom prop comparison without evidence.

- Platform/API correctness:
  - Web-only APIs (`react-dom`) used only in browser/web contexts.
  - Deprecated React DOM APIs (e.g., legacy `render`) are not introduced.

## Output Expectations

When producing React guidance or code:

- Explain why a pattern is chosen (correctness first, then optimization).
- Prefer modern, official React patterns from react.dev.
- Keep examples small, focused, and directly adaptable.
- Call out trade-offs explicitly (e.g., effect vs derived render logic, memoization cost/benefit).
- Include dependency reasoning for hooks whenever effects/memoization are involved.
