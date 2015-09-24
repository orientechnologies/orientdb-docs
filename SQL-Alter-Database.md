# SQL - ALTER DATABASE

The `ALTER DATABASE` command update database settings.

## Syntax

```sql
ALTER DATABASE <attribute-name> <attribute-value>
```

Where: **attribute-value** attribute's value to set and **attribute-name** between those supported:
- **STATUS** database's status between:
- **IMPORTING** to set importing status
- **DEFAULTCLUSTERID** to set the default cluster. By default is 2 = "default"
- **DATEFORMAT** sets the default date format. Look at [Java Date Format](http://docs.oracle.com/javase/6/docs/api/java/text/SimpleDateFormat.html) for more information. Default is "yyyy-MM-dd"
- **DATETIMEFORMAT** sets the default date time format. Look at [Java Date Format](http://docs.oracle.com/javase/6/docs/api/java/text/SimpleDateFormat.html) for more information. Default is "yyyy-MM-dd HH:mm:ss"
- **TIMEZONE** set the default timezone. Look at [Java Date TimeZones](http://docs.oracle.com/javase/6/docs/api/java/util/TimeZone.html) for more information. Default is the JVM's default timezone
- **LOCALECOUNTRY** sets the default locale country. Look at [Java Locales](http://docs.oracle.com/javase/6/docs/api/java/util/Locale.html) for more information. Default is the JVM's default locale country. Example: "GB"
- **LOCALELANGUAGE** sets the default locale language. Look at [Java Locales](http://docs.oracle.com/javase/6/docs/api/java/util/Locale.html) for more information. Default is the JVM's default locale language. Example: "en"
- **CHARSET** set the default charset charset. Look at [Java Charset](http://docs.oracle.com/javase/6/docs/api/java/nio/charset/Charset.html) for more information. Default is the JVM's default charset. Example: "utf8"
- **CLUSTERSELECTION** sets the default strategy used on selecting the cluster where to create new records. This setting is read on class creation. After creation, each class has own modifiable strategy. Supported strategies are:
 - **default**, uses always the Class's ```defaultClusterId``` property. This was the default before 1.7
 - **round-robin**, put the Class's configured clusters in a ring and returns a different cluster every time restarting from the first when the ring is completed
 - **balanced**, checks the records in all the clusters and returns the smaller cluster. This allows the cluster to have all the underlying clusters balanced on size. On adding a new cluster to an existent class, the new empty cluster will be filled before the others because more empty then the others. In distributed configuration when configure clusters on different servers this setting allows to keep the server balanced with the same amount of data. Calculation of cluster size is made every 5 or more seconds to avoid to slow down insertion
- **MINIMUMCLUSTERS**, as the minimum number of clusters to create automatically when a new class is created. By default is 1, but on multi CPU/core having multiple clusters/files improves read/write performance
- **CONFLICTSTRATEGY**, (since v2.0) is the name of the strategy used to handle conflicts when OrientDB's MVCC finds an update or delete operation executed against an old record. The strategy is applied for the entire database, but single clusters can have own strategy (use [ALTER CLUSTER](SQL-Alter-Cluster.md) command for this). While it's possible to inject custom logic by writing a Java class, the out of the box modes are:
 - `version`, the default, throw an exception when versions are different
 - `content`, in case the version is different checks if the content is changed, otherwise use the highest version and avoid throwing exception
 - `automerge`, merges the changes
- **CUSTOM** sets custom properties
- **VALIDATION**, (Since v2.2) disable or enable the validation for the entire database. This setting is not persistent, so at the next restart the validation is active (Default). Disabling the validation sometimes is needed in case of [remote import database](Console-Command-Import.md#validation-errors).


## See also
- [Console Command Create Database](Console-Command-Create-Database.md)
- [Console Command Drop Database](Console-Command-Drop-Database.md)

## Examples

### Disable new SQL strict parser

```sql
ALTER DATABASE custom strictSQL=false
```

### Use GraphDB created with releases before 1.4
Starting from v 1.4, OrientDB can use [Lightweight Edges](Lightweight-Edges.md). After v2.0 this is disabled by default with new databases. To maintain the compatibility with OrientDB 1.4 or minor execute this commands:
```sql
ALTER DATABASE custom useLightweightEdges=false
ALTER DATABASE custom useClassForEdgeLabel=false
ALTER DATABASE custom useClassForVertexLabel=false
ALTER DATABASE custom useVertexFieldsForEdgeLabels=false
```

## History
### 1.7
- Added support for CLUSTERSELECTION that sets the strategy used on selecting the cluster where to create new records
- Added **MINIMUMCLUSTERS** to pre-create X clusters every time a new class is created

