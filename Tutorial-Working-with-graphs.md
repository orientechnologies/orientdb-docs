---
search:
   keywords: ["tutorial", "graph"]
---

<!-- proofread 2015-11-26 SAM -->

# Working with Graphs


In graph databases, the database system graphs data into network-like structures consisting of vertices and edges. In the OrientDB [Graph model](Tutorial-Document-and-graph-model.md#graph-model), the database represents data through the concept of a property graph, which defines a vertex as an entity linked with other vertices and an edge, as an entity that links two vertices.

OrientDB ships with a generic vertex persistent class, called `V`, as well as a class for edges, called `E`. As an example, you can create a new vertex using the [`INSERT`](SQL-Insert.md) command with `V`.

<pre>
orientdb> <code class="lang-sql userinput">INSERT INTO V SET name='Jay'</code>

Created record with RID #9:0
</pre>

In effect, the Graph model database works on top of the underlying document model. But, in order to simplify this process, OrientDB introduces a new set of commands for managing graphs from the console. Instead of [`INSERT`](SQL-Insert.md), use [`CREATE VERTEX`](SQL-Create-Vertex.md)

<pre>
orientdb> <code class="lang-sql userinput">CREATE VERTEX V SET name='Jay'</code>

Created vertex with RID #9:1
</pre>

By using the graph commands over the standard SQL syntax, OrientDB ensures that your graphs remain consistent. For more information on the particular commands, see the following pages:

- [CREATE VERTEX](SQL-Create-Vertex.md)
- [DELETE VERTEX](SQL-Delete-Vertex.md)
- [CREATE EDGE](SQL-Create-Edge.md)
- [UPDATE EDGE](SQL-Update-Edge.md)
- [DELETE EDGE](SQL-Delete-Edge.md)

## Use Case: Social Network for Restaurant Patrons

While you have the option of working with vertexes and edges in your database as they are, you can also extend the standard `V` and `E` classes to suit the particular needs of your application. The advantages of this approach are,

- It grants better understanding about the meaning of these entities.
- It allows for optional constraints at the class level.
- It improves performance through better partitioning of entities.
- It allows for object-oriented inheritance among the graph elements.

For example, consider a social network based on restaurants. You need to start with a class for individual customers and another for the restaurants they patronize. Create these classes to extend the `V` class.

<pre>
orientdb> <code class="lang-sql userinput">CREATE CLASS Person EXTENDS V</code>

orientdb> <code class="lang-sql userinput">CREATE CLASS Restaurant EXTENDS V</code>
</pre>

Doing this creates the schema for your social network. Now that the schema is ready, populate the graph with data.

<pre>
orientdb> <code class="lang-sql userinput">CREATE VERTEX Person SET name='Luca'</code>

Created record with RID #11:0


orientdb> <code class="lang-sql userinput">CREATE VERTEX Person SET name='Bill'</code>

Created record with RID #11:1


orientdb> <code class="lang-sql userinput">CREATE VERTEX Person SET name='Jay'</code>

Created record with RID #11:2


orientdb> <code class="lang-sql userinput">CREATE VERTEX Restaurant SET name='Dante', type='Pizza'</code>

Created record with RID #12:0


orientdb> <code class="lang-sql userinput">CREATE VERTEX Restaurant SET name='Charlie', type='French'</code>

Created record with RID #12:1
</pre>

This adds three vertices to the `Person` class, representing individual users in the social network. It also adds two vertices to the `Restaurant` class, representing the restaurants that they patronize.

#### Creating Edges

For the moment, these vertices are independent of one another, tied together only by the classes to which they belong. That is, they are not yet connected by edges. Before you can make these connections, you first need to create a class that extends `E`.

<pre>
orientdb> <code class="lang-sql userinput">CREATE CLASS Eat EXTENDS E</code>
</pre>

This creates the class `Eat`, which extends the class `E`. `Eat` represents the relationship between the vertex `Person` and the vertex `Restaurant`.

When you create the edge from this class, note that the orientation of the vertices is important, because it gives the relationship its meaning. For instance, creating an edge in the opposite direction, (from `Restaurant` to `Person`), would call for a separate class, such as `Attendee`.

The user Luca eats at the pizza joint Dante. Create an edge that represents this connection:

<pre>
orientdb> <code class="lang-sql userinput">CREATE EDGE Eat FROM ( SELECT FROM Person WHERE name='Luca' )
          TO ( SELECT FROM Restaurant WHERE name='Dante' )</code>
</pre>

#### Creating Edges from Record ID

In the event that you know the [Record ID](Concepts.md#recordid) of the vertices, you can connect them directly with a shorter and faster command. For example, the person Bill also eats at the restaurant Dante and the person Jay eats at the restaurant Charlie. Create edges in the class `Eat` to represent these connections. 

<pre>
orientdb> <code class="lang-sql userinput">CREATE EDGE Eat FROM #11:1 TO #12:0</code>

orientdb> <code class="lang-sql userinput">CREATE EDGE Eat FROM #11:2 TO #12:1</code>
</pre>


#### Querying Graphs

In the above example you created and populated a small graph of a social network of individual users and the restaurants at which they eat. You can now begin to experiment with queries on a graph database.

To cross edges, you can use special graph functions, such as:

- `OUT()` To retrieve the adjacent outgoing vertices
- `IN()` To retrieve the adjacent incoming vertices
- `BOTH()` To retrieve the adjacent incoming and outgoing vertices

For example, to know all of the people who eat in the restaurant Dante, which has a Record ID of `#12:0`, you can access the record for that restaurant and traverse the incoming edges to discover which entries in the `Person` class connect to it.

<pre>
orientdb> <code class="lang-sql userinput">SELECT IN() FROM Restaurant WHERE name='Dante'</code>

-------+----------------+
 @RID  | in             |
-------+----------------+
 #-2:1 | [#11:0, #11:1] |
-------+----------------+
</pre>

This query displays the record ID's from the `Person` class that connect to the restaurant Dante. In cases such as this, you can use the `EXPAND()` special function to transform the vertex collection in the result-set by expanding it.


<pre>
orientdb> <code class="lang-sql userinput">SELECT EXPAND( IN() ) FROM Restaurant WHERE name='Dante'</code>

-------+-------------+-------------+---------+
 @RID  | @CLASS      | Name        | out_Eat |
-------+-------------+-------------+---------+
 #11:0 | Person      | Luca        | #12:0   |
 #11:1 | Person      | Bill        | #12:0   |
-------+-------------+-------------+---------+
</pre>

#### Creating Edge to Connect Users

Your application at this point shows connections between individual users and the restaurants they patronize. While this is interesting, it does not yet function as a social network. To do so, you need to establish edges that connect the users to one another.

To begin, as before, create a new class that extends `E`:

<pre>
orientdb> <code class="lang-sql userinput">CREATE CLASS Friend EXTENDS E</code>
</pre>

The users Luca and Jay are friends. They have Record ID's of ``#11:0`` and ``#11:2``. Create an edge that connects them.

<pre>
orientdb> <code class="lang-sql userinput">CREATE EDGE Friend FROM #11:0 TO #11:2</code>
</pre>

In the `Friend` relationship, orientation is not important. That is, if Luca is a friend of Jay's then Jay is a friend of Luca's. Therefore, you should use the `BOTH()` function.

<pre>
orientdb> <code class="lang-sql userinput">SELECT EXPAND( BOTH( 'Friend' ) ) FROM Person WHERE name = 'Luca'</code>

-------+-------------+-------------+---------+-----------+
 @RID  | @CLASS      | Name        | out_Eat | in_Friend |
-------+-------------+-------------+---------+-----------+
 #11:2 | Person      | Jay         | #12:1   | #11:0     |
-------+-------------+-------------+---------+-----------+
</pre>

Here, the `BOTH()` function takes the edge class `Friend` as an argument, crossing only relationships of the Friend kind, (that is, it skips the `Eat` class, at this time). Note in the result-set that the relationship with Luca, with a Record ID of `#11:0` in the `in_` field.

You can also now view all the restaurants patronized by friends of Luca.

<pre>
orientdb> <code class="lang-sql userinput">SELECT EXPAND( BOTH('Friend').out('Eat') ) FROM Person
          WHERE name='Luca'</code>

-------+-------------+-------------+-------------+--------+
 @RID  | @CLASS      | Name        | Type        | in_Eat |
-------+-------------+-------------+-------------+--------+
 #12:1 | Restaurant  | Charlie     | French      | #11:2  |
-------+-------------+-------------+-------------+--------+
</pre>

## Lightweight Edges

In version 1.4.x, OrientDB begins to manage some edges as Lightweight Edges. Lightweight Edges do not have Record ID's, but are physically stored as links within vertices. Note that OrientDB only uses a Lightweight Edge only when the edge has no properties, otherwise it uses the standard Edge.

From the logic point of view, Lightweight Edges are Edges in all effects, so that all graph functions work with them. This is to improve performance and reduce disk space.

Because Lightweight Edges don't exist as separate records in the database, some queries won't work as expected. For instance,

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM E</code>
</pre>

For most cases, an edge is used connecting vertices, so this query would not cause any problems in particular. But, it would not return Lightweight Edges in the result-set. In the event that you need to query edges directly, including those with no properties, disable the Lightweight Edge feature.

To disable the Lightweight Edge feature, execute the following command.

<pre>
orientdb> <code class="lang-sql userinput">ALTER DATABASE CUSTOM useLightweightEdges=FALSE
</pre>

You only need to execute this command once. OrientDB now generates new edges as the standard Edge, rather than the Lightweight Edge. Note that this does not affect existing edges.

For troubleshooting information on Lightweight Edges, see [Why I can't see all the edges](Troubleshooting.md#why-cant-i-see-all-the-edges). For more information in the Graph model in OrientDB, see [Graph API](Graph-Database-Tinkerpop.md).
