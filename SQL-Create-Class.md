# SQL - `CREATE CLASS`

Creates a new class in the schema.

**Syntax**

```sql
CREATE CLASS <class> [EXTENDS <super-class>] [CLUSTER <cluster-id>*] [CLUSTERS <total-cluster-number>] [ABSTRACT]
```

- **`<class>`** Defines the name of the class you want to create.  You must use a letter for the first character, for all other characters you can use alphanumeric characters, underscores and dashes.
- **`<super-class>`** Defines the super-class you want to extend with this class.
- **`<cluster-id>`**  Defines in a comma-separated list the ID's of the clusters you want this class to use.
- **`<total-cluster-number>`** Defines the total number of clusters you want to create for this class.  The default value is `1`.  This feature was introduced in version 2.1.
- **`ABSTRACT`** Defines whether the class is abstract.  For abstract classes, you cannot create instances of the class.


In the event that a cluster of the same name exists in the cluster, the new class uses this cluster by default.  If you do not define a cluster in the command and a cluster of this name does not exist, OrientDB creates one.  The new cluster has the same name as the class, but in lower-case.

When working with multiple cores, it is recommended that you use multiple clusters to improve concurrency during inserts.  To change the number of clusters created by default, [`ALTER DATABASE`](SQL-Alter-Database.md) command to update the `minimumclusters` property.  Beginning with version 2.1, you can also define the number of clusters you want to create using the `CLUSTERS` option when you create the class.


**Examples**

- Create the class `Account`:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE CLASS Account</code>
  </pre>

- Create the class `Car` to extend `Vehicle`:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE CLASS Car EXTENDS Vehicle</code>
  </pre>

- Create the class `Car`, using the cluster ID of `10`:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE CLASS Car CLUSTER 10</code>
  </pre>

- Create the class `Person` as an [abstract class](Concepts.md#abstract-class):

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE CLASS Person ABSTRACT</code>
  </pre>


## Cluster Selection Strategies

When you create a class, it inherits the cluster selection strategy defined at the database-level.  By default this is set to round-robin.  You can change the database default using the [`ALTER DATABASE`](SQL-Alter-Database.md) command and the selection strategy for the class using the [`ALTER CLASS`](SQL-Alter-Class.md) command.

Supported Strategies:

| Strategy | Description |
|---|---|
| `default` | Selects the cluster using the class property `defaultClusterId`.  This was the default selection strategy before version 1.7.|
| `round-robin` | Selects the next cluster in a circular order, restarting once complete. |
| `balanced` | Selects the smallest cluster.  Allows the class to have all underlying clusters balanced on size.  When adding a new cluster to an existing class, it fills the new cluster first.  When using a distributed database, this keeps the servers balanced with the same amount of data.  It calculates the cluster size every five seconds or more to avoid slow-downs on insertion.|

>For more information, see
>
>- [`ALTER CLASS`](SQL-Alter-Class.md)
>- [`DROP CLASS`](SQL-Drop-Class.md)
>- [`CREATE CLUSTER`](SQL-Create-Cluster.md)
>- [SQL Commands](SQL.md)
>- [Console Commands](Console-Commands.md)

