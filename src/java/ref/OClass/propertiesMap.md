
# OClass - propertiesMap()

This method retrieves the properties on the class.

## Retrieving Properties

Where the class allows you to organize groups of records by their particular purpose or usage, OrientDB uses properties to organize the data you store on records.  Using this method, you can retrieve the properties on a class, for situations where you need to operate on them collectively.

### Syntax

```
Map<String, OProperty> OClass().properties()
```

#### Return Value

This method returns a [`Map`]({{ book.javase }}/api/java/util/Map.html) that contains a series of key/value entries, where the key is a [`String`]({{ book.javase }}/api/java/lang/String.html) providing the property name and the value is the [`OProperty`](../OProperty.md) instance for each property on the class. 


