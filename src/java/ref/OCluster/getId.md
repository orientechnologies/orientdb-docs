---
search:
   keywords: ['java', 'ocluster', 'getid']
---

# OCluster - getId()

Retrieves the Cluster ID.

## Getting Cluster ID's

When you retrieve a record from OrientDB, it displays a Record ID that is composed of two numbers.  The first number is the Cluster ID, a numeric value that identifies the Cluster within the database.  Using this method, you can retrieve the Cluster ID to use in your application.

### Syntax

```
int OCluster().getId()
```

#### Return Value

This method returns an `int` instance.  The value represents the Cluster ID.





