---
search:
   keywords: ['java', 'odatabasedocument', 'clusters', 'getclusters']
---

# ODatabaseDocument - getClusters()

Returns the number of clusters on the database.

## Counting Clusters

OrientDB uses clusters to designate physical or in-memory spaces in which to store your data.  Using this method you can retrieve a count of the number of clusters on the database.  

### Syntax

```
int ODatabaseDocument().getClusters()
```

#### Return Value

This method returns an `int` value, providing the number of clusters on the database.



