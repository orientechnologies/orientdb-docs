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
  orientdb> <code class="lang-sql userinput">ALTER CLUSTER profile NAME profile2</code>
  </pre>

- Change the name of a cluster, using its ID:

  <pre>
  orientdb> <code class="lang-sql userinput">ALTER CLUSTER 9 NAME profile2</code>
  </pre>

- Update the cluster conflict strategy to `automerge`:

  <pre>
  orientdb> <code class="lang-sql userinput">ALTER CLUSTER V CONFLICTSTRATEGY automerge</code>
  </pre>

- Put cluster `V_2012` offline:

  <pre>
  orientdb> <code class='lang-sql userinput'>ALTER CLUSTER V_2012 STATUS OFFLINE</code>
  </pre>

- Update multiple clusters with a similar name:

  <pre>
  orientdb> <code class='lang-sql userinput'>ALTER CLUSTER employee* status offline</code>
  </pre>



>For more information see, [`CREATE CLUSTER`](SQL-Create-Cluster.md), [`DROP CLUSTER`](SQL-Drop-Cluster.md), [`ALTER CLUSTER`](SQL-Alter-Cluster.md) commands.  For more information on other commands, see [Console](Console-Commands.md) and [SQL](SQL.md) commands.

## Supported Attributes

| Name | Type | Support | Description |
|---|---|---|---|
| `NAME` | String | | Changes the cluster name. |
| `STATUS`| String | | Changes the cluster status.  Allowed values are `ONLINE` and `OFFLINE`.  By default, clusters are online.  When offline, OrientDB no longer opens the physical files for the cluster.  You may find this useful when you want to archive old data elsewhere and restore when needed.|
| `COMPRESSION` | String | | Defines the compression type to use.  Allowed values are `NOTHING`, `SNAPPY`, `GZIP`, and any other compression types registered in the `OCompressionFactory` class.  OrientDB class the `compress()` method each time it saves the record to the storage, and the `uncompress()` method each time it loads the record from storage.  You can also use the `OCompression` interface to manage encryption.|
|`USE_WAL`| Boolean || Defines whether it uses the Journal (Write Ahead Log) when OrientDB operates against the cluster.|
| `RECORD_GROW_FACTOR`|Integer| | Defines the grow factor to save more space on record creation.  You may find this useful when you update the record with additional information.  In larger records, this avoids defragmentation, as OrientDB doesn't have to find new space in the event of updates with more data.|
|`RECORD_OVERFLOW_GROW_FACTOR`|Integer|| Defines grow factor on updates.  When it reaches the size limit, is uses this setting to get more space, (factor > 1).|
|`CONFLICTSTRATEGY`|String|2.0+| Defines the strategy it uses to handle conflicts in the event that OrientDB MVCC finds an update or a delete operation it executes against an old record.  If you don't define a strategy at the cluster-level, it uses the database-level configuration.  For more information on supported strategies, see the section below.|

### Supported Conflict Strategies

| Strategy | Description |
|---|---|
| `version` | Throws an exception when versions are different.  This is the default setting. |
| `content` | In the event that the versions are different, it checks for changes in the content, otherwise it uses the highest version to avoid throwing an exception.|
| `automerge` | Merges the changes.|





To know more about other SQL commands, take a look at [SQL commands](SQL.md).
