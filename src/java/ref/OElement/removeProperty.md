
# OElement - removeProperty()

This method removes a property from the record.

## Removing Properties

In the event that you would like to remove a property from a record with the corresponding data, you can do so using this method.  If you would like instead to add or retrieve a property to the record, see [`setProperty`](setProperty.md) or [`getProperty()`](getProperty.md).

### Syntax

```
<RET> RET OElement().removeProperty(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the property name |

#### Return Value

This method returns the property that you removed from the record.  The return value is a generic and belongs to whatever type is set for the property.
