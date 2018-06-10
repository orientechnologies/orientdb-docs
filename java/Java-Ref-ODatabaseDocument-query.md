---
search:
   keywords: ['java', 'odatabasedocument', 'query']
---

# ODatabaseDocument - query()

This method executes idempotent OrientDB SQL queries.

## Querying the Database

OrientDB makes a distinction between idempotent queries that read data from the database and non-idempotent commands that modify the records.  Using this method you can retrieve and operate on result-sets from OrientDB.

In the event that you need to execute a non-idempotent command on the database, see the [`command()`](Java-Ref-ODatabaseDocument-command.md) method.

### Syntax

```
OResultSet ODatabaseDocument().query(String query, Map args)
```

| Argument | Type | Description |
|---|---|---|
| **`query`** | [`String`]({{ book.javase }}/java/lang/String.html) | Defines the query you want to execute. |
| **`args`** | [`Map`]({{ book.javase }}/java/util/Map.html) | Defines a map of parameters to use in formatting the query. |

### Return Value

This method returns an [`OResultSet`](Java-Ref-OResultSet.md) instance, that contains the result-set of your query.  Remember that you need to close a result-set when you're done with it, in order to free up resources.


