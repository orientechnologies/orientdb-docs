# SQL - `MATCH`

Queries the database in a declarative manner, using pattern matching.  This feature was introduced in version 2.2.

**Simplified Syntax**


```
MATCH 
  {
    [class: <class>], 
    [as: <alias>], 
    [where: (<whereCondition>)]
  }
  .<functionName>(){
    [class: <className>], 
    [as: <alias>], 
    [where: (<whereCondition>)], 
    [while: (<whileCondition>)]
    [maxDepth: <number>]
  }*
RETURN <alias> [, <alias>]*
LIMIT <number>
```

- **`<class>`** Defines a valid target class.
- **`as: <alias>`** Defines an alias for a node in the pattern.
- **`<whereCondition>`** Defines a filter condition to match a node in the pattern.  It supports the normal SQL [`WHERE`](SQL-Where.md) clause.  You can also use the `$currentMatch` and `$matched` [context variables](#context-variables).
- **`<functionName>`** Defines a graph function to represent the connection between two nodes.  For instance, `out()`, `in()`, `outE()`, `inE()`, etc.
For out(), in(), both() also a shortened *arrow* syntax is supported: 
  - `{...}.out(){...}` can be written as `{...}-->{...}`
  - `{...}.out("EdgeClass"){...}` can be written as `{...}-EdgeClass->{...}`
  - `{...}.in(){...}` can be written as `{...}<--{...}`
  - `{...}.in("EdgeClass"){...}` can be written as `{...}<-EdgeClass-{...}`
  - `{...}.both(){...}` can be written as `{...}--{...}`
  - `{...}.both("EdgeClass"){...}` can be written as `{...}-EdgeClass-{...}`
- **`<whileCondition>`** Defines a condition that the statement must meet to allow the traversal of this path.  It supports the normal SQL [`WHERE`](SQL-Where.md) clause.  You can also use the `$currentMatch`, `$matched` and `$depth` [context variables](#context-variables).  For more information, see [Deep Traversal While Condition](#deep-traversal-while-condition), below.
- **`<maxDepth>`** Defines the maximum depth for this single path.
- **`RETURN <alias>`** Defines elements in the pattern that you want returned.  It can use one of the following:
  - Aliases defined in the `as:` block.
  - `$matches` Indicating all defined aliases.
  - `$paths` Indicating the full traversed paths.

**BNF Syntax**

```
MatchStatement     := ( <MATCH> MatchExpression ( <COMMA> MatchExpression )* <RETURN> Identifier ( <COMMA> Identifier )* ( Limit )? )
	
MatchExpression	   := ( MatchFilter ( ( MatchPathItem | MultiMatchPathItem ) )* )
	
MatchPathItem	   := ( MethodCall ( MatchFilter )? )
	
MatchPathItemFirst := ( FunctionCall ( MatchFilter )? )
	
MultiMatchPathItem := ( <DOT> <LPAREN> MatchPathItemFirst ( MatchPathItem )* <RPAREN> ( MatchFilter )? )
	
MatchFilter        := ( <LBRACE> ( MatchFilterItem ( <COMMA> MatchFilterItem )* )? <RBRACE> )
	
MatchFilterItem    := ( ( <CLASS> <COLON> Expression )  | ( <AS> <COLON> Identifier ) | ( <WHERE> <COLON> <LPAREN> ( WhereClause ) <RPAREN> ) | ( <WHILE> <COLON> <LPAREN> ( WhereClause ) <RPAREN> ) | ( <MAXDEPTH> <COLON> Integer ) )
```

**Examples**

The following examples are based on this sample data-set from the class `People`:

![](images/match-example-table.png)

![](images/match-example-graph.png)

- Find all people with the name John:

  <pre>
  orientdb> <code class="lang-sql userinput">MATCH {class: Person, as: people, where: (name = 'John')} 
            RETURN people</code>

  ---------
    people 
  ---------
    #12:0
    #12:1
  ---------
  </pre>

- Find all people with the name John and the surname Smith:

  <pre>
  orientdb> <code class="lang-sql userinput">MATCH {class: Person, as: people, where: (name = 'John' AND 
            surname = 'Smith')} RETURN people</code>

  -------
  people
  -------
   #12:1
  -------
  </pre>


- Find people named John with their friends:

  <pre>
  orientdb> <code class="lang-sql userinput">MATCH {class: Person, as: person, where: 
            (name = 'John')}.both('Friend') {as: friend} 
            RETURN person, friend</code>

  --------+---------
   people | friend 
  --------+---------
   #12:0  | #12:1
   #12:0  | #12:2
   #12:0  | #12:3
   #12:1  | #12:0
   #12:1  | #12:2
  --------+---------
  </pre>
 

- Find friends of friends:

  <pre>
  orientdb> <code class="lang-sql userinput">MATCH {class: Person, as: person, where: (name = 'John' AND
            surname = 'Doe')}.both('Friend').both('Friend')
			{as: friendOfFriend} RETURN person, friendOfFriend</code>

  --------+----------------
   people | friendOfFriend 
  --------+----------------
   #12:0  | #12:0
   #12:0  | #12:1
   #12:0  | #12:2
   #12:0  | #12:3
   #12:0  | #12:4
  --------+----------------
  </pre>
  
  
- Find people, excluding the current user:
  
  <pre>
  orientdb> <code class="lang-sql userinput">MATCH {class: Person, as: person, where: (name = 'John' AND 
            surname = 'Doe')}.both('Friend').both('Friend'){as: friendOfFriend,
			where: ($matched.person != $currentMatch)} 
			RETURN person, friendOfFriend</code>

  --------+----------------
   people | friendOfFriend
  --------+----------------
   #12:0  | #12:1
   #12:0  | #12:2
   #12:0  | #12:3
   #12:0  | #12:4
  --------+----------------
  </pre>
  
- Find friends of friends to the sixth degree of separation:
  
  <pre>
  orientdb> <code class="lang-sql userinput">MATCH {class: Person, as: person, where: (name = 'John' AND 
            surname = 'Doe')}.both('Friend'){as: friend, 
			where: ($matched.person != $currentMatch) while: ($depth < 6)} 
			RETURN person, friend</code>

  --------+---------
   people | friend
  --------+---------
   #12:0  | #12:0
   #12:0  | #12:1
   #12:0  | #12:2
   #12:0  | #12:3
   #12:0  | #12:4
  --------+---------
  </pre>


- Finding friends of friends to six degrees of separation, since a particular date:

  <pre>
  orientdb> <code class="lang-sql userinput">MATCH {class: Person, as: person, 
            where: (name = 'John')}.(bothE('Friend'){
			where: (date < ?)}.bothV()){as: friend, 
			while: ($depth < 6)} RETURN person, friend</code>
  </pre>
  
  In this case, the condition ``$depth < 6`` refers to traversing the block ``bothE('Friend')`` six times.


- Find friends of my friends who are aslo my friends, using multiple paths:

  <pre>
  orientdb> <code class="lang-sql userinput">MATCH {class: Person, as: person, where: (name = 'John' AND 
            surname = 'Doe')}.both('Friend').both('Friend'){as: friend},
			{ as: person }.both('Friend'){ as: friend } 
			RETURN person, friend</code>

  --------+--------
   people | friend
  --------+--------
   #12:0  | #12:1
   #12:0  | #12:2
  --------+--------
  </pre>
  
  In this case, the statement matches two expression: the first to friends of friends, the second to direct friends.  Each expression shares the common aliases (`person` and `friend`). To match the whole statement, the result must match both expressions, where the alias values for the first expression are the same as that of the second.

- Find common friends of John and Jenny:

  <pre>
  orientdb> <code class="lang-sql userinput">MATCH {class: Person, where: (name = 'John' AND 
            surname = 'Doe')}.both('Friend'){as: friend}.both('Friend')
			{class: Person, where: (name = 'Jenny')} RETURN friend</code>

  --------
   friend
  --------
   #12:1
  --------
  </pre>
  
  The same, with two match expressions:

  <pre>
  orientdb> <code class="lang-sql userinput">MATCH {class: Person, where: (name = 'John' AND 
            surname = 'Doe')}.both('Friend'){as: friend}, 
			{class: Person, where: (name = 'Jenny')}.both('Friend')
			{as: friend} RETURN friend</code>
  </pre>



## Context Variables

When running these queries, you can use any of the following context variables:

| Variable | Description |
|---|---|
|`$matched`| Gives the current matched record.  You must explicitly define the attributes for this record in order to access them.  You can use this in the `where:` and `while:` conditions to refer to current partial matches or as part of the `RETURN` value.|
|`$currentMatch`| Gives the current complete node during the match.|
|`$depth`| Gives the traversal depth, following a single path item where a `while:` condition is defined.|



## Use Cases


### Expanding Attributes

You can run this statement as a sub-query inside of another statement.  Doing this allows you to obtain details and aggregate data from the inner [`SELECT`](SQL-Query.md) query.

<pre>
orientdb> <code class="lang-sql userinput">SELECT person.name AS name, person.surname AS surname,
          friend.name AS friendName, friend.surname AS friendSurname
		  FROM (MATCH {class: Person, as: person,
		  where: (name = 'John')}.both('Friend'){as: friend}
		  RETURN person, friend)</code>

--------+----------+------------+---------------
 name   | surname  | friendName | friendSurname
--------+----------+------------+---------------
 John   | Doe      | John       | Smith
 John   | Doe      | Jenny      | Smith
 John   | Doe      | Frank      | Bean
 John   | Smith    | John       | Doe
 John   | Smith    | Jenny      | Smith
--------+----------+------------+---------------
</pre>
  



### Incomplete Hierarchy

Consider building a database for a company that shows a hierarchy of departments within the company.  For instance,

```
           [manager] department        
          (employees in department)    
                                       
                                       
                [m0]0                   
                 (e1)                  
                 /   \                 
                /     \                
               /       \               
           [m1]1        [m2]2
          (e2, e3)     (e4, e5)        
             / \         / \           
            3   4       5   6          
          (e6) (e7)   (e8)  (e9)       
          /  \                         
      [m3]7    8                       
      (e10)   (e11)                    
       /                               
      9                                
  (e12, e13)                         
```

This loosely shows that,
- Department `0` is the company itself, manager 0 (`m0`) is the CEO
- `e10` works at department `7`, his manager is `m3`
- `e12` works at department `9`, this department has no direct manager, so `e12`'s manager is `m3` (the upper manager)


In this case, you would use the following query to find out who's the manager to a particular employee:

<pre>
orientdb> <code class="lang-sql userinput">SELECT EXPAND(manager) FROM (MATCH {class:Employee, 
          where: (name = ?)}.out('WorksAt').out('ParentDepartment')
		  {while: (out('Manager').size() == 0), 
		  where: (out('Manager').size() > 0)}.out('Manager')
		  {as: manager} RETURN manager)</code>
</pre>



### Deep Traversal

Match path items act in a different manners, depending on whether or not you use `while:` conditions in the statement.

For instance, consider the following graph:

``` 
[name='a'] -FriendOf-> [name='b'] -FriendOf-> [name='c']
```

Running the following statement on this graph only returns `b`:

<pre>
orientdb> <code class="lang-sql userinput">MATCH {class: Person, where: (name = 'a')}.out("FriendOf")
          {as: friend} RETURN friend</code>

--------
 friend 
--------
 b
--------
</pre>

What this means is that it traverses the path item `out("FriendOf")` exactly once.  It only returns the result of that traversal.

If you add a ```while``` condition:

<pre>
orientdb> <code class="lang-sql userinput">MATCH {class: Person, where: (name = 'a')}.out("FriendOf")
          {as: friend, while: ($depth <= 1)} RETURN friend</code>

---------
 friend 
---------
 a
 b
---------
</pre>

Including a `while:` condition on the match path item causes OrientDB to evaluate this item as zero to *n* times.  That means that it returns the starting node, (`a`, in this case), as the result of zero traversal.

To exclude the starting point, you need to add a `where:` condition, such as:

<pre>
orientdb> <code class="lang-sql userinput">MATCH {class: Person, where: (name = 'a')}.out("FriendOf")
          {as: friend, while: ($depth <= 1) where: ($depth > 0)} 
		  RETURN friend</code>
</pre>

As a general rule,
- **`while` Conditions:** Define this if it must execute the next traversal, (it evaluates at level zero, on the origin node).
- **`where` Condition:** Define this if the current element, (the origin node at the zero iteration the right node on the iteration is greater than zero), must be returned as a result of the traversal.


For instance, suppose that you have a genealogical tree.  In the tree, you want to show a person, grandparent and the grandparent of that grandparent, and so on.  The result: saying that the person is at level zero, parents at level one, grandparents at level two, etc., you would see all ancestors on even levels.  That is, `level % 2 == 0`.

To get this, you might use the following query:

<pre>
orientdb> <code class="lang-sql userinput">MATCH {class: Person, where: (name = 'a')}.out("Parent")
          {as: ancestor, while: (true) where: ($depth % 2 = 0)} 
		  RETURN ancestor</code>
</pre>


## Best practices

Queries can involve multiple operations, based on the domain model and use case.  In some cases, like projection and aggregation, you can easily manage them with a [`SELECT`](SQL-Query.md) query.  With others, such as pattern matching and deep traversal, [`MATCH`](SQL-Match.md) statements are more appropriate.

Use [`SELECT`](SQL-Query.md) and [`MATCH`](SQL-Match.md) statements together (that is, through sub-queries), to give each statement the correct responsibilities.  Here, 

### Filtering Record Attributes for a Single Class

Filtering based on record attributes for a single class is a trivial operation through both statements.  That is, finding all people named John can be written as:

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM Person WHERE name = 'John'</code>
</pre>

You can also write it as,

<pre>
orientdb> <code class="lang-sql userinput">MATCH {class: Person, as: person, where: (name = 'John')} 
          RETURN person</code>
</pre>

The efficiency remains the same.  Both queries use an index.  With [`SELECT`](SQL-Query.md), you obtain expanded records, while with [`MATCH`](SQL-Match.md), you only obtain the Record ID's.


### Filtering on Record Attributes of Connected Elements

Filtering based on the record attributes of connected elements, such as neighboring vertices, can grow trick when using [`SELECT`](SQL-Query.md), while with [`MATCH`](SQL-Match.md) it is simple.

For instance, find all people living in Rome that have a friend called John.  There are three different ways you can write this,  using [`SELECT`](SQL-Query.md):

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM Person WHERE BOTH('Friend').name CONTAINS 'John'
          AND out('LivesIn').name CONTAINS 'Rome'</code>

orientdb> <code class="lang-sql userinput">SELECT FROM (SELECT BOTH('Friend') FROM Person WHERE name
          'John') WHERE out('LivesIn').name CONTAINS 'Rome'</code>

orientdb> <code class="lang-sql userinput">SELECT FROM (SELECT in('LivesIn') FROM City WHERE name = 'Rome')
          WHERE BOTH('Friend').name CONTAINS 'John'</code>
</pre>

In the first version, the query is more readable, but it does not use indexes, so it is less optimal in terms of execution time.  The second and third use indexes if they exist, (on `Person.name` or `City.name`, both in the sub-query), but they're harder to read.  Which index they use depends only on the way you write the query.  That is, if you only have an index on `City.name` and not `Person.name`, the second version doesn't use an index.

Using a [`MATCH`](SQL-Match.md) statement, the query becomes:

<pre>
orientdb> <code class="lang-sql userinput">MATCH {class: Person, where: (name = 'John')}.both("Friend")
          {as: result}.out('LivesIn'){class: City, where: (name = 'Rome')}
		  RETURN result</code>
</pre>

Here, the query executor optimizes the query for you, choosing indexes where they exist.  Moreover, the query becomes more readable, especially in complex cases, such as multiple nested [`SELECT`](SQL-Query.md) queries.

### `TRAVERSE` Alternative

There are similar limitations to using [`TRAVERSE`](SQL-Traverse.md).  You may benefit from using [`MATCH`](SQL-Match.md) as an alternative.

For instance, consider a simple [`TRAVERSE`](SQL-Traverse.md) statement, like:

<pre>
orientdb> <code class="lang-sql userinput">TRAVERSE out('Friend') FROM (SELECT FROM Person WHERE name = 'John') 
          WHILE $depth < 3</code>
</pre>


Using a [`MATCH`](SQL-Match.md) statement, you can write the same query as:

<pre>
orientdb> <code class="lang-sql userinput">MATCH {class: Person, where: (name = 'John')}.both("Friend")
          {as: friend, while: ($depth < 3)} RETURN friend</code>
</pre>

Consider a case where you have a `since` date property on the edge `Friend`.  You want to traverse the relationship only for edges where the `since` value is greater than a given date.  In a [`TRAVERSE`](SQL-Traverse.md) statement, you might write the query as:

<pre>
orientdb> <code class="lang-sql userinput">TRAVERSE bothE('Friend')[since > date('2012-07-02', 'yyyy-MM-dd')].bothV()
          FROM (SELECT FROM Person WHERE name = 'John') WHILE $depth < 3</code>
</pre>

Unforunately, this statement DOESN"T WORK in the current release.  However, you can get the results you want using a [`MATCH`](SQL-Match.md) statement:

<pre>
orientdb> <code class="lang-sql userinput">MATCH {class: Person, where: (name = 'John')}.(bothE("Friend")
          {where: (since > date('2012-07-02', 'yyyy-MM-dd'))}.bothV())
		  {as: friend, while: ($depth < 3)} RETURN friend</code>
</pre>


### Projections and Grouping Operations

Projections and grouping operations are better expressed with a [`SELECT`](SQL-Query.md) query.  If you need to filter and do projection or aggregation in the same query, you can use [`SELECT`](SQL-Query.md) and [`MATCH`](SQL-Match.md) in the same statement.

This is particular important when you expect a result that contains attributes from different connected records (cartesian product).  FOr instance, to retrieve names, their friends and the date since they became friends:

<pre>
orientdb> <code class="lang-sql userinput">SELECT person.name AS name, friendship.since AS since, friend.name 
          AS friend FROM (MATCH {class: Person, as: person}.bothE('Friend')
		  {as: friendship}.bothV(){as: friend, 
		  where: ($matched.person != $currentMatch)} 
		  RETURN person, friendship, friend)</code>
</pre>


### Arrow notation

`out()`, `in()` and `both()` operators can be replaced with arrow notation `-->`, `<--` and `--`

Eg. the query 

<pre>
<code class="lang-sql userinput">
MATCH {class: V, as: a}.out(){}.out(){}.out(){as:b}
RETURN a, b
</code>
</pre>

can be written as

<pre>
<code class="lang-sql userinput">
MATCH {class: V, as: a}-->{}-->{}-->{as:b}
RETURN a, b
</code>
</pre>


Eg. the query (things that belong to friends)

<pre>
<code class="lang-sql userinput">
MATCH {class: Person, as: a}.out('Friend'){as:friend}.in('BelongsTo'){as:b}
RETURN a, b
</code>
</pre>

can be written as

<pre>
<code class="lang-sql userinput">
MATCH {class: Person, as: a}-Friend->{as:friend}<-BelongsTo-{as:b}
RETURN a, b
</code>
</pre>

Using arrow notation the curly braces are mandatory on both sides. eg:

<pre>
<code class="lang-sql userinput">
MATCH {class: Person, as: a}-->{}-->{as:b} RETURN a, b  //is allowed

MATCH {class: Person, as: a}-->-->{as:b} RETURN a, b  //is NOT allowed

MATCH {class: Person, as: a}.out().out(){as:b} RETURN a, b  //is allowed

MATCH {class: Person, as: a}.out(){}.out(){as:b} RETURN a, b  //is allowed
</code>
</pre>
