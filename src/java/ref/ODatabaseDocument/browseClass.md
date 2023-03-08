
# ODatabaseDocument - browseClasss()

This method returns all records in the given database class.  It also returns subclasses, where available.


## Browsing Records by Class

Records in OrientDB belong to a [database class](../../../general/Schema.md#class), which internally is an implementation of [`OClass`](../OClass.md).  Using this method, you can retrieve all records that belong to a particular database class.

### Syntax

```
// METHOD 1
ORecordIteratorClass<ODocument> ODatabaseDocument().browseClass(String name)

// METHOD 2
ORecordIteratorClass<ODocument> ODatabaseDocument().browseClass(String name, Boolean polymorphic)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the database class name |
| **`polymorphic`** | [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Defines whether the database class is polymorphic, (that is, whether it has sub-classes) |

#### Return Value

This method returns an `ORecordIteratorClass` instance that contains the relevant `ODocument` instances.  `ODocument` is an subclass of [`OElement`](../OElement.md).


