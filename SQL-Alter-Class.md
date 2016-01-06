# SQL - `ALTER CLASS`

Updates attributes on an existing class in the schema.

**Syntax**

```sql
ALTER CLASS <class> <attribute-name> <attribute-value>
```

- **`<class>`** Defines the class you want to change.
- **`<attribute-name>`** Defines the attribute you want to change.  For a list of supported attributes, see the table below.
- **`<attribute-value>`** Defines the value you want to set.
  

**Examples**

- Define a super-class:

  <pre>
  orientdb> <code class='lang-sql userinput'>ALTER CLASS Employee SUPERCLASS Person</code>
  </pre>

- Define multiple inheritances:

  <pre>
  orientdb> <code class='lang-sql userinput'>ALTER CLASS Employee SUPERCLASS Person, ORestricted</code>
  </pre>

  This feature was introduced in version 2.1.

- Add a super-class:

  <pre>
  orientdb> <code class="lang-sql userinput">ALTER CLASS Employee SUPERCLASS +Person</code>
  </pre>

  This feature was introduced in version 2.1.

- Remove a super-class:

  <pre>
  orientdb> <code class="lang-sql userinput">ALTER CLASS Employee SUPERCLASS -Person</code>
  </pre>

  This feature was introduced in version 2.1.

- Update the class name from `Account` to `Seller`:

  <pre>
  orientdb> <code class="lang-sql userinput">ALTER CLASS Account NAME Seller</code>
  </pre>

- Update the oversize factor on the class `Account`:

  <pre>
  orientdb> <code class='lang-sql userinput'>ALTER CLASS Account OVERSIZE 2</code>
  </pre>

- Add a cluster to the class `Account`.

  <pre>
  orientdb> <code class="lang-sql userinput">ALTER CLASS Account ADDCLUSTER account2</code>
  </pre>

  In the event that the cluster does not exist, it automatically creates it.

- Remove a cluster from the class `Account` with the ID `34`:

  <pre>
  orientdb> <code class='lang-sql userinput'>ALTER CLASS Account REMOVECLUSTER 34</code>
  </pre>

- Add custom properties:

  <pre>
  orientdb> <code class='lang-sql userinput'>ALTER CLASS Post CUSTOM onCreate.fields=_allowRead,_allowUpdate</code>
  orientdb> <code class='lang-sql userinput'>ALTER CLASS Post CUSTOM onCreate.identityType=role</code>
  </pre>

- Create a new cluster for the class `Employee`, then set the cluster selection strategy to `balanced`:

  <pre>
  orientdb> <code class='lang-sql userinput'>CREATE CLUSTER employee_1</code>
  orientdb> <code class='lang-sql userinput'>ALTER CLASS Employee ADDCLUSTER employee_1</code>
  orientdb> <code class='lang-sql userinput'>ALTER CLASS Employee CLUSTERSELECTION balanced</code>
  </pre>

- Convert the class `TheClass` to an abstract class:

  <pre>
  orientdb> <code class="lang-sql userinput">ALTER CLASS TheClass ABSTRACT true</code>
  </pre>

>For more information see [`CREATE CLASS`](SQL-Create-Class.md), [`DROP CLASS`](SQL-Drop-Class.md), [`ALTER CLUSTER`](SQL-Alter-Cluster.md) commands.  For more information on other commands, see [`Console`](Console-Commands.md) and [SQL](SQL.md) commands.


## Supported Attributes

| Attribute | Type | Support| Description |
|---|---|---|---|
| `NAME` | String | | Changes the class name. |
| `SHORTNAME`| String | | Defines a short name, (that is, an alias), for the class.  Use `NULL` to remove a short name assignment. |
| `SUPERCLASS` | String | | Defines a super-class for the class.  Use `NULL` to remove a super-class assignment.  Beginning with version 2.1, it supports multiple inheritances. To add a new class, you can use the syntax `+<class>`, to remove it use `-<class>`.|
| `OVERSIZE`| Decimal number | | Defines the oversize factor. |
| `ADDCLUSTER` | String | | Adds a cluster to the class.  If the cluster doesn't exist, it creates a physical cluster. Adding clusters to a class is also useful in storing records in distributed servers.  For more information, see [Distributed Sharding](Distributed-Sharding.md). |
| `REMOVECLUSTER` | String | | Removes a cluster from a class.  It does not delete the cluster, only removes it from the class. |
| `STRICTMODE` | | | Enalbes or disables strict mode.  When in strict mode, you work in schema-full mode and cannot add new properties to a record if they're part of the class' schema definition. |
| `CLUSTERSELECTION` | | 1.7 | Defines the selection strategy in choosing which cluster it uses for new records.  On class creation it inherits the setting from the database.  For more information, see [Cluster Selection](Cluster-Selection.md).|
| `CUSTOM` | | | Defines custom properties.  Property names and values must follow the syntax `<property-name>=<value>` without spaces between the name and value. |
| `ABSTRACT` | Boolean | | Converts class to an abstract class or the opposite. |




## Java API

In addition to updating a class through the console or SQL, you can also change it through the Java API, using either the Graph or Document API.

- **Graph API**:

  ```java
  // ADD A CLUSTER TO A VERTEX CLASS
  graph.getVertexType("Customer").addCluster("customer_usa");

  // ADD A CLUSTER TO AN EDGE CLASS
  graph.getEdgeType("WorksAt").addCluster("WorksAt_2015");
  ```
- **Document API**

  ```java
  db.getMetadata().getSchema().getClass("Customer").addCluster("customer_usa")
  ```



## History

### 2.1

- Added support for multiple inheritance.

### 1.7

- Added support for `CLUSTERSELECTION` that sets the strategy used on selecting the cluster to use when creating new records.
