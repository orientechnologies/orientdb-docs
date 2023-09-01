# OSchema - getClassesRelyOnCluster()

Retrieves all the classes that rely on the given cluster. 

## Retrieving Classes

OrientDB has the concept of class within the database, which represents a broad grouping of records, similar to the table in relational contexts.  Internally, OrientDB represents a class as an [`OClass`](../OClass.md) instance.   Using this method you can retrieve all the classes in the schema that rely on the given cluster. 

### Syntax

```
Set<OClass> OSchema().getCLassesRelyOnCluster(String cluster)
```

| Argument | Type | Description |
|---|---|---|
| **`cluster`** | `String` | Defines the cluster name  | 

#### Return Value

This method returns a `Set` of [`OClass`](../OClass.md) instances that rely on the given cluster. 

