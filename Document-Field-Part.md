# Working with Fields

OrientDB has a powerful way to extract parts of a Document field. This applies to the Java API, SQL Where conditions, and SQL projections.

To extract parts you have to use the square brackets.

## Extract punctual items

### Single item

Example: tags is an EMBEDDEDSET of Strings containing the values ['Smart', 'Geek', 'Cool'].

The expression tags[0] will return 'Smart'.

### Single items

Inside square brackets put the items separated by comma ",".

Following the tags example above, the expression tags[0,2] will return a list with [Smart, 'Cool'].

### Range items

Inside square brackets put the lower and upper bounds of an item, separated by "-".

Following the tags example above, the expression tags[1-2] returns ['Geek', 'Cool'].

### Usage in SQL query

Example:
```sql
SELECT * FROM profile WHERE phones['home'] LIKE '+39%'
```
Works the same with double quotes.

You can go in a chain (contacts is a map of map):
```sql
SELECT * FROM profile WHERE contacts[phones][home] LIKE '+39%'
```
With lists and arrays you can pick an item element from a range:
```sql
SELECT * FROM profile WHERE tags[0] = 'smart'
```
and single items:
```sql
SELECT * FROM profile WHERE tags[0,3,5] CONTAINSALL ['smart', 'new', 'crazy']
```
and a range of items:
```sql
SELECT * FROM profile WHERE tags[0-5] CONTAINSALL ['smart', 'new', 'crazy']
```

### Condition

Inside the square brackets you can specify a condition. Today only the equals condition is supported.

Example:
```sql
employees[label = 'Ferrari']
```

#### Use in graphs

You can cross a graph using a projection. This an example of traversing all the retrieved nodes with name "Tom". "out" is outEdges and it's a collection. Previously, a collection couldn't be traversed with the . notation. Example:
```sql
SELECT out.in FROM v WHERE name = 'Tom'
```
This retrieves all the vertices connected to the outgoing edges from the Vertex with name = 'Tom'.

A collection can be filtered with the equals operator. This an example of traversing all the retrieved nodes with name "Tom". The traversal crosses the out edges but only where the linked (in) Vertex has the label "Ferrari" and then forward to the:
```sql
SELECT out[in.label = 'Ferrari'] FROM v WHERE name = 'Tom'
```
Or selecting vertex nodes based on class:
```sql
SELECT out[in.@class = 'Car'] FROM v WHERE name = 'Tom'
```
Or both:
```sql
SELECT out[label='drives'][in.@class = 'Car'] FROM v WHERE name = 'Tom'
```
As you can see where brackets ([]) follow brackets, the result set is filtered in each step like a Pipeline.

NOTE: This doesn't replace the support of GREMLIN. GREMLIN is much more powerful because it does thousands of things more, but it's a simple and, at the same time, powerful tool to traverse relationships.

### Future directions

In the future you will be able to use the full expression of the OrientDB SQL language inside the square brackets [], like:
```sql
SELECT out[in.label.trim() = 'Ferrari' AND in.@class='Vehicle'] FROM v WHERE name = 'Tom'
```
But for this you have to wait yet :-) Monitor the issue: https://github.com/nuvolabase/orientdb/issues/513
