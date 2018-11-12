---
search:
   keywords: ['SQL', 'TRUNCATE CLUSTER', 'truncate', 'cluster'] 
---

# SQL - `TRUNCATE CLUSTER`

Deletes all records of a cluster.  This command operates at a lower level than the standard [`DELETE`](SQL-Delete.md) command.

Truncation is not permitted on vertex or edge classes, but you can force its execution using the `UNSAFE` keyword.  Forcing truncation is strongly discouraged, as it can leave the graph in an inconsistent state.

**Syntax**

```
TRUNCATE CLUSTER <cluster>
```

- **`<cluster>`** Defines the cluster to delete.
- **`UNSAFE`** Defines whether the command forces truncation on vertex or edge classes, (that is, sub-classes that extend the classes `V` or `E`).

**Examples**

- Remove all records in the cluster `profile`:

  <pre>
  orientdb> <code class='lang-sql userinput'>TRUNCATE CLUSTER profile</code>
  </pre>

>For more information, see
>- [`DELETE`](SQL-Delete.md)
>- [`TRUNCATE CLASS`](SQL-Truncate-Class.md)
>- [SQL Commands](SQL-Commands.md)
>- [Console Commands](../console/Console-Commands.md)
