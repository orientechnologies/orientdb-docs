
# OProperty - getLinkedType()

Retrieves the property type.

## Retrieving Types

OrientDB enforces typing for properties.  Each property in a database class is set to a particular type, which provide some constraint on the kinds of data set for the property. Using this method you can retrieve the property type for further operations.

### Syntax

```
OType OProperty.getLinkedType()
```

#### Return Type

This method returns an [`OType`](../OType.md) instance that corresponds to the property type.
