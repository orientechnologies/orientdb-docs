---
search:
   keywords: ['Graph API', 'Lightweight Edge', 'edge']
---

# Lightweight Edges

In OrientDB Graph databases, there are two types of edges available: 

- [**Regular Edges**](#regular-edge-representation), which are instances or extensions of the `E` class and have their own records on the database.
- [**Lightweight Edges**](#lightweight-edge-representation), which have no properties and have no identity on the database, since they only exist within the vertex records.

The advantage of Lightweight Edges lies in performance and disk usage.  Similar to [links](Concepts.md#relationships), because it doesn't create the underlying document it runs faster and saves on space, with the addition of allowing for bidirectional connections.  This allows you to use the [`MOVE VERTEX`](SQL-Move-Vertex.md) command to refactor your graph without breaking any links.

>**NOTE**: Beginning in version 2.0, OrientDB disables Lightweight Edges by default.


## Edge Representations

In order to better understand edges and their use, consider the differences in how OrientDB handles and stores them in records.  The examples below show a Graph Database built to form a social network where you need to connect to `Account` vertices by an edge to indicate that one user is friends with another.


### Regular Edge Representation

When building a social network using regular edges, the edge exists as a separate record, which is either an instance of `E` or an extension of that class.

```
+---------------------+    +---------------------+    +---------------------+  
|   Account Vertex    |    |     Friend Edge     |    |    Account Vertex   |
|       #10:33        |    |       #17:11        |    |       #10:12        |
+---------------------+    +---------------------+    +---------------------+
|out_Friend: [#17:11] |<-->|out: [#10:33]        |    |                     |
+---------------------+    |         in: [#10:12]|<-->|in_Friend: [#17:11]  |
                           +---------------------+    +---------------------+
```

When using regular edges, the vertices are connected through an edge document.  Here, the account vertices for users #10:33 and #10:12 are connected by the edge class instance #17:11, which indicates that the first user is friends with the second.  The outgoing `out_Friend` property on #10:33 and the incoming `in_Friend` property on #10:12 each take #17:11 as a link to that edge.  

When you cross this relationship, OrientDB loads the edge document #17:11  to resolve the other side of the relationship.


### Lightweight Edge Representation

When building a social network using Lightweight Edges, the edge doesn't exist as a document, but rather are connected directly to each other through properties on the relevant vertices.

```
+---------------------+    +---------------------+
|   Account Vertex    |    |    Account Vertex   |
|       #10:33        |    |       #10:12        |
+---------------------+    +---------------------+
|out_Friend: [#10:12] |<-->|in_Friend: [#10:33]  |
+---------------------+    +---------------------+
```

When using Lightweight Edges, instead of an edge document, each vertex (here, #10:33 and #10:12), are connected directly to each other.  The outgoing `out_Friend` property in the #10:30 document contains the direct link to the vertex #10:12.  The occurs in #10:12, where the incoming `in_Friend` property contains a direct link to #10:30.

When you cross this relationship, OrientDB can register the relationship without needing to load a third record to resolve the relationship, thus it doesn't create an edge document.

#### Enabling Lightweight Edges

Beginning in version 2.0, OrientDB disables Lightweight Edges by default on new databases.  The reasoning behind this decision is that it is easier for users and applications to operate on OrientDB from SQL when the edges are regular edges.  Enabling it by default created a number of issues with beginners just starting out with OrientDB who were unprepared for how it handles Lightweight Edges.

In the event that you would like to restore Lightweight Edges as the default, you can do so by updating the database.  From the Java API, add the following lines:


```java
OrientGraph g = new OrientGraph("mygraph");
g.setUseLightweightEdges(true);
```

You can do the same from the Console using the [`ALTER DATABASE`](SQL-Alter-Database.md) command:

<pre>
orientdb> <code class="lang-sql userinput">ALTER DATABASE custom useLightweightEdges=true</code>
</pre>

Note that changing the `useLightweightEdges` to `true` does not update or transform any existing edges on the database.  They remain in the same state they held before you issued the command.  That said, all new edges you create after running the above commands are Lightweight Edges.



## Lightweight Edges vs. Regular Edges


There are advantages and disadvantages to using Lightweight Edges.  You should consider these before switching your application over to one or the other:

**Advantages**

- *Faster Creation and Traversal*: Given that OrientDB can operate on the relationship between two vertices without needing to load any additional documents, it's able to create and traverse relationships faster with Lightweight Edges than it can with Regular Edges.

**Disadvantages**

- *Edge Properties*: Given that Lightweight Edges do not have records of their own, you cannot assign properties to the edge.
- *SQL Issues*: It is more difficult to interact with OrientDB through SQL given that there is no document underlying the edges.




