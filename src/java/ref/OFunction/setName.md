---
search:
   keywords: ['java', 'ofunction', 'setname']
---

# OFunction - setName()

Defines the logical name of the function.

## Function Names

Functions are retrieved and operated on from within OrientDB SQL by their logical names.  If you query the functions available in a database, this is the name that OrientDB returns.  It is also the name used in calling the function within OrientDB SQL statements.  Using this method you can define the logical name of the function. To retrieve the logical name of the function, see the [`getName()`](getName.md) method.

### Syntax

```
OFunction OFunction().setName(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | `String` | Logical name to set |

#### Return Type

This method returns the updated [`OFunction`](../OFunction.md) instance.  You may find this useful when stringing several operations together.


