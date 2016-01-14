# SQL - `CREATE CLUSTER`

Creates a new cluster in the database.  Once created, you can use the cluster to save records by specifying its name during saves.  If you want to add the new cluster to a class, follow its creation with the [`ALTER CLASS`](SQL-Alter-Class.md) command, using the `ADDCLUSTER` option.


**Syntax**

```sql
CREATE CLUSTER <cluster> [ID <cluster-id>]
```

- **`<cluster>`** Defines the name of the cluster you want to create.  You must use a letter for the first character, for all other characters, you can use alphanumeric characters, underscores and dashes.
- **`<cluster-id>`** Defines the numeric ID you want to use for the cluster.

**Examples**

- Create the cluster `account`:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE CLUSTER account</code>
  </pre>

>For more information see,
>
>- [`DROP CLUSTER`](SQL-Drop-Cluster.md)
>- [SQL Commands](SQL.md)
>- [Console Commands](Console-Commands.md)
