---
search:
   keywords: ['concept', 'Graph API', 'Document API']
---

<!-- proofread 2015-11-26 SAM -->
# Graph or Document API?

**(legacy, please refer to [MultiModel API](Java-MultiModel-API.md))**

In OrientDB, we created 2 different APIs: the Document API and the Graph API. The Graph API works on top of the Document API. The Document API contains the Document, Key/Value and Object Oriented models. The Graph API handles the Vertex and Edge relationships.

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
With OrientDB 2.0, we improved our Graph API to support [all models in just one Multi-Model](Tutorial-Document-and-graph-model.md) API. This API will probably cover 80% of your database use cases, so it should be your "go to" API, if you're starting with OrientDB.

Using the Graph API:
- Your Data ('records' in the RDBMS world) will be modeled as Vertices and Edges. You can store properties in both.
- You can still work in Schema-Less, Schema-Full or Hybrid modes.
- Relationships are modeled as Bidirectional Edges. If the Lightweight edge setting is active, OrientDB uses [Lightweight Edges](Lightweight-Edges.md) in cases where edges have no properties, so it has the same impact on speed and space as with Document LINKs, but with the additional bonus of having bidirectional connections. This means you can use the `MOVE VERTEX` command to refactor your graph with no broken LINKs. For more information how Edges are managed, please refer to [Lightweight Edges](Lightweight-Edges.md).

## Document API

What about the remaining 20% of your database use cases? Should you need a Document Database (while retaining the additional OrientDB features, like LINKs) or come from the Document Database world, using the Document API could be the right choice. 

These are the Pros and Cons of using the Document API:

- The Document API is simpler than the Graph API in general.
- Relationships are only mono-directional. If you need bidirectional relationships, it is your responsibility to maintain both LINKs.
- A Document is an atomic unit, while with Graphs, the relationships are modeled through In and Out properties. For this reason, Graph operations must be done within transactions. In contrast, when you create a relationship between documents with a LINK, the targeted linked document is not involved in this operation. This results in better Multi-Threaded support, especially with insert, delete and update operations.
