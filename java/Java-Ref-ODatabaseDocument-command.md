---
search:
   keywords: ['java', 'odatabasedocument', 'command']
---

# ODatabaseDocument - command()

This method executes a generic command.

## Executing Commands

Using this method you can issue a command to the OrientDB database.  The command can either be idempotent or non-idempotent.  The return value is an [`OResultSet`](Java-Ref-OResultSet.md) instance.  Note that you need to close the result-set after usage to free up resources.

### Syntax

```
OResultSet ODatabaseDocument().command(String query, Map args)
```

| Argument | Type | Description |
|---|---|---|
| **`query`** | [`String`]({{ book.javase }}/java/lang/String.html) | Defines the query you want to execute. |
| **`args`** | [`Map`]({{ book.javase }}/java/util/Map.html) | Defines parameters for use in formatting the query. |

### Return Value

This method returns an [`OResultSet`](Java-Ref-OResultSet.md) instance, which contains the result-set of your query.  Note that you need to close it when you're done to free up resources.


