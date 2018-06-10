---
search:
   keywords: ['Java API', 'OProperty', 'get minimum', 'getMin']
---

# OProperty - getMax()

This method sets the minimum allowed value for the property.

## Retrieving Constraints

Properties can enforce constraints on the data you store in them.  This can be limited to the data-type of the stored value.  It can also extend to constraints on the actual data.

OrientDB calculates the minimum allowed values in different ways, depending on what [`OType`](../OType.md) you have set for the property:

- **String** The minimum value is the minimum allowed number of characters. 
- **Number** The minimum value is the smallest allowed number. 
- **Date** The minimum value is the earliest allowed date.
- **Time** The minimum value is the earliest allowed time, measured in milliseconds.
- **Binary** The minimum value is the smallest allowed size for a byte array.
- **List**, **Set** or **Collection** The minimum value is smallest size of the collection.

Using this method, you can set the minimum allowed value for the property.

### Syntax

```
OProperty OProperty().setMin(String min)
```

| Argument | Type | Description |
|---|---|---|
| **`min`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the new minimum value |

#### Return Value

This method returns the updated [`OProperty`](../OProperty.md) instance.
