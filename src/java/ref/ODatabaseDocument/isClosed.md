
# ODatabaseDocument - isClosed()

Determines whether the current database is closed or open.

## Checking Database

When you finish with an [`ODatabaseDocument`](../ODatabaseDocument.md)  instance, you should close it to free up resources, using the [`close()`](close.md) method.  In cases where you are uncertain as to whether the database instance is open or whether it was closed at this particular point in your application, you can check whether it is closed using this method.


### Syntax

```
boolean ODatabaseDocument().isClosed()
```

#### Return Value

This method returns a `boolean` value, if `true` it indicates that the database is closed.  Otherwise, it is currently open.

