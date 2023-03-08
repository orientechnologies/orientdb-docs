
# OFunction - getId()

Retrieves Record ID for the function.

## Function Records

Internally, OrientDB stores functions as records on the database, which you can in turn query and operate on with normal OrientDB SQL statements, rather than through dedicated syntax like [`CREATE FUNCTION`](../../../sql/SQL-Create-Function.md).  This means that each function you create on your database has its own dedicated Record ID.  Using this method, you can retrieve this Record ID from the function.

### Syntax

```
ORID OFunction().getId()
```

#### Return Value

This method returns an [`ORID`](../ORID.md) instance that corresponds to the function Record ID.



