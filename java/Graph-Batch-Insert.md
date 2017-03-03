---
search:
   keywords: ['Graph API', 'batch insert', 'bulk load', 'bulk insert', 'OGraphBatchInsertBasic', 'OGraphBatchInsert']
---

# Graph Batch Insert

Creating big graphs in OrientDB is a common operation, so OrientDB provides some APIs to make it fast and easy.


## Basic use case

For a basic use case, where your graph fits in the following constraints:

- a single vertex class
- a single edge class
- vertices are identified by a numeric (Long) id
- no properties on vertices and edges

OrientDB provides an API called [OGraphBatchInsertBasic]({{javadoc}}com/orientechnologies/orient/graph/batch/OGraphBatchInsertBasic.html).

This API is designed for fast batch import of simple graphs, starting from an empty (or non existing) DB. 

These limitations are intended to have best performance on a very simple use case. If these limitations do not fit your requirements you can rely on other implementations. 


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

is equivalent to (but less performing than):


```
   batch.createEdge(0L, 1L);
```

`batch.createVertex()` is needed only if you want to create unconnected vertices.


## Slightly more complex use case

For a use case, where your graph fits in the following constraints:

- a single vertex class
- a single edge class
- vertices are identified by a numeric (Long) id
- edges and/or vertices have properties 

OrientDB provides an API called [OGraphBatchInsert]({{javadoc}}com/orientechnologies/orient/graph/batch/OGraphBatchInsert.html).

This API is designed for fast batch import of simple graphs, starting from an empty (or non existing) DB. 

This batch insert procedure is made of four phases, that have to be executed in the correct order:
 
 1. begin(): initializes the database
 2. create edges (with or without properties) and vertices
 3. set properties on vertices
 4. end(): flushes data to db

 
### Typical usage: 

```
OGraphBatchInsert batch = new OGraphBatchInsert("plocal:your/db", "admin", "admin");
 
//phase 1: begin
batch.begin();
  
//phase 2: create edges
Map<String, Object> edgeProps = new HashMap<String, Object>();
edgeProps.put("foo", "bar");
batch.createEdge(0L, 1L, edgeProps);
batch.createVertex(2L);
batch.createEdge(3L, 4L, null);
...
  
//phase 3: set properties on vertices, THIS CAN BE DONE ONLY AFTER EDGE AND VERTEX CREATION
Map<String, Object> vertexProps = new HashMap<String, Object>();
 vertexProps.put("foo", "bar");
batch.setVertexProperties(0L, vertexProps);
...
  
//phase 4: end
batch.end();
```
 
There is no need to create vertices before connecting them:
  
```
    batch.createVertex(0L);
    batch.createVertex(1L);
    batch.createEdge(0L, 1L, props);
```
 
is equivalent to (but less performing than):
  
```
    batch.createEdge(0L, 1L, props);
```

`batch.createVertex(Long)` is needed only if you want to create unconnected vertices.


