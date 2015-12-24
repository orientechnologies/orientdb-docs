# Console - `DROP CLUSTER`

Removes a cluster from the database completely, deleting it with all records and caches in the cluster.

**Syntax**

```sql
DROP CLUSTER <cluster-name>
```

- **`<cluster-name>`** Defines the name of the cluster you want to drop.

>**NOTE**: When you drop a cluster, the cluster and all records and caches in the cluster are gone.  Unless you have made backups, there is no way to restore the cluster after you drop it.


**Examples**

- Drop a cluster `person` from the current, local database:

  <pre>
  orientdb> <code class="lang-sql userinput">DROP CLUSTER person</code>
  </pre>

  This removes both the cluster `Person` and all records of the `Person` class in that cluster.

>You can create a new cluster using the [`CREATE CLUSTER`](Console-Command-Create-Cluster.md) command.

>For information on other commands, see [SQL](SQL.md) and [Console](Console-Commands.md) commands.
