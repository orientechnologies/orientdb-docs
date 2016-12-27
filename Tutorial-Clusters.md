---
search:
   keywords: ["tutorial", "cluster"]
---

<!-- proofread 2015-11-26 SAM -->
# Clusters


The [Cluster](Concepts.md#cluster) is a place where a group of records are stored. Like the [Class](Concepts.md#class), it is comparable with the collection in traditional document databases, and in relational databases with the table.  However, this is a loose comparison given that unlike a table, clusters allow you to store the data of a class in different physical locations.

In this tutorial you will learn what clusters are and how to use them in your database.

To list all the configured clusters on your system, use the [`CLUSTERS`](Console-Command-Clusters.md) command in the console:

<pre>
orientdb> <code class="lang-sql userinput">CLUSTERS</code>

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


## Understanding Clusters

Starting from v2.2, OrientDB automatically may create multiple clusters per each [Class](Concepts.md#class) to improve the performance of parallelism. The number of clusters created per class is equal to the number of CPU cores available on the server. You can also have more clusters per class. The limit on the number of clusters in a database is 32,767 (or, 2<sup>15</sup> - 1). Understanding classes and clusters will allow you to take advantage their unique powers in designing new databases.

While the default strategy is that each class maps to one cluster for each CPU core available, a class can rely on fewer or more clusters. For instance, in a distributed server environment you can spawn records physically in multiple locations, thereby creating multiple clusters.

One key feature about clusters is 'Cluster Selection'. This features specifies to which cluster any new record will be added. Cluster Selection can be 'round robin', 'default', 'balanced', or 'local'.

Suppose you have a class `Customer` that relies on two clusters:

- `USA_customers`, which is a cluster that contains all customers in the United States.

- `China_customers`, which is a cluster that contains all customers in China.

![Class-Custer](http://www.orientdb.org/images/class-clusters.png)

In ths deployment, the default cluster is `USA_customers`. Therefore, when 'Cluster Selection' is set to 'default' records added with the [`INSERT`](SQL-Insert.md) statement belong to 'USA_customers' unless specified otherwise. If the selection strategy is 'default' then inserting data into a non-default cluster would require that you specify the cluster you want to insert the data into in your `INSERT` statement.

![Class-Cluster](http://www.orientdb.org/images/class-newrecord.png)

If we have different remote servers servicing customers in China and the USA, then it might also make sense to have 'Cluster Selection' set to 'local'. This will result in modifications of the customer class to take place on the cluster associated with the server making the modification.

When you run a query on the `Customer` class, such as  [`SELECT`](SQL-Query.md), for instance:

![Class-Cluster](http://www.orientdb.org/images/class-query.png)

OrientDB scans all clusters associated with the class looking for matches.

In the event that you know the cluster in which the data you seek is stored, you can optimize the query by querying that cluster directly and thus avoid scanning all the others clusters.

![Class-Cluster](http://www.orientdb.org/images/class-query-cluster.png)

Here, OrientDB only scans the `China_customers` cluster of the `Customer` class in looking for matches.

>**Note**: The method OrientDB uses to select the cluster, where it inserts new records, is configurable and extensible.  For more information, see [Cluster Selection](Cluster-Selection.md).

## Working with Clusters

While running in HA mode, upon the creation of a new record (document, vertex, edge, etc.) the coordinator server automatically assigns the cluster among the list of local clusters for the current server. For more information look at [HA: Cluster Ownership](Distributed-Architecture.md#cluster-ownership).

You may also find it beneficial to locate different clusters on different servers, physically separating where you store records in your database.  The advantages of this include:

- **Optimization** Faster query execution against clusters, given that you need only search a subset of the clusters in a class.
- **Indexes** With good partitioning, you can reduce or remove the use of indexes.
- **Parallel Queries**: Queries can be run in parallel when made to data on multiple disks.
- **Sharding**: You can shard large data-sets across multiple instances.

### Adding Clusters

When you create a class, OrientDB creates a set of default clusters of the same name.  In order for you to take advantage of the power of clusters, you need to create additional clusters on the class.  This is done with the [`ALTER CLASS`](SQL-Alter-Class.md) statement in conjunction with the `ADDCLUSTER` parameter.

To add a cluster to the `Customer` class, use an [`ALTER CLASS`](SQL-Alter-Class.md) statement in the console:

<pre>
orientdb> <code class="lang-sql userinput">ALTER CLASS Customer ADDCLUSTER UK_Customers</code>

Class updated successfully
</pre>

You now have a third cluster for the `Customer` class, covering those customers located in the United Kingdom.



## Viewing Records in a Cluster

Clusters store the records contained by a class in OrientDB. You can view all records that belong to a cluster using the [`BROWSE CLUSTER`](Console-Command-Browse-Cluster.md) command and the data belonging to a particular record with the [`DISPLAY RECORD`](Console-Command-Display-Record.md) command.

In the above example, you added a cluster to a class for storing records customer information based on their locations around the world, but you did not create these records or add any data.  As a result, running these commands on the `Customer` class returns no results.  Instead, for the examples below, consider the `ouser` cluster.

OrientDB ships with a number of default clusters to store data from its default classes. You can see these using the [`CLUSTERS`](Console-Command-Clusters.md) command. Among these, there is the `ouser` cluster, which stores data of the users on your database.

To see records stored in the `ouser` cluster, run the [`BROWSE CLUSTER`](Console-Command-Browse-Cluster.md) command:


<pre>
orientdb> <code class="lang-sql userinput">BROWSE CLUSTER OUser</code>

---+------+--------+--------+----------------------------------+--------+-------+
 # | @RID | @CLASS | name   | password                         | status | roles |
---+------+-------+--------+-----------------------------------+--------+-------+
 0 | #5:0 | OUser | admin  | {SHA-256}8C6976E5B5410415BDE90... | ACTIVE | [1]   |
 1 | #5:1 | OUser | reader | {SHA-256}3D0941964AA3EBDCB00CC... | ACTIVE | [1]   |
 2 | #5:2 | OUser | writer | {SHA-256}B93006774CBDD4B299389... | ACTIVE | [1]   |
---+------+--------+--------+----------------------------------+--------+-------+
</pre>

The results are identical to executing [`BROWSE CLASS`](Console-Command-Browse-Class.md) on the `OUser` class, given that there is only one cluster for the `OUser` class in this example.

|||
|---|-----|
|![](images/warning.png)| In the example, you are listing all of the users of the database.  While this is fine for your initial setup and as an example, it is not particularly secure. To further improve security in production environments, see [Security](Security.md).|

When you run [`BROWSE CLUSTER`](Console-Command-Browse-Cluster.md), the first column in the output provides the identifier number, which you can use to display detailed information on that particular record.

To show the first record browsed from the `ouser` cluster, run the [`DISPLAY RECORD`](Console-Command-Display-Record.md) command:

<pre>
orientdb> <code class="lang-sql userinput">DISPLAY RECORD 0</code>

DOCUMENT @class:OUser @rid:#5:0 @version:1
----------+--------------------------------------------+
     Name | Value                                      |
----------+--------------------------------------------+
     name | admin                                      |
 password | {SHA-256}8C6976E5B5410415BDE908BD4DEE15... |
   status | ACTIVE                                     |
    roles | [#4:0=#4:0]                                |
----------+--------------------------------------------+
</pre>

Bear in mind that this command references the last call of [`BROWSE CLUSTER`](Console-Command-Browse-Cluster.md). You can continue to display other records, but you cannot display records from another cluster until you browse that particular cluster.

## Congratulations

You now know how to use clusters to parse records of a class, and how to alter a class to add new clusters to it in your database. It's important to know about the clusters associated with a class for the next part of the tutorial. Now that you know a little bit more about clusters we can move on to Record IDs. 
