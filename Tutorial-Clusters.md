<!-- proofread 2015-11-26 SAM -->
# Clusters


The [Cluster](Concepts.md#cluster) is a place where a group of records are stored. Like the [Class](Concepts.md#class), it is comparable with the collection in traditional document databases, and in relational databases with the table.  However, this is a loose comparison given that unlike a table, clusters allow you to store the data of a class in different physical locations.

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

By default, OrientDB creates one cluster for each [Class](Concepts.md#class).  All records of a class are stored in the same cluster, which has the same name as the class. You can create up to 32,767 (or, 2<sup>15</sup> - 1) clusters in a database. Understanding the concepts of classes and clusters allows you to take advantage of the power of clusters in designing new databases.

While the default strategy is that each class maps to one cluster, a class can rely on multiple clusters. For instance, you can spawn records physically in multiple locations, thereby creating multiple clusters.

![Class-Custer](http://www.orientdb.org/images/class-clusters.png)

Here, you have a class `Customer` that relies on two clusters:

- `USA_customers`, which is a cluster that contains all customers in the United States.

- `China_customers`, which is a cluster that contains all customers in China.

In this deployment, the default cluster is `USA_customers`. Whenever commands are run on the `Customer` class, such as [`INSERT`](SQL-Insert.md) statements, OrientDB assigns this new data to the default cluster.

![Class-Cluster](http://www.orientdb.org/images/class-newrecord.png)

The new entry from the [`INSERT`](SQL-Insert.md) statement is added to the `USA_customers` cluster, given that it's the default.  Inserting data into a non-default cluster would require that you specify the cluster you want to insert the data into in your statement.

When you run a query on the `Customer` class, such as  [`SELECT`](SQL-Query.md) queries, for instance:

![Class-Cluster](http://www.orientdb.org/images/class-query.png)

OrientDB scans all clusters associated with the class in looking for matches.

In the event that you know the cluster in which the data is stored, you can query that cluster directly to avoid scanning all others and optimize the query.

![Class-Cluster](http://www.orientdb.org/images/class-query-cluster.png)

Here, OrientDB only scans the `China_customers` cluster of the `Customer` class in looking for matches

>**Note**: The method OrientDB uses to select the cluster, where it inserts new records, is configurable and extensible.  For more information, see [Cluster Selection](Cluster-Selection.md).



## Working with Clusters

In OrientDB there are two types of clusters:

- **Physical Cluster** (known as **local**) which is persistent because it writes directly to the file system
- **Memory Cluster** where everything is volatile and will be lost on termination of the process or server if the database is remote

For most cases, physical clusters are preferred because databases must be persistent.  OrientDB creates physical clusters by default.

You may also find it beneficial to locate different clusters on different servers, physically separating where you store records in your database.  The advantages of this include:

- **Optimization** Faster query execution against clusters, given that you need only search a subset of the clusters in a class.
- **Indexes** With good partitioning, you can reduce or remove the use of indexes.
- **Parallel Queries**: Queries can be run in parallel when made to data on multiple disks.
- **Sharding**: You can shard large data-sets across multiple instances.




### Adding Clusters

When you create a class, OrientDB creates a default cluster of the same name.  In order for you to take advantage of the power of clusters, you need to create additional clusters on the class.  This is done with the [`ALTER CLASS`](SQL-Alter-Class.md) statement in conjunction with the `ADDCLUSTER` parameter.

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

------------------------------------------------------------------------------+
 Document - @class: OUser                      @rid: #5:0      @version: 1    |
----------+-------------------------------------------------------------------+
     Name | Value                                                             |
----------+-------------------------------------------------------------------+
     name | admin                                                             |
 password | {SHA-256}8C6976E5B5410415BDE908BD4DEE15DFB167A9C873F8A81F6F2AB... |
   status | ACTIVE                                                            |
    roles | [#4:0=#4:0]                                                       |
----------+-------------------------------------------------------------------+
</pre>

Bear in mind that this command references the last call of [`BROWSE CLUSTER`](Console-Command-Browse-Cluster.md). You can continue to display other records, but you cannot display records from another cluster until you browse that particular cluster.

