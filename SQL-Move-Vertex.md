# SQL - `MOVE VERTEX`

Moves one or more vertices into a different class or cluster.  

Following the move, the vertices use a different Record ID.  The command updates all edges to use the moved vertices.  When using a distributed database, if you specify a cluster, it moves the vertices to the server owner of the target cluster.

**Syntax**

```sql
MOVE VERTEX <source> TO <destination> [SET [<field>=<value>]* [,]] [MERGE <JSON>] 
[BATCH <batch-size>]
```

- **`<source>`** Defines the vertex you want to move. It supports the following values,
  - *Vertex* Using the Record ID of a single vertex.
  - *Array* Using an array of record ID's for vertices you want to move.
- **`<destination>`** Defines where you want to move the vertex to.  It supports the following values,
  - *Class* Using `CLASS:<class>` with the class you want to move the vertex into.
  - *Cluster* Using `CLUSTER:<cluster>` with the cluster you want to move the vertex into. 
- **`SET`** Clause to set values on fields during the transition.
- **`MERGE`** Clause to set values on fields during the transition, through JSON.
- **`BATCH`** Defines the batch size, allowing you to execute the command in smaller blocks to avoid memory problems when moving a large number of vertices.  


|![WARNING](images/warning.png) | **WARNING**: This command updates all connected edges, but not the [links](Concepts.md#relationships).  When using the Graph API, it is recommend that you always use edges connected to vertices and never links. |
|---|---|


**Examples**

- Move a single vertex from its current position to the class `Provider`:

  <pre>
  orientdb> <code class="lang-sql userinput">MOVE VERTEX #34:232 TO CLASS:Provider</code>
  </pre>

- Move an array of vertices by their record ID's to the class `Provider`:

  <pre>
  orientdb> <code class="lang-sql userinput">MOVE VERTEX [#34:232,#34:444] TO CLASS:Provider</code>
  </pre>

- Move a set of vertices to the class `Provider`, defining those you want to move with a subquery:

  <pre>
  orientdb> <code class="lang-sql userinput">MOVE VERTEX (SELECT FROM V WHERE city = 'Rome') TO CLASS:Provider</code>
  </pre>

- Move a vertex from its current position to the European cluster

  <pre>
  orientdb> <code class="lang-sql userinput">MOVE VERTEX #3:33 TO CLUSTER:providers_europe</code>
  </pre>

  You may find this useful when using a [distributed database](Distributed-Architecture.md), where you can move vertices onto different servers.

- Move a set of vertices to the class `Provider`, while doing so update the property `movedOn` to the current date:

  <pre>
  orientdb> <code class="lang-sql userinput">MOVE VERTEX (SELECT FROM V WHERE type = 'provider') TO CLASS:Provider 
            SET movedOn = Date()</code>
  </pre>

  Note the similarities this syntax has with the [`UPDATE`](SQL-Update.md) command. 

- Move the vertex using a subquery, using JSON update the properties during the transition:

  <pre>
  orientdb> <code class="lang-sql userinput>MOVE VERTEX (SELECT FROM V WHERE type = 'provider') TO CLASS:Provider 
            MERGE { author : 'Jay Miner' }</code>
  </pre>

- Move a large number of vertices by subquery in batches of fifty: 

  <pre>
  orientdb> <code class="lang-sql userinput">MOVE VERTEX (SELECT FROM User) TO CLUSTER:users_europe BATCH 50</code>
  </pre>

- Move the same vertices as above using only one transaction:


  <pre>
  orientdb> <code class="lang-sql userinput">MOVE VERTEX (SELECT FROM User) TO CLUSTER:users_europe BATCH -1</code>
  </pre>

>For more information, see
>
>- [`CREATE VERTEX`](SQL-Create-Vertex.md)
>- [`CREATE EDGE`](SQL-Create-Edge.md)
>- [SQL Commands](SQL.md)

## Use Cases

### Refactoring Graphs through Sub-types

It's a very common situation where you begin modeling your domain one way, but find later that you need more flexibility.  

For instance, say that you start out with a vertex class called `Person`.  After using the database for several months, populating it with new vertices, you decide that you need to split these vertices into two new classes, or sub-types, called `Customer` and `Provider`, (rendering `Person` into an abstract class).

- Create the new classes for your sub-types:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE CLASS Customer EXTENDS Person</code>
  orientdb> <code class="lang-sql userinput">CREATE CLASS Provider EXTENDS Person</code>
  </pre>

- Move the providers and customers from `Person` into their respective sub-types:

  <pre>
  orientdb> <code class="lang-sql userinput">MOVE VERTEX (SELECT FROM Person WHERE type = 'Customer') TO 
            CLASS:Customer</code>
  orientdb> <code class="lang-sql userinput">MOVE VERTEX (SELECT FROM Person WHERE type = 'Provider') TO 
            CLASS:Provider</code>
  </pre>

- Make the class `Person` an abstract class:

  <pre>
  orientdb> <code class="lang-sql userinput">ALTER CLASS Person ABSTRACT TRUE</code>
  </pre>

### Moving Vertices onto Different Servers

With OrientDB, you can scale your infrastructure up by adding new servers.  When you add a new server, OrientDB automatically creates a new cluster with the name of the class plus the node name.  For instance, `customer_europe`.

The best practice when you need to scale up is partitioning, especially on writes.  If you have a graph with `Customer` vertices and you want to move some of these onto a different server, you can move them to the cluster owned by the server.

For instance, move all customers that live in Italy, Germany or the United Kingdom onto the cluster `customer_europe`, which is assigned to the node `Europe`.  This means that access to European customers is faster with applications connected to the European node.

<pre>
orientdb> <code class="lang-sql userinput">MOVE VERTEX (SELECT FROM Customer WHERE ['Italy', 'Germany', 'UK'] IN 
          out('city').out('country') ) TO CLUSTER:customer_europe</code>
</pre>



## History

### 2.0

- Initial implementation of the feature.
