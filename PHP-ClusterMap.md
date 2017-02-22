---
search:
   keywords: ["PHP", "PhpOrient", "clusters"]
---

PhpOrient - Clusters

In OrientDB clusters provide physical or in-memory storage for data on your database.  In the event that you would like to operate on clusters from within your application, PhpOrient provides a series of methods to add, remove and size clusters on the database.

## Using Clusters

Methods relating to clusters in PhpOrient are called on the `$client` interface and all start with `dataCluster`.  Once you have initialized the client, you can begin to use these methods in your application.

| Method | Description |
|---|---|
| [**`dataClusterAdd()`**](PHP-dataClusterAdd.md) | Adds a cluster |
| [**`dataClusterCount()`**](PHP-dataClusterCount.md) | Counts records in cluster or clusters |
| [**`dataClusterDrop()`**](PHP-dataClusterDrop.md) | Removes a cluster |
| [**`dataClusterDataRange()`**](PHP-dataClusterDataRange.md) | Retrieves a range of Record ID's by cluster |


