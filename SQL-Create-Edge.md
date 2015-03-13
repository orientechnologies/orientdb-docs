# SQL - CREATE EDGE

This command creates a new Edge into the database. Edges, together with Vertices, are the main components of a Graph. OrientDB supports polymorphism on edges. The base class is "E" (before 1.4 was called "OGraphEdge"). Look also how to [Create Vertex](SQL-Create-Vertex.md).

| ![NOTE](images/warning.png) | _NOTE: While running as distributed, edge creation could be done in two steps (create+update). This could break some constraint defined at Edge's class level. To avoid this kind of problem disable the constrains in Edge's class._ |
|----|----|

## Syntax

```sql
CREATE EDGE <class> [CLUSTER <cluster>] FROM <rid>|(<query>)|[<rid>]* TO <rid>|(<query>)|[<rid>]*
                    [SET <field> = <expression>[,]*]|CONTENT {<JSON>}
                    [RETRY <retry> [WAIT <pauseBetweenRetriesInMs]]
```

Where:
- **class**, is the Edge's class name, or "E" if you don't use sub-types
- **cluster**, is the cluster name where to physically store the edge
- **JSON**, is the JSON content to set as record content, instead of field by field
- **retry**, is the number of retries in case of conflict (optimistic approach)
- **pauseBetweenRetriesInMs**, are the milliseconds of delay between retries

## Examples

### Create a new edge between two vertices of the base class 'E', namely OGraphEdge

```sql
create edge from #10:3 to #11:4
```

### Create a new edge type and a new edge of the new type

```sql
create class E1 extends E
create edge E1 from #10:3 to #11:4
```

### Create a new edge in a particular cluster

```sql
create edge E1 cluster EuropeEdges from #10:3 to #11:4
```

### Create a new edge setting properties

```sql
create edge from #10:3 to #11:4 set brand = 'fiat'
```

### Create a new edge of type E1 setting properties

```sql
create edge E1 from #10:3 to #11:4 set brand = 'fiat', name = 'wow'
```
### Create new edges of type Watched between all the action Movies and me using sub-queries

```sql
create edge Watched from (select from account where name = 'Luca') to (select from movies where type.name = 'action')
```

### Create an edge with JSON content
```sql
create edge E from #22:33 to #22:55 content { "name" : "Jay", "surname" : "Miner" }
```


## History and compatibility

- 1.1: first version
- 1.2: the support for query and collection of RIDs in FROM/TO
- 1.4: the command uses the Blueprints API under the hood, so if you're working in Java using the OGraphDatabase API you could experience in some difference how edges are managed. To force the command to work with the "old" API change the GraphDB settings described in [Graph backward compatibility](SQL-Alter-Database.md#use-graphdb-created-with-releases-before-14)
- 2.0: New databases have [Lightweight Edges](Lightweight-Edges) disabled by default, so this command creates regular edges.


To know more about other SQL commands look at [SQL commands](SQL.md).
