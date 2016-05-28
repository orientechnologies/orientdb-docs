# Graph Batch Insert

Creating big graphs in OrientDB is a common operation, so OrientDB provides some APIs to make it fast and easy.


## Basic use case

For a basic use case, where your graph fits in the following constraints:
- a single vertex class
- a single edge class
- vertices are identified by a numeric (Long) id
- no properties on vertices and edges
OrientDB provides an API called OGraphBatchInsertBasic


This API is designed for fast batch import of simple graphs, starting from an empty (or non existing) DB. 

These limitations are intended to have best performance on a very simple use case. If there limitations don't fit your
requirements you can rely on other implementations 

### Typical usage: 

```
   OGraphBatchInsertSimple batch = new OGraphBatchInsertSimple("plocal:your/db", "admin", "admin");
   batch.begin();
   batch.createEdge(0L, 1L);
   batch.createEdge(0L, 2L);
   ...
   batch.end();
 ```

There is no need to create vertices before connecting them: 

```
   batch.createVertex(0L);
   batch.createVertex(1L);
   batch.createEdge(0L, 1L);
 ```

is equivalent to (but less performing than)


```
   batch.createEdge(0L, 1L);
```

batch.createVertex() is needed only if you want to create unconnected vertices.







