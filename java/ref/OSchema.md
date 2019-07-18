---
search:
   keywords: ['java', 'oschema']
---

# Java API - OSchema

Provides an interface for operating on schemas in OrientDB.

## Working with Schemas

In order to operate on schemas in your Java application, you first need to import it.

```java
import com.orientechnologies.orient.core.db.OSchema;
```

### Methods

| Method | Return Type | Description |
|---|---|---|
| [**`createClass()`**](OSchema/createClass.md) | `int` | Counts the number of classes associated with the schema |
| [**`createAbstractClass()`**](OSchema/createAbstractClass.md) | [`OClass`](OClass.md) | Creates an abstract class in the schema |
| [**`createClass()`**](OSchema/createClass.md) | [`OClass`](OClass.md) | Creates a class in the schema |
| [**`dropClass()`**](OSchema/dropClass.md) | `void` | Removes a class from the schema |
| [**`existsClass()`**](OSchema/existsClass.md) | `boolean` | Checks whether the class exists in the schema |
| [**`getClass()`**](OSchema/getClass.md) | [`OClass`](OClass.md) | Retrieves class from the schema |
| [**`getClassByClusterId()`**](OSchema/getClassByClusterId.md) | [`OClass`](OClass.md) | Retrieves class by associated Cluster ID |
| [**`getClasses()`**](OSchema/getClasses.md) | [`Set<OClass>`](OClass.md) | Retrieves all classes associated with schema |
| [**`getClassesRelyOnCluster()`**](OSchema/getClassesRelyOnCluster.md) | [`Set<OClass>`](OClass.md) | Retrieves all classes associated with the given cluster |
| [**`getOrCreateClass()`**](OSchema/getOrCreateClass.md) | [`OClass`](OClass.md) | Retrieves class from the schema and create the class if it does not already exist |


