
# OProperty - setLinkedType()

Defines the property type.

## Retrieving Types

OrientDB enforces typing for properties.  Each property in a database class is set to a particular type, which provide some constraint on the kinds of data set for the property. Using this method you can set the property type.

### Syntax

```
OProperty OProperty.setLinkedType(OType <type>)
```

- **`<type>`** Defines the [`OType`](../OType.md) instance.

#### Return Type

This method returns an [`OProperty`](../OProperty.md) instance that corresponds to the property type.
