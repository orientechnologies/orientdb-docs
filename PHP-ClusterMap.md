---
search:
   keywords: ["PHP", "PhpOrient", "clusters"]
---

# PhpOrient - Cluster Maps

When you open a database on the client interface, the return value is cluster map.  This PHP class provides you with an interface and a series of methods for manipulating clusters on the database.

## Using Clusters

In order to retrieve the cluster map for a database, you need to open the database and set the return value on a variable.  For instance,

```php
$clusterMap = $client->dbOpen("GratefulDeadConcerts", "admin", "admin);
```

You can then use the `$clusterMap` object in calling additional methods.

| Method | Description |
|---|---|
| [**`count()`**](#count) | Returns a count of records in the cluster. |
| [**`dropClusterID()`**](PHP-ClusterMap-dropClusterID.md) | Removes a cluster from the database. |
| [**`getIdList()`**](PHP-ClusterMap-getIdList.md) | Retrieves a list of Cluster ID's. |


### `count()`

In cases where you want to know how many records the Cluster Map contains, you can obtains this using the `count()` method.  For instance, you might want to test that a database contains records after opening it:

```php
// Open Database
$clusterMap = $client->dbOpen("GratefulDeadConcerts", "admin", "admin);

// Report Count
$entityCount = $clusterMap->count();
echo "Database Contains: $entityCount records";
```


