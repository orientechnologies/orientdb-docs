---
search:
   keywords: ['Java API', 'OClass', 'OProperty', 'properties', 'get properties']
---

# OClass - properties()

This method retrieves the properties on the class.

## Retrieving Properties

Where the class allows you to organize groups of records by their particular purpose or usage, OrientDB uses properties to organize the data you store on records.  Using this method, you can retrieve the properties on a class, for situations where you need to operate on them collectively.

### Syntax

```
Collection<OProperty> OClass().properties()
```

#### Return Value

This method returns a [`Collection`]({{ book.javase }}/api/java/util/Collection.html) that contains `OProperty` instances for each property configured on the class.


