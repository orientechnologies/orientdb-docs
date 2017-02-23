---
search:
   keywords: ['SQL', 'TRUNCATE CLUSTER', 'truncate', 'cluster'] 
---

# SQL - `TRUNCATE CLUSTER`

Deletes all records of a cluster.  This command operates at a lower level than the standard [`DELETE`](SQL-Delete.md) command.

**Syntax**

```
TRUNCATE CLUSTER <cluster>
```

- **`<cluster>`** Defines the cluster to delete.


**Examples**

- Remove all records in the cluster `profile`:

  <pre>
  orientdb> <code class='lang-sql userinput'>TRUNCATE CLUSTER profile</code>
  </pre>

>For more information, see
>- [`DELETE`](SQL-Delete.md)
>- [`TRUNCATE CLASS`](SQL-Truncate-Class.md)
>- [SQL Commands](SQL.md)
>- [Console Commands](console/Console-Commands.md)
