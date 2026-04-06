---
name: vue
description: "Use when working with Vue 3 components, Single-File Components, Composition API, reactivity, props/events, v-model, watchers, and TypeScript patterns based on official Vue documentation."
---

# Vue

Use this skill when building or reviewing Vue 3 applications and components, especially when work involves Single-File Components, Composition API, template bindings, reactivity, and typed component APIs.

This skill is based on official Vue documentation:
- https://vuejs.org/guide/introduction.html
- https://vuejs.org/guide/essentials/reactivity-fundamentals.html
- https://vuejs.org/guide/essentials/component-basics.html
- https://vuejs.org/guide/essentials/computed.html
- https://vuejs.org/guide/essentials/watchers.html
- https://vuejs.org/guide/essentials/forms.html
- https://vuejs.org/guide/typescript/composition-api.html

## Domain Focus

This skill applies when tasks involve:

- Building Vue 3 components with Single-File Components (`.vue`) and `<script setup>`.
- Managing reactive state with `ref()` and `reactive()`.
- Writing component interfaces with props, emits, and slots.
- Using computed state, watchers, and DOM update timing correctly.
- Building forms with `v-model` across inputs, textareas, selects, and custom components.
- Choosing between Options API and Composition API, with Composition API preferred for full applications.
- Typing props, emits, refs, computed values, handlers, and template refs in TypeScript.

## Best Practices

- Prefer Single-File Components and Composition API with `<script setup>` for build-tool-based applications.
- Keep templates declarative and move non-trivial logic into script code or computed state.
- Use `ref()` as the primary API for reactive state, especially for primitives and state that may be replaced wholesale.
- Use `reactive()` for object-shaped state when stable object identity is appropriate.
- Use computed properties for derived state and keep computed getters side-effect free.
- Use watchers only for side effects such as async requests, integration with external systems, or DOM-adjacent reactions.
- Define component contracts explicitly with `defineProps()` and `defineEmits()`.
- Prefer local component registration through imports in SFCs.
- Type component APIs in `<script setup lang="ts">` using type-based declarations when practical.

## Common Pitfalls

- Mutating or depending on raw objects instead of the reactive proxy returned by `reactive()`.
- Forgetting `.value` in JavaScript when using refs outside templates.
- Destructuring reactive object properties and accidentally losing reactivity.
- Putting side effects, async work, or DOM mutation inside computed getters.
- Using deep watchers broadly on large nested structures without considering cost.
- Watching `obj.count` directly instead of using a getter like `() => obj.count`.
- Accessing DOM immediately after a reactive mutation without waiting for `nextTick()` when post-update state matters.
- Mixing in-DOM template assumptions with SFC conventions, especially around PascalCase, self-closing tags, and placement restrictions.
- Using `v-model` while expecting initial DOM attributes (`value`, `checked`, `selected`) to remain the source of truth.
- Overcomplicating props/emits typing by mixing runtime and type-based declarations in the same macro.

## Practical Patterns

### 1) Prefer `<script setup>` with `ref()` for local state

```vue
<script setup>
import { ref } from 'vue'

const count = ref(0)

function increment() {
  count.value++
}
</script>

<template>
  <button @click="increment">Count is: {{ count }}</button>
</template>
```

### 2) Use computed for derived state, not methods in templates

```vue
<script setup>
import { reactive, computed } from 'vue'

const author = reactive({
  name: 'John Doe',
  books: ['Vue 2', 'Vue 3']
})

const hasPublishedBooks = computed(() => author.books.length > 0)
</script>

<template>
  <span>{{ hasPublishedBooks ? 'Yes' : 'No' }}</span>
</template>
```

### 3) Watch for side effects, not derivation

```vue
<script setup>
import { ref, watch } from 'vue'

const question = ref('')
const answer = ref('')
const loading = ref(false)

watch(question, async (newQuestion, _oldQuestion, onCleanup) => {
  if (!newQuestion.includes('?')) {
    return
  }

  const controller = new AbortController()
  onCleanup(() => controller.abort())

  loading.value = true
  answer.value = 'Thinking...'

  try {
    const response = await fetch('https://yesno.wtf/api', {
      signal: controller.signal,
    })
    answer.value = (await response.json()).answer
  } finally {
    loading.value = false
  }
})
</script>
```

### 4) Define props and emits explicitly

```vue
<script setup lang="ts">
const props = defineProps<{
  title: string
  disabled?: boolean
}>()

const emit = defineEmits<{
  save: [id: number]
}>()

function save() {
  emit('save', 1)
}
</script>

<template>
  <button :disabled="props.disabled" @click="save">{{ props.title }}</button>
</template>
```

### 5) Use `v-model` as the JavaScript-state source of truth

```vue
<script setup>
import { ref } from 'vue'

const message = ref('')
const selected = ref('')
</script>

<template>
  <input v-model.trim="message" placeholder="Edit me" />

  <select v-model="selected">
    <option disabled value="">Please select one</option>
    <option>A</option>
    <option>B</option>
  </select>
</template>
```

### 6) Use `nextTick()` when post-update DOM access is required

```ts
import { ref, nextTick } from 'vue'

const count = ref(0)

async function incrementAndMeasure() {
  count.value++
  await nextTick()
  // DOM now reflects the latest count
}
```

## Review Checklist

- Component structure:
  - Is SFC + `<script setup>` used where appropriate?
  - Is component logic kept out of templates when it becomes non-trivial?

- Reactivity:
  - Is `ref()` or `reactive()` chosen for the right reason?
  - Are refs accessed with `.value` in JavaScript and not misused after destructuring?
  - Is code consistently using reactive proxies rather than raw objects?

- Derived state and side effects:
  - Is derived state implemented with `computed()`?
  - Are computed getters free of side effects?
  - Are watchers used only for side effects and configured carefully (`deep`, `immediate`, `flush`) when needed?

- Components and templates:
  - Are props and emits declared explicitly?
  - Are child components locally imported and used consistently?
  - Are event names, prop names, and casing appropriate for SFC vs in-DOM usage?

- Forms:
  - Is `v-model` used with the correct element semantics?
  - Are modifiers such as `.trim`, `.number`, and `.lazy` chosen intentionally?
  - For selects, is there a disabled empty option when an unselected initial state is needed?

- TypeScript:
  - Are props, emits, refs, computed values, and handlers typed correctly?
  - Is `withDefaults` or reactive props destructure used correctly for prop defaults?
  - Are template refs treated as nullable until mount?

## Output Expectations

When producing Vue guidance or code:

- Prefer Vue 3 terminology and official patterns.
- Default to SFC + Composition API + `<script setup>` unless the use case clearly favors another style.
- Separate derived state (`computed`) from side effects (`watch` / `watchEffect`).
- Keep examples realistic, small, and directly adaptable.
- Explain reactivity caveats when code relies on proxy behavior, ref unwrapping, or watcher timing.
- Include TypeScript typing patterns when the surrounding codebase is typed.
