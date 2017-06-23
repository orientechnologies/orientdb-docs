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

### Managing Clusters

| Method | Return Type | Description |
|---|---|---|
| [**`addCluster()`**](Java-Ref-OClass-addCluster.md) | `OClass` | Adds a cluster to the database class, by its name |
| [**`addClusterId()`**](Java-Ref-OClass-addClusterId.md) | `OClass` | Add a cluster to the database class, by its Cluster ID |


### Managing Indexes

| Method | Return Type | Description |
|---|---|---|
| [**`areIndexed()`**](Java-Ref-OClass-areIndexed.md) | [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Determines whether the given fields are contained as first key fields in the database class indexes |
