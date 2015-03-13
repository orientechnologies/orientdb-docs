# SQL - DELETE EDGE

This command deletes one or more edges from the database. Use this command if you work against graphs. The "Delete edge" command takes care to remove all the cross references to the edge in both "in" and "out" vertices.

## Syntax

```sql
DELETE EDGE <rid>|[<rid> (, <rid>)*]|FROM <rid>|TO <rid>|[<class>] [WHERE <conditions>]> [LIMIT <MaxRecords>]
```

The [WHERE](SQL-Where.md) clause is common to the other SQL commands.

# History and Compatibility
- 1.1: first version
- 1.4: the command uses the Blueprints API under the hood, so if you're working in Java using the OGraphDatabase API you could experience in some difference how edges are managed. To force the command to work with the "old" API change the GraphDB settings described in [Graph backward compatibility](SQL-Alter-Database.md#use-graphdb-created-with-releases-before-14)
- 2.1: delete a set of RIDs:
```sql
DELETE EDGE [<rid> (, <rid>)*]
```
# Examples

Delete edges where date is a property which might exist in one of more edges between the two vertices:
```sql
DELETE EDGE from #11:101 TO #11:117 Where date >= "2012-01-15"
```

Deletes edges filtering also by Edge's class:
```sql
DELETE EDGE FROM #11:101 TO #11:117 WHERE @class = 'owns' and comment like "regex of forbidden words"
```

This is the faster alternative to <code>DELETE EDGE WHERE @class = 'owns' and date < "2011-11"</code>:
```sql
DELETE EDGE Owns WHERE date < "2011-11"
```

Deletes edges where in.price shows the condition on 'to vertex' for the edge
```sql
DELETE EDGE Owns WHERE date < "2011-11" and in.price >= 202.43
```

#Deleting Edge using Java Code:

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
