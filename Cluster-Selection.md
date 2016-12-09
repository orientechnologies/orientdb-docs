---
search:
   keywords: ['concepts', 'cluster', 'cluster selection']
---

<!-- proofread 2015-11-26 SAM -->
# Cluster Selection

When you create a new record and specify the [class](Concepts.md#class) to which it belongs, OrientDB automatically selects a [cluster](Concepts.md#cluster), where it stores the physical data of the record. There are a number of configuration strategies available for you to use in determining how OrientDB selects the appropriate cluster for the new record.

- `default`  It selects the cluster using the `defaultClusterId` property from the class.  Prior to version 1.7, this was the default method.

- `round-robin` It arranges the configured clusters for the class into sequence and assigns each new record to the next cluster in order.

- `balanced` It checks the number of records in the configured clusters for the class and assigns the new record to whichever is the smallest at the time.  To avoid latency issues on data insertions, OrientDB calculates cluster size every five seconds or longer.

- `local` When the database is run in distributed mode, it selects the master cluster on the current node. This helps to avoid conflicts and reduce network latency with remote calls between nodes.

Whichever cluster selection strategy works best for your application, you can assign it through the [`ALTER CLASS...CLUSTERSELECTION`](SQL-Alter-Class.md) command.  For example,

<pre>
orientdb> <code class="lang-sql userinput">ALTER CLASS Account CLUSTERSELECTION round-robin</code>
</pre>

When you run this command, it updates the `Account` class to use the `round-robin` selection strategy.  It cycles through available clusters, adding new records to each in sequence.



## Custom Cluster Selection Strategies

In addition to the cluster selection strategies listed above, you can also develop your own select strategies through the Java API.  This ensures that if the strategies that are available by default do not meet your particular needs, you can develop one that does.

1. Using your preferred text editor, create the implementation in Java.  In order to use a custom strategy, the class must implement the `OClusterSelectionStrategy` interface.

   ```java
   package mypackage;
   public class RandomSelectionStrategy implements OClusterSelectionStrategy {
      public int getCluster(final OClass iClass, final ODocument doc) {
         final int[] clusters = iClass.getClusterIds();

         // RETURN A RANDOM CLUSTER ID IN THE LIST
         int r = new Random().nextInt(clusters.length);
		   return clusters[r];
      }

      public String getName(){ return "random"; }
   }
   ``` 

   Bear in mind that the method `getCluster()` also receives the `ODocument` cluster to insert. You may find this useful, if you want to assign the `clusterId` variable, based on the Document content.

1. Register the implementation as a service.  You can do this by creating a new file under `META-INF/service`.  Use the filename `com.orientechnologies.orient.core.metadata.schema.clusterselection.OClusterSelectionStrategy`.  For its contents, code your class with the full package.  For instance,

   ``` java
   mypackage.RandomSelectionStrategy
   ```

   This adds to the default content in the OrientDB core:

   ``` java
   com.orientechnologies.orient.core.metadata.schema.clusterselection.ORoundRobinClusterSelectionStrategy
   com.orientechnologies.orient.core.metadata.schema.clusterselection.ODefaultClusterSelectionStrategy
   com.orientechnologies.orient.core.metadata.schema.clusterselection.OBalancedClusterSelectionStrategy
   ```

1. From the database console, assign the new selection strategy to your class with the [`ALTER CLASS...CLUSTERSELECTION`](SQL-Alter-Class.md) command.

   <pre>
   orientdb> <code class="lang-sql userinput">ALTER CLASS Employee CLUSTERSELECTION random</code>
   </pre>

The class `Employee` now selects clusters using `random`, your custom strategy.


