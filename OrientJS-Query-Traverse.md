# OrientJS - `traverse()` 

Traversal queries in OrientJS are those used to traverse records, crossing relationships.  This works in both Graph and Document Databases.  The method is comparable to the [`TRAVERSE`](SQL-Traverse.md) command in the OrientDB Console.

>Bear in mind, in many cases you may find it sufficient to use the [`db.select()`](OrientJS-Query-Select.md) method, which can result in shorter and faster queries.  For more information, see [`TRAVERSE` versus `SELECT`](SQL-Traverse.md#traverse-versus-select). 

## Working with Traversal Queries

In OrientJS, traversal operations use the `traverse()` method.  The example below uses a database of baseball statistics, which has been initialized on the `db` variable.


### Traverse All Records

The simplest use of the method is to traverse all records connected to a particular class.  For instance, say you want to see see all records associated with the Boston Red Sox, which has a Record ID of #12:45.

```js
var records = db.traverse()
   .where({
      name: 'Boston Red Sox'
   }).all();
console.log('Found Records', records);
```

