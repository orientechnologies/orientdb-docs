# Record ID

In OrientDB each record has its own self-assigned unique ID within the database called [Record ID](Concepts.md#wiki-RecordID) or RID. It is composed of two parts:

```
#<cluster-id>:<cluster-position>
```

- **cluster-id** is the id of the cluster. Each database can have a maximum of 32,767 clusters (2<sup>15-1</sup>)
- **cluster-position** is the position of the record inside the cluster. Each cluster can handle up to 9,223,372,036,854,780,000 (2<sup>63</sup>) records, namely 9,223,372 trillion of records!

So the maximum size of a database is 2<sup>78</sup> records = 302,231,454,903 trillion of records. We have never tested such high numbers due to the lack of hardware resources, but we most definitely have users working with OrientDB databases in the billions of records.

A RID ([Record ID](Concepts.md#wiki-RecordID)) is the physical position of the record inside the database. This means that loading a record by its RID is blazing fast, even with a growing database. With document and relational DBMS the more data you have, the slower the database will be. Joins have a heavy runtime cost. OrientDB handles relationships as physical links to the records. The relationship is assigned only once when the edge is created O(1). Compare this to an RDBMS that "computes" the relationship every single time you query a database O(LogN). Traversing speed is not affected by the database size in OrientDB. It is always constant, whether for one record or 100 billion records. This is critical in the age of Big Data!

To load a record directly via the console, use the [`LOAD RECORD`](Console-Command-Load-Record.md) command. Below, we load the record #12:4 of the "demo" database.

<pre>
orientdb> <code class="lang-sql userinput">LOAD RECORD #12:4</code>

--------------------------------------------------------
 ODocument - @class: Company  @rid: #12:4  @version: 8 
-------------+------------------------------------------
        Name | Value
-------------+------------------------------------------
   addresses | [NOT LOADED: #19:159]
      salary | 0.0
   employees | 100004
          id | 4
        name | Microsoft4
 initialized | false
     salary2 | 0.0
  checkpoint | true
     created | Sat Dec 29 23:13:49 CET 2012
-------------+------------------------------------------
</pre>

The [`LOAD RECORD`](Console-Command-Load-Record.md) command returns some useful information about this record:

- It's a *document*. OrientDB supports different types of records. This tutorial covers documents only.

- The *class* is "Company"

- The current *version* is 8. OrientDB has a [MVCC system](Transactions.md#Optimistic-Transaction). It will be covered at a later point. Just know that every time you update a record its version is incremented by 1.

- We have different field types: "salary" and "salary2" are floats, "employees" and "id" are integers, "name" is a string, "initialized" and "checkpoint" are booleans and "created" is a date-time

- The field "addresses" has been NOT LOADED. It is also a LINK to another record #19:159. This is a [relationship](Tutorial-Relationships.md). (More explanation to follow)
