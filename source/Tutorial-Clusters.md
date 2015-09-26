# Clusters

We've already talked about classes. A class is a logical concept in OrientDB. Clusters are also an important concept in OrientDB. Records (or documents/vertices) are stored in [clusters](Concepts.md#cluster).

## What is a cluster?

A [cluster](Concepts.md#cluster) is a place where a group of records are stored. Perhaps the best equivalent in the relational world would be a *Table*. By default, OrientDB will create one cluster per class. All the records of a class are stored in the same cluster which has the same name as the class. You can create up to 32,767 (2^15-1) clusters in a database.

Understanding the concepts of classes and clusters allows you to take advantage of the power of clusters while designing your new database.

Even though the default strategy is that each class maps to one cluster, a class can rely on multiple clusters. You can spawn records physically in multiple places, thereby creating multiple clusters. For example:

![Class-Custer](http://www.orientdb.org/images/class-clusters.png)

The class "Customer" relies on 2 clusters:
- *USA_customers*, containing all USA customers. This is the default cluster as denoted by the red star.
- *China_customers*, containing all Chinese customers.

The default cluster (in this case, the USA_customers cluster) is used by default when the generic class "Customer" is used. Example:

![Class-Custer](http://www.orientdb.org/images/class-newrecord.png)

When querying the "Customer" class, all the involved clusters are scanned:

![Class-Custer](http://www.orientdb.org/images/class-query.png)

If you know the location of a customer you're looking for you can query the target cluster *directly*. This avoids scanning the other clusters and optimizes the query:

![Class-Cluster](http://www.orientdb.org/images/class-query-cluster.png)

To add a new cluster to a class, use the [ALTER CLASS](SQL-Alter-Class.md) command. To remove a cluster use REMOVECLUSTER in [ALTER CLASS](SQL-Alter-Class.md) command. Example to create the cluster "USA_Customers" under the "Customer" class:

<pre>
orientdb> <code class="lang-sql userinput">ALTER CLASS Customer ADDCLUSTER USA_Customers</code>
</pre>

The benefits of using different physical places to store records are:

- faster queries against clusters because only a sub-set of all the class's clusters must be searched
- good partitioning allows you to reduce/remove the use of indexes
- parallel queries if on multiple disks
- sharding large data sets across multiple disks or server instances

There are two types of clusters:

- **Physical Cluster** (known as **local**) which is persistent because it writes directly to the file system
- **Memory Cluster** where everything is volatile and will be lost on termination of the process or server if the database is remote

For most cases physical clusters are preferred because the database must be persistent. OrientDB creates physical clusters by default so you don't have to worry too much about it for now.

To view all clusters, from the console run the [`CLUSTERS`](Console-Command-Clusters.md) command:

<pre>
orientdb> <code class="lang-sql userinput">LIST CLUSTERS</code>

CLUSTERS:
-------------+------+-----------+-----------+
 NAME        | ID   | TYPE      | RECORDS   |
-------------+------+-----------+-----------+
 account     | 11   | PHYSICAL  |      1107 |
 actor       | 91   | PHYSICAL  |         3 |
 address     | 19   | PHYSICAL  |       166 |
 animal      | 17   | PHYSICAL  |         0 |
 animalrace  | 16   | PHYSICAL  |         2 |
 ....        | .... | ....      |      .... |
-------------+------+-----------+-----------+
 TOTAL                                23481 |
--------------------------------------------+
</pre>

Since by default each class has its own cluster, we can query the database's users by class or by cluster:

<pre>
orientdb> <code class="lang-sql userinput">BROWSE CLUSTER OUser</code>

---+------+--------+--------+-------------------------------------+--------+-------- 
 # | @RID | @CLASS | name   | password                            | status | roles
---+------+-------+--------+--------------------------------------+--------+--------
 0 | #5:0 | OUser | admin  | {SHA-256}8C6976E5B5410415BDE908BD... | ACTIVE | [1]
 1 | #5:1 | OUser | reader | {SHA-256}3D0941964AA3EBDCB00CCEF5... | ACTIVE | [1]
 2 | #5:2 | OUser | writer | {SHA-256}B93006774CBDD4B299389A03... | ACTIVE | [1]
---+------+--------+--------+-------------------------------------+--------+--------
</pre>

The result is identical to `BROWSE CLASS OUser` executed in the classes section because there is only one cluster for the OUser class in this example.

The strategy where OrientDB selects the cluster when inserts a new record is configurable and pluggable. For more information take a look at [Cluster Selection](Cluster-Selection.md).
