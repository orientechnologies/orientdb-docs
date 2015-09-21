# SQL - MOVE VERTEX

This command moves one or more Vertices into another class or cluster. The new vertices will have a new identity ([RID](Concepts.md#recordid)). The command takes care of updating all the edges to point to the new vertices. If a cluster is specified as target and OrientDB is running distributed, then the vertices will be moved to the servers owner of the target cluster. 

|![](images/warning.png)|NOTE: `MOVE VERTEX` command updates all connected edges, but not [links](Concepts.md#relationships). If you work with Graph API, we suggest to always use edges to connect vertices and never links.|
|----|----|

## Syntax

```sql
MOVE VERTEX <source> TO <destination> [SET [<field>=<value>]* [,]] [MERGE <JSON>] [BATCH <batch-size>]
```

Where:
- `source` are the vertices to move. This could be one of the following values:
 - A **single vertex** by RID. Example: `MOVE VERTEX #34:232 TO CLASS:Provider`
 - An **array of vertices** by RIDs. Example: `MOVE VERTEX [#34:232,#34:444] TO CLASS:Provider`
 - A **subquery** with vertices as result. All the returning vertices will be moved. Example: `MOVE VERTEX (SELECT FROM V WHERE city = 'Rome') TO CLASS:Provider`
- `destination` is the location where to move vertices. Can be one of the followings:
 - **Class**, by using the syntax `CLASS:<class-name>`. Use this to refactor your graph assigning a new class to vertices
 - **Cluster**, by using the syntax `CLUSTER:<cluster-name>`. Use this to move your vertices on different clusters in the same class. This is useful on [Distributed Configuration](Distributed-Architecture.md) where you can move vertices on other servers
- `SET` optional block contains the pairs of values to assign during the moving. The syntax is the same as [SQL UPDATE](SQL-Update.md). Example: `MOVE VERTEX (SELECT FROM V WHERE type = 'provider') TO CLASS:Provider SET movedOn = Date()`
- `MERGE` optional block gets a JSON containing the pairs of values to assign during the moving. The syntax is the same as [SQL UPDATE](SQL-Update.md). Example: `MOVE VERTEX (SELECT FROM V WHERE type = 'provider') TO CLASS:Provider MERGE { author : 'Jay Miner' }`
- `BATCH` optional block gets the `<batch-size>` to execute the command in small blocks, avoiding memory problems when the number of vertices is high (Transaction consumes RAM). By default is 100. To execute the entire operation in one transaction, disable the batch by setting the `<batch-size>` to `-1`


## See also
- [Create Vertex](SQL-Create-Vertex.md)
- [Create Edge](SQL-Create-Edge.md)

## History and Compatibility

- 2.0: first version

## Examples

### Refactoring of graph by adding sub-types

It's very common the case when you start modeling your domain in a way, but then you need more flexibility. On this example we want to split all the "Person" vertices under 2 new sub-types called "Customer" and "Provider" respectively. At the end we declare Person as abstract class.

```sql
CREATE CLASS Customer EXTENDS Person
CREATE CLASS Provider EXTENDS Person
MOVE VERTEX (SELECT FROM Person WHERE type = 'Customer') TO CLASS:Customer
MOVE VERTEX (SELECT FROM Person WHERE type = 'Provider') TO CLASS:Provider
ALTER CLASS Person ABSTRACT TRUE
```

### Move vertices on different servers

OrientDB allows you to scale up by just adding servers. As soon as you add a new server, OrientDB creates automatically a new cluster with the name of the class plus the node name. Example: "customer_europe". Partitioning is a best practice when you need to scale up, specially on writes. If you have a graph with "Customer" vertices and you want to move some vertices to other server you can move them to the cluster owned by the server where you want your vertices are moved.

With this example, we're moving all the customers that live in Italy, Germany or UK to the "customer_europe" cluster assigned to the node "Europe". In this way all the access to European customers will be faster to the applications connected to the European node:

```sql
MOVE VERTEX (SELECT FROM Customer WHERE ['Italy', 'Germany', 'UK'] IN out('city').out('country') ) TO CLUSTER:customer_europe
```

---
To know more about other SQL commands look at [SQL commands](SQL.md).
