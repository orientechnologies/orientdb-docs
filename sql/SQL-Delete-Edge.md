---
search:
   keywords: ['SQL', 'DELETE EDGE', 'command', 'delete', 'edge', 'drop']
---

# SQL - `DELETE EDGE`

Removes edges from the database.  This is the equivalent of the [`DELETE`](SQL-Delete.md) command, with the addition of checking and maintaining consistency with vertices by removing all cross-references to the edge from both the `in` and `out` vertex properties.

**Syntax**

```sql
DELETE EDGE 
	( <rid>
	  |
	  [<rid> (, <rid>)*]
	  |
	  ( [ FROM (<rid> | <select_statement> ) ] [ TO ( <rid> | <select_statement> ) ] )
	  |
	  [<class>] 
	(
	[WHERE <conditions>]
	[LIMIT <MaxRecords>] 
	[BATCH <batch-size>]
```

- **`FROM`** Defines the starting point vertex of the edge to delete.
- **`TO`** Defines the ending point vertex of the edge to delete.
- **[`WHERE`](SQL-Where.md)** Defines the filtering conditions.
- **`LIMIT`** Defines the maximum number of edges to delete.
- **`BATCH`** Defines the block size for the operation, allowing you to break large transactions down into smaller units to reduce resource demands.  Its default is `100`.  Feature introduced in 2.1.



**Examples**

- Delete an edge by its RID:

  <pre>
  orientdb> <code class='lang-sql userinput'>DELETE EDGE #22:38482</code>
  </pre>

- Delete edges by RIDs:

  <pre>
  orientdb> <code class='lang-sql userinput'>DELETE EDGE [#22:38482,#23:232,#33:2332]</code>
  </pre>

- Delete edges where the data is a property that might exist in one or more edges between two vertices:

  <pre>
  orientdb> <code class='lang-sql userinput'>DELETE EDGE FROM #11:101 TO #11:117 WHERE date >= "2012-01-15"</code>
  </pre>

- Delete edges filtering by the edge class:

  <pre>
  orientdb> <code class="lang-sql userinput">DELETE EDGE FROM #11:101 TO #11:117 WHERE @class = 'Owns' AND comment 
            LIKE "regex of forbidden words"</code>
  </pre>

- Delete edge filtering by the edge class and date:

  <pre>
  orientdb> <code class="lang-sql userinput">DELETE EDGE Owns WHERE date < "2011-11"</code>
  </pre>

  Note that this syntax is faster than filtering the class through the [`WHERE`](SQL-Where.md) clause.

- Delete edges where `in.price` shows the condition on the `to` vertex for the edge:
 
  <pre>
  orientdb> <code class="lang-sql userinput">DELETE EDGE Owns WHERE date < "2011-11" AND in.price >= 202.43</code>
  </pre>

- Delete edges in blocks of one thousand per transaction.

  <pre>
  orientdb> <code class='lang-sql userinput'>DELETE EDGE Owns WHERE date < "2011-11" BATCH 1000</code>
  </pre>

  This feature was introduced in version 2.1.

>For more information, see
>
>- [`DELETE`](SQL-Delete.md)
>- [SQL Commands](SQL.md)


## Use Cases

### Controlling Vertex Version Increments

Creating and deleting edges causes OrientDB to increment versions on the involved vertices.  You can prevent this operation by implementing the [Bonsai Structure](../RidBag.md).

By default, OrientDB only uses Bonsai as soon as it reaches the threshold, in order to optimize operation.  To always use Bonsai, configure it on the JVM or in the `orientdb-server-config.xml` configuration file.

<pre>
$ <code class="lang-sh userinput">javac ... -DridBag.embeddedToSbtreeBonsaiThreshold=-1</code>
</pre>

To implement it in Java, add the following line to your application at a point before opening the database:

```java
OGlobalConfiguration.RID_BAG_EMBEDDED_TO_SBTREEBONSAI_THRESHOLD.setValue(-1);
```

For more information, see [Concurrency on Adding Edges](../Concurrency.md#concurrency-when-adding-edges).


| ![NOTE](../images/warning.png) | **NOTE**: When using a distributed database, OrientDB does not support SBTree indexes.  In these environments, you must set `ridBag.embeddedToSbtreeBonsaiThreshold=Integer.MAX\_VALUE` to avoid replication errors._ |
|----|----|

### Deleting Edges from a Sub-query

Consider a situation where you have an edge with a Record ID of `#11:0` that you want to delete.  In attempting to do so, you run the following query:

<pre>
orientdb> <code class='lang-sql userinput'>DELETE EDGE FROM (SELECT FROM #11:0)</code>
</pre>

This does **not** delete the edge.  To delete edges using sub-queries, you have to use a somewhat different syntax.  For instance,

<pre>
orientdb> <code class="lang-sql userinput">DELETE EDGE E WHERE @rid IN (SELECT FROM #11:0)</code>
</pre>

This removes the edge from your database.

### Deleting Edges through Java

When a `User` node follows a `company` node, we create an edge between the user and the company of the type `followCompany` and `CompanyFollowedBy` classes.  We can then remove the relevant edges through Java.

```java
node1 is User node,
node2 is company node

OGraphDatabase rawGraph = orientGraph.getRawGraph();
String[] arg={"followCompany,"CompanyFollowedBy"};
Set<OIdentifiable> edges=rawGraph.getEdgesBetweenVertexes(node1, node2,null,arg);
for (OIdentifiable oIdentifiable : edges) {
	**rawGraph.removeEdge(oIdentifiable);
}
```

## History


## 2.1

- Implements support for the option `BATCH` clause

## 1.4

- Command implements the Blueprints API.  In the event that you are working in Java using the OGraphDatabase API, you may experience some unexpected results in how edges are managed between versions.  To force the command to use the older API, change the GraphDB settings, as described on the [`ALTER DATABASE`])SQL-Alter-Database.md) command examples.

## 1.1 
- First implementation of the feature.

