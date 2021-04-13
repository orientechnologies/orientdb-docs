---
search:
   keywords: ['SQL', 'command', 'alter', 'class', 'ALTER CLASS']
---

# Server Commands - `DROP DATABASE`

Drops a database

**Syntax**

```sql
DROP DATABASE <dbName> [if exists]
```

- **`<dbName>`** the name of an existing db


**Examples**

- drop an existing db:

  <pre>
  orientdb> <code class='lang-sql userinput'>DROP DATABASE foo</code>
  </pre>


- drop a db if it exists:

  <pre>
  orientdb> <code class='lang-sql userinput'>DROP DATABASE foo if exists</code>
  </pre>
