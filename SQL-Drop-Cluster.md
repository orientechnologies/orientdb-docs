---
search:
   keywords: ['SQL', 'DROP CLUSTER', 'drop', 'cluster', 'delete']
---

# SQL - `DROP CLUSTER`

Removes the cluster and all of its content.  This operation is permanent and cannot be rolled back.

**Syntax**

```sql
DROP CLUSTER <cluster-name>|<cluster-id>
```

- **`<cluster-name>`** Defines the name of the cluster you want to remove.
- **`<cluster-id>`** Defines the ID of the cluster you want to remove.

**Examples**

- Remove the cluster `Account`:

  <pre>
  orientdb> <code class="lang-sql userinput">DROP CLUSTER Account</code>
  </pre>

>For more information, see
>- [`CREATE CLUSTER`](SQL-Create-Cluster.md)
>- [`ALTER CLUSTER`](SQL-Alter-Cluster.md)
>- [`DROP CLASS`](SQL-Drop-Class.md)
>- [SQL Commands](SQL.md)
>- [Console Commands](console/Console-Commands.md)
