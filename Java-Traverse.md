---
search:
   keywords: ['Java API', 'traverse', 'traversal']
---

# Traverse

OrientDB is a Graph database.  This means that its focal point is on relationships, (that is, links), and on managing them. The standard SQL language is not sufficient to work with trees or graphs, as it lacks the concept of recursion.  For this reason, the OrientDB subset of SQL implements a dedicated command for tree traversal: [`TRAVERSE`](SQL-Traverse.md).

Traversal operations cross relationships between records, (that is, documents, vertices, nodes, and so on).  This operation runs much faster than the Relational database solution of executing a `JOIN`.

The main concepts in traversal are:

- **Target**: Defines where you want to begin traversing records, which can be a [class](Concepts.md#class), [cluster](Concepts.md#cluster), or a set of records defined by their [Record ID's](Concepts.md#record-id).

  You can also use any sub-query that returns an iterable `OIdentifiable` object, such as when nesting multiple [`SELECT`](SQL-Query.md) and [`TRAVERSE`](SQL-Traverse.md) queries together.

- **Fields**: Defines the fields you want to traverse.  If you want to traverse all fields in a document, use `*`, `any()` or `all()`.

- **Limit**: Defines the maximum number of records to retrieve.

- **Predicate** Defines an operation you want to execute against each traversed document.  If the predicate returns `true`, the document is returned, otherwise it is skipped.

- **Strategy**: Defines how you want to traverse the graph, which can be [`DEPTH_FIRST`](#depthfirst-stragety) or [`BREADTH_FIRST`](#breadthfirst-strategy).


## Traversal Strategies

When issuing a traversal query to OrientDB, you can define the particular strategy for the traversal path that it uses.  For instance, OrientDB can traverse down a particular branch to its maximum depth first, then backtrack, or it can traverse each child node then search the next level down.  Which to use depends on the specific needs of your application.


### `DEPTH_FIRST` Strategy

By default, OrientDB traverses to depth first.  That is, it explores as far as possible through each branch before backtracking to the next.

This process is implemented using recursion.  For more information, see [Depth-First algorithm](http://en.wikipedia.org/wiki/Depth-first_search).

The diagram below shows the ordered steps OrientDB executes while traversing a graph using `DEPTH_FIRST` strategy.

![Depth-first-tree](http://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Depth-first-tree.svg/600px-Depth-first-tree.svg.png)

### `BREADTH_FIRST` Strategy

With this strategy, OrientDB inspects all neighboring nodes, then for each of those neighboring nodes in turn it inspects their neighboring nodes, which were unvisited, and so on.


Compare **BREADTH_FIRST** with the equivalent, but more memory-efficient iterative deepening depth first search and contrast it with [`DEPTH_FIRST`](#depth-first-search) search. For more information, see [Breadth-First algorithm](http://en.wikipedia.org/wiki/Breath-first_search).

The diagram below shows the ordered steps OrientDB executes while traversing a graph using `BREADTH_FIRST` strategy.

![Breadth-first-tree](http://upload.wikimedia.org/wikipedia/commons/thumb/3/33/Breadth-first-tree.svg/600px-Breadth-first-tree.svg.png)

## Context Variables

During traversal, OrientDB provides context variables, which you can use in traversal conditions:

| Variable | Description |
|---|---|
| `$depth` | Provides an integer indicating nesting depth in the tree.  The first level is 0. |
| `$path` | Provides a string representation of the current position as a sum of the traversed nodes. |
| `$stack` | Provides a stack of the current traversed nodes. |
| `$history` | Provides the entire collection of visited nodes. |


## Traversal Methods

The following sections describe various traversal methods.

### SQL Traverse

The simplest method available in executing a traversal is to use the SQL [`TRAVERSE`](SQL-Traverse.md) command.

For example, say that you have a `Movie` class and you want to retrieve all connected `from` and `to` records up to the fifth level in depth.  You might use something like this,

```java
for (OIdentifiable id : 
      new OSQLSynchQuery<ODocument>(
         "TRAVERSE in, out FROM Movie WHILE $depth <= 5"
      )) {
   System.out.println(id);
}
```

For more information on traversal in SQL, see [`TRAVERSE`](SQL-Traverse.md).


### Native Fluent API

The Native API supports fluent execution, which guarantees a compact and readable syntax.  The main class is `OTraverse`.

| Method | Description |
|---|---|
| `target(<iter:Iterable<OIdentifiable>>)` | Specifies the target as any iterable object, such as collections or arrays of `OIdentifiable` objects. |
| `target(<iter:Iterator<OIdentifiable>>)` | Specifies the target as any iterator object.  To specify a class, use `database.browseClass(<class-name>).iterator()`. |
| `target(<record:OIdentifiable>. <record:OIdentifiable>,...)` | Specifies the target as a variable array of `OIterable` objects. |
| `field(<field-name:string>)` | Specifies the document field to traverse.  To add multiple fields, call this method in a chain.  For instance, `.field("in").field("out")`. |
| `fields(<field-name:string>, <field-name:string>,...)` | Specifies multiple fields in on call, passing a variable array of strings. |
| `fields(Collection<field-name:string>)` | Specifies multiple fields in one call, passing a collection of strings. |
| `limit(<max:int>)` | Defines the maximum number of records to return. |
| `predicate(<predicate:OCommandPredicate>)` | Specifies a predicate command to execute against each traversed record.  If the predicate returns `true`, then it returns the record, otherwise it skips the record.  It's common to create an anonymous class specifying the predicate on the fly. |
| `predicate(<predicate:OSQLPredicate>)` | Specifies the predicate using SQL syntax. |

Into the traverse command context `iContext` you can read or put any variable.  The traverse command updates the following variables:

- **`$depth`** Provides the current nesting depth.

- **`$path`** Provides the string representation of the current path.  You can also display it.  For instance,

  ```sql
  SELECT $path FROM (TRAVERSE * FROM V)
  ```

- **`$stack`** Provides a list of operations in the stack.  You can use it to access the traversal history.  It's a `List<OTraverseAbstractProcess<?>>` where the process implementations are:

  - `OTraverseRecordSetProcess` Represents the first.  It's the base target of the traversal. 
  - `OTraverseRecordProcess` Represents a traversed record.
  - `OTraverseFieldProcess` Represents a traversal through a record's field.
  - `OTRaverseMultiValueProcess` Represents fields that are multi-value: arrays, collections and maps.

- **`$history`** Provides the set of records traversed as a `Set<RID>`. 

#### Examples

- Using an anonymous `OCommandPredicate` as predicate:

  ```java
  for (OIdentifiable id : new OTraverse()
                .field("in").field("out")
                .target( database.browseClass("Movie")
                .iterator() )
                .predicate(new OCommandPredicate() {

           public Object evaluate(ORecord iRecord,
                 ODocument iCurrentResult, 
                 OCommandContext iContext) {
              return ((Integer) iContext
                 .getVariable("depth")) <= 5;
           }
  })) {

     System.out.println(id);
  }
  ```

- Using the `OSQLPredicate` as predicate:


  ```java
  for (OIdentifiable id : new OTraverse()
              .field("in").field("out")
              .target(database.browseClass("Movie").iterator())
              .predicate( new OSQLPredicate("$depth <= 5"))) {

  System.out.println(id);
  }
  ```

`OTraverse gets` any Iterable, Iterator and Single/Multi `OIdentifiable`. There's also the `limit()` clause. To specify multiple fields use `fields()`. Full example:

```java
for (OIdentifiable id : new OTraverse()
              .target(new ORecordId("#6:0"), new ORecordId("#6:1"))
              .fields("out", "in")
              .limit(100)
              .predicate( new OSQLPredicate("$depth <= 10"))) {

  System.out.println( id);
}
```
