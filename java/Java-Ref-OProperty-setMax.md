---
search:
   keywords: ['Java API', 'OProperty', 'get max', 'getMax']
---

# OProperty - getMax()

This method sets the maximum allowed value for the property.

## Setting Constraints

Properties can enforce constraints on the data you store in them.  This can be limited to the data-type of the stored value.  It can also extend to constraints on the actual data.

OrientDB calculates the maximum allowed values in different ways, depending on what [`OType`](Java-Ref-OType.md) you have set for the property:

- **String** The maximum value is the maximum allowed number of characters. 
- **Number** The maximum value is the largest allowed number. 
- **Date** The maximum value is the latest allowed date.
- **Time** The maximum value is the latest allowed time, measured in milliseconds.
- **Binary** The maximum value is the largest allowed size for a byte array.
- **List**, **Set** or **Collection** The maximum value is largest size of the collection.

Using this method, you can set the maximum allowed value for the property.

### Syntax

```
OProperty OProperty().setMax(String max)
```

| Argument | Type | Description |
|---|---|---|
| **`max`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Define the maximum allowed value |

#### Return Value

This method returns the updated [`OProperty`](Java-Ref-OProperty.md) instance.
