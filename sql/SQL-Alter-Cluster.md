---
search:
   keywords: ['SQL', 'command', 'alter', 'cluster', 'ALTER CLUSTER']
---
# SQL - `ALTER CLUSTER`

Updates attributes on an existing cluster.

**Syntax**

```sql
ALTER CLUSTER <cluster> <attribute-name> <attribute-value>
```

- **`<cluster>`** Defines the cluster you want to change.  You can use its logical name or ID.  Beginning with version 2.2, you can use the wildcard `*` to update multiple clusters together.
- **`<attribute-name>`** Defines the attribute you want to change.  For a list of supported attributes, see the table below.
- **`<attribute-value>`** Defines the value you want to set.

**Examples**

- Change the name of a cluster, using its name:

  <pre>
  orientdb> <code class="lang-sql userinput">ALTER CLUSTER profile NAME "profile2"</code>
  </pre>


> IMPORTANT: cluster name, status, compression, conflictstrategy are strings, so they have to be "quoted"

- Change the name of a cluster, using its ID:

  <pre>
  orientdb> <code class="lang-sql userinput">ALTER CLUSTER 9 NAME "profile2"</code>
  </pre>

- Update the cluster conflict strategy to `automerge`:

  <pre>
  orientdb> <code class="lang-sql userinput">ALTER CLUSTER V CONFLICTSTRATEGY "automerge"</code>
  </pre>

- Put cluster `V_2012` offline:

  <pre>
  orientdb> <code class='lang-sql userinput'>ALTER CLUSTER V_2012 STATUS "OFFLINE"</code>
  </pre>

- Update multiple clusters with a similar name:

  <pre>
  orientdb> <code class='lang-sql userinput'>ALTER CLUSTER employee* status "offline"</code>
  </pre>



>For more information see, [`CREATE CLUSTER`](SQL-Create-Cluster.md), [`DROP CLUSTER`](SQL-Drop-Cluster.md), [`ALTER CLUSTER`](SQL-Alter-Cluster.md) commands.  
>For more information on other commands, please refer to [Console Commands](../console/Console-Commands.md) and [SQL Commands](SQL-Commands.md).

## Supported Attributes

| Name | Type | Support | Description |
|---|---|---|---|
| `NAME` | String | | Changes the cluster name. |
| `STATUS`| String | | Changes the cluster status.  Allowed values are `ONLINE` and `OFFLINE`.  By default, clusters are online.  When offline, OrientDB no longer opens the physical files for the cluster.  You may find this useful when you want to archive old data elsewhere and restore when needed.|
|`CONFLICTSTRATEGY`|String|2.0+| Defines the strategy it uses to handle conflicts in the event that OrientDB MVCC finds an update or a delete operation it executes against an old record.  If you don't define a strategy at the cluster-level, it uses the database-level configuration.  For more information on supported strategies, see the section below.|

> **Note**: from version 3.x attributes `COMPRESSION`, `USE_WAL`, `RECORD_OVERFLOW_GROW_FACTOR`, `RECORD_OVERFLOW_GROW_FACTOR` are no longer supported.

### Supported Conflict Strategies

| Strategy | Description |
|---|---|
| `version` | Throws an exception when versions are different.  This is the default setting. |
| `content` | In the event that the versions are different, it checks for changes in the content, otherwise it uses the highest version to avoid throwing an exception.|
| `automerge` | Merges the changes.|





To know more about other SQL commands, take a look at [SQL Commands](SQL-Commands.md).
