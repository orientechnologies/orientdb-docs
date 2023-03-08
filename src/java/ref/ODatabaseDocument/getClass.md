
# ODatabaseDocument - getClass()

This method retrieves the given class.

## Retrieving Classes

OrientDB has the concept of classes used to organize data of similar types.  Using this method, you can retrieve a particular [`OClass`](../OClass.md) instance for the given class name.

### Syntax

```
OClass ODatabaseDocument().getClass(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the name of the class |

#### Return Value

This method returns the [`OClass`](../OClass.md) instance corresponding to the given name.




