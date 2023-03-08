
# OProperty - getType()

This method retrieves the type for the property.

## Retrieving Property Types

Properties on a database class have types and can enforce type-based constraints on the data the class allows for its records.  OrientDB uses the [`OType`](../OType.md) class to define the data-types for the property and to provide methods for common operations performed on data-types for the property.

Using this method, you can retrieve the property type.

### Syntax

```
OType OProperty().getType()
```

#### Return Type

This method returns an [`OType`](../OType.md) instance for the type.
