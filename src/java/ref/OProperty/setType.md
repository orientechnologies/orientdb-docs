
# OProperty - setType()

This method sets the type for the property.

## Retrieving Property Types

Properties on a database class have types and can enforce type-based constraints on the data the class allows for its records.  OrientDB uses the `OType` class to define the data-types for the property and to provide methods for common operations performed on data-types for the property.

Using this method, you can set the property type.

### Syntax

```
OProperty OProperty().setType(OType type)
```

| Argument | Type | Description |
|---|---|---|
| **`type`** | [`OType`](../OType.md) | Defines the new type for the property |

#### Return Type

This method returns the updated [`OProperty`](../OProperty.md) instance.
