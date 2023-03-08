---
search:
   keywords: ['Java API', 'OClass' ]
---

# Java API - OClass

This class provides a standard interface for handling database classes.

## Managing Database Classes

OrientDB draws from the Object Oriented programming paradigm in the concept of a [class](../../general/Schema.md#class), which for the prposes of clarity is called a *database class* in this Reference guide, to avoid confusion with classes in Java.  Database classes are loosely comparable with tables in Relational databases.  But, unlike tables, database classes are not required to follow a schema unless you want them to follow a schema.  In Java, database classes implement the `OClass` class.

This class is available at `com.orientechnologies.orient.core.metadata.schema`.

```java
import com.orientechnologies.orient.core.metadata.schema.OClass;
```

Once you've imported the class to your application, you can use to build particular instances in your code.


## Methods

### Managing Classes

| Method | Return Type | Description |
|---|---|---|
| [**`addSuperClass()`**](OClass/addSuperClass.md) | `OClass` | Adds a superclass to the database class |
| [**`count()`**](OClass/count.md) | [`Long`]({{ book.javase }}/api/java/lang/Long.html) | Counts the number of records in the class |
| [**`getAllSubclasses()`**](OClass/getAllSubclasses.md) | [`Collection`]({{ book.javase }}/api/java/util/Collection.html)[`<OClass>`](OClass.md) | Retrieves classes that use this class as thier superclass, and subclasses of these classes, (the complete hierarchy) | 
| [**`getAllSuperClasses()`**](OClass/getAllSuperClasses.md) | [`Collection`]({{ book.javase }}/api/java/util/Collection.html)[`<OClass>`](OClass.md)| Retrives all superclasses of this class |
| [**`getSubclasses()`**](OClass/getSubclasses.md) |  [`Collection`]({{ book.javase }}/api/java/util/Collection.html)[`<OClass>`](OClass.md) | Retrieves classes that use this class as their immediate superclass, (one level hierarchy) |
| [**`getSuperClassesNames()`**](OClass/getSuperClassesNames.md) | [`List`]({{ book.javase }}/api/java/util/List.html)[`<String>`]({{ book.javase }}/api/java/lang/String.html) | Retrieves the names of all superclasses for this class |
| [**`hasSuperClasses()`**](OClass/hasSuperClasses.md) | [`boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Determines whether the class has superclasses |
| [**`isEdgeType()`**](OClass/isEdgeType.md) | [`boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Determines whether the class is an edge | 
| [**`isVertexType()`**](OClass/isVertexType.md) | [`boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Determines whether the class is a vertex | 
| [**`removeSuperClass()`**](OClass/removeSuperClass.md) | `OClass` | Removes a superclass from the class | 
| [**`setName()`**](OClass/setName.md) | `OClass` | Sets the class name |

### Managing Clusters

| Method | Return Type | Description |
|---|---|---|
| [**`addCluster()`**](OClass/addCluster.md) | `OClass` | Adds a cluster to the database class, by its name |
| [**`addClusterId()`**](OClass/addClusterId.md) | `OClass` | Add a cluster to the database class, by its Cluster ID |
| [**`getClusterIds`**](OClass/getClusterIds.md) | [`int[]`]({{ book.javase }}/api/java/util/Array.html) | Retrieves ID's for clusters on the class |
| [**`getDefaultClusterId()`**](OClass/getDefaultClusterId.md) | [`int`]({{ book.javase }}/api/java/lang/Integer.html) | Retrieves the default Cluster ID |
| [**`hasClusterId()`**](OClass/hasClusterId.md) | [`boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Determines whether the class uses the given Cluster ID |
| [**`hasPolymorphicClusterId()`**](OClass/hasPolymorphicClusterId.md) | [`boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Determines whether the class or any superclasses of the class use the given Cluster ID |
| [**`setDefaultClusterId()`**](OClass/setDefaultClusterId.md) | [`void`]({{ book.javase }}/api/java/lang/Void.html) | Configures the default cluster, by Cluster ID |
| [**`removeClusterId()`**](OClass/removeClusterId.md) | `OClass` | Removes a Cluster ID |
| [**`truncate()`**](OClass/truncate.md) | `void` | Removes all data from all clusters on the class |
| [**`truncateCluster()`**](OClass/truncateCluster.md) | `OClass` | Removes all data in cluster with the given name |

### Managing Properties

| Method | Return Type | Description |
|---|---|---|
| [**`createProperty()`**](OClass/createProperty.md) | [`OProperty`](OProperty.md) | Creates a property (that is, a field) on the class |
| [**`dropProperty()`**](OClass/dropProperty.md) | [`void`]({{ book.javase }}/api/java/lang/Void.html) | Removes property from class |
| [**`existsProperty()`**](OClass/existsProperty.md) | [`boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Determines whether a property exists on the class |
| [**`getIndexedProperties()`**](OClass/getIndexedProperties.md) | [`Collection`]({{ book.javase }}/api/java/util/Collection.html) [`<OProperty>`](OProperty.md) | Retrieves a collection of properties that are indexed |
| [**`getProperty()`**](OClass/getProperty.md) | [`OProperty`](OProperty.md) | Retrieves the given property |
| [**`properties()`**](OClass/properties.md) | [`Collection`]({{ book.javase }}/api/java/util/Collection.html)[`<OProperty>`](OProperty.md) | Retrieves properties on the class |
| [**`propertiesMap()`**](OClass/propertiesMap.md) | [`Map`]({{ book.javase }}/api/java/util/Map.html) [`<String, `]({{ book.javase }}/api/java/lang/String.html)`OProperty>` | Retrieves properties on the class |

### Managing Indexes

| Method | Return Type | Description |
|---|---|---|
| [**`areIndexed()`**](OClass/areIndexed.md) | [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Determines whether the given fields are contained as first key fields in the database class indexes |
| [**`createIndex()`**](OClass/createIndex.md) | `OIndex<?>` | Creates an index on the given property |
| [**`getAutoShardingIndex()`**](OClass/getAutoShardingIndex.md) | `OIndex<?>` | Retrieves the auto sharding index configured for the class, if any |
| [**`getClassIndex()`**](OClass/getClassIndex.md) | `OIndex<?>` | Retrieves the requested index instance |
| [**`getClassIndexes()`**](OClass/getClassIndexes.md) | [`Set`]({{ book.javase }}/api/java/util/Set.html)`<OIndex<?>>` | Retrieves indexes for the class |
| [**`getClassInvolvedIndexes()`**](OClass/getClassInvolvedIndexes.md) | [`Set`]({{ book.javase }}/api/java/util/Set.html)`<OIndex<?>>` | Retrieves indexes that include the given properties as first keys |
| [**`getIndexedProperties()`**](OClass/getIndexedProperties.md) | [`Collection`]({{ book.javase }}/api/java/util/Collection.html)[`<OProperty>`](OProperty.md) | Retrieves a collection of properties that are indexed |
