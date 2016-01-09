<!-- proofread 2015-01-07 SAM -->

# Console - `CREATE CLUSTER`

Creates a new cluster in the current database. The cluster you create can either be physical or  in memory. OrientDB saves physical clusters to disk. Memory clusters are volatile, so any records you save to them are lost, should the server be stopped.

**Syntax**

```sql
CREATE CLUSTER <cluster-name> <cluster-type> <data-segment> <location> [<position>]
```

- **`<cluster-name>`** Defines the name of the cluster.
- **`<cluster-type>`** Defines whether the cluster is `PHYSICAL` or `LOGICAL`.
- **`<data-segment>`** Defines the data segment you want to use.
  - *`DEFAULT`* Sets the cluster to the default data segment.
- **`<location>`** Defines the location for new cluster files, if applicable.  Use `DEFAULT` to save these to the database directory.
- **`<position>`** Defines where to add new cluster.  Use `APPEND` to create it as the last cluster. Leave empty to replace.

**Example**

- Create a new cluster `documents`:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE CLUSTER documents PHYSICAL DEFAULT DEFAULT APPEND</code>

  Creating cluster [documents] of type 'PHYSICAL' in database demo as last one...
  PHYSICAL cluster created correctly with id #68
  </pre>


>You can display all configured clusters in the current database using the [`CLUSTERS`](Console-Command-Clusters.md) command.  To delete an existing cluster, use the [`DROP CLUSTER`](Console-Command-Drop-Cluster.md) command.
>
>For more information on other commands, see [Console Commands](Console-Commands.md)