---
search:
   keywords: ['java', 'ofunction', 'isidempotent']
---

# OFunction - isIdempotent()

Determines whether the function is idempotent.

## Function Idempotence 

OrientDB differentiates between idempotent queries and non-idempotent commands.  That is, queries that always return the same results versus commands that write to the database.  In functions this is indicated by a simple boolean value set on the [`OFunction`](../OFunction.md) instance.  Using this method, you can check whether the function has been designated as idempotent.  To set idempotence for the function, see the [`setIdempotent()`](setIdempotent.md) method.

### Syntax

```
boolean OFunction.isIdempotent()
```

#### Return Type

This method returns a `boolean` instance.  A value of `true` indicates that the function is idempotent and only reads from the database.  A value of `false` indicates that the function is non-idempotent and modifies data on the database.



