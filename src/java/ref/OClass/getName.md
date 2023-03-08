---
search:
   keywords: ['java', 'api', 'oclass', 'class name', 'get name', 'getName']
---

# OClass - getName()

This method returns the logical name of the class.

## Retrieving Class Names

Internally, OrientDB manages clsases as [`OClass`](../OClass.md) instance.  But, each database class has a logical name that gets used in [OrientDB SQL](../../../sql) queries.  Using this method, you can retrieve the logical name as string.

### Syntax

```
String OClass().getName()
```

#### Return Type

This method returns a [`String`]({{ javase }}/java/lang/String.html) instance, which provides the logical name of the [`OClass`](../OClass.md).

