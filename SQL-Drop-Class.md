---
search:
   keywords: ['SQL', 'DROP CLASS', 'delete', 'drop', 'class']
---

# SQL - `DROP CLASS`

Removes a class from the schema.

**Syntax**

```sql
DROP CLASS <class> [IF EXISTS] [ UNSAFE ]
```

- **`<class>`** Defines the class you want to remove.
- **`IF EXISTS`** (since v 2.2.13) Drops the class only if it exists (does nothing if it doesn't)
- **`UNSAFE`** Defines whether the command drops non-empty edge and vertex classes.  Note, this can disrupt data consistency.  Be sure to create a backup before running it.



>**NOTE**: Bear in mind, that the schema must remain coherent.  For instance, avoid removing calsses that are super-classes to others.  This operation won't delete the associated cluster.

**Examples**

- Remove the class `Account`:

  <pre>
  orientdb> <code class="lang-sql userinput">DROP CLASS Account</code>
  </pre>


>For more information, see
>- [`CREATE CLASS`](SQL-Create-Class.md)
>- [`ALTER CLASS`](SQL-Alter-Class.md)
>- [`ALTER CLUSTER`](SQL-Alter-Cluster.md)
>- [SQL Commands](SQL.md)
>- [Console Commands](Console-Commands.md)
