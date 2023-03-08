
# OFunction - getName()

Retrieves the logical name of the function.

## Function Names

Functions are retrieved and operated on from within OrientDB SQL by their logical names.  If you query the functions available in a database, this is the name that OrientDB returns.  It is also the name used in calling the function within OrientDB SQL statements.  Using this method you can retrieve the function's logical name.  To set the logical name for the function, see the [`setName()`](setName.md) method.

### Syntax

```
String OFunction().getName()
```

#### Return Type

This method returns a `String` instance, which contains the logical name of the function.


