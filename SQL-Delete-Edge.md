# SQL - DELETE EDGE

This command deletes one or more edges from the database. Use this command if you work against graphs. The "DELETE EDGE" command takes care to remove all the cross references to the edge in both "in" and "out" vertices.

## Syntax

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

Where:
- `FROM` the starting point vertex of the edge to delete
- `TO` the end point vertex of the edge to delete
- [WHERE](SQL-Where.md) clause is common to the other SQL commands.
- `LIMIT` the maximum number of edges to delete
- `BATCH` optional block (since v2.1) gets the `<batch-size>` to execute the command in small blocks, avoiding memory problems when the number of vertices is high (Transaction consumes RAM). By default is 100.

## Control vertices version increment
Creation and deletion of edges cause updating of versions on involved vertices. To avoid this behavior use the [Bonsai structure](RidBag.md). By default [Bonsai](RidBag.md) is used as soon as the threshold is reached to optimize operations. To always use Bonsai, set this configuration on JVM (or in `orientdb-server-config.xml` file): 

```
-DridBag.embeddedToSbtreeBonsaiThreshold=-1
``` 
Or in Java by calling this before opening the database:

```java
OGlobalConfiguration.RID_BAG_EMBEDDED_TO_SBTREEBONSAI_THRESHOLD.setValue(-1);
```

For more information look at [Concurrency on adding edges](Concurrency.md#concurrency-on-adding-edges).

| ![NOTE](images/warning.png) | _NOTE: While running in distributed mode SBTrees are not supported. If using a distributed database then you must set `ridBag.embeddedToSbtreeBonsaiThreshold=Integer.MAX\_VALUE` to avoid replication errors._ |
|----|----|


# History and Compatibility
- 1.1: first version
- 1.4: the command uses the Blueprints API under the hood, so if you're working in Java using the OGraphDatabase API you could experience in some difference how edges are managed. To force the command to work with the "old" API change the GraphDB settings described in [Graph backward compatibility](SQL-Alter-Database.md#use-graphdb-created-with-releases-before-14)
- 2.1: supported optional BATCH block and set of RIDs: `DELETE EDGE [<rid> (, <rid>)*]`

# Examples

Delete edges where date is a property which might exist in one of more edges between the two vertices:
```sql
DELETE EDGE FROM #11:101 TO #11:117 WHERE date >= "2012-01-15"
```

Deletes edges filtering also by Edge's class:
```sql
DELETE EDGE FROM #11:101 TO #11:117 WHERE @class = 'owns' AND comment LIKE "regex of forbidden words"
```

This is the faster alternative to <code>DELETE EDGE WHERE @class = 'owns' and date < "2011-11"</code>:
```sql
DELETE EDGE Owns WHERE date < "2011-11"
```

Deletes edges where in.price shows the condition on 'to vertex' for the edge
```sql
DELETE EDGE Owns WHERE date < "2011-11" AND in.price >= 202.43
```

Deletes edges with a condition in blocks of 1000 each (Since v2.1)
```sql
DELETE EDGE Owns WHERE date < "2011-11" BATCH 1000
```

# Deleting Edges from a subquery

Suppose you have an edge with RID = #11:0, the following query **DOES NOT DELETE** the edge

```sql
DELETE EDGE FROM (SELECT FROM #11:0)
```

To delete the edge with a subquery, the right syntax is:

```sql
DELETE EDGE E WHERE @rid in (SELECT FROM #11:0)
```


# Deleting Edge using Java Code:

When User follow a company We create edge between User and company of type followCompany and CompanyFollowedBy class

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

