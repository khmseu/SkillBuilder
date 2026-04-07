---
name: postgres
description: "Use when working with the postgres (postgres.js) client in Node.js/TypeScript, including tagged-template queries, dynamic SQL helpers, transactions, pooling, custom types, listen/notify, and connection options. Trigger phrases: postgres, postgres.js, npm postgres, sql tagged template, node postgres client"
---

# Postgres.js (postgres)

Use this skill when building or reviewing code that uses the `postgres` npm package (Postgres.js).

Official sources used:
- https://github.com/porsager/postgres
- https://www.npmjs.com/package/postgres

## Domain Focus

This skill applies when tasks involve:

- Creating and configuring a `postgres()` client instance.
- Writing safe tagged-template SQL queries with interpolated values.
- Building dynamic SQL with `sql(...)` helpers for identifiers/columns/values.
- Running transactions with `sql.begin()` and savepoints.
- Tuning connection pooling and lifecycle behavior.
- Handling PostgreSQL types (`bigint`, `numeric`, custom OIDs).
- Using `listen`/`notify` and optional realtime subscribe APIs.

## Best Practices

- Use tagged template queries for all normal SQL calls:
  - `await sql`...`` automatically parameterizes values (`$1`, `$2`, etc.).
  - This prevents SQL injection for interpolated values.
  - Do not concatenate SQL strings manually for value interpolation.

- Interpolate values and identifiers correctly:
  - Values: `${value}`
  - Identifiers (table/column): `${sql(identifier)}`
  - SQL fragments/keywords: `${sql`...`}`
  - Helper inserts/updates: `${sql(objectOrArray, columns?)}`

- Never quote interpolated values in tagged SQL:
  - `where name = ${name}` is correct.
  - `where name = '${name}'` is wrong and breaks parameter handling.

- Keep transactions scoped with the provided callback client:
  - Use `sql.begin(async tx => { ... })`.
  - Only use `tx` inside the transaction block.
  - Use `tx.savepoint(...)` for partial rollback boundaries.

- Treat pool and lifecycle explicitly:
  - Connections are lazy and opened only when queries run.
  - Use `max`, `idle_timeout`, and `max_lifetime` for workload/serverless tuning.
  - Call `await sql.end()` for graceful shutdown.

- Handle numeric precision intentionally:
  - `bigint` and `numeric/decimal` may come back as strings by default.
  - Use custom types when you need explicit conversion behavior.

- Keep prepared statement behavior aligned with infrastructure:
  - Default `prepare: true` is good for most deployments.
  - Consider `prepare: false` for incompatible pooler modes/configs.

- Use `listen`/`notify` for event fanout with reconnection-aware listeners:
  - `.listen(channel, onnotify, onlisten?)` keeps a dedicated listener connection.
  - `.notify(channel, payload)` is available as an API helper.

## Common Pitfalls

- Using plain string SQL building with user values instead of tagged templates.
- Wrapping interpolated params in quotes, causing `'$1'`-style query mistakes.
- Mixing transaction and non-transaction client instances in the same unit of work.
- Assuming query ordering across pooled connections without transaction boundaries.
- Passing `undefined` values (Postgres.js throws `UNDEFINED_VALUE` by default).
- Ignoring cleanup and leaking idle clients in short-lived/serverless contexts.
- Treating `numeric` as JS `number` without precision strategy.
- Using unsafe raw query execution unless absolutely necessary and audited.

## Practical Patterns

### 1) Client setup

```js
import postgres from 'postgres'

const sql = postgres(process.env.DATABASE_URL, {
  max: 10,
  idle_timeout: 20,
  connect_timeout: 30,
})

export default sql
```

### 2) Safe parameterized query

```js
const minAge = 21
const users = await sql`
  select id, name
  from users
  where age >= ${minAge}
`
```

### 3) Dynamic identifier and filter fragments

```js
const table = 'users'
const maybeId = 42

const rows = await sql`
  select *
  from ${sql(table)}
  ${maybeId ? sql`where id = ${maybeId}` : sql``}
`
```

### 4) Insert/update helpers

```js
const user = { name: 'Murray', age: 68 }
await sql`insert into users ${sql(user, ['name', 'age'])}`

await sql`
  update users set ${sql({ name: 'Walter' }, ['name'])}
  where id = ${1}
`
```

### 5) Transaction and savepoint

```js
const result = await sql.begin(async tx => {
  const [user] = await tx`
    insert into users (name) values ('Murray') returning id
  `

  await tx.savepoint(async sp => {
    await sp`insert into audit_log (user_id, event) values (${user.id}, 'created')`
  })

  return user
})
```

### 6) Listen/notify

```js
await sql.listen('jobs', payload => {
  const job = JSON.parse(payload)
  runJob(job)
})

await sql.notify('jobs', JSON.stringify({ type: 'reindex', id: 1 }))
```

### 7) Graceful shutdown

```js
process.on('SIGTERM', async () => {
  await sql.end({ timeout: 5 })
  process.exit(0)
})
```

## Review Checklist

- Are all value interpolations done via tagged templates (`${value}`), not string concatenation?
- Are dynamic table/column names wrapped with `sql(identifier)`?
- Are transactions using `sql.begin` with the scoped client only?
- Are `undefined` values avoided or transformed intentionally?
- Are pool/lifecycle options (`max`, `idle_timeout`, `max_lifetime`) appropriate for deployment?
- Is shutdown cleanup (`sql.end`) in place for app termination?
- Is numeric precision handling (`bigint`/`numeric`) explicit where needed?

## Output Expectations

When producing Postgres.js code or guidance:

- Prefer tagged-template SQL and helper-driven dynamic query composition.
- Keep examples parameter-safe and transaction-safe.
- Mention connection lifecycle and shutdown behavior for production code.
- Call out precision and type conversion risks for numeric-heavy domains.
- Avoid recommending unsafe/raw query modes unless the use case requires it.
