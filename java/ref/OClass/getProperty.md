---
search:
   keywords: ['Java API', 'OClass', 'OProperty', 'get property', 'getProperty']
---

# OClass - getProperty()

This method retrieves the given property instance from the class.

## Retrieving Properties

In cases where you want to operate on properties rather than the values they contain, you can use this method to retrieve [`OProperty`](../OProperty.md) instances for the given property on the class.

### Syntax

```
OProperty OClass().getProperty(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the property you want |

#### Return Value

This method returns an [`OProperty`](../OProperty.md) instance for the requested property on the class.
