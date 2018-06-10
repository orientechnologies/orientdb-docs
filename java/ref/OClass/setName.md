---
search:
   keywords: ['Java API', 'OClass', 'set name', 'setName']
---

# OClass - setName()

This method sets the name for the class.

## Setting the Class Name

Database classes in OrientDB have names, allowing you to reference them and request the [`OClass`](../OClass.md) instance using a simple string.  This method allows you to define the string OrientDB uses as its class name.

### Syntax

```
OClass OClass().setName(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the new class name |

#### Return Value

This method returns the updated [`OClass`](../OClass.md) instance.
