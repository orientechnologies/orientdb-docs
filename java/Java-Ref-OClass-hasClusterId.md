---
search:
   keywords: ['Java API', 'OClass', 'Cluster ID', 'has cluster id', 'hasClusterId']
---

# OClass - hasClusterId()

This method determines whether the class uses a cluster, as defined by the Cluster ID.

## Checking for Clusters

Where classes are used to organized what data you store, clusters define where and how you store data.  Using this method, you can detemrine whether the class uses the given cluster, identifying the cluster you want to check for by its Cluster ID, (the first number in a Record ID).

### Syntax

```
boolean OClass().hasClusterId(int clusterId)
```

| Argument | Type | Description |
|---|---|---|
| **`clusterId`** | [`int`]({{ book.javase }}/api/java/lang/Integer.html) | Defines the cluster you want to check for by its Cluster ID |

#### Return Value

This method returns a [`boolean`]({{ book.javase }}/api/java/lang/Boolean.html) instance, where a `true` value indicates that the class does use the given cluster.
