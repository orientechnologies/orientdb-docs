---
search:
   keywords: ['Java API', 'OProperty', 'set name', 'property name', 'setName']
---

# OProperty - setName()

This method defines the name of the property.

## Retrieving the Property Name

OrientDB differentiates between properties by the property name.  Using this method you can set the name from an [`OProperty`](../OProperty.md) instance.

### Syntax

```
OProperty OProperty().setName(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the new property name |

#### Return Value

This method returns an updated `OProperty` instance.

