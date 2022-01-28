---
search:
   keywords: ['SQL', 'REBUILD INDEXES', 'rebuild', 'index', 'indices']
---

# SQL - `REBUILD INDEXES`

Rebuilds automatic indexes.

**Syntax**

```sql
REBUILD INDEX <index>
```

- **`<index>`** Defines the index that you want to rebuild.  Use `*` to rebuild all automatic indexes.

>**NOTE**: During the rebuild, any idempotent queries made against the index, skip the index and perform sequential scans.  This means that queries run slower during this operation.  Non-idempotent commands, such as [`INSERT`](SQL-Insert.md), [`UPDATE`](SQL-Update.md), and [`DELETE`](SQL-Delete.md) are blocked waiting until the indexes are rebuilt.

**Examples**

- Rebuild an index on the `nick` property on the class `Profile`:

  <pre>
  orientdb> <code class='lang-sql userinput'>REBUILD INDEX Profile.nick</code>
  </pre>

- Rebuild all indexes:
  
  <pre>
  orientdb> <code class='lang-sql userinput'>REBUILD INDEX *</code>
  </pre>

>For more information, see
>- [`CREATE INDEX`](SQL-Create-Index.md)
>- [`DROP INDEX`](SQL-Drop-Index.md)
>- [Indexes](../indexing/Indexes.md)
>- [SQL Commands](SQL-Commands.md)
