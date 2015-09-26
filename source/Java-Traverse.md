# Traverse

OrientDB is a graph database. This means that the focal point is on relationships (links) and how they are managed. The standard SQL language is not enough to work with trees or graphs because it lacks the recursion concept. This is the reason why OrientDB provides a new command to traverse trees and graphs: TRAVERSE. Traversing is the operation that crosses relationships between records (documents, vertexes, nodes, etc). This operation is much much faster than executing a JOIN in a Relational database.

The main concepts of Traversal are:
- **target**, as the starting point where to traverse records. Can be:
 - **[class](Concepts.md#class)**
 - **[cluster](Concepts.md#cluster)**
 - **set of records**, specifying its [RecordID](Concepts.md#recordid)
 - **sub-command** that returns an <code>Iterable&lt;OIdentifiable&gt;</code>. You can nest multiple [select](SQL-Query.md) and [traverse](SQL-Traverse.md) all together
- **fields**, the fields to traverse. Use <code>*</code>, <code>any()</code> or <code>all()</code> to traverse all fields in a document
- **limit**, the maximum number of records to retrieve
- **predicate**, as the predicate to execute against each traversed document. If the predicate returns true, the document is returned, otherwise it is skipped
- **strategy**, indicates how the graph traversed:
 - *[DEPTH_FIRST](https://github.com/orientechnologies/orientdb/wiki/Java-Traverse#depth_first-strategy)*, the default,
 - *[BREADTH_FIRST](https://github.com/orientechnologies/orientdb/wiki/Java-Traverse#breadth_first-strategy)*,

### Traversing strategies
#### DEPTH_FIRST strategy
This is the default strategy used by OrientDB for traversal. It explores as far as possible along each branch before backtracking. It's implemented using recursion. To know more look at [Depth-First algorithm](http://en.wikipedia.org/wiki/Depth-first_search). Below the ordered steps executed while traversing the graph using *BREADTH_FIRST* strategy:

![Depth-first-tree](http://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Depth-first-tree.svg/600px-Depth-first-tree.svg.png)

#### BREADTH_FIRST strategy
It inspects all the neighboring nodes, then for each of those neighbor nodes in turn, it inspects their neighbor nodes which were unvisited, and so on. Compare **BREADTH_FIRST** with the equivalent, but more memory-efficient iterative deepening **DEPTH_FIRST** search and contrast with **DEPTH_FIRST** search. To know more look at [Breadth-First algorithm](http://en.wikipedia.org/wiki/Breadth-first_search). Below the ordered steps executed while traversing the graph using *Depth-First* strategy:

![Breadth-first-tree](http://upload.wikimedia.org/wikipedia/commons/thumb/3/33/Breadth-first-tree.svg/600px-Breadth-first-tree.svg.png)

### Context variables

During traversal some context variables are managed and can be used by the traverse condition:
- **$depth**, as an integer that contain the depth level of nesting in traversal. First level is 0
- **$path**, as a string representation of the current position as the sum of traversed nodes
- **$stack**, as the stack current node traversed
- **$history**, as the entire collection of visited nodes

The following sections describe various traversal methods.

## SQL Traverse

The simplest available way to execute a traversal is by using the [SQL Traverse command](SQL-Traverse.md). For instance, to retrieve all records connected **from** and **to** **Movie** records up to the **5th level of depth**:
```java
for (OIdentifiable id : new OSQLSynchQuery<ODocument>("traverse in, out from Movie while $depth <= 5")) {
  System.out.println(id);
}
```

Look at the [command syntax](SQL-Traverse.md) for more information.

## Native Fluent API

Native API supports fluent execution guaranteeing compact and readable syntax. The main class is **<code>OTraverse</code>**:
- **<code>target(&lt;iter:Iterable&lt;OIdentifiable&gt;&gt;)</code>**, to specify the target as any iterable object like collections or arrays of OIdentifiable objects.
- **<code>target(&lt;iter:Iterator&lt;OIdentifiable&gt;&gt;)</code>**, to specify the target as any iterator object. To specify a class use <code>database.browseClass(&lt;class-name&gt;).iterator()</code>
- **<code>target(&lt;record:OIdentifiable&gt;, &lt;record:OIdentifiable&gt;, ... )</code>**, to specify the target as a var ars of OIterable objects
- **<code>field(&lt;field-name:string&gt;)</code>**, to specify the document's field to traverse. To add multiple field call this method in chain. Example: <code>.field("in").field("out")</code>
- **<code>fields(&lt;field-name:string&gt;, &lt;field-name:string&gt;, ...)</code>**, to specify multiple fields in one call passing a var args of Strings
- **<code>fields(Collection&lt;field-name:string&gt;)</code>**, to specify multiple fields in one call passing a collection of String
- **<code>limit(&lt;max:int&gt;)</code>**, as the maximum number of record returned
- **<code>predicate(&lt;predicate:OCommandPredicate&gt;)</code>**, to specify a predicate to execute against each traversed record. If the predicate returns true, then the record is returned as result, otherwise false. it's common to create an anonymous class specifying the predicate at the fly
- **<code>predicate(&lt;predicate:OSQLPredicate&gt;)</code>**, to specify the predicate using the SQL syntax.

In the traverse command context iContext you can read/put any variable. Traverse command updates these variables:
- **depth**, as the current depth of nesting
- **path**, as the string representation of the current path. You can also display it. Example: <code>select $path from (traverse * from V)</code>
- **stack**, as the List of operation in the stack. Use it to access to the history of the traversal. It's a <code>List&lt;OTraverseAbstractProcess&lt;?&gt;&gt;</code> where process implementations are:
 - **<code>OTraverseRecordSetProcess</code>**, usually the first one it's the base target of traverse
 - **<code>OTraverseRecordProcess</code>**, represent a traversed record
 - **<code>OTraverseFieldProcess</code>**, represent a traversal through a record's field
 - **<code>OTraverseMultiValueProcess</code>**, use on fields that are multivalue: arrays, collections and maps
- **history**, as the set of records traversed as a <code>Set&lt;ORID&gt;</code>.

### Example using an anonymous OCommandPredicate as predicate

```java
for (OIdentifiable id : new OTraverse()
              .field("in").field("out")
              .target( database.browseClass("Movie").iterator() )
              .predicate(new OCommandPredicate() {

    public Object evaluate(ORecord iRecord, ODocument iCurrentResult, OCommandContext iContext) {
      return ((Integer) iContext.getVariable("depth")) <= 5;
    }
  })) {

  System.out.println(id);
}
```

### Example using the OSQLPredicate as predicate

```java
for (OIdentifiable id : new OTraverse()
              .field("in").field("out")
              .target(database.browseClass("Movie").iterator())
              .predicate( new OSQLPredicate("$depth <= 5"))) {

  System.out.println(id);
}
```

### Other examples

OTraverse gets any Iterable, Iterator and Single/Multi OIdentifiable. There's also the limit() clause. To specify multiple fields use fields(). Full example:
```java
for (OIdentifiable id : new OTraverse()
              .target(new ORecordId("#6:0"), new ORecordId("#6:1"))
              .fields("out", "int")
              .limit(100)
              .predicate( new OSQLPredicate("$depth <= 10"))) {

  System.out.println( id);
}
```
