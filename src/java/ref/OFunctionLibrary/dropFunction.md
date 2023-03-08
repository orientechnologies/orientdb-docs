
# OFunctionLibrary - dropFunction()

Removes the given function from the database.

## Removing Functions

OrientDB SQL supports the use of functions and user-defined functions from the console or application code.  Using this method, you can remove the given function from the function library.

### Syntax

```
void OFunctionLibrary().dropFunction(OFunction func)
void OFunctionLibrary().dropFunction(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`func`** | [`OFunction`](../OFunction.md) | Defines the function you want to remove |
| **`name`** | `String` | Defines the logical name of the function |



