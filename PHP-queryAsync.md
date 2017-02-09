---
search:
   keywords: ['PHP', 'PhpOrient', 'asynchronous query', 'query async', 'queryAsync']
---

# PhpOrient - `queryAsync()`

This method issues a query to the database.  For each record the query returns, it executes the given callback function.

## Querying the Database

When issue a query to OrientDB using the [`query()`](PHP-Query.md) method, PhpOrient executes the SQL staetment against the open database and then gives you all of the records as a return value.  In cases where this is not the desired result, you can use this method to execute a callback function on each record the query returns.

You may find this useful in cases where you need to initiate certain calculations in advance of the final result, or to log information as the query runs.

### Example




