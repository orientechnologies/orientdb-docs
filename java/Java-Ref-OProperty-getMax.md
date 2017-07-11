---
search:
   keywords: ['Java API', 'OProperty', 'get max', 'getMax']
---

# OProperty - getMax()

This method retrieves the maximum allowed value for the property.

## Retrieving Constraints

Properties can enforce constraints on the data you store in them.  This can be limited to the data-type of the stored value.  It can also extend to constraints on the actual data.

OrientDB calculates the maximum allowed values in different ways, depending on what [`OType`](Java-Ref-OType.md) you have set for the property:

- **String** The maximum value is the maximum allowed number of characters. 
- **Number** The maximum value is the largest allowed number. 
- **Date** The maximum value is the latest allowed date.
- **Time** The maximum value is the latest allowed time, measured in milliseconds.
- **Binary** The maximum value is the largest allowed size for a byte array.
- **List**, **Set** or **Collection** The maximum value is largest size of the collection.

Using this method, you can retrieve the maximum allowed value for the property.

### Syntax

```
String OProperty().getMax()
```

#### Return Value

This method returns a [`String`]({{ book.javase }}/api/java/lang/String.html) instance, which provides the maximum value set on the property.  In the event that there is no maximum value set on the property, it returns `null`.
