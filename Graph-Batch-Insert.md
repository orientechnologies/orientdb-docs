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
OrientDB provides an API called OGraphBatchInsertBasic


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

OrientDB provides an API called [OGraphBatchInsert](http://orientdb.com/javadoc/latest/com/orientechnologies/orient/graph/batch/OGraphBatchInsert.html).

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



## Custom Batch Insert

Creating graphs consists mainly of two operations:

- creating vertices
- connecting them with edges

Adding a single edge to an existing database actually consists of three operations:

- creating the edge document
- updating the left vertex to point to the edge 
- updating the right vertex to point to the edge 

and typically, at low level, it's even more complex:

- load vertex1 by key (index lookup)
- load vertex2 by key (index lookup)
- create edge document setting out = vertex1.@rid and in = vertex2.@rid
- add the edge RID to vertex1.out_EdgeClass
- add the edge RID to vertex2.in_EdgeClass
 
As a result, the creation of an edge can be considered an expensive operation compared to a simple document creation.

In some circumstances, the batch graph creation can be made faster. 

Taking into consideration that RIDs are assigned sequentially for clusters, that edges and vertices are just ODocuments and that `out_*` and `in_*` properties for vertices can be manually manipulated at document level, in some circumstances (based on your specific domain structure) you can write a custom piece of code that "predicts" RIDs that will be assigned to edge and vertex documents, and do the edge creation as a single write operation.

Below a simple example.

Suppose that you have to create a graph like the following:

```
Vertex1 -Edge1-> Vertex2 -Edge2-> Vertex3
```

Vertex class is `VertexClass` and edge class is `EdgeClass`.

Let's suppose that vertices will be inserted in cluster `9 (cluster vertexclass)` and that edges will be inserted in cluster `10 (cluster edgeclass)`. Let's also suppose that both clusters are empty and newly created.

If you insert all the vertices in the given order, you will be sure that:
 
- Vertex1 will have @RID = #9:0
- Vertex2 will have @RID = #9:1
- Vertex3 will have @RID = #9:2

If you insert all the edges in the given order, you will be sure that:

- Edge1 will have @RID = #10:0
- Edge2 will have @RID = #10:1

This said, you can use the Document API to create the graph structure:

```
ORecordId ridVertex1 = new ORecordId(9L, 0L); // #9:0, the RID of Vertex1, that still does not exist
ORecordId ridVertex2 = new ORecordId(9L, 1L); // #9:1, the RID of Vertex2, that still does not exist
ORecordId ridVertex3 = new ORecordId(9L, 2L); // #9:2, the RID of Vertex3, that still does not exist

ORecordId ridEdge1 = new ORecordId(10L, 0L); // #10:0, the RID of Edge1, that still does not exist
ORecordId ridEdge2 = new ORecordId(10L, 1L); // #10:1, the RID of Edge2, that still does not exist

ODocument vertex1 = new ODocument("VertexClass");
vertex1.field("foo", "bar");// set property names and values
ORidBag outBag1 = new ORidBag();
outBag1.add(ridEdge1); // add the RID of the corresponding outgoing edge
vertex1.field("out_EdgeClass", outBag1);
db.save(vertex1, "vertexclass"); //make sure that you are saving on the right cluster (vertexclass)

/*
At this point, in the databse you have a single record (#9:0) that represents a vertex.
You know that the record RID is #9:0 because it's the first record created in cluster 9.
The vertex points to an edge (#10:0) that still does not exist and that will be created later
*/



ODocument vertex2 = new ODocument("VertexClass");
vertex2.field("foo", "bar");// set property names and values
ORidBag outBag2 = new ORidBag();
outBag2.add(ridEdge2); // add the RID of the corresponding outgoing edge
vertex2.field("out_EdgeClass", outBag2);
ORidBag inBag2 = new ORidBag();
inBag2.add(ridEdge1); // add the RID of the corresponding incoming edge
vertex2.field("in_EdgeClass", inBag2);
db.save(vertex2, "vertexclass"); //make sure that you are saving on the right cluster

ODocument vertex3 = new ODocument("VertexClass");
vertex3.field("foo", "bar");// set property names and values
ORidBag inBag3 = new ORidBag();
inBag3.add(ridEdge2); // add the RID of the corresponding incoming edge
vertex3.field("in_EdgeClass", inBag3);
db.save(vertex3, "vertexclass"); //make sure that you are saving on the right cluster

ODocument edge1 = new ODocument("EdgeClass");
edge1.field("foo", "bar"); //set edge fields
edge1.field("out", ridVertex1); //set pointers to the right vertices
edge1.field("in", ridVertex2);
db.save(edge1, "edgeclass"); //make sure that you are saving on the right cluster (edgeclass)

ODocument edge2 = new ODocument("EdgeClass");
edge2.field("foo", "bar"); //set edge fields
edge2.field("out", ridVertex2); //set pointers to the right vertices
edge2.field("in", ridVertex3);
db.save(edge2, "edgeclass"); //make sure that you are saving on the right cluster
```

As you can see, this batch insert consists of exactly five write (insert) operations, and no load and update operations are made.

Saving documents with links to other not (yet) existing documents is allowed, so saving a vertex that points 
to a non existing edge will result in a correct operation. The graph consistency will be restored as soon as you create the edge.

