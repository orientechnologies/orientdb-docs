
# ODatabaseDocument - getName()

Retrieves the logical name of the database.

## Database Names

Each database you create in OrientDB has a logical name under which it can be accessed later.  This is the name you passed to the [`CREATE DATABASE`](../../../console/Console-Command-Create-Database.md) statement when you created the database.  Using this method you can retrieve the logical name from OrientDB.

### Syntax

```
String ODatabaseDocument().getName()
```

#### Return Value

This method returns a `String` instance, which corresponds to the logical name of the database.


