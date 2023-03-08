
# OClass - getIndexedProperties()

This method returns the properties on the class that have indexes.

## Retrieving Indexed Properties

When you create an index in OrientDB, the index is applied to properties on the class.  Using this method, you can retrieve a collection of all properties that have indexes.  You might find this useful when optimizing queries or as an automated troubleshooting tool, that checks which properties have indexes in determining which need indexes.

### Syntax

```
Collection<OProperty> OClass().getIndexedProperties()
```

#### Return Value

This method returns a [`Collection`]({{ book.javase }}/api/java/util/Collection.html) instance that contains instances of [`OProperty`](../OProperty.md) that correspond to properties that have indexes.
