# Lightweight Edges

OrientDB supports **Lightweight Edges** as regular edges, but without an identity on database. Lightweight edges can be used only when no properties are defined on edge.

By avoiding the creation of the underlying Document, **Lightweight Edges** have the same impact on speed and space as with Document [LINKs](Concepts.md#relationships), but with the additional bonus to have bidirectional connections. This means you can use the MOVE VERTEX command to refactor your graph with no broken LINKs.

## Regular Edge representation
Look at the figure below. With Regular Edges both vertices (#10:33 and #10:12) are connected through an Edge Document (#17:11). The outgoing `out_Friend` property in #10:33 document is a set of [LINKs](Concepts.md#relationships) with #17:11 as item. Instead, in document #10:12 the relationship is as incoming, so the property `in_Friend` is used with the [LINK](Concepts.md#relationships) to the same Edge #17:11.

When you cross this relationship, OrientDB loads the Edge document #17:11 to resolve the other part of the relationship.

```
+---------------------+    +---------------------+    +---------------------+  
|   Account Vertex    |    |     Friend Edge     |    |    Account Vertex   |
|       #10:33        |    |       #17:11        |    |       #10:12        |
+---------------------+    +---------------------+    +---------------------+
|out_Friend: [#17:11] |<-->|out: [#10:33]        |    |                     |
+---------------------+    |         in: [#10:12]|<-->|in_Friend: [#17:11]  |
                           +---------------------+    +---------------------+
```

## Lightweight Edge representation
With Lightweight Edge, instead, there is no Edge document, but both vertices (#10:33 and #10:12) are connected directly to each other. The outgoing `out_Friend` property in #10:33 document contains the direct [LINK](Concepts.md#relationships) to the vertex #10:12. The same happens on Vertex document #10:12, where the relationship is as incoming and the property `in_Friend` contains the direct [LINK](Concepts.md#relationships) to vertex #10:33.

When you cross this relationship, OrientDB doesn't need to load any edge to resolve the other part of the relationship. Furthermore no edge document is created.
```
+---------------------+    +---------------------+
|   Account Vertex    |    |    Account Vertex   |
|       #10:33        |    |       #10:12        |
+---------------------+    +---------------------+
|out_Friend: [#10:12] |<-->|in_Friend: [#10:33]  |
+---------------------+    +---------------------+
```

Starting from OrientDB v2.0, **Lightweight Edges** are disabled by default with new databases. This is because having regular edges makes easier to act on edges from SQL. Many issues from beginner users were on **Lightweight Edges**. If you want to use **Lightweight Edges**, enable it via API:

```java
OrientGraph g = new OrientGraph("mygraph");
g.setUseLightweightEdges(true);
```

Or via [SQL](SQL-Alter-Database.md):

```sql
ALTER DATABASE custom useLightweightEdges=true
```

Changing `useLightweightEdges` setting to `true`, will not transform previous edges, but all new edges could be **Lightweight Edges** if they meet the requirements.

## When use Lightweight Edges?

These are the PROS and CONS of Lightweight Edges vs Regular Edges:

PROS:
- faster in creation and traversing, because don't need an additional document to keep the relationships between 2 vertices

CONS:
- cannot store properties
- harder working with Lightweight edges from SQL, because there is no a regular document under the edge
