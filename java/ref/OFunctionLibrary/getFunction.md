---
search:
   keywords: ['java', 'ofunctionlibrary', 'getfunction', 'ofunction']
---

# OFunctionLibrary - getFunction()

Retrieves the specified database function from the function library.

## Retrieving Functions

OrientDB supports the use of functions and user-defined functions in OrientDB SQL. Internally these functions are stored as a series of [`OFunction`](../OFunction.md)  instances on the database in the function library.  Using this method, you can retrieve the specified function from the function library, to further operate on it.

### Syntax

```
OFunction OFunctionLibrary().getFunction(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | `String` | Defines the logical name of the function to retrieve |

#### Return Type

This method returns an [`OFunction`](../OFunction.md) instance that corresponds to the logical name requested.
