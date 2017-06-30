---
search:
   keywords: ['Java API', 'OClass' ]
---

# Java API - OClass

This class provides a standard interface for handling database classes.

## Managing Database Classes

OrientDB draws from the Object Oriented programming paradigm in the concept of a [class](../general/Schema.html#class), which for the prposes of clarity is called a *database class* in this Reference guide, to avoid confusion with classes in Java.  Database classes are loosely comparable with tables in Relational databases.  But, unlike tables, database classes are not required to follow a schema unless you want them to follow a schema.  In Java, database classes implement the `OClass` class.

This class is available at `com.orientechnologies.orient.core.metadata.schema`.

```java
import com.orientechnologies.orient.core.metadata.schema.OClass;
```

Once you've imported the class to your application, you can use to build particular instances in your code.


## Methods

### Managing Classes

| Method | Return Type | Description |
|---|---|---|
| [**`addSuperClass()`**](Java-Ref-OClass-addSuperClass.md) | `OClass` | Adds a superclass to the database class |
| [**`count()`**](Java-Ref-OClass-count.md) | [`Long`]({{ book.javase }}/api/java/lang/Long.html) | Counts the number of records in the class |
| [**`getAllSubclasses()`**](Java-Ref-OClass-getAllSubclasses.md) | [`Collection`]({{ book.javase }}/api/java/util/Collection.html)[`<OClass>`](Java-Ref-OClass.md) | Retrieves classes that use this class as thier superclass, and subclasses of these classes, (the complete hierarchy) | 
| [**`getAllSuperClasses()`**](Java-Ref-OClass-getAllSuperClasses.md) | [`Collection`]({{ book.javase }}/api/java/util/Collection.html)[`<OClass>`](Java-Ref-OClass.md)| Retrives all superclasses of this class |
| [**`getSubclasses()`**](Java-Ref-OClass-getSubclasses.md) |  [`Collection`]({{ book.javase }}/api/java/util/Collection.html)[`<OClass>`](Java-Ref-OClass.md) | Retrieves classes that use this class as their immediate superclass, (one level hierarchy) |

### Managing Clusters

| Method | Return Type | Description |
|---|---|---|
| [**`addCluster()`**](Java-Ref-OClass-addCluster.md) | `OClass` | Adds a cluster to the database class, by its name |
| [**`addClusterId()`**](Java-Ref-OClass-addClusterId.md) | `OClass` | Add a cluster to the database class, by its Cluster ID |
| [**`getClusterIds`**](Java-Ref-OClass-getClusterIds.md) | [`int[]`]({{ book.javase }}/api/java/util/Array.html) | Retrieves ID's for clusters on the class |
| [**`getDefaultClusterId()`**](Java-Ref-OClass-getDefaultClusterId.md) | [`int`]({{ book.javase }}/api/java/lang/Integer.html) | Retrieves the default Cluster ID |
| [**`setDefaultClusterId()`**](Java-Ref-OClass-setDefaultClusterId.md) | [`void`]({{ book.javase }}/api/java/lang/Void.html) | Configures the default cluster, by Cluster ID |
| [**`removeClusterId()`**](Java-Ref-OClass-removeClusterId.md) | `OClass` | Removes a Cluster ID |
| [**`truncateCluster()`**](Java-Ref-OClass-truncateCluster.md) | `OClass` | Removes all data in cluster with the given name |

### Managing Properties

| Method | Return Type | Description |
|---|---|---|
| [**`createProperty()`**](Java-Ref-OClass-createProperty.md) | `OProperty` | Creates a property (that is, a field) on the class |
| [**`dropProperty()`**](Java-Ref-OClass-dropProperty.md) | [`void`]({{ book.javase }}/api/java/lang/Void.html) | Removes property from class |
| [**`existsProperty()`**](Java-Ref-OClass-existsProperty.md)

### Managing Indexes

| Method | Return Type | Description |
|---|---|---|
| [**`areIndexed()`**](Java-Ref-OClass-areIndexed.md) | [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Determines whether the given fields are contained as first key fields in the database class indexes |
| [**`createIndex()`**](Java-Ref-OClass-createIndex.md) | `OIndex<?>` | Creates an index on the given property |
| [**`getAutoShardingIndex()`**](Java-Ref-OClass-getAutoShardingIndex.md) | `OIndex<?>` | Retrieves the auto sharding index configured for the class, if any |
| [**`getClassIndex()`**](Java-Ref-OClass-getClassIndex.md) | `OIndex<?>` | Retrieves the requested index instance |
| [**`getClassIndexes()`**](Java-Ref-OClass-getClassIndexes.md) | [`Set`]({{ book.javase }}/api/java/util/Set.html)`<OIndex<?>>` | Retrieves indexes for the class |
| [**`getClassInvolvedIndexes()`**](Java-Ref-OClass-getClassInvolvedIndexes.md) | [`Set`]({{ book.javase }}/api/java/util/Set.html)`<OIndex<?>>` | Retrieves indexes that include the given properties as first keys |
