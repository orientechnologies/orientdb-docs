# Cluster Selection

When you create a new record specifying its [Class](Concepts.md#Class), OrientDB automatically selects the [Class](Concepts.md#Cluster) where to store the physical record, by using configurable strategies.

The available strategies are:
- **default**, uses always the Class's ```defaultClusterId``` property. This was the default before 1.7
- **round-robin**, put the Class's configured clusters in a ring and returns a different cluster every time restarting from the first when the ring is completed
- **balanced**, checks the records in all the clusters and returns the smaller cluster. This allows the cluster to have all the underlying clusters balanced on size. On adding a new cluster to an existent class, the new empty cluster will be filled before the others because more empty then the others. Calculation of cluster size is made every 5 or more seconds to avoid to slow down insertion
- **local**. This is injected when OrientDB is running in distributed mode. With this strategy the cluster that is the master on current node is always preferred. This avoids conflicts and reduces network latency with remote calls between nodes.

## Create custom strategy
To create your custom strategy follow the following steps:

### 1) Create the implementation in Java

The class must implements interface OClusterSelectionStrategy. Example:

```java
package mypackage;
public class RandomSelectionStrategy implements OClusterSelectionStrategy {
  public int getCluster(final OClass iClass, final ODocument doc) {
    final int[] clusters = iClass.getClusterIds();

    // RETURN A RANDOM CLUSTER ID IN THE LIST
    return new Random().nextInt(clusters.length);
  }

  public String getName(){ return "random"; }
}
``` 

Note that the method `getCluster()` receives also the ODocument to insert. This is useful if you want to assign the clusterId based on the Document content.

### 2) Register the implementation as service
Create a new file under META-INF/services called `com.orientechnologies.orient.core.metadata.schema.clusterselection.OClusterSelectionStrategy` and write your class with full package.

Example of the content:
``` 
mypackage.RandomSelectionStrategy
```

This is the default content in OrientDB core is:
``` 
com.orientechnologies.orient.core.metadata.schema.clusterselection.ORoundRobinClusterSelectionStrategy
com.orientechnologies.orient.core.metadata.schema.clusterselection.ODefaultClusterSelectionStrategy
com.orientechnologies.orient.core.metadata.schema.clusterselection.OBalancedClusterSelectionStrategy
```

### 3) Assign it

To assign your new strategy to a class, use the [ALTER CLASS](SQL-Alter-Class.md) command. Example:

    ALTER CLASS Employee CLUSTERSELECTION random

