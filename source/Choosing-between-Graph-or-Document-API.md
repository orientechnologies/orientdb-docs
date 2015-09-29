# Graph or Document API?
In OrientDB, we created 2 different APIs: Document API and Graph API. The Graph API works on top of the Document API. The Document API contains the Document, Key/Value and Object Oriented models.

``` 
         YOU, THE USER

    ||                 ||
   _||_                ||
   \  /                ||
    \/                _||_
+-------------+       \  /
|  Graph API  |        \/
+-------------+-----------------+
|         Document API          |
+-------------------------------+
| Key/Value and Object Oriented |
+-------------------------------+
```

## Graph API 
With OrientDB 2.0, we improved our Graph API to support [all models in just one Multi-Model](Tutorial-Document-and-graph-model.md) API. This API usually covers 80% of use cases, so this could be the default API you should use if you're starting with OrientDB.

In this way:
- Your Data ('records' in the RDBMS world) is modeled as Vertices and Edges. You can store properties on both.
- You can still work in Schema-Less, Schema-Full or Hybrid modes.
- Relationships are modeled as Bidirectional Edges. If Lightweight edge setting is active, OrientDB uses [Lightweight Edges](Lightweight-Edges.md) in cases where edges have no properties, so it has the same impact on speed and space as with Document LINKs, but with the additional bonus to have bidirectional connections. This means you can use the `MOVE VERTEX` command to refactor your graph with no broken LINKs. For more information how Edges are managed look at [Lightweight Edges](Lightweight-Edges.md).

## Document API

What about the remaining 20%? In the case where you need a Document Database (keeping the additional OrientDB features, like LINKs) or you come from the Document Database world, using the Document API could be the right choice. 

These are the Pros and Cons:
- The Document API is simpler than the Graph API in general.
- Relationships are only Mono Directional. If you need Bidirectional relationships, it is your responsibility to maintain both LINKs.
- A Document is an atomic unit, while with Graphs everything is connected as In & Out. For this reason, Graph operations must be done within Transactions. Instead, when you create a relationship between documents with a LINK, the target linked document is not involved in this operation. This results in better Multi-Thread support, especially with insert, deletes and updates operations.