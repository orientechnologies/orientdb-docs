---
search:
   keywords: ['ofunctionlibrary', 'ofunction', 'createfunction']
---

# OFunctionLibrary - createFunction()

Creates a new function on the database.

## Creating Functions

OrientDB SQL supports the use of functions and user-defined functions, which are typically defined in JavaScript.   Using this method you can create a new function in the database.  The method takes the logical name of the function as an argument and then returns an [`OFunction`](../OFunction.md) instance, from which you can further define its operation.

### Syntax

```
OFunction OFunctionLibrary().createFunction(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | `String` | Defines the logical name of the function |

#### Return Type

This method returns an [`OFunction`](../OFunction.md) instance.  Note that this method does not configure the function, define arguments or what OrientDB should do in the event of a user calling the function.  You need to define that from the [`OFunction`](../OFunction.md) instance.

