---
search:
   keywords: ['SQL', 'TRAVERSE']
---

# SQL - `TRAVERSE`

Retrieves connected records crossing relationships.  This works with both the Document and Graph API's, meaning that you can traverse relationships between say invoices and customers on a graph, without the need to model the domain using the Graph API.

| | |
|----|-----|
|![](images/warning.png)| In many cases, you may find it more efficient to use [`SELECT`](SQL-Query.md), which can result in shorter and faster queries.  For more information, see [`TRAVERSE` versus `SELECT`](#traverse-versus-select) below.|

**Syntax**

```sql
TRAVERSE <[class.]field>|*|any()|all()
         [FROM <target>]
         [
           MAXDEPTH <number>
           |
           WHILE <condition> 
         ]
         [LIMIT <max-records>]
         [STRATEGY <strategy>]
```

- **[`<fields>`](#Fields)** Defines the fields you want to traverse.
- **[`<target>`](#Target)** Defines the target you want to traverse.  This can be a class, one or more clusters, a single Record ID, set of Record ID's, or a sub-query.
- **`MAXDEPTH`** Defines the maximum depth of the traversal.  `0` indicates that you only want to traverse the root node.  Negative values are invalid.
- **`WHILE`** Defines the condition for continuing the traversal while it is true.  
- **`LIMIT`** Defines the maximum number of results the command can return.
- **[`STRATEGY`](Java-Traverse.md#traversing-strategies)** Defines strategy for traversing the graph.

>**NOTE**: The use of the [`WHERE`](SQL-Where.md) clause has been deprecated for this command.

>**NOTE**: There is a difference between `MAXDEPTH N` and `WHILE DEPTH <= N`: the `MAXDEPTH` will evaluate exactly N levels, while the `WHILE` will evaluate N+1 levels and will discard the N+1th, so the `MAXDEPTH` in general has better performance.


**Examples**

In a social network-like domain, a user profile is connected to friends through links.  The following examples consider common operations on a user with the record ID `#10:1234`.

- Traverse all fields in the root record:

  <pre>
  orientdb> <code class="lang-sql userinput">TRAVERSE * FROM #10:1234</code>
  </pre>

- Specify fields and depth up to the third level, using the [`BREADTH_FIRST`](Java-Traverse.md#traversing-strategies) strategy:

  <pre>
  orientdb> <code class="lang-sql userinput">TRAVERSE out("Friend") FROM #10:1234 WHILE $depth &lt;= 3 
            STRATEGY BREADTH_FIRST</code>
  </pre>

- Execute the same command, this time filtering for a minimum depth to exclude the first target vertex:

  <pre>
  orientdb> <code class="lang-sql userinput">SELECT FROM (TRAVERSE out("Friend") FROM #10:1234 WHILE $depth &lt;= 3) 
            WHERE $depth >= 1</code>
  </pre>

  >**NOTE**: You can also define the maximum depth in the [`SELECT`](SQL-Query.md) command, but it's much more efficient to set it at the inner [`TRAVERSE`](SQL-Traverse.md) statement because the returning record sets are already filtered by depth.

- Combine traversal with [`SELECT`](SQL-Query.md) command to filter the result-set.  Repeat the above example, filtering for users in Rome:

  <pre>
  orientdb> <code class="lang-sql userinput">SELECT FROM (TRAVERSE out("Friend") FROM #10:1234 WHILE $depth &lt;= 3) 
            WHERE city = 'Rome'</code>
  </pre>

- Extract movies of actors that have worked, at least once, in any movie produced by J.J. Abrams:

  <pre>
  orientdb> <code class='lang-sql userinput'>SELECT FROM (TRAVERSE out("Actors"), out("Movies") FROM (SELECT FROM 
            Movie WHERE producer = "J.J. Abrams") WHILE $depth &lt;= 3) WHERE 
            @class = 'Movie'</code>
  </pre>

- Display the current path in the traversal:

  <pre>
  orientdb> <code class='lang-sql userinput'>SELECT $path FROM ( TRAVERSE out() FROM V WHILE $depth &lt;= 10 )</code>
  </pre>



## Supported Variables

### Fields

Defines the fields that you want to traverse.  If set to `*`, `any()` or `all()` then it traverses all fields.  This can prove costly to performance and resource usage, so it is recommended that you optimize the command to only traverse the pertinent fields.

In addition tot his, you can specify the fields at a class-level.  [Polymorphism](Inheritance.md) is supported.  By specifying `Person.city` and the class `Customer` extends person, you also traverse fields in `Customer`.

Field names are case-sensitive, classes not.

### Target

Targets for traversal can be,
- **`<class>`** Defines the class that you want to traverse.  
- **`CLUSTER:<cluster>`** Defines the cluster you want to traverse.
- **`<record-id>`** Individual root Record ID that you want to traverse.
- **`[<record-id>,<record-id>,...]`** Set of Record ID's that you want to traverse.  This is useful when navigating graphs starting from the same root nodes.

### Context Variables

In addition to the above, you can use the following context variables in traversals:
- **`$parent`** Gives the parent context, if any.  You may find this useful when traversing from a sub-query. 
- **`$current`** Gives the current record in the iteration.  To get the upper-level record in nested queries, you can use `$parent.$current`.
- **`$depth`** Gives the current depth of nesting.
- **`$path`** Gives a string representation of the current path.  For instance, `#5:0#.out`.  You can also display it through [`SELECT`](SQL-Query.md):
  <pre>
  orientdb> <code class="lang-sql userinput">SELECT $path FROM (TRAVERSE * FROM V)</code>
  </pre>
- **`$stack`** Gives a list of operations in the stack.  Use it to access the traversal history.  It's a `List<OTraverseAbstractProcess<?>>`, where the process implementations are:
  - *`OTraverseRecordSetProcess`*  The base target of traversal, usually the first given.
  - *`OTraverseRecordProcess`* The traversed record.
  - *`OTraverseFieldProcess`* The traversal through the record's fields.
  - *`OTraverseMultiValueProcess`* Use on fields that are multivalue, such as arrays, collections and maps.
- **`$history`** Gives a set of records traversed as `SET<ORID>`.


## Use Cases

### `TRAVERSE` versus `SELECT`

When you already know traversal information, such as relationship names and depth-level, consider using [`SELECT`](SQL-Query.md) instead of [`TRAVERSE`](SQL-Traverse.md) as it is faster in some cases. 

For example, this query traverses the `follow` relationship on Twitter accounts, getting the second level of friendship:

<pre>
orientdb> <code class='lang-sql userinput'>SELECT FROM (TRAVERSE out('follow') FROM TwitterAccounts WHILE 
          $depth &lt;= 2) WHERE $depth = 2</code>
</pre>

But, you could also express this same query using [`SELECT`](SQL-Query.md) operation, in a way that is also shorter and faster:

<pre>
orientdb> <code class="lang-sql userinput">SELECT out('follow').out('follow') FROM TwitterAccounts</code>
</pre>

### `TRAVERSE` with the Graph Model and API

While you can use the [`TRAVERSE`](SQL-Traverse.md) command with any domain model, it provides the greatest utility in [Graph Databases[(Graph-Database-Tinkerpop.md) model.

This model is based on the concepts of the Vertex (or Node) as the class `V` and the Edge (or Arc, Connection, Link, etc.) as the class `E`.  If you want to traverse in a direction, you have to use the class name when declaring the traversing fields.  The supported directions are:

- **Vertex to outgoing edges**  Using `outE()` or `outE('EdgeClassName')`.  That is, going out from a vertex and into the outgoing edges.
- **Vertex to incoming edges**  Using `inE()` or `inE('EdgeClassName')`.  That is, going from a vertex and into the incoming edges.
- **Vertex to all edges**  Using `bothE()` or `bothE('EdgeClassName')`.  That is, going from a vertex and into all the connected edges.
- **Edge to Vertex (end point)** Using `inV()` .  That is, going out from an edge and into a vertex.
- **Edge to Vertex (starting point)** Using `outV()` .  That is, going back from an edge and into a vertex.
- **Edge to Vertex (both sizes)** Using `bothV()` .  That is, going from an edge and into connected vertices.
- **Vertex to Vertex (outgoing edges)** Using `out()` or `out('EdgeClassName')`. This is the same as  `outE().inV()`
- **Vertex to Vertex (incoming edges)** Using `in()` or `in('EdgeClassName')`. This is the same as  `outE().inV()`
- **Vertex to Vertex (all directions)** Using `both()` or `both('EdgeClassName')`. 


For instance, traversing outgoing edges on the record `#10:3434`:

<pre>
orientdb> <code class="lang-sql userinput">TRAVERSE out() FROM #10:3434</code>
</pre>

In a domain for emails, to find all messages sent on January 1, 2012 from the user Luca, assuming that they are stored in the vertex class `User` and that the messages are contained in the vertex class `Message`.  Sent messages are stored as `out` connections on the edge class `SentMessage`:

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM (TRAVERSE outE(), inV() FROM (SELECT FROM User WHERE 
          name = 'Luca') WHILE $depth <= 2 AND (@class = 'Message' or 
          (@class = 'SentMessage' AND sentOn = '01/01/2012') )) WHERE 
          @class = 'Message'</code>
</pre>

## Deprecated `TRAVERSE` Operator

Before the introduction of the [`TRAVERSE`](SQL-Traverse.md) command, OrientDB featured a `TRAVERSE` operator, which worked in a different manner and was applied to the [`WHERE`](SQL-Where.md) condition.

More recent releases deprecated this operator.  It is recommended that you transition to the [`TRAVERSE`](SQL-Traverse.md) command with [`SELECT`](SQL-Query.md) queries to utilize more power.

The deprecated syntax for the `TRAVERSE` operator looks like this:

| | |
|----|-----|
|![](images/warning.png)|WARNING: Beginning in version 2.1, OrientDB no longer supports this syntax.|

**Syntax**

```
SELECT FROM <target> WHERE <field> TRAVERSE[(<minDeep> [,<maxDeep> [,<fields>]])] (<conditions>)
```

- **`<target>`** Defines the query target.
- **`<field>`** Defines the field to traverse. Supported fields are,
  - *`out`* Gives outgoing edges.
  - *`in`* Gives incoming edges.
  - *`any()`* Any field, including `in` and `out`.
  - *`all()`* All fields, including `in` and `out`.
  - Any attribute of the vertex.
- *`minDeep`* Defines the minimum depth-level to begin applying the conditions.  This is usually `0` for the root vertex, or `1` for only the outgoing vertices.
- **`maxDeep`** Defines  the maximum depth-level to read.  Default is `-1`, for infinite depth.
- **`[<field>, <field>,...]`** Defines a list of fields to traverse.  Default is `any()`.
- **`<conditions>`** Defines conditions to check on any traversed vertex.  

>For more information, see [SQL syntax](SQL-Where.md).

**Examples**

- Find all vertices that have at least one friend, (connected through `out`), up to the third depth, that lives in Rome:

  <pre>
  orientdb> <code class='lang-sql userinput'>SELECT FROM Profile WHERE any() TRAVERSE(0,3) (city = 'Rome')</code>
  </pre>

- Alternatively, you can write the above as:

  <pre>
  orientdb> <code class='lang-sql userinput'>SELECT FROM Profile LET $temp = (SELECT FROM (TRAVERSE * FROM $current
            WHILE $depth &lt;= 3) WHERE city = 'Rome') WHERE $temp.size() > 0</code>
  </pre>

- Consider an example using the Graph Query, with the following schema:

  ```
  Vertex    edge         Vertex
  User----->Friends----->User
            Label='f'
  ```

- Find the first-level friends of the user with the Record ID `#10:11`:
 
  <pre>
  orientdb> <code class='lang-sql userinput'>SELECT DISTINCT(in.lid) AS lid,distinct(in.fid) AS fid FROM 
            (TRAVERSE outE(), inV() FROM #10:11 WHILE $depth &lt;=1) WHERE 
            @class = 'Friends'</code>
  </pre>

- By changing the depth to 3, you can find the second-level friends of the user:

  <pre>
  orientdb> <code class="lang-sql userinput">SELECT distinct(in.lid) AS lid, distinct(in.fid) AS fid FROM 
            (TRAVERSE outE(), inV() FROM #10:11 WHILE $depth &lt;=3) WHERE 
            @class = 'Friends'</code>
  </pre>

>For more information, see
>- [Java-Traverse](Java-Traverse.md) page.
>- [SQL Commands](SQL.md)
