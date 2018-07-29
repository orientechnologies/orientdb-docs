---
search:
   keywords: ['java', 'ocluster', 'getlastposition']
---

# OCluster - getLastPosition()

Retrieves the last Record ID position in the cluster.

## Getting Record Positions

When you query OrientDB, the records in the result-set each have a Record ID, which is composed of two numbers.  The first number is the Cluster ID, the second is the record's position in the cluster.  Using this method you can retrieve the last record position in this cluster.

### Syntax

```
long OCluster().getLastPosition()
```

#### Return Value

This method returns a `long` value that represents the last record position in the cluster.
