# Working with Graphs

We already met the [Graph Model](Tutorial-Document-and-graph-model.md#graph-model) a few pages ago. Now we have all the basic knowledge needed to work with OrientDB as a GraphDB! This requires the graph edition of OrientDB. Connect to the `GratefulDeadConcerts` database for experimentation. It contains the concerts performed by the "[Grateful Dead](http://en.wikipedia.org/wiki/Grateful_Dead)" band.

### Create Vertexes and Edges

OrientDB comes with a generic Vertex persistent class called `V` and `E` for Edge. You can create a new Vertex with:

<pre>
orientdb> <code class="lang-sql userinput">INSERT INTO V SET name='Jay'</code>

Created record with RID #9:0
</pre>

In effect, the GraphDB model works on top of the underlying Document model, so all the stuff you have learned until now (Records, Relationships, etc.) remains valid. But in order to simplify the management of the graph we've created special commands, so don't use the SQL Insert command anymore to create a new vertex. Instead, use the ad-hoc `CREATE VERTEX` command:

<pre>
orientdb> <code class="lang-sql userinput">CREATE VERTEX V SET name='Jay'</code>

Created vertex with RID #9:1
</pre>

By using graph commands, OrientDB takes care of ensuring that the graph remains always consistent. All the Graph commands are:

- [CREATE VERTEX](SQL-Create-Vertex.md)
- [DELETE VERTEX](SQL-Delete-Vertex.md)
- [CREATE EDGE](SQL-Create-Edge.md)
- [DELETE EDGE](SQL-Delete-Edge.md)

### Create custom Vertices and Edges classes

Even though you can work with Vertices and Edges, OrientDB provides the possibility to extend the `V` and `E` classes. The pros of this approach are:

- better understanding about meaning of entities
- optional constraints at class level
- performance: better partitioning of entities
- object-oriented inheritance among graph elements

So from now on, we will avoid using plain `V` and `E` and will always create custom classes. Let's develop an example graph to model a social network based on restaurants:

<pre>
orientdb> <code class="lang-sql userinput">CREATE CLASS Person EXTENDS V</code>

orientdb> <code class="lang-sql userinput">CREATE CLASS Restaurant EXTENDS V</code>
</pre>

Now that the schema has been created let's populate the graph with some vertices:

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

Before we connect them using edges, let's go create a new Edge type:

<pre>
orientdb> <code class="lang-sql userinput">CREATE CLASS Eat EXTENDS E</code>
</pre>

This will represent the relationship from Person to Restaurant. The orientation is important when you create an edge because it gives the meaning of the relationship. If we wanted to model the edge in the opposite orientation, from Restaurant to Person, we might call the Edge class "Attendee", or something similar.

Now let's create a connection between person "Luca" and restaurant "Dante":

<pre>
orientdb> <code class="lang-sql userinput">CREATE EDGE Eat FROM ( SELECT FROM Person WHERE name='Luca' )
          TO ( SELECT FROM Restaurant WHERE name='Dante' )</code>
</pre>

If you know the [RID](Concepts.md#recordid) of vertices you can connect them with a shorter and faster command. Below we will connect "Bill" with the same "Dante" Restaurant and 'Jay' to 'Charlie' Restaurant:

<pre>
orientdb> <code class="lang-sql userinput">CREATE EDGE Eat FROM #11:1 TO #12:0</code>

orientdb> <code class="lang-sql userinput">CREATE EDGE Eat FROM #11:2 TO #12:1</code>
</pre>

Now that our small graph has been created let's play with queries. To cross edges we can use special graph functions like:

- `OUT()`, to retrieve the adjacent outgoing vertices
- `IN()`, to retrieve the adjacent incoming vertices
- `BOTH()`, to retrieve the adjacent incoming and outgoing vertices

To know all the people who eat in the "Dante" restaurant (RID = #12:0), we can get Dante's record and then traverse the incoming edges to discover the Person records connected:

<pre>
orient> <code class="lang-sql userinput">SELECT IN() FROM Restaurant WHERE name='Dante'</code>

-------+----------------
 @RID  | in 
-------+----------------
 #-2:1 | [#11:0, #11:1]
-------+----------------
</pre>

Those are the RIDs of the Person instances connected. In these cases the `EXPAND()` special function becomes very useful to transform the collection of vertices in the resultset by expanding it:

<pre>
orientdb> <code class="lang-sql userinput">SELECT EXPAND( IN() ) FROM Restaurant WHERE name='Dante'</code>

-------+-------------+-------------+---------
 @RID  | @CLASS      | Name        | out_Eat
-------+-------------+-------------+---------
 #11:0 | Person      | Luca        | #12:0
 #11:1 | Person      | Bill        | #12:0
-------+-------------+-------------+---------
</pre>

Much better! Now let's create the new relationship "Friend" to connect people:

<pre>
orientdb> <code class="lang-sql userinput">CREATE CLASS Friend EXTENDS E</code>
</pre>

And connect "Luca" with "Jay":

<pre>
orientdb> <code class="lang-sql userinput">CREATE EDGE Friend FROM #11:0 TO #11:2</code>
</pre>

"Friend" relationship is one of these edge types where the orientation is not important: if "Luca" is a friend of "Jay" the opposite is usually true, so the orientation looses importance. To discover Luca's friends, we should use the `BOTH()` function:

<pre>
orientdb> <code class="lang-sql userinput">SELECT EXPAND( BOTH( 'Friend' ) ) FROM Person WHERE name = 'Luca'</code>

-------+-------------+-------------+---------+-----------
 @RID  | @CLASS      | Name        | out_Eat | in_Friend 
-------+-------------+-------------+---------+-----------
 #11:2 | Person      | Jay         | #12:1   | #11:0
-------+-------------+-------------+---------+-----------
</pre>

In this case I've passed the Edge's class "Friend" as argument of the `BOTH()` function to cross only the relationships of kind "Friend" (so skip the "Eat" this time). Note also in the result set that the relationship with "Luca" (RID = #11:0) is in the `in_` field.

Now let's make things more complicated. Get all the restaurants where Luca's friends go.

<pre>
orientdb> <code class="lang-sql userinput">SELECT EXPAND( BOTH('Friend').out('Eat') ) FROM Person
          WHERE name='Luca'</code>

-------+-------------+-------------+-------------+---------
 @RID  | @CLASS      | Name        | Type        | in_Eat
-------+-------------+-------------+-------------+---------
 #12:1 | Restaurant  | Charlie     | French      | #11:2
-------+-------------+-------------+-------------+---------
</pre>

Cool, isn't it?

## Lightweight edges

Starting from OrientDB v1.4.x edges, by default, are managed as **lightweight edges**: they don't have own identities as record, but are physically stored as links inside vertices. OrientDB automatically uses Lightweight edges only when edges have no properties, otherwise regular edges are used. From the logic point of view, **lightweight edges** are edges at all the effects, so all the graph functions work correctly. This is to improve performance and reduce the space on disk. But as a consequence, since lightweight edges don't exist as separate records in the database, the following query will not return the lightweight edges:

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM E</code>
</pre>

In most of the cases Edges are used from Vertices, so this doesn't cause any particular problem. In case you need to query Edges directly, even those with no properties, disable **lightweight** edge feature by executing this command once:

<pre>
orientdb> <code class="lang-sql userinput">ALTER DATABASE CUSTOM useLightweightEdges=FALSE
</pre>

This will only take effect for new edges. For more information look at: [Why I can't see all the edges](https://github.com/orientechnologies/orientdb/wiki/Troubleshooting#why-i-cant-see-all-the-edges).


For more information look at [Graph API](Graph-Database-Tinkerpop.md).
