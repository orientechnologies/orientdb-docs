
# OFunction - setIdempotent()

Sets whether the function is idempotent.

## Function Idempotence 

OrientDB differentiates between idempotent queries and non-idempotent commands.  That is, queries that always return the same results versus commands that write to the database.  In functions this is indicated by a simple boolean value set on the [`OFunction`](../OFunction.md) instance.  Using this method you can set idempotence for the function.  To determine whether a function is set as idempotent, see the [`isIdempotent()`](isIdempotent.md) method.

### Syntax

```
OFunction OFunction().setIdempotent(boolean idempotence)
```

| Argument | Type | Description |
|---|---|---|
| **`idempotence`** | `boolean` | Indicates whether the function is idempotent |

#### Return Type

This method returns the updated [`OFunction`](../OFunction.md) instance, which you may find useful when stringing several operations together. 



