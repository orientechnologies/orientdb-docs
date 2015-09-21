# SQL - CREATE EDGE

This command creates a new Edge into the database. Edges, together with Vertices, are the main components of a Graph. OrientDB supports polymorphism on edges. The base class is "E". Look also how to [Create Vertex](SQL-Create-Vertex.md). 

Before 2.1, if no edges were created, no error was thrown. Starting from 2.1, instead, if no edges are created, an `OCommandExecutionException` exception is thrown. This makes easier to use `CREATE EDGE` in transactions where if source or target vertices doesn't exist the entire transaction is rolled back.

## Syntax

```sql
CREATE EDGE <class> [CLUSTER <cluster>] FROM <rid>|(<query>)|[<rid>]* TO <rid>|(<query>)|[<rid>]*
                    [SET <field> = <expression>[,]*]|CONTENT {<JSON>}
                    [RETRY <retry> [WAIT <pauseBetweenRetriesInMs]] [BATCH <batch-size>]
```

Where:
- **class**, is the Edge's class name, or "E" if you don't use sub-types
- **cluster**, is the cluster name where to physically store the edge
- **JSON**, is the JSON content to set as record content, instead of field by field
- **retry**, is the number of retries in case of conflict (optimistic approach)
- **pauseBetweenRetriesInMs**, are the milliseconds of delay between retries
- `BATCH` optional block gets the `<batch-size>` to execute the command in small blocks, avoiding memory problems when the number of vertices is high (Transaction consumes RAM). By default is 100. To execute the entire operation in one transaction, disable the batch by setting the `<batch-size>` to `-1`. Since 2.1.3

## Control vertices version increment
Creation and deletion of edges cause updating of versions in involved vertices. To avoid this behavior use [Bonsai structure](RidBag.md). By default [Bonsai](RidBag.md) is used as soon as the threshold is reached to optimize operations. To always use Bonsai, set this configuration on JVM (or in `orientdb-server-config.xml` file): 

```
-DridBag.embeddedToSbtreeBonsaiThreshold=-1
``` 
Or in Java by calling this before opening the database:

```java
OGlobalConfiguration.RID_BAG_EMBEDDED_TO_SBTREEBONSAI_THRESHOLD.setValue(-1);
```

For more information look at [Concurrency on adding edges](Concurrency.md#concurrency-on-adding-edges).

| ![NOTE](images/warning.png) | _NOTE: While running as distributed, edge creation could be done in two steps (create+update). This could break some constraint defined at Edge's class level. To avoid this kind of problem disable the constrains in Edge's class. While running in distributed mode SBTrees are not supported. If using a distributed database then you must set `ridBag.embeddedToSbtreeBonsaiThreshold=Integer.MAX\_VALUE` to avoid replication errors._ |
|----|----|

## Examples

### Create a new edge between two vertices of the base class 'E'

```sql
CREATE EDGE FROM #10:3 TO #11:4
```

### Create a new edge type and a new edge of the new type

```sql
CREATE CLASS E1 EXTENDS E
CREATE EDGE E1 FROM #10:3 TO #11:4
```

### Create a new edge in a particular cluster

```sql
CREATE EDGE E1 CLUSTER EuropeEdges FROM #10:3 TO #11:4
```

### Create a new edge setting properties

```sql
CREATE EDGE FROM #10:3 TO #11:4 SET brand = 'fiat'
```

### Create a new edge of type E1 setting properties

```sql
CREATE EDGE E1 FROM #10:3 TO #11:4 SET brand = 'fiat', name = 'wow'
```
### Create new edges of type Watched between all the action Movies and me using sub-queries

```sql
CREATE EDGE Watched FROM (SELECT FROM account WHERE name = 'Luca') TO (SELECT FROM movies WHERE type.name = 'action')
```

### Create an edge with JSON content
```sql
CREATE EDGE E FROM #22:33 TO #22:55 CONTENT { "name" : "Jay", "surname" : "Miner" }
```


## History and compatibility

- 1.1: first version
- 1.2: the support for query and collection of RIDs in FROM/TO
- 1.4: the command uses the Blueprints API under the hood, so if you're working in Java using the OGraphDatabase API you could experience in some difference how edges are managed. To force the command to work with the "old" API change the GraphDB settings described in [Graph backward compatibility](SQL-Alter-Database.md#use-graphdb-created-with-releases-before-14)
- 2.0: New databases have [Lightweight Edges](Lightweight-Edges.md) disabled by default, so this command creates regular edges.


To know more about other SQL commands look at [SQL commands](SQL.md).
