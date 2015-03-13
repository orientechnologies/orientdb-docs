# SQL - TRAVERSE

**Traverse** is a special command that retrieves the connected records crossing the relationships. This command works not only with graph API but at document level. This means you can traverse relationships between invoice and customers without the need to model the domain using the Graph API.

To know more look at [Java-Traverse](Java-Traverse.md) page.

| | |
|----|-----|
|![](images/warning.png)|In many cases SELECT can be used instead of TRAVERSE, resulting in faster and shorter query. Take a look at [Should I use TRAVERSE or SELECT?](SQL-Traverse.md#should-i-use-traverse-or-select)|

## Syntax

```sql
TRAVERSE <[class.]field>|*|any()|all()
         [FROM <target>]
         [LET <Assignment>*]
         WHILE <condition>
         [LIMIT <max-records>]
         [STRATEGY <strategy>]
```

- **[fields](#Fields)** are the list of fields you want to traverse
- **[target](#Target)** can be a class, one or more clusters, a single [RID](Concepts.md#recordid), a set of [RID](Concepts.md#recordid)s or another command like another TRAVERSE (as recursion) or a [SELECT](SQL-Query.md)
- **[LET](SQL-Query.md#let_block)** is the part that bind context variables to be used in projections, conditions or sub-queries
- **[while](SQL-Where.md)** condition to continue the traversing while it's true. Usually it's used to limit the traversing depth by using `$depth` where x is the maximum level of depth you want to reach. **$depth** is the first context variable that reports the depth level during traversal. *NOTE: the old 'where' keyword is deprecated*
- **max-records** sets the maximum result the command can return
- **[strategy](Java-Traverse.md#traversing-strategies)**, to specify how to traverse the graph

### Fields

Are the list of fields you want to traverse. If `*`, any() or all() are specified then all the fields are traversed. This could be costly so to optimize the traverse use the pertinent fields. You can also specify fields at class level. [Polymorphism](Inheritance.md) is supported, so by specifying Person.city and Customer class extends Person, you will traverse Customer instances too.

Field names are case-sensitive, classes not.

### Target

Target can be:
- **Class** is the class name to browse all the record to be traversed. You can avoid to specify **class:** as prefix
- **Cluster** with the prefix 'cluster:' is the cluster name where to execute the query
- A set of [RID](Concepts.md#recordid)s inside square brackets to specify one or a small set of records. This is useful to navigate graphs starting from some root nodes
- A root record specifying its [RID](Concepts.md#recordid)

### Context

Traverse command uses the following variables in the context:
- **$parent**, to access to the parent's context if any. This is useful when the Traverse is called in a sub-query
- **$current**, current record iterated. To access to the upper level record in nested queries use $parent.$current
- **$depth**, as the current depth of nesting
- **$depth**, as the current depth of nesting
- **$path**, as the string representation of the current path. Example <code>#6:0.in.#5:0#.out</code>. You can also display it with -> <code>select $path from (traverse ** from V)</code>
- **$stack**, as the List of operation in the stack. Use it to access to the history of the traversal. It's a List<OTraverseAbstractProcess<?>> where process implementations are:
 - **OTraverseRecordSetProcess**, usually the first one it's the base target of traverse
 - **OTraverseRecordProcess**, represent a traversed record
 - **OTraverseFieldProcess**, represent a traversal through a record's field
 - **OTraverseMultiValueProcess**, use on fields that are multivalue: arrays, collections and maps
- **$history**, as the set of all the records traversed as a <code>Set&lt;ORID&gt;</code>.

## Examples

### Traverse all the fields of a root record

Assuming #10:1234 is the [RID](Concepts.md#rid) of the record to start traversing:
```sql
traverse * from #10:1234
```

### Social Network domain

In a social-network-like domain a profile is linked to all the friends. Below some commands.

#### Specify fields and depth level

Assuming #10:1234 is the [RID](Concepts.md#rid) of the record to start traversing get all the friends up to the third level of depth using the [BREADTH_FIRST](Java-Traverse.md#traversing-strategies) strategy:
```sql
traverse friends from #10:1234 while $depth <= 3 strategy BREADTH_FIRST
```

In case you want to filter per minimum depth create a predicate in the select. Example like before but excluding the first target vertex (#10:1234):
```sql
select from ( traverse friends from #10:1234 while $depth <= 3 ) where $depth >= 1
```

*NOTE: You can also define the maximum depth in the SELECT clause but it's much more efficient to set it at the inner TRAVERSE statement because the returning record sets are already filtered by depth*

#### Mix with select to have more power

Traverse command can be combined with [SQL SELECT](SQL-Query.md) statement to filter the result set. Below the same example above but filtering by Rome as city:
```sql
select from ( traverse friends from #10:1234 while $depth <= 3 ) where city = 'Rome'
```

Another example to extract all the movies of actors that have worked, at least once, in any movie produced by J.J. Abrams:
```sql
select from (
  traverse Movie.actors, Actor.movies from (
    select from Movie where producer = "J.J. Abrams"
  ) while $depth <= 3
) where @class = 'Movie'
```

### Display the current path

To return or use the current path in traversal refer to the **$path** variable:
```sql
select $path from ( traverse out from V while $depth <= 10 )
```

## Should I use TRAVERSE or SELECT?
If traversing information, such as relationship names and depth level, are known at priori, please consider using SELECT instead of TRAVERSE. SELECT is faster on this case. Example:

This query traverses the "follow" relationship of Twitter accounts getting the 2nd level of friendship:
```sql
SELECT FROM (
  TRAVERSE out('follow') FROM TwitterAccounts WHERE $depth <= 2
) WHERE $depth = 2
```

But can be expressed also with SELECT and it's shorter and faster:
```sql
SELECT out('follow').out('follow') FROM TwitterAccounts
```

## Using TRAVERSE with Graph model and API

Even if the TRAVERSE command can be used with any domain model, the place where is more used is the [Graph-Database](Graph-Database.md) model.

Following this model all is based on the concepts of the Vertex (or Node) as the class "V" and the Edge (or Arc, Connection, Link, etc.) as the class "E". So if you want to traverse in a direction you have to use the class name when declare the traversing fields. Below the directions:
- **OUTGOING**, use <code>V.out, E.in</code> because vertices are connected with the "out" field but the edge exits as "in" field.
- **INCOMING**, use <code>V.in, E.out</code> because vertices are connected with the "in" field but the edge enters as "out" field.

Example of traversing all the outgoing vertices found starting from the vertex with id #10:3434:
```sql
traverse V.out, E.in from #10:3434
```

So in a mailing-like domain to find all the messages sent in 1/1/2012 from the user 'Luca' assuming it's stored in the 'User' Vertex class and that messages are contained in the 'Message' Vertex class. Sent messages are stored as "out" connections of Edge class 'SentMessage':

```sql
select from (
  traverse V.out, E.in from (
    select from User where name = 'Luca'
  ) while $depth <= 2 and (@class = 'Message' || ( @class = 'SentMessage' and sentOn = '01/01/2012') )
) where @class = 'Message'
```

## Operator TRAVERSE

Before the introducing of TRAVERSE command OrientDB has the TRAVERSE operator but worked in the opposite way and it was applied in the WHERE condition.

TRAVERSE operator is deprecated. Please use the TRAVERSE command together with SELECT command to have much more power!

The syntax of the old TRAVERSE operator was:
```sql
SELECT FROM <target> WHERE <field> TRAVERSE[(<minDeep> [,<maxDeep> [,<fields>]])] (<conditions>)
```

| | |
|----|-----|
|![](images/warning.png)|WARNING: THIS SYNTAX WILL NOT BE SUPPORTED ANYMORE IN v. 2.1|


Where:
- **target** can be one of [listed above](#Query_target)
- **field** can be:
 - **out**, as the outgoing edges
 - **in**, as the incoming edges
 - **any attribute of the vertex**
 - **any()**, means any of the field considering also **in** and **out**
 - **all()**, means all the fields considering also **in** and **out**
- **minDeep** is the minimum deep level to start to apply the conditions. Usually is 0 for the root vertex or 1 for the just-outgoing vertexes
- **maxDeep**, optionally limits the maximum deep level to reach. -1 means infinite. Default is -1
- **fields**, optionally tells the field list to traverse. Default is any()
- **conditions** are the conditions to check for any traversed vertex. To know more about the query syntax see [SQL syntax](http://code.google.com/p/orient/wiki/SQLWhere)

### Examples

Example of a query that returns all the vertices that have at least one friend (connected with out), up to the 3rd degree, that lives in Rome:

```sql
select from Profile where any() traverse(0,3) (city = 'Rome')
```

This can be rewritten using the most power TRAVERSE command:
```sql
select from Profile
let $temp = (
  select from (
    traverse * from $current while $depth <= 3
  )
  where city = 'Rome'
)
where $temp.size() > 0
```
### Examples Of Graph Query.

Vertex    edge         Vertex
User----->Friends----->User
          Label='f'

#### Query to Find the first level friends of User Whose record Id is #10:11
```sql
select distinct(in.lid) as lid,distinct(in.fid) as fid   from (traverse V.out, E.in from #10:11 while $depth <=1) where @class='Friends'
```

#### 2nd level friends of a user, to find that we have to just change the depth to 3

```sql
SELECT distinct(in.lid) as lid, distinct(in.fid) as fid FROM (
  TRAVERSE V.out, E.in FROM #10:11 WHILE $depth <=3
) WHERE @class='Friends'
```

To know more about other SQL commands look at [SQL commands](SQL.md).