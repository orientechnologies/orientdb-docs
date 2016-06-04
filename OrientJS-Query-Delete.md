# OrientJS - `delete()`

Deletion queries in OrientJS are those used in removing records from the database.  It can also account for edges between vertices, updating the graph to maintain its consistency.

The deletion query method is comparable to [`DELETE`](SQL-Delete.md), [`DELETE VERTEX`](SQL-Delete-Vertex.md) and the [`DELETE EDGE`](SQL-Delete-Edge.md) statements.


## Working with Deletion Queries

In OrientJS, deletions use the `delete()` method.  The examples below operate on a database of baseball statistics, which has been initialized on the `db` variable.


### Deleting Vertices

With Graph Databases, deleting vertices is a little more complicated than the normal process of deleting records. You need to tell OrientDB that you want to delete a vertex to ensure that it takes the additional steps necessary to update the connecting edges. 

For instance, you find that you have two entries made for the player Shoeless Joe Jackson, #12:24 and #12:84 you decide to remove the extra instance within your application.

```js
var count = db.delete('VERTEX')
   .where('@rid = #12:84').one;
console.log('Deleted ' + count + ' vertices.');
```

### Deleting Edges

When deleting edges, you need to define the vertices that the edge connects.  For instance, consider the case where you have a bad entry on the `playsFor` edge, where you have Ty Cobb assigned to the Chicago Cubs.  Ty Cobb has a Record ID of #12:12, the Chicago Cubs #12:54.

```js
var count = db.delete('EDGE', 'PlaysFor')
   .from('#12:12').to('#12:54')
   .scalar();
console.log('Deleted ' + count + ' edges');
```

### Deleting Records

In order to delete records in a given class, you need to define a conditional value that tells OrientDB the specific records in the class that you want to delete.  When working from the Console, you would use the [`WHERE`](SQL-Where.md) clause.  In OrientJS, set the `where()` method.

```js
var count = db.delete().from('Player')
   .where('@rid = #12:84').limit(1).scalar();
console.log('Deleted', count, 'records');
```

