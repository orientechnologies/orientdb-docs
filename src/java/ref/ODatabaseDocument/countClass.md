
# ODatabaseDocument - countClass()

This method returns the number of records in a given database class.

## Counting Records by Class

OrientDB organizes data by a database class, which is an instance of the [`OClass`](../OClass.md) class.  Using this method, you can retrieve a count of the number of records in a given database class.

### Syntax

```
// METHOD 1
long ODatabaseDocument().countClass(String name)

// METHOD 2
long ODatabaseDocument().countClass(String name, Boolean isPolymorphic)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the database class name |
| **`isPolymorphic`** | [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Defines whether the class has sub-classes |

#### Return Value

This method returns a [`Long`]({{ book.javase }}/api/java/lang/Long.html) instance that represents the number of records on the given database class.

