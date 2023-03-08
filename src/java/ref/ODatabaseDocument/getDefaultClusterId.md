
# ODatabaseDocument - getDefaultClusterId()

Retrieves the default Cluster ID for the database.

## Default Clusters 

While OrientDB does support the use of a schema, it can also be used without a schema or with a partially enforced schema.  In these cases, data that added without a specified class or cluster is stored on the database under the default cluster.  Using this method, you can retrieve the Cluster ID for the default cluster. 

### Syntax

```
int ODatabaseDocument().getDefaultClusterId()
```

#### Return Value

This method returns an `int` value, which corresponds to the default Cluster ID.



